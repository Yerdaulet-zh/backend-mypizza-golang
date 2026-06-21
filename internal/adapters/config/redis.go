package config

import (
	"os"
	"strconv"

	"github.com/spf13/viper"
)

type RedisConfig struct {
	RedisPasword string
	Host         string
	Port         int
	DB           int
}

func NewRedisConfig() *RedisConfig {
	return &RedisConfig{
		RedisPasword: os.Getenv("REDIS_PASSWORD"),
		Host:         viper.GetString("cache.redis.host"),
		Port:         viper.GetInt("cache.redis.port"),
		DB:           viper.GetInt("cache.redis.db"),
	}
}

func (cnf *RedisConfig) Addr() string {
	return cnf.Host + ":" + strconv.Itoa(cnf.Port)
}
