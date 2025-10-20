# Language-Specific Templates

This directory contains language-specific templates for the AI SWE Template system. These templates are automatically selected during project initialization based on the primary programming language.

## Overview

When setting up a new project with the AI SWE Template, the setup script will:

1. **Detect or prompt** for the primary programming language
2. **Select** the appropriate language-specific template
3. **Copy** language-specific files to `.memory_bank/`
4. **Replace placeholders** with actual project values

## Available Languages

### Python (`templates/python/`)
**Use for**: Python 3.11+ projects

**Includes**:
- `tech_stack.md` - Python-specific tech stack and best practices
- Async/await patterns (asyncio)
- Type hints and mypy configuration
- pytest testing framework
- Poetry dependency management
- Common frameworks: FastAPI, Django, Flask
- Pydantic for validation

**Best for**:
- Web APIs
- Data processing
- Machine learning applications
- Telegram bots (like this project)
- Automation scripts

### JavaScript/TypeScript (`templates/javascript/`)
**Use for**: Node.js and TypeScript projects

**Includes**:
- `tech_stack.md` - TypeScript-specific tech stack and best practices
- Strict TypeScript configuration
- Zod for runtime validation
- Vitest or Jest testing framework
- ESLint and Prettier configuration
- Common frameworks: Express, Next.js, NestJS, React

**Best for**:
- Web applications
- RESTful APIs
- Frontend applications
- Full-stack applications
- Real-time applications

### Go (`templates/go/`)
**Use for**: Go 1.21+ projects

**Includes**:
- `tech_stack.md` - Go-specific tech stack and best practices
- Standard library focus
- Goroutines and channels patterns
- Table-driven tests
- golangci-lint configuration
- Common frameworks: Gin, Echo, Chi, Standard Library

**Best for**:
- Microservices
- System programming
- CLI tools
- High-performance APIs
- Concurrent applications

### Rust (`templates/rust/`)
**Use for**: Rust 1.75+ projects

**Includes**:
- `tech_stack.md` - Rust-specific tech stack and best practices
- Ownership and borrowing patterns
- Tokio async runtime
- Result and Option handling
- clippy and rustfmt configuration
- Common frameworks: Actix, Axum, Rocket

**Best for**:
- Systems programming
- Performance-critical applications
- Embedded systems
- WebAssembly
- CLI tools

## Template Structure

Each language template follows this structure:

```
templates/{language}/
├── tech_stack.md              # Language-specific tech stack
└── workflows/                 # (Optional) Enhanced workflows
    ├── new_feature.md
    ├── bug_fix.md
    └── code_review.md
```

**Note**: Workflows are optional. If not provided, the generic workflows from `.memory_bank/workflows/` will be used.

## Placeholders

All template files use consistent placeholders that are replaced during setup:

| Placeholder | Description | Example |
|------------|-------------|---------|
| `{{PROJECT_NAME}}` | Project name | `my-awesome-app` |
| `{{PROJECT_DESC}}` | Project description | `A web API for user management` |
| `{{LANGUAGE}}` | Primary language | `python`, `javascript`, `go`, `rust` |
| `{{FRAMEWORK}}` | Framework choice | `FastAPI`, `Express`, `Gin`, `Axum` |
| `{{PROJECT_TYPE}}` | Type of project | `web-api`, `cli`, `library` |

### Example Template Content

```markdown
# Technology Stack for {{PROJECT_NAME}}

**Language**: {{LANGUAGE}}
**Framework**: {{FRAMEWORK}}
**Description**: {{PROJECT_DESC}}

## Core Stack
...
```

After replacement:

```markdown
# Technology Stack for user-api

**Language**: Python
**Framework**: FastAPI
**Description**: A web API for user management

## Core Stack
...
```

## How Language Detection Works

The setup script (`scripts/setup.sh`) uses the following logic:

### 1. Interactive Mode (Default)
```bash
./scripts/setup.sh

# Prompts user:
# "Primary language (python/javascript/go/rust): "
```

### 2. Automatic Detection (Planned)
Detects language from existing files:
- `*.py`, `pyproject.toml`, `requirements.txt` → Python
- `*.ts`, `*.js`, `package.json`, `tsconfig.json` → JavaScript/TypeScript
- `*.go`, `go.mod` → Go
- `*.rs`, `Cargo.toml` → Rust

### 3. Command-Line Flag (Planned)
```bash
./scripts/setup.sh --language python --framework FastAPI
```

## Adding a New Language

