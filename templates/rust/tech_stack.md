# Technology Stack and Conventions

## Core Stack
- **Language**: Rust 1.75+ (latest stable version)
- **Edition**: Rust 2021
- **Framework**: {{FRAMEWORK}} (Actix/Axum/Rocket/Tokio)
- **Package Manager**: Cargo (built-in)
- **Build Tool**: Cargo with workspace support

## Rust-Specific Best Practices

### Ownership and Borrowing
- **Embrace Ownership**: Design APIs around ownership semantics
- **Prefer Borrowing**: Use references (`&T`, `&mut T`) when possible
- **Avoid `clone()` in Hot Paths**: Clone only when necessary
- **Use Lifetime Annotations**: When multiple references are involved
- **Smart Pointers**: Use `Box`, `Rc`, `Arc` appropriately

### Type System
- **Strong Static Typing**: Leverage Rust's type system
- **Option and Result**: Never use `unwrap()` in production code
- **Pattern Matching**: Exhaustive matching for safety
- **Traits**: Define behavior through traits
- **Generics**: Write reusable, type-safe code

### Project Structure
```
{{PROJECT_NAME}}/
├── src/
│   ├── main.rs           # Binary entry point
│   ├── lib.rs            # Library root (optional)
│   ├── api/              # API handlers
│   │   └── mod.rs
│   ├── domain/           # Business logic and models
│   │   └── mod.rs
│   ├── repository/       # Data access layer
│   │   └── mod.rs
│   └── utils/            # Utility functions
│       └── mod.rs
├── tests/                # Integration tests
├── benches/              # Benchmarks
├── examples/             # Usage examples
├── Cargo.toml            # Package manifest
├── Cargo.lock            # Dependency lock file
├── .rustfmt.toml         # Formatting config
└── .clippy.toml          # Linting config
```

## Code Quality Tools

### Essential Tools
- **rustfmt**: Code formatting (MUST use)
- **clippy**: Linting and suggestions (MUST run)
- **cargo check**: Fast compilation check
- **cargo test**: Testing framework
- **cargo doc**: Documentation generation

### Clippy Configuration
```toml
# .clippy.toml
msrv = "1.75"

[lints.clippy]
unwrap_used = "deny"
expect_used = "warn"
panic = "deny"
todo = "warn"
unimplemented = "deny"
```

### rustfmt Configuration
```toml
# .rustfmt.toml
edition = "2021"
max_width = 100
use_small_heuristics = "Max"
imports_granularity = "Crate"
group_imports = "StdExternalCrate"
```

## Testing Framework

### Testing Standards
- **Unit Tests**: In same file with `#[cfg(test)]`
- **Integration Tests**: In `tests/` directory
- **Doc Tests**: Test code in documentation
- **Property Testing**: Use `proptest` or `quickcheck`
- **Minimum Coverage**: 80% (use `cargo tarpaulin`)

### Test Example
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_fetch_user_data() {
        // Arrange
        let user_id = "test-123";
        let expected_name = "Test User";

        // Act
        let result = fetch_user_data(user_id).unwrap();

        // Assert
        assert_eq!(result.id, user_id);
        assert_eq!(result.name, expected_name);
    }

    #[test]
    fn test_invalid_user_id() {
        let result = fetch_user_data("");
        assert!(result.is_err());
    }

    #[test]
    #[should_panic(expected = "invalid user")]
    fn test_panic_on_invalid_data() {
        fetch_user_data("invalid").unwrap();
    }
}
```

### Async Testing
```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_async_fetch() {
        let result = fetch_data_async("https://api.example.com").await;
        assert!(result.is_ok());
    }
}
```

## Type System and Patterns

### Error Handling with Result
```rust
use thiserror::Error;
use std::result::Result as StdResult;

// Define custom error types
#[derive(Error, Debug)]
pub enum AppError {
    #[error("Resource not found: {0}")]
    NotFound(String),

    #[error("Invalid input: {0}")]
    InvalidInput(String),

