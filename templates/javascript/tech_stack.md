# Technology Stack and Conventions

## Core Stack
- **Language**: TypeScript 5.0+ (strict mode enabled)
- **Runtime**: Node.js 20+ LTS
- **Framework**: {{FRAMEWORK}} (Express/Next.js/NestJS/React)
- **Package Manager**: npm or pnpm (specify in project)

## TypeScript-Specific Best Practices

### Type Safety
- **Strict Mode**: Always enabled in `tsconfig.json`
- **No `any` types**: Use `unknown` or proper type definitions
- **Type Inference**: Let TypeScript infer types when obvious
- **Generics**: Use for reusable, type-safe components
- **Type Guards**: For runtime type checking

### TypeScript Configuration
```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ES2022", "DOM", "DOM.Iterable"],
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
```

## Code Quality Tools

### Linting and Formatting
- **ESLint**: Code linting with TypeScript support
- **Prettier**: Code formatting (integrated with ESLint)
- **TypeScript Compiler**: Static type checking
- **Husky**: Git hooks for automated checks

### ESLint Configuration
```json
{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/recommended-requiring-type-checking",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "rules": {
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "no-console": ["warn", { "allow": ["warn", "error"] }]
  }
}
```

## Testing Framework

### Testing Stack
- **Vitest or Jest**: Primary testing framework
- **Testing Library**: For React/DOM testing
- **Supertest**: For API endpoint testing
- **MSW (Mock Service Worker)**: For mocking HTTP requests
- **Minimum Coverage**: 80%

### Test Example
```typescript
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { fetchUserData } from './api';

describe('fetchUserData', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('should fetch user data successfully', async () => {
    // Arrange
    const userId = 'test-123';
    const mockData = { id: userId, name: 'Test User' };

    // Act
    const result = await fetchUserData(userId);

    // Assert
    expect(result).toEqual(mockData);
    expect(result.id).toBe(userId);
  });

  it('should handle errors gracefully', async () => {
    // Arrange
    const invalidId = 'invalid';

    // Act & Assert
    await expect(fetchUserData(invalidId)).rejects.toThrow();
  });
});
```

## Project Structure

```
{{PROJECT_NAME}}/
├── src/
│   ├── api/           # API routes/endpoints
│   ├── components/    # React components (if applicable)
│   ├── services/      # Business logic
│   ├── models/        # TypeScript types and interfaces
│   ├── utils/         # Utility functions
│   ├── config/        # Configuration
│   └── index.ts       # Entry point
├── tests/             # Test files
├── dist/              # Compiled output
├── package.json
├── tsconfig.json
├── .eslintrc.json
├── .prettierrc
└── .env.example
```

## Asynchronous Patterns

### Promises and Async/Await
```typescript
// Type-safe async function
async function fetchData(url: string): Promise<UserData> {
  try {
    const response = await fetch(url, {
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data: UserData = await response.json();
    return data;
  } catch (error) {
    console.error('Failed to fetch data:', error);
    throw error;
  }
}
```

### Error Handling
```typescript
// Custom error types
class APIError extends Error {
  constructor(
    message: string,
    public statusCode: number,
    public cause?: unknown
  ) {
    super(message);
    this.name = 'APIError';
  }
}

// Type-safe error handling
function isAPIError(error: unknown): error is APIError {
  return error instanceof APIError;
}

// Usage
try {
  await riskyOperation();
} catch (error) {
  if (isAPIError(error)) {
    console.error(`API Error ${error.statusCode}: ${error.message}`);
  } else if (error instanceof Error) {
    console.error(`Error: ${error.message}`);
  } else {
    console.error('Unknown error:', error);
  }
}
```

## Type Definitions