To add support for a new language (e.g., Java, PHP, C#):

### Step 1: Create Directory
```bash
mkdir -p templates/java
```

### Step 2: Create tech_stack.md
Create `templates/java/tech_stack.md` following this template:

```markdown
# Technology Stack and Conventions

## Core Stack
- **Language**: Java 17+ LTS
- **Framework**: {{FRAMEWORK}} (Spring Boot/Quarkus/Micronaut)
- **Build Tool**: Maven or Gradle

## Java-Specific Best Practices

### Type Safety
- Use modern Java features (records, sealed classes, pattern matching)
- Leverage strong typing
...

## Code Quality Tools
- **Checkstyle**: Code style checking
- **SpotBugs**: Static analysis
- **JUnit 5**: Testing framework
...

## Prohibited Practices
1. Avoid raw types
2. Don't suppress warnings without justification
3. Always close resources (use try-with-resources)
...
```

### Step 3: Update Setup Script
In `scripts/setup.sh`, add the new language to the case statement:

```bash
case $LANG in
    python)
        echo "Setting up Python project..."
        cp templates/python/tech_stack.md .memory_bank/tech_stack.md
        ;;
    javascript|typescript)
        echo "Setting up JavaScript/TypeScript project..."
        cp templates/javascript/tech_stack.md .memory_bank/tech_stack.md
        ;;
    java)  # NEW
        echo "Setting up Java project..."
        cp templates/java/tech_stack.md .memory_bank/tech_stack.md
        ;;
    # ... other languages
esac
```

### Step 4: Update Documentation
Add the new language to:
1. This `templates/README.md` (Available Languages section)
2. Main `README.md` (if it mentions supported languages)
3. `TEMPLATE_STRATEGY.md` (if applicable)

## Template Best Practices

When creating or updating language templates:

### 1. Follow Consistent Structure
All `tech_stack.md` files should include:
- Core Stack section
- Code Quality Tools
- Testing Framework
- Project Structure
- Best Practices specific to the language
- Prohibited Practices (anti-patterns)
- Logging Standards
- Configuration Management
- Version Control
- Security Best Practices

### 2. Use Professional Tone
- Be direct and actionable
- Use imperative mood ("Use X", "Avoid Y")
- Provide code examples
- Explain the "why" behind practices

### 3. Include Working Code Examples
All code examples should:
- Be syntactically correct
- Follow the language's conventions
- Demonstrate best practices
- Include comments when necessary

### 4. Reference Memory Bank Patterns
Link to generic patterns when applicable:
```markdown
For error handling, follow the patterns described in
**[.memory_bank/patterns/error_handling.md](.memory_bank/patterns/error_handling.md)**
```

### 5. Keep Placeholders Consistent
Always use the standard placeholder format:
- `{{PLACEHOLDER_NAME}}` (uppercase, underscores)
- Never hardcode project-specific values

## Maintenance

### Updating Templates
When updating templates:

1. **Test changes** with a fresh project setup
2. **Update version date** at bottom of `tech_stack.md`
3. **Document breaking changes** in commit message
4. **Keep consistency** across all language templates

### Version Information
Each `tech_stack.md` includes version metadata:

```markdown
---

**Last Updated**: 2025-10-19
**Language Version**: Python 3.11+ / TypeScript 5.0+ / Go 1.21+ / Rust 1.75+
**Framework**: {{FRAMEWORK}}
```

### Syncing with Main Template
If core Memory Bank structure changes:
1. Review all language templates
2. Update language-specific sections
3. Test setup script with each language
4. Commit all languages together

## Integration with Setup Script

The setup script uses templates as follows:

```bash
# 1. Detect or prompt for language
read -p "Primary language (python/javascript/go/rust): " LANG

# 2. Copy language-specific files
case $LANG in
    python)
        cp templates/python/tech_stack.md .memory_bank/tech_stack.md
        cp -r templates/python/workflows/* .memory_bank/workflows/ 2>/dev/null || true
        ;;
    # ... other languages
esac

# 3. Replace placeholders
find .memory_bank -type f -name "*.md" -exec sed -i \
    -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{LANGUAGE}}/$LANG/g" \
    -e "s/{{FRAMEWORK}}/$FRAMEWORK/g" \
    {} \;
```

## Testing Templates

### Manual Testing
To test a language template:

```bash
# 1. Create test directory
mkdir -p /tmp/test-python-template
cd /tmp/test-python-template

# 2. Copy template repository
git clone <template-repo-url> .

# 3. Run setup
./scripts/setup.sh

# 4. Follow prompts:
# - Project name: test-project
# - Description: Testing Python template
# - Language: python
# - Framework: FastAPI

# 5. Verify results
cat .memory_bank/tech_stack.md | grep "FastAPI"
cat .memory_bank/tech_stack.md | grep "test-project"
```

### Automated Testing (Future)
```bash
# Test all languages
./scripts/test-templates.sh

# Test specific language
./scripts/test-templates.sh --language python
```

## Common Issues and Solutions

### Issue: Placeholders not replaced
**Cause**: Incorrect placeholder format or sed command failure

**Solution**:
1. Check placeholder format: `{{PLACEHOLDER}}` (double braces)
2. Verify sed command in setup script
3. Test with: `echo "{{PROJECT_NAME}}" | sed 's/{{PROJECT_NAME}}/MyProject/g'`

### Issue: Wrong language template selected
**Cause**: Language detection logic or typo in input

**Solution**:
1. Check detection logic in `setup.sh`
2. Add validation for language input
3. Provide clear error messages

### Issue: Template files not found
**Cause**: Directory structure mismatch

**Solution**:
1. Verify directory structure matches documentation
2. Check file paths in setup script
3. Use absolute paths or `realpath` for reliability

## Resources

### Language-Specific Resources

**Python**:
- [PEP 8 Style Guide](https://peps.python.org/pep-0008/)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [asyncio Documentation](https://docs.python.org/3/library/asyncio.html)

**TypeScript**:
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/)
- [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
- [Zod Documentation](https://zod.dev/)

**Go**:
- [Effective Go](https://go.dev/doc/effective_go)
- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Standard Go Project Layout](https://github.com/golang-standards/project-layout)

**Rust**:
- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
- [Tokio Tutorial](https://tokio.rs/tokio/tutorial)

### Generic Resources
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)
- [Memory Bank Documentation](../.memory_bank/README.md)

---

**Last Updated**: 2025-10-19
**Template Version**: 1.0
**Maintainer**: AI SWE Template Project