    #[error("Database error: {0}")]
    Database(#[from] sqlx::Error),

    #[error("HTTP error: {0}")]
    Http(#[from] reqwest::Error),

    #[error("Unknown error")]
    Unknown,
}

// Type alias for convenience
pub type Result<T> = StdResult<T, AppError>;

// Usage
pub fn fetch_user(id: &str) -> Result<User> {
    if id.is_empty() {
        return Err(AppError::InvalidInput("User ID cannot be empty".to_string()));
    }

    // Database call that can fail
    let user = database::find_user(id)?;

    match user {
        Some(u) => Ok(u),
        None => Err(AppError::NotFound(format!("User {} not found", id))),
    }
}
```

### Option Handling
```rust
// Use combinators instead of unwrap()
fn get_user_email(user_id: &str) -> Option<String> {
    database::find_user(user_id)
        .and_then(|user| user.email)
        .map(|email| email.to_lowercase())
}

// Pattern matching
fn process_user(user: Option<User>) -> String {
    match user {
        Some(u) => format!("Processing user: {}", u.name),
        None => "No user to process".to_string(),
    }
}

// if let for single pattern
if let Some(user) = database::find_user(id) {
    println!("Found user: {}", user.name);
}
```

### Structs and Traits
```rust
use serde::{Deserialize, Serialize};
use chrono::{DateTime, Utc};

// Define structs with derives
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct User {
    pub id: String,
    pub name: String,
    pub email: String,
    pub created_at: DateTime<Utc>,
}

// Implement traits
impl User {
    pub fn new(id: String, name: String, email: String) -> Self {
        Self {
            id,
            name,
            email,
            created_at: Utc::now(),
        }
    }

    pub fn is_valid(&self) -> bool {
        !self.id.is_empty() && !self.name.is_empty() && self.email.contains('@')
    }
}

// Trait definition
pub trait Repository<T> {
    async fn find_by_id(&self, id: &str) -> Result<Option<T>>;
    async fn save(&self, entity: &T) -> Result<()>;
    async fn delete(&self, id: &str) -> Result<()>;
}

// Trait implementation
impl Repository<User> for UserRepository {
    async fn find_by_id(&self, id: &str) -> Result<Option<User>> {
        // Implementation
    }

    async fn save(&self, user: &User) -> Result<()> {
        // Implementation
    }

    async fn delete(&self, id: &str) -> Result<()> {
        // Implementation
    }
}
```

## Asynchronous Programming

### Tokio Runtime
```rust
use tokio::time::{sleep, Duration};
use reqwest;

#[tokio::main]
async fn main() -> Result<()> {
    let result = fetch_data().await?;
    println!("Result: {:?}", result);
    Ok(())
}

// Async function
async fn fetch_data() -> Result<String> {
    let response = reqwest::get("https://api.example.com/data")
        .await?
        .text()
        .await?;

    Ok(response)
}

// Parallel async operations
async fn fetch_multiple() -> Result<Vec<User>> {
    let futures = vec![
        fetch_user("1"),
        fetch_user("2"),
        fetch_user("3"),
    ];

    // Wait for all futures
    let results = futures::future::try_join_all(futures).await?;
    Ok(results)
}

// Timeout handling
use tokio::time::timeout;

async fn fetch_with_timeout() -> Result<String> {
    let result = timeout(
        Duration::from_secs(5),
        fetch_data()
    ).await;

    match result {
        Ok(Ok(data)) => Ok(data),
        Ok(Err(e)) => Err(e),
        Err(_) => Err(AppError::Unknown), // Timeout
    }
}
```

### Channels and Concurrency
```rust
use tokio::sync::{mpsc, oneshot};

// Multi-producer, single-consumer channel
async fn process_items(items: Vec<Item>) -> Result<Vec<Result>> {
    let (tx, mut rx) = mpsc::channel(100);

    // Spawn worker tasks
    for item in items {
        let tx = tx.clone();
        tokio::spawn(async move {
            let result = process_item(item).await;
            tx.send(result).await.ok();
        });
    }
    drop(tx); // Close channel

    // Collect results
    let mut results = Vec::new();
    while let Some(result) = rx.recv().await {
        results.push(result);
    }

    Ok(results)
}
```

## Configuration Management

### Environment Variables with Config
```rust
use config::{Config, ConfigError, Environment, File};
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct AppConfig {
    pub app_name: String,
    pub environment: String,
    pub port: u16,
    pub database_url: String,
    pub redis_url: Option<String>,
    pub log_level: String,
}

impl AppConfig {
    pub fn load() -> Result<Self, ConfigError> {
        let env = std::env::var("ENVIRONMENT").unwrap_or_else(|_| "development".into());

        let config = Config::builder()
            // Default values
            .set_default("app_name", "{{PROJECT_NAME}}")?
            .set_default("environment", &env)?
            .set_default("port", 8080)?
            .set_default("log_level", "info")?
            // Load from file (optional)
            .add_source(File::with_name("config/default").required(false))
            .add_source(File::with_name(&format!("config/{}", env)).required(false))
            // Override with environment variables
            .add_source(Environment::with_prefix("APP"))
            .build()?;

        config.try_deserialize()
    }
}
```

## Prohibited Practices

### FORBIDDEN:

1. **Using `unwrap()` or `expect()` in production**
   ```rust
   // BAD
   let value = some_option.unwrap();
   let result = some_result.expect("failed");

   // GOOD
   let value = some_option.ok_or(AppError::NotFound("Value missing".into()))?;
   let result = some_result?;

   // Or pattern matching
   let value = match some_option {
       Some(v) => v,
       None => return Err(AppError::NotFound("Value missing".into())),
   };
   ```

2. **Using `panic!()` for error handling**
   ```rust
   // BAD
   if value < 0 {
       panic!("Negative value!");
   }

   // GOOD
   if value < 0 {
       return Err(AppError::InvalidInput("Value must be positive".into()));
   }
   ```

3. **Ignoring Result types**
   ```rust
   // BAD
   let _ = risky_operation(); // Ignoring potential error

   // GOOD
   risky_operation()?;
   // Or explicitly handle
   match risky_operation() {
       Ok(_) => println!("Success"),
       Err(e) => eprintln!("Error: {}", e),
   }
   ```

4. **Unnecessary cloning**
   ```rust
   // BAD
   fn process_name(name: String) -> String {
       name.clone().to_uppercase()
   }

   // GOOD
   fn process_name(name: &str) -> String {
       name.to_uppercase()
   }
   ```

5. **Using `unsafe` without justification**
   ```rust
   // Only use unsafe when:
   // 1. Interfacing with C code
   // 2. Performance-critical with proof
   // 3. Well-documented invariants
   // 4. Thoroughly tested

   // Document safety invariants
   /// # Safety
   /// Caller must ensure that `ptr` is valid and properly aligned
   unsafe fn read_from_ptr(ptr: *const u8) -> u8 {
       *ptr
   }
   ```

## Logging Standards

### Structured Logging with tracing
```rust
use tracing::{info, warn, error, debug, instrument};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

// Setup logging
pub fn setup_logging(log_level: &str) {
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| log_level.into()),
        )
        .with(tracing_subscriber::fmt::layer().json())
        .init();
}