### Interfaces vs Types
```typescript
// Use interfaces for object shapes that may be extended
interface User {
  id: string;
  name: string;
  email: string;
}

interface AdminUser extends User {
  role: 'admin';
  permissions: string[];
}

// Use types for unions, intersections, and utilities
type Status = 'active' | 'inactive' | 'pending';
type Result<T> = { success: true; data: T } | { success: false; error: string };

// Utility types
type PartialUser = Partial<User>;
type ReadonlyUser = Readonly<User>;
type UserKeys = keyof User;
```

### Generics
```typescript
// Generic function
function identity<T>(value: T): T {
  return value;
}

// Generic class
class ApiClient<TResponse> {
  constructor(private baseUrl: string) {}

  async get(endpoint: string): Promise<TResponse> {
    const response = await fetch(`${this.baseUrl}${endpoint}`);
    return response.json() as Promise<TResponse>;
  }
}

// Usage
const userClient = new ApiClient<User>('https://api.example.com');
const user = await userClient.get('/users/123');
```

## Data Validation

### Zod for Runtime Validation
```typescript
import { z } from 'zod';

// Define schema
const UserSchema = z.object({
  id: z.string().uuid(),
  name: z.string().min(2).max(50),
  email: z.string().email(),
  age: z.number().int().positive().optional(),
  createdAt: z.date(),
});

// Infer TypeScript type from schema
type User = z.infer<typeof UserSchema>;

// Validate data
function validateUser(data: unknown): User {
  return UserSchema.parse(data); // Throws on invalid data
}

// Safe validation
function safeValidateUser(data: unknown): Result<User> {
  const result = UserSchema.safeParse(data);
  if (result.success) {
    return { success: true, data: result.data };
  }
  return { success: false, error: result.error.message };
}
```

## Environment Configuration

### Type-Safe Environment Variables
```typescript
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  PORT: z.string().transform(Number).pipe(z.number().int().positive()),
  DATABASE_URL: z.string().url(),
  API_KEY: z.string().min(1),
  LOG_LEVEL: z.enum(['debug', 'info', 'warn', 'error']).default('info'),
});

export type Env = z.infer<typeof envSchema>;

export function loadEnv(): Env {
  const result = envSchema.safeParse(process.env);

  if (!result.success) {
    console.error('Invalid environment variables:');
    console.error(result.error.format());
    process.exit(1);
  }

  return result.data;
}

export const config = loadEnv();
```

## Prohibited Practices

### FORBIDDEN:

1. **Using `any` type**
   ```typescript
   // BAD
   function process(data: any): any {
     return data;
   }

   // GOOD
   function process<T>(data: T): T {
     return data;
   }

   // Or if truly unknown
   function process(data: unknown): string {
     if (typeof data === 'string') {
       return data;
     }
     throw new Error('Invalid data type');
   }
   ```

2. **Ignoring type errors**
   ```typescript
   // BAD
   // @ts-ignore
   const value = dangerousOperation();

   // GOOD - Fix the type issue or use proper type guard
   const value = isValidData(data) ? data : defaultValue;
   ```

3. **Mutation of readonly data**
   ```typescript
   // BAD
   function modifyUser(user: Readonly<User>): void {
     user.name = 'New Name'; // Error!
   }

   // GOOD
   function updateUser(user: Readonly<User>): User {
     return { ...user, name: 'New Name' };
   }
   ```

4. **Non-null assertions without validation**
   ```typescript
   // BAD
   const value = maybeUndefined!.property;

   // GOOD
   const value = maybeUndefined?.property ?? defaultValue;
   ```

5. **Unhandled promise rejections**
   ```typescript
   // BAD
   async function riskyOperation(): Promise<void> {
     await mightFail();
     // No error handling!
   }

   // GOOD
   async function safeOperation(): Promise<Result<void>> {
     try {
       await mightFail();
       return { success: true, data: undefined };
     } catch (error) {
       return { success: false, error: String(error) };
     }
   }
   ```

## Logging Standards

