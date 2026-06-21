package redis

import (
	"context"

	"github.com/redis/go-redis/v9"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/adapters/config"
	"github.com/yerdauletzhumabay/backend-mypizza-golang/internal/core/ports"
)

type redisClient struct {
	client *redis.Client
}

func NewRedisClient(logger ports.Logger, cfg *config.RedisConfig) ports.Redis {
	client := redis.NewClient(&redis.Options{
		Addr:     cfg.Addr(),
		Password: cfg.RedisPasword,
		DB:       cfg.DB,
	})
	return &redisClient{client: client}
}

func (r *redisClient) Pipeline() redis.Pipeliner {
	return r.client.Pipeline()
}

func (r *redisClient) Close() error {
	return r.client.Close()
}

func (r *redisClient) Eval(ctx context.Context, script string, keys []string, args ...interface{}) *redis.Cmd {
	return r.client.Eval(ctx, script, keys, args...)
}

func (r *redisClient) EvalSha(ctx context.Context, sha1 string, keys []string, args ...interface{}) *redis.Cmd {
	return r.client.EvalSha(ctx, sha1, keys, args...)
}

func (r *redisClient) EvalRO(ctx context.Context, script string, keys []string, args ...interface{}) *redis.Cmd {
	return r.client.EvalRO(ctx, script, keys, args...)
}
func (r *redisClient) EvalShaRO(ctx context.Context, sha1 string, keys []string, args ...interface{}) *redis.Cmd {
	return r.client.EvalShaRO(ctx, sha1, keys, args...)
}

func (r *redisClient) ScriptExists(ctx context.Context, hashes ...string) *redis.BoolSliceCmd {
	return r.client.ScriptExists(ctx, hashes...)
}

func (r *redisClient) ScriptLoad(ctx context.Context, script string) *redis.StringCmd {
	return r.client.ScriptLoad(ctx, script)
}