// Usage with structured fields
#[instrument(skip(db))]
pub async fn fetch_user(db: &Database, user_id: &str) -> Result<User> {
    info!(user_id = %user_id, "Fetching user");

    match db.find_user(user_id).await {
        Ok(Some(user)) => {
            debug!(user_id = %user_id, user_name = %user.name, "User found");
            Ok(user)
        }
        Ok(None) => {
            warn!(user_id = %user_id, "User not found");
            Err(AppError::NotFound(format!("User {} not found", user_id)))
        }
        Err(e) => {
            error!(user_id = %user_id, error = %e, "Database error");
            Err(AppError::Database(e))
        }
    }
}
```

## HTTP Server with Axum

### Server Setup
```rust
use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::{get, post},
    Json, Router,
};
use std::sync::Arc;
use tokio::net::TcpListener;

// Shared application state
#[derive(Clone)]
pub struct AppState {
    pub db: Arc<Database>,
    pub config: Arc<AppConfig>,
}

// Error response
impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, message) = match self {
            AppError::NotFound(msg) => (StatusCode::NOT_FOUND, msg),
            AppError::InvalidInput(msg) => (StatusCode::BAD_REQUEST, msg),
            _ => (StatusCode::INTERNAL_SERVER_ERROR, "Internal error".to_string()),
        };

        (status, Json(serde_json::json!({ "error": message }))).into_response()
    }
}