### Structured Logging
```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: config.LOG_LEVEL,
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    }),
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});

// Usage with context
logger.info('User logged in', { userId: '123', ip: '192.168.1.1' });
logger.error('Failed to fetch data', { error: err, userId: '123' });
```

## API Design Patterns

### RESTful API with Express
```typescript
import express, { Request, Response, NextFunction } from 'express';

interface TypedRequest<TBody> extends Request {
  body: TBody;
}

interface TypedResponse<TData> extends Response {
  json: (data: TData) => this;
}

// Type-safe route handler
const getUserHandler = async (
  req: Request<{ id: string }>,
  res: TypedResponse<User>
): Promise<void> => {
  const user = await userService.findById(req.params.id);
  res.json(user);
};

// Error handling middleware
const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  logger.error('Request failed', { error: err, path: req.path });

  if (isAPIError(err)) {
    res.status(err.statusCode).json({ error: err.message });
  } else {
    res.status(500).json({ error: 'Internal server error' });
  }
};
```

## Performance Optimization

### Best Practices
1. **Lazy Loading**: Load modules/components only when needed
2. **Memoization**: Cache expensive computations
3. **Debouncing/Throttling**: Limit frequent operations
4. **Tree Shaking**: Remove unused code in production builds
5. **Code Splitting**: Split large bundles

```typescript
// Memoization example
function memoize<TArgs extends unknown[], TResult>(
  fn: (...args: TArgs) => TResult
): (...args: TArgs) => TResult {
  const cache = new Map<string, TResult>();

  return (...args: TArgs): TResult => {
    const key = JSON.stringify(args);
    if (cache.has(key)) {
      return cache.get(key)!;
    }
    const result = fn(...args);
    cache.set(key, result);
    return result;
  };
}
```

## Dependency Management

### package.json
```json
{
  "name": "{{PROJECT_NAME}}",
  "version": "0.1.0",
  "description": "{{PROJECT_DESC}}",
  "type": "module",
  "engines": {
    "node": ">=20.0.0"
  },
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "test": "vitest",
    "test:coverage": "vitest --coverage",
    "lint": "eslint src --ext .ts",
    "format": "prettier --write 'src/**/*.ts'",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "zod": "^3.22.4"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^6.15.0",
    "@typescript-eslint/parser": "^6.15.0",
    "eslint": "^8.56.0",
    "eslint-config-prettier": "^9.1.0",
    "prettier": "^3.1.1",
    "tsx": "^4.7.0",
    "typescript": "^5.3.3",
    "vitest": "^1.0.4"
  }
}
```

## Version Control

### Git Workflow
- **Branch Naming**: `feature/`, `bugfix/`, `hotfix/`, `docs/`
- **Commit Messages**: Conventional Commits
  - `feat:` - New feature
  - `fix:` - Bug fix
  - `docs:` - Documentation
  - `refactor:` - Code refactoring
  - `test:` - Tests
  - `chore:` - Maintenance

### Git Hooks (Husky)
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "pre-push": "npm run test"
    }
  },
  "lint-staged": {
    "*.ts": [
      "eslint --fix",
      "prettier --write",
      "vitest related --run"
    ]
  }
}
```

## Security Best Practices

1. **Environment Variables**: Never commit `.env` files
2. **Input Validation**: Validate all user inputs with Zod
3. **SQL Injection**: Use parameterized queries or ORM
4. **XSS Prevention**: Sanitize user-generated content
5. **Dependency Audits**: Run `npm audit` regularly
6. **HTTPS Only**: All external requests over HTTPS
7. **Rate Limiting**: Implement for public APIs

```typescript
// Input sanitization
import DOMPurify from 'isomorphic-dompurify';

function sanitizeUserInput(input: string): string {
  return DOMPurify.sanitize(input, { ALLOWED_TAGS: [] });
}
```

---

**Last Updated**: 2025-10-19
**TypeScript Version**: 5.0+
**Node.js Version**: 20+ LTS
**Framework**: {{FRAMEWORK}}
