# ============================================================================
# STAGE 1: BUILD THE BINARY
# ============================================================================
FROM golang:1.26.4-alpine3.23 AS builder

# Add globally trusted CA-certificates
RUN apk add --no-cache ca-certificates && update-ca-certificates

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

# Compile the Go application with optimization flags
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o mypizza-backend ./cmd/main.go

# ============================================================================
# STAGE 2: FINAL RUNTIME MINIMAL IMAGE (SECURED)
# ============================================================================
FROM alpine:3.19 AS runtime

# Add trusted CA certificates, timezone data, and create a non-root group/user
RUN apk add --no-cache ca-certificates tzdata \
    && addgroup -S appgroup \
    && adduser -S appuser -G appgroup

WORKDIR /app

# Copy the pre-compiled binary from the builder stage
COPY --from=builder /app/mypizza-backend .

# Copy config assets cuz the application loads 'configs.yaml' at runtime
COPY --from=builder /app/configs/configs.yaml ./configs/configs.yaml

# Secure permissions: Ensure our appuser owns everything inside the working directory
RUN chown -R appuser:appgroup /app

# Switch execution context from root to the unprivileged appuser
USER appuser

EXPOSE 8080 2112

CMD ["./mypizza-backend"]
