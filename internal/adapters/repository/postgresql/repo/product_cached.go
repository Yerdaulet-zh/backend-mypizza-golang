package repo

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/redis/go-redis/v9"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"go.opentelemetry.io/otel"
	"golang.org/x/sync/singleflight"
)

type cachedProductRepository struct {
	logger      ports.Logger
	dbRepo      ports.ProductRepository
	redisClient *redis.Client
	sfGroup     *singleflight.Group
}

func NewCachedProductRepository(
	logger ports.Logger,
	dbRepo ports.ProductRepository,
	redisClient *redis.Client,
	sfGroup *singleflight.Group,
) ports.ProductRepository {
	return &cachedProductRepository{
		logger:      logger,
		dbRepo:      dbRepo,
		redisClient: redisClient,
		sfGroup:     sfGroup,
	}
}

func (r *cachedProductRepository) GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error) {
	ctx, span := otel.Tracer("repo").Start(ctx, "repo.cache.GetCityAllCategoriesProducts")
	defer span.End()

	// Define the cache key
	cacheKey := fmt.Sprintf("city:categories:products:%s", cityName)

	// Cache Hit -> Immediate return
	if cityData, err := r.getFromCache(ctx, cacheKey); err == nil && cityData != nil {
		return cityData, err
	}

	// Cache Miss -> Collapse multiple concurrent requests for this city down to 1
	v, err, _ := r.sfGroup.Do(cacheKey, func() (any, error) {
		// Double-check cache inside the lock (prevents dogpiling if another thread just finished)
		if doubleCheckData, _ := r.getFromCache(ctx, cacheKey); doubleCheckData != nil {
			return doubleCheckData, nil
		}

		// Hit the actual PostgreSQL database repository
		city, err := r.dbRepo.GetCityAllCategoriesProducts(ctx, cityName)
		if err != nil {
			return nil, err
		}

		// Create a background context that inherits values (like trace IDs) but ignores parent cancellations
		detachedCtx := context.WithoutCancel(ctx)

		// Save the fresh data into Redis
		go func() {
			if err := r.sendToCache(detachedCtx, cacheKey, city, 5*time.Minute); err != nil {
				r.logger.Warn(detachedCtx, "error while saving the repo.GetCityAllCategoriesProducts method's resulting data")
			}
		}()

		return city, nil
	})
	if err != nil {
		return nil, err
	}

	return v.(*domain.City), nil
}

func (r *cachedProductRepository) getFromCache(ctx context.Context, key string) (*domain.City, error) {
	ctx, span := otel.Tracer("repo").Start(ctx, "repo.GetCityAllCategoriesProducts.getFromCache")
	defer span.End()

	val, err := r.redisClient.Get(ctx, key).Result()
	if err == redis.Nil {
		// Key does not exist in Redis (Expected Cache Miss)
		return nil, nil
	}
	if err != nil {
		// Actual connection or Redis system error
		return nil, err
	}

	var city domain.City
	if err := json.Unmarshal([]byte(val), &city); err != nil {
		return nil, err
	}
	return &city, nil
}

func (r *cachedProductRepository) sendToCache(ctx context.Context, key string, city *domain.City, ttl time.Duration) error {
	ctx, span := otel.Tracer("repo").Start(ctx, "GetCityAllCategoriesProducts.sendToCache")
	defer span.End()

	data, err := json.Marshal(city)
	if err != nil {
		return err
	}
	return r.redisClient.Set(ctx, key, data, ttl).Err()
}
