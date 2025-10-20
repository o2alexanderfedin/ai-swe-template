# Technology Stack and Conventions

## Core Stack
- **Language**: Go 1.21+ (latest stable version)
- **Framework**: {{FRAMEWORK}} (Gin/Echo/Chi/Fiber/Standard Library)
- **Package Management**: Go Modules (go.mod)
- **Build Tool**: Standard Go toolchain

## Go-Specific Best Practices

### Code Organization
- **Standard Project Layout**: Follow [golang-standards/project-layout](https://github.com/golang-standards/project-layout)
- **Package Design**: Small, focused packages with clear responsibilities
- **Naming Conventions**: Use Go idioms (CamelCase for exported, camelCase for internal)
- **Error Handling**: Explicit error returns, no exceptions

### Project Structure
```
{{PROJECT_NAME}}/
├── cmd/                    # Application entry points
│   └── server/
│       └── main.go
├── internal/              # Private application code
│   ├── api/              # API handlers
│   ├── domain/           # Business logic and models
│   ├── repository/       # Data access layer
│   └── service/          # Service layer
├── pkg/                  # Public libraries (reusable)
│   └── utils/
├── api/                  # API definitions (OpenAPI/gRPC)
├── config/               # Configuration files
├── scripts/              # Build and deployment scripts
├── tests/                # Additional test files
├── go.mod                # Go module definition
├── go.sum                # Dependency checksums
└── Makefile              # Build automation
```

## Code Quality Tools

### Static Analysis and Linting
- **golangci-lint**: Comprehensive linter aggregator (MUST use)
- **go vet**: Built-in static analyzer
- **staticcheck**: Advanced static analysis
- **gofmt**: Code formatting (built-in)
- **goimports**: Import management

### golangci-lint Configuration
```yaml
# .golangci.yml
run:
  timeout: 5m
  tests: true
  skip-dirs:
    - vendor

linters:
  enable:
    - errcheck
    - govet
    - staticcheck
    - gosimple
    - ineffassign
    - unused
    - typecheck
    - bodyclose
    - noctx
    - gosec
    - revive
    - gocyclo
    - goconst

linters-settings:
  errcheck:
    check-type-assertions: true
    check-blank: true
  govet:
    check-shadowing: true
  revive:
    rules:
      - name: var-naming
      - name: exported
      - name: error-return
      - name: error-naming
```

## Testing Framework

### Testing Standards
- **Standard Library**: Use `testing` package
- **Table-Driven Tests**: Standard pattern for multiple test cases
- **Testify**: Assertion library (optional, but popular)
- **gomock**: Mocking framework
- **Minimum Coverage**: 80%

### Test Example
```go
package api

import (
	"testing"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestFetchUserData(t *testing.T) {
	tests := []struct {
		name    string
		userID  string
		want    *User
		wantErr bool
	}{
		{
			name:    "valid user",
			userID:  "123",
			want:    &User{ID: "123", Name: "Test User"},
			wantErr: false,
		},
		{
			name:    "invalid user",
			userID:  "invalid",
			want:    nil,
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := FetchUserData(tt.userID)

			if tt.wantErr {
				require.Error(t, err)
				assert.Nil(t, got)
			} else {
				require.NoError(t, err)
				assert.Equal(t, tt.want, got)
			}
		})
	}
}
```

### Benchmarking
```go
func BenchmarkExpensiveOperation(b *testing.B) {
	for i := 0; i < b.N; i++ {
		ExpensiveOperation()
	}
}
```

## Type System and Interfaces

### Interface Design
```go
// Small, focused interfaces (Go idiom)
type Reader interface {
	Read(p []byte) (n int, err error)
}

type Writer interface {
	Write(p []byte) (n int, err error)
}

// Compose interfaces
type ReadWriter interface {
	Reader
	Writer
}

// Accept interfaces, return structs
func ProcessData(r Reader) (*Result, error) {
	// Implementation
}
```

### Struct Design
```go
// Use struct tags for JSON/validation
type User struct {
	ID        string    `json:"id" validate:"required,uuid"`
	Name      string    `json:"name" validate:"required,min=2,max=50"`
	Email     string    `json:"email" validate:"required,email"`
	CreatedAt time.Time `json:"created_at"`
}

// Constructor pattern
func NewUser(id, name, email string) (*User, error) {
	if id == "" || name == "" || email == "" {
		return nil, errors.New("invalid user data")
	}

	return &User{
		ID:        id,
		Name:      name,
		Email:     email,
		CreatedAt: time.Now(),
	}, nil
}
```

## Error Handling

### Go Error Patterns
```go
import (
	"errors"
	"fmt"
)

// Sentinel errors
var (
	ErrNotFound     = errors.New("resource not found")
	ErrUnauthorized = errors.New("unauthorized access")
	ErrInvalidInput = errors.New("invalid input")
)

// Custom error types
type APIError struct {
	StatusCode int
	Message    string
	Err        error
}

func (e *APIError) Error() string {
	return fmt.Sprintf("API error (status %d): %s", e.StatusCode, e.Message)
}

func (e *APIError) Unwrap() error {
	return e.Err
}

// Error wrapping (Go 1.13+)
func FetchData(url string) error {
	resp, err := http.Get(url)
	if err != nil {
		return fmt.Errorf("failed to fetch data from %s: %w", url, err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return &APIError{
			StatusCode: resp.StatusCode,
			Message:    "unexpected status code",
		}
	}

	return nil
}

// Error checking
func HandleRequest() error {
	err := FetchData("https://api.example.com")
	if err != nil {
		// Check for specific error types
		var apiErr *APIError
		if errors.As(err, &apiErr) {
			// Handle API error specifically
			return fmt.Errorf("API error: %w", apiErr)
		}

		// Check for sentinel errors
		if errors.Is(err, ErrNotFound) {
			// Handle not found
			return nil
		}

		return fmt.Errorf("unexpected error: %w", err)
	}

	return nil
}
```

## Concurrency Patterns

### Goroutines and Channels
```go
// Worker pool pattern
func ProcessItems(items []Item, numWorkers int) []Result {
	jobs := make(chan Item, len(items))
	results := make(chan Result, len(items))

	// Start workers
	for w := 0; w < numWorkers; w++ {
		go worker(jobs, results)
	}

	// Send jobs
	for _, item := range items {
		jobs <- item
	}
	close(jobs)

	// Collect results
	var output []Result
	for i := 0; i < len(items); i++ {
		output = append(output, <-results)
	}

	return output
}

func worker(jobs <-chan Item, results chan<- Result) {
	for item := range jobs {
		result := processItem(item)
		results <- result
	}
}
```

### Context for Cancellation
```go
import (
	"context"
	"time"
)

func FetchDataWithTimeout(ctx context.Context, url string) (*Data, error) {
	// Create timeout context
	ctx, cancel := context.WithTimeout(ctx, 10*time.Second)
	defer cancel()

	// Create request with context
	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	// Execute request
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to execute request: %w", err)
	}
	defer resp.Body.Close()

	var data Data
	if err := json.NewDecoder(resp.Body).Decode(&data); err != nil {
		return nil, fmt.Errorf("failed to decode response: %w", err)
	}

	return &data, nil
}
```

### Synchronization
```go
import "sync"

// Use sync.WaitGroup for coordinating goroutines
func ProcessParallel(items []Item) []Result {
	var wg sync.WaitGroup
	results := make([]Result, len(items))

	for i, item := range items {
		wg.Add(1)
		go func(idx int, it Item) {
			defer wg.Done()
			results[idx] = processItem(it)
		}(i, item)
	}

	wg.Wait()
	return results
}

// Use sync.Mutex for shared state
type SafeCounter struct {
	mu    sync.RWMutex
	count int
}

func (c *SafeCounter) Increment() {
	c.mu.Lock()
	defer c.mu.Unlock()
	c.count++
}

func (c *SafeCounter) Value() int {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.count
}
```

## Configuration Management

### Environment Variables
```go
package config

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

type Config struct {
	AppName     string
	Environment string
	Port        int
	DatabaseURL string
	RedisURL    string
	LogLevel    string
	Timeout     time.Duration
}

func Load() (*Config, error) {
	cfg := &Config{
		AppName:     getEnv("APP_NAME", "{{PROJECT_NAME}}"),
		Environment: getEnv("ENVIRONMENT", "development"),
		LogLevel:    getEnv("LOG_LEVEL", "info"),
	}

	var err error
	cfg.Port, err = getEnvAsInt("PORT", 8080)
	if err != nil {
		return nil, fmt.Errorf("invalid PORT: %w", err)
	}

	cfg.DatabaseURL = getEnv("DATABASE_URL", "")
	if cfg.DatabaseURL == "" {
		return nil, fmt.Errorf("DATABASE_URL is required")
	}

	timeoutSecs, err := getEnvAsInt("TIMEOUT_SECONDS", 30)
	if err != nil {
		return nil, fmt.Errorf("invalid TIMEOUT_SECONDS: %w", err)
	}
	cfg.Timeout = time.Duration(timeoutSecs) * time.Second

	return cfg, nil
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvAsInt(key string, defaultValue int) (int, error) {
	valueStr := getEnv(key, "")
	if valueStr == "" {
		return defaultValue, nil
	}
	return strconv.Atoi(valueStr)
}
```

## Prohibited Practices

### FORBIDDEN:

1. **Ignoring errors**
   ```go
   // BAD
   data, _ := FetchData()

   // GOOD
   data, err := FetchData()
   if err != nil {
       return fmt.Errorf("failed to fetch data: %w", err)
   }
   ```

2. **Using panic for normal error handling**
   ```go
   // BAD
   if err != nil {
       panic(err)
   }

   // GOOD
   if err != nil {
       return fmt.Errorf("operation failed: %w", err)
   }

   // Only use panic for truly unrecoverable errors in init()
   ```

3. **Not closing resources**
   ```go
   // BAD
   resp, err := http.Get(url)
   // No defer resp.Body.Close()!

   // GOOD
   resp, err := http.Get(url)
   if err != nil {
       return err
   }
   defer resp.Body.Close()
   ```

4. **Naked returns in long functions**
   ```go
   // BAD
   func LongFunction() (result string, err error) {
       // ... 50 lines of code ...
       return  // What are we returning?
   }

   // GOOD
   func LongFunction() (string, error) {
       var result string
       // ... code ...
       return result, nil
   }
   ```

5. **Using global mutable state**
   ```go
   // BAD
   var globalDB *sql.DB  // Mutable global

   // GOOD - Dependency injection
   type Service struct {
       db *sql.DB
   }

   func NewService(db *sql.DB) *Service {
       return &Service{db: db}
   }
   ```

## Logging Standards

### Structured Logging
```go
import (
	"log/slog"
	"os"
)

// Setup structured logger
func setupLogger(level string) *slog.Logger {
	var logLevel slog.Level
	switch level {
	case "debug":
		logLevel = slog.LevelDebug
	case "info":
		logLevel = slog.LevelInfo
	case "warn":
		logLevel = slog.LevelWarn
	case "error":
		logLevel = slog.LevelError
	default:
		logLevel = slog.LevelInfo
	}

	handler := slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
		Level: logLevel,
	})

	return slog.New(handler)
}

// Usage with context
func ProcessUser(logger *slog.Logger, userID string) error {
	logger.Info("processing user",
		slog.String("user_id", userID),
		slog.String("action", "process"),
	)

	err := doWork(userID)
	if err != nil {
		logger.Error("failed to process user",
			slog.String("user_id", userID),
			slog.Any("error", err),
		)
		return err
	}

	logger.Info("user processed successfully",
		slog.String("user_id", userID),
	)

	return nil
}
```

## HTTP Server Patterns

### Standard Library HTTP Server
```go
package main

import (
	"context"
	"fmt"
	"log/slog"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func main() {
	logger := setupLogger("info")

	mux := http.NewServeMux()
	mux.HandleFunc("/health", healthHandler(logger))
	mux.HandleFunc("/api/users", usersHandler(logger))

	// Middleware
	handler := loggingMiddleware(logger)(mux)
	handler = recoveryMiddleware(logger)(handler)

	server := &http.Server{
		Addr:         ":8080",
		Handler:      handler,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	// Graceful shutdown
	go func() {
		logger.Info("server starting", slog.String("addr", server.Addr))
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Error("server error", slog.Any("error", err))
			os.Exit(1)
		}
	}()

	// Wait for interrupt signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	logger.Info("server shutting down")

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err := server.Shutdown(ctx); err != nil {
		logger.Error("server forced to shutdown", slog.Any("error", err))
	}

	logger.Info("server stopped")
}

// Middleware
func loggingMiddleware(logger *slog.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			start := time.Now()
			next.ServeHTTP(w, r)
			logger.Info("request",
				slog.String("method", r.Method),
				slog.String("path", r.URL.Path),
				slog.Duration("duration", time.Since(start)),
			)
		})
	}
}

func recoveryMiddleware(logger *slog.Logger) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			defer func() {
				if err := recover(); err != nil {
					logger.Error("panic recovered",
						slog.Any("error", err),
						slog.String("path", r.URL.Path),
					)
					http.Error(w, "Internal Server Error", http.StatusInternalServerError)
				}
			}()
			next.ServeHTTP(w, r)
		})
	}
}
```

## Dependency Management

### go.mod
```go
module github.com/username/{{PROJECT_NAME}}

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/stretchr/testify v1.8.4
)

// Use replace for local development
// replace github.com/myorg/mylib => ../mylib
```

### Makefile
```makefile
.PHONY: build test lint clean run

build:
	go build -o bin/server ./cmd/server

test:
	go test -v -race -coverprofile=coverage.out ./...

coverage:
	go tool cover -html=coverage.out

lint:
	golangci-lint run ./...

clean:
	rm -rf bin/ coverage.out

run:
	go run ./cmd/server

install-tools:
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

## Version Control

### Git Workflow
- **Branch Naming**: `feature/`, `bugfix/`, `hotfix/`, `docs/`
- **Commit Messages**: Conventional Commits
  - `feat:` - New feature
  - `fix:` - Bug fix
  - `docs:` - Documentation
  - `refactor:` - Refactoring
  - `test:` - Tests
  - `chore:` - Maintenance

## Performance Optimization

### Best Practices
1. **Profile first**: Use pprof before optimizing
2. **Use sync.Pool**: For frequently allocated objects
3. **Avoid allocations**: In hot paths
4. **Use buffered channels**: When appropriate
5. **Benchmark**: Use Go's built-in benchmarking

```go
// Profiling
import _ "net/http/pprof"

// In main()
go func() {
    log.Println(http.ListenAndServe("localhost:6060", nil))
}()
```

## Security Best Practices

1. **Environment Variables**: All secrets via environment
2. **Input Validation**: Validate all inputs
3. **SQL Injection**: Use parameterized queries
4. **Context Timeouts**: Always use context with timeouts
5. **Dependency Scanning**: Run `go list -json -m all | nancy sleuth`
6. **gosec**: Security-focused linter

---

**Last Updated**: 2025-10-19
**Go Version**: 1.21+
**Framework**: {{FRAMEWORK}}
