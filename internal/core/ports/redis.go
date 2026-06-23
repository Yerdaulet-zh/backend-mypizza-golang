package ports

import (
	"context"
	"time"

	"github.com/redis/go-redis/v9"
)

type Redis interface {
	// Satisfy the redis.Scripter interface
	Eval(ctx context.Context, script string, keys []string, args ...interface{}) *redis.Cmd
	EvalSha(ctx context.Context, sha1 string, keys []string, args ...interface{}) *redis.Cmd
	EvalRO(ctx context.Context, script string, keys []string, args ...interface{}) *redis.Cmd
	EvalShaRO(ctx context.Context, sha1 string, keys []string, args ...interface{}) *redis.Cmd
	ScriptExists(ctx context.Context, hashes ...string) *redis.BoolSliceCmd
	ScriptLoad(ctx context.Context, script string) *redis.StringCmd

	Pipeline() redis.Pipeliner
	Close() error
}

type RateLimiter interface {
	Allow(ctx context.Context, key string, window time.Duration, limit int64) (bool, error)
}
