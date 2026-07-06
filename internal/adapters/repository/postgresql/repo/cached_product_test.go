package repo

// import (
// 	"context"
// 	"sync"
// 	"testing"
// 	"time"

// 	"github.com/alicebob/miniredis/v2"
// 	"github.com/redis/go-redis/v9"
// 	"github.com/stretchr/testify/assert"
// 	"github.com/stretchr/testify/mock"
// 	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/logging"
// 	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
// 	"golang.org/x/sync/singleflight"
// )

// // --- MOCK PRODUCT REPOSITORY ---
// type MockProductRepository struct {
// 	mock.Mock
// }

// func (m *MockProductRepository) GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error) {
// 	args := m.Called(ctx, cityName)
// 	if args.Get(0) == nil {
// 		return nil, args.Error(1)
// 	}
// 	return args.Get(0).(*domain.City), args.Error(1)
// }

// // --- THE CONCURRENCY/COLLAPSING TEST ---
// func TestGetCityAllCategoriesProducts_CollapsesConcurrentRequests(t *testing.T) {
// 	// 1. Setup Miniredis (In-memory mock Redis)
// 	mr, err := miniredis.Run()
// 	assert.NoError(t, err)
// 	defer mr.Close()

// 	redisClient := redis.NewClient(&redis.Options{Addr: mr.Addr()})

// 	// 2. Setup dependencies
// 	mockDBRepo := new(MockProductRepository)
// 	sfGroup := &singleflight.Group{}
// 	logger := logging.NewDefaultLogger("../../../../../configs")

// 	repo := NewCachedProductRepository(logger, mockDBRepo, redisClient, sfGroup)

// 	cityName := "Shymkent"
// 	expectedCity := &domain.City{Name: cityName}

// 	// 3. EXPECTATION: The DB repository should only be called EXACTLY ONCE
// 	// even though we are going to fire dozens of concurrent requests simultaneously.
// 	mockDBRepo.On("GetCityAllCategoriesProducts", mock.Anything, cityName).
// 		Return(expectedCity, nil).
// 		Once() // <--- CRITICAL CHECK

// 	// 4. Fire concurrent requests using a WaitGroup
// 	var wg sync.WaitGroup
// 	concurrentRequests := 10
// 	results := make([]*domain.City, concurrentRequests)

// 	// We use a gate channel to unblock all goroutines at the exact same moment
// 	startGate := make(chan struct{})

// 	for i := 0; i < concurrentRequests; i++ {
// 		wg.Add(1)
// 		go func(index int) {
// 			defer wg.Done()
// 			<-startGate // Wait here until the gate opens

// 			res, err := repo.GetCityAllCategoriesProducts(context.Background(), cityName)
// 			if err == nil {
// 				results[index] = res
// 			}
// 		}(i)
// 	}

// 	// Open the gate! All goroutines dogpile the endpoint simultaneously
// 	close(startGate)
// 	wg.Wait()

// 	// 5. Assertions
// 	mockDBRepo.AssertExpectations(t) // Verifies DB was hit exactly once
// 	for _, res := range results {
// 		assert.NotNil(t, res)
// 		assert.Equal(t, cityName, res.Name)
// 	}

// 	// Give the background goroutine a split second to save to miniredis
// 	time.Sleep(50 * time.Millisecond)
// 	assert.True(t, mr.Exists("city:categories:products:Shymkent"))
// }