// Handler
async fn get_user(
    State(state): State<AppState>,
    Path(user_id): Path<String>,
) -> Result<Json<User>> {
    let user = state.db.find_user(&user_id).await?;
    Ok(Json(user))
}

// Main server
#[tokio::main]
async fn main() -> Result<()> {
    setup_logging("info");

    let config = Arc::new(AppConfig::load()?);
    let db = Arc::new(Database::new(&config.database_url).await?);

    let state = AppState { db, config: config.clone() };

    let app = Router::new()
        .route("/health", get(health_check))
        .route("/api/users/:id", get(get_user))
        .with_state(state);

    let addr = format!("0.0.0.0:{}", config.port);
    let listener = TcpListener::bind(&addr).await?;

    info!("Server listening on {}", addr);
    axum::serve(listener, app).await?;

    Ok(())
}
```

## Dependency Management

### Cargo.toml
```toml
[package]
name = "{{PROJECT_NAME}}"
version = "0.1.0"
edition = "2021"
rust-version = "1.75"

[dependencies]
# Async runtime
tokio = { version = "1.35", features = ["full"] }

# Web framework
axum = "0.7"

# Serialization
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"

# Error handling
thiserror = "1.0"
anyhow = "1.0"

# Logging
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["json", "env-filter"] }

# HTTP client
reqwest = { version = "0.11", features = ["json"] }

# Database (example)
sqlx = { version = "0.7", features = ["runtime-tokio-native-tls", "postgres"] }

# Configuration
config = "0.13"

# Date/time
chrono = { version = "0.4", features = ["serde"] }

[dev-dependencies]
# Testing
tokio-test = "0.4"
proptest = "1.4"

# Coverage
cargo-tarpaulin = "0.27"

[profile.release]
opt-level = 3
lto = true
codegen-units = 1
strip = true

[profile.dev]
opt-level = 0
debug = true
```

### Makefile
```makefile
.PHONY: build test lint fmt check clean run

build:
	cargo build --release

test:
	cargo test --all-features

test-coverage:
	cargo tarpaulin --out Html --output-dir coverage

lint:
	cargo clippy -- -D warnings

fmt:
	cargo fmt

check:
	cargo check

clean:
	cargo clean

run:
	cargo run

install-tools:
	rustup component add rustfmt clippy
	cargo install cargo-tarpaulin
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
1. **Profile First**: Use `cargo flamegraph` or `perf`
2. **Avoid Allocations**: In hot paths, use stack allocation
3. **Use `&str` over `String`**: When ownership not needed
4. **Lazy Statics**: Use `once_cell` or `lazy_static`
5. **Zero-Copy Parsing**: Use `serde` efficiently

```rust
// Use Cow for flexible ownership
use std::borrow::Cow;

fn process_string(s: Cow<str>) -> Cow<str> {
    if s.contains("old") {
        Cow::Owned(s.replace("old", "new"))
    } else {
        s  // No allocation needed
    }
}
```

## Security Best Practices

1. **Environment Variables**: All secrets via environment
2. **Input Validation**: Validate all inputs
3. **SQL Injection**: Use prepared statements (sqlx)
4. **Dependency Auditing**: Run `cargo audit` regularly
5. **Memory Safety**: Leverage Rust's guarantees
6. **No `unsafe` without review**: Thoroughly document and test

---

**Last Updated**: 2025-10-19
**Rust Version**: 1.75+
**Edition**: 2021
**Framework**: {{FRAMEWORK}}
