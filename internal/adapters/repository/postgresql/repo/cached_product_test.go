package repo

import (
	"context"
	"sync"
	"testing"
	"time"

	"github.com/alicebob/miniredis/v2"
	"github.com/redis/go-redis/v9"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/suite"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/logging"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/domain"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
	"golang.org/x/sync/singleflight"
)

type CachedRepoTestSuite struct {
	suite.Suite
	redisServer *miniredis.Miniredis
	redisClient *redis.Client
	mockDBRepo  *MockDBRepository // Renamed to keep things clear
	logger      ports.Logger
}

type MockDBRepository struct {
	mock.Mock
}

func (m *MockDBRepository) GetCityAllCategoriesProducts(ctx context.Context, cityName string) (*domain.City, error) {
	args := m.Called(ctx, cityName)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*domain.City), args.Error(1)
}

func (suite *CachedRepoTestSuite) SetupSuite() {
	// Spin up the mock Redis Server
	mr, err := miniredis.Run()
	if err != nil {
		suite.T().Fatalf("Failed to initialize miniredis suite: %v", err)
	}
	suite.redisServer = mr

	// Redis client
	suite.redisClient = redis.NewClient(&redis.Options{
		Addr: mr.Addr(),
	})

	// Setup logger
	suite.logger = logging.NewDefaultLogger("../../../../../configs")
}

func (suite *CachedRepoTestSuite) TearDownSuite() {
	if suite.redisClient != nil {
		suite.redisClient.Close()
	}
	if suite.redisServer != nil {
		suite.redisServer.Close()
	}
}

// Reset the mocks and flush Redis BEFORE EACH test runs
func (suite *CachedRepoTestSuite) SetupTest() {
	suite.mockDBRepo = new(MockDBRepository)
	suite.redisServer.FlushAll()
}

// Entrypoint function required by Go to execute the suite
func TestCachedProductRepositorySuite(t *testing.T) {
	suite.Run(t, new(CachedRepoTestSuite))
}

// --- THE CONCURRENCY/COLLAPSING TEST ---
func (suite *CachedRepoTestSuite) TestGetCityAllCategoriesProducts_CollapsesConcurrentRequests() {
	t := suite.T()
	sfGroup := &singleflight.Group{}

	// Initialize the actual caching repository we want to test
	repo := NewCachedProductRepository(suite.logger, suite.mockDBRepo, suite.redisClient, sfGroup)

	cityName := "Shymkent"
	expectedCity := &domain.City{Name: cityName}

	// EXPECTATION: The DB repository should only be called EXACTLY ONCE
	suite.mockDBRepo.On("GetCityAllCategoriesProducts", mock.Anything, cityName).
		Return(expectedCity, nil).
		Once()

	// Fire concurrent requests using a WaitGroup
	var wg sync.WaitGroup
	concurrentRequests := 10
	results := make([]*domain.City, concurrentRequests)
	startGate := make(chan struct{})

	for i := 0; i < concurrentRequests; i++ {
		wg.Add(1)
		go func(index int) {
			defer wg.Done()
			<-startGate // Wait here until the gate opens

			res, err := repo.GetCityAllCategoriesProducts(context.Background(), cityName)
			if err == nil {
				results[index] = res
			}
		}(i)
	}

	// Open the gate! All goroutines dogpile the endpoint simultaneously
	close(startGate)
	wg.Wait()

	// Assertions
	suite.mockDBRepo.AssertExpectations(t) // Verifies DB was hit exactly once
	for _, res := range results {
		assert.NotNil(t, res)
		assert.Equal(t, cityName, res.Name)
	}

	// Give the background goroutine a split second to save to miniredis
	time.Sleep(50 * time.Millisecond)
	assert.True(t, suite.redisServer.Exists("city:categories:products:Shymkent"))
}
