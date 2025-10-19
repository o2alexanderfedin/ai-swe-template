# AI SWE Implementation Plan

## Overview
This document provides a comprehensive, hierarchical implementation plan for setting up the AI Software Engineering (AI SWE) methodology based on the Memory Bank concept. The plan is organized into major components, subdirectories, and individual files with their required content structures.

---

## Level 1: Major Components

### 1.1 Memory Bank Setup
### 1.2 Workflows Directory
### 1.3 Claude Code Configuration
### 1.4 Custom Commands Setup

---

## COMPONENT 1: Memory Bank Setup

**Purpose**: Create a structured knowledge base that serves as the "brain" of the project for AI agents.

**Location**: `/.memory_bank/`

**Dependencies**: None (this is the foundation)

**Success Criteria**:
- Directory structure is created
- All core files are populated with appropriate content
- Navigation structure is logical and hierarchical
- Links between documents are functional

---

### 1.1.1 Core Memory Bank Files

#### Task 1.1.1.1: Create README.md (Navigation Hub)

**File**: `/.memory_bank/README.md`

**Purpose**: Main entry point and navigation router for all project knowledge

**Dependencies**: None

**Content Structure**:

```markdown
# Memory Bank: Единый источник истины проекта

Этот банк памяти — твой главный источник информации. Перед началом любой задачи **обязательно** ознакомься с этим файлом и перейди по релевантным ссылкам.

## Обязательная последовательность чтения перед ЛЮБОЙ задачей

1.  **[Технический стек](./tech_stack.md)**: Узнай, какие технологии, библиотеки и версии мы используем.
2.  **[Стандарты кодирования](./guides/coding_standards.md)**: Ознакомься с правилами форматирования, именования и лучшими практиками.
3.  **[Текущие задачи](./current_tasks.md)**: Проверь список активных задач, чтобы понять текущий фокус команды.

## Карта системы знаний

### 1. О проекте (Контекст "ЗАЧЕМ")
- **[Описание продукта](./product_brief.md)**: Бизнес-цели, целевая аудитория, ключевые функции. Обращайся сюда, чтобы понять *ЧТО* мы строим и *ДЛЯ КОГО*.

### 2. Техническая основа (Контекст "КАК")
- **[Технический стек](./tech_stack.md)**: Полный список фреймворков, библиотек и их версий. **ЗАПРЕЩЕНО** добавлять новые зависимости без обновления этого файла.
- **[Архитектурные паттерны](./patterns/)**: Фундаментальные решения. Изучи их перед внесением изменений в структуру модулей.
- **[Гайды по подсистемам](./guides/)**: Детальное описание ключевых модулей (например, аутентификация, платежная система).

### 3. Процессы и задачи (Контекст "ЧТО ДЕЛАТЬ")
- **[Рабочие процессы (Workflows)](./workflows/)**: Пошаговые инструкции для стандартных задач. Выбери нужный workflow для твоей текущей задачи.
  - **[Разработка новой фичи](./workflows/new_feature.md)**
  - **[Исправление бага](./workflows/bug_fix.md)**
- **[Спецификации (ТЗ)](./specs/)**: Детальные технические задания на новые фичи.

---
**Правило:** Если ты вносишь изменения, которые затрагивают архитектуру или добавляют новую зависимость, ты должен обновить соответствующий документ в Memory Bank.
```

**Success Criteria**:
- File exists at `/.memory_bank/README.md`
- Contains clear navigation structure
- All internal links are created (files may not exist yet)
- Mandatory reading sequence is defined

---

#### Task 1.1.1.2: Create tech_stack.md (Technical Passport)

**File**: `/.memory_bank/tech_stack.md`

**Purpose**: Define allowed technologies, libraries, versions, and forbidden practices

**Dependencies**: None

**Content Structure**:

```markdown
# Технологический стек и конвенции

## Core Stack
- **Frontend**: React 18 (использовать **ТОЛЬКО** функциональные компоненты с хуками).
- **State Management**: Redux Toolkit + RTK Query для всех асинхронных запросов.
- **Styling**: CSS Modules. **ЗАПРЕЩЕНО** использовать inline-стили или глобальные CSS-селекторы.

## Запрещенные практики
- ❌ Использование `any` в TypeScript. Все типы должны быть явно определены.
- ❌ Использование классовых компонентов в React.
- ❌ Прямые DOM-манипуляции. Всегда использовать React-way.

## API Конвенции
- Все API-запросы должны проходить через единый клиент `src/api/apiClient.ts`.
- Обработка ошибок должна соответствовать схеме, описанной в **[./patterns/error_handling.md](./patterns/error_handling.md)**.
```

**Customization Notes**:
- Replace with your actual tech stack (Python, Node.js, etc.)
- Add specific version numbers
- Include database technologies
- List testing frameworks
- Define CI/CD tools

**Success Criteria**:
- File exists at `/.memory_bank/tech_stack.md`
- All technologies used in project are listed
- Forbidden practices are clearly defined
- Links to related patterns are included

---

#### Task 1.1.1.3: Create product_brief.md (Business Context)

**File**: `/.memory_bank/product_brief.md`

**Purpose**: Help AI understand business context, goals, and target audience

**Dependencies**: None

**Content Structure**:

```markdown
# Описание продукта

## Название проекта
[Your Project Name]

## Цель проекта (ЗАЧЕМ)
[Describe the core business problem this project solves]

## Целевая аудитория (ДЛЯ КОГО)
[Describe your target users/customers]

## Ключевые функции
1. [Feature 1]
2. [Feature 2]
3. [Feature 3]

## Бизнес-метрики успеха
- [Metric 1]
- [Metric 2]

## Конкурентные преимущества
[What makes this project unique]
```

**Success Criteria**:
- File exists at `/.memory_bank/product_brief.md`
- Business goals are clearly articulated
- Target audience is defined
- Key features are listed

---

#### Task 1.1.1.4: Create current_tasks.md (Kanban Board)

**File**: `/.memory_bank/current_tasks.md`

**Purpose**: Living Kanban board for task synchronization

**Dependencies**: None

**Content Structure**:

```markdown
# Текущие задачи

## To Do
- [ ] [FE-42] Реализовать авторизацию через Google.
- [ ] [BE-17] Оптимизировать запросы к базе данных в отчете по продажам.

## In Progress
- [x] [FE-39] Сделать адаптивную верстку для главной страницы.

## Done
- [x] [BE-15] Внедрить кэширование для API-ответов каталога.
```

**Customization Notes**:
- Use your project's task ID format
- Update this file dynamically as work progresses
- Agent should update this automatically based on workflows

**Success Criteria**:
- File exists at `/.memory_bank/current_tasks.md`
- Three sections exist: To Do, In Progress, Done
- Task format includes ID and description

---

### 1.1.2 Patterns Directory

#### Task 1.1.2.1: Create /patterns directory

**Location**: `/.memory_bank/patterns/`

**Purpose**: Store fundamental architectural decisions and patterns

**Dependencies**: README.md should link to this directory

**Success Criteria**:
- Directory exists
- At least 2 pattern documents are created

---

#### Task 1.1.2.2: Create api_standards.md

**File**: `/.memory_bank/patterns/api_standards.md`

**Purpose**: Define API design patterns and conventions

**Dependencies**: patterns/ directory exists

**Content Structure**:

```markdown
# API Standards

## Naming Conventions
- Endpoints use lowercase with hyphens: `/api/user-profiles`
- Resource-based URLs, not action-based

## Request/Response Format
- All requests/responses use JSON
- Date formats: ISO 8601 (YYYY-MM-DDTHH:mm:ssZ)

## Error Handling
- Standard error response structure:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable message",
    "details": {}
  }
}
```

## Authentication
- [Describe your auth mechanism: JWT, OAuth, etc.]

## Versioning
- API versioning in URL: `/api/v1/...`
```

**Success Criteria**:
- File exists at `/.memory_bank/patterns/api_standards.md`
- All API conventions are documented
- Examples are provided

---

#### Task 1.1.2.3: Create error_handling.md

**File**: `/.memory_bank/patterns/error_handling.md`

**Purpose**: Define error handling patterns across the application

**Dependencies**: patterns/ directory exists

**Content Structure**:

```markdown
# Error Handling Patterns

## Philosophy
- Fail fast and explicitly
- Always log errors with context
- User-facing errors should be actionable

## Error Categories
1. **Validation Errors**: User input issues (4xx)
2. **System Errors**: Internal failures (5xx)
3. **Business Logic Errors**: Rule violations

## Implementation Pattern

### Python Example
```python
class ApplicationError(Exception):
    """Base exception class"""
    def __init__(self, message, code=None, details=None):
        self.message = message
        self.code = code
        self.details = details or {}
```

### JavaScript Example
```javascript
class ApplicationError extends Error {
  constructor(message, code, details = {}) {
    super(message);
    this.code = code;
    this.details = details;
  }
}
```

## Logging Standards
- Use structured logging
- Include correlation IDs
- Never log sensitive data
```

**Success Criteria**:
- File exists at `/.memory_bank/patterns/error_handling.md`
- Error handling philosophy is defined
- Code examples are provided
- Logging standards are specified

---

### 1.1.3 Guides Directory

#### Task 1.1.3.1: Create /guides directory

**Location**: `/.memory_bank/guides/`

**Purpose**: Store practical guides for specific subsystems and practices

**Dependencies**: README.md should link to this directory

**Success Criteria**:
- Directory exists
- At least 2 guide documents are created

---

#### Task 1.1.3.2: Create coding_standards.md

**File**: `/.memory_bank/guides/coding_standards.md`

**Purpose**: Define code formatting, naming, and best practices

**Dependencies**: guides/ directory exists

**Content Structure**:

```markdown
# Coding Standards

## General Principles
- Code readability over cleverness
- Self-documenting code with minimal comments
- Follow DRY (Don't Repeat Yourself)

## Naming Conventions

### Variables and Functions
- Use descriptive names: `getUserProfile()` not `getUP()`
- Boolean variables: `isActive`, `hasPermission`
- Constants: `UPPER_SNAKE_CASE`

### Files and Directories
- Components: `PascalCase.tsx`
- Utilities: `camelCase.ts`
- Tests: `componentName.test.ts`

## Code Organization
- Maximum file length: 300 lines
- Maximum function length: 50 lines
- Single Responsibility Principle

## Comments
- Use comments for "why", not "what"
- Update comments when code changes
- Document complex algorithms

## Formatting
- Use project's linter configuration
- Run formatter before committing
- Consistent indentation (2 or 4 spaces, not tabs)
```

**Success Criteria**:
- File exists at `/.memory_bank/guides/coding_standards.md`
- Naming conventions are defined
- Code organization rules are specified
- Examples are provided

---

#### Task 1.1.3.3: Create testing_strategy.md

**File**: `/.memory_bank/guides/testing_strategy.md`

**Purpose**: Define testing approach and requirements

**Dependencies**: guides/ directory exists

**Content Structure**:

```markdown
# Testing Strategy

## Testing Pyramid
1. **Unit Tests** (70%): Test individual functions and classes
2. **Integration Tests** (20%): Test module interactions
3. **E2E Tests** (10%): Test complete user flows

## Unit Testing Requirements
- All business logic must have unit tests
- Minimum 80% code coverage
- Test file naming: `module.test.js`

## Test Structure (AAA Pattern)
```javascript
describe('UserService', () => {
  it('should create a new user', () => {
    // Arrange
    const userData = { name: 'John', email: 'john@example.com' };

    // Act
    const user = userService.create(userData);

    // Assert
    expect(user.id).toBeDefined();
    expect(user.name).toBe('John');
  });
});
```

## Mocking Strategy
- Mock external dependencies (APIs, databases)
- Use dependency injection for testability

## Test Data
- Use factories for test data
- Never use production data in tests

## Running Tests
```bash
npm test              # Run all tests
npm run test:watch    # Watch mode
npm run test:coverage # Generate coverage report
```
```

**Success Criteria**:
- File exists at `/.memory_bank/guides/testing_strategy.md`
- Testing pyramid is defined
- Code coverage requirements are specified
- Examples are provided

---

### 1.1.4 Specs Directory

#### Task 1.1.4.1: Create /specs directory

**Location**: `/.memory_bank/specs/`

**Purpose**: Store detailed technical specifications for new features

**Dependencies**: README.md should link to this directory

**Success Criteria**:
- Directory exists
- Template for feature specs is created

---

#### Task 1.1.4.2: Create feature_spec_template.md

**File**: `/.memory_bank/specs/feature_spec_template.md`

**Purpose**: Provide template for writing detailed feature specifications

**Dependencies**: specs/ directory exists

**Content Structure**:

```markdown
# [FEATURE-ID]: [Feature Name]

**Epic:** [Link to Epic if applicable]

**Status:** [Planning / In Development / In Review / Done]

## Аннотация
[1-2 sentence summary of what this feature does and why it's needed]

## Описание задачи
[Detailed description of the feature, including:
- Current state/problem
- Desired outcome
- How it fits into the larger system]

## Ключевые компоненты для реализации

### 1. [Component Name]
- **Location:** `path/to/component`
- **Purpose:** [What this component does]
- **Important:** [Any constraints, existing code to reuse, or patterns to follow]

### 2. [Component Name]
- **Location:** `path/to/component`
- **Purpose:** [What this component does]

## Структура данных

### API Request Schema
```json
{
  "field1": "type",
  "field2": "type"
}
```

### API Response Schema
```json
{
  "field1": "type",
  "field2": "type"
}
```

## API Endpoints

### 1. [Endpoint Name]
- **Method:** `POST/GET/PUT/DELETE`
- **Endpoint:** `/api/path`
- **Request Body:** [Schema reference]
- **Action:** [What this endpoint does step-by-step]
- **Response:** `200 OK` [Response body structure]

### 2. [Endpoint Name]
[Same structure as above]

## Файлы для создания/изменения
- [ ] `path/to/file1.ts` - [Purpose]
- [ ] `path/to/file2.ts` - [Purpose]
- [ ] `path/to/test.test.ts` - [Purpose]

## Критерии приемки
- [ ] [Specific testable criterion 1]
- [ ] [Specific testable criterion 2]
- [ ] [Specific testable criterion 3]
- [ ] All unit tests pass
- [ ] Code follows coding standards
- [ ] Documentation is updated

## Зависимости от других компонентов
- [Component/Module Name]: [How it's used]
- [Shared Utility]: Import from `path/to/utility`

## Ограничения и известные проблемы
- [Any technical limitations]
- [Known edge cases]
```

**Usage Notes**:
- Copy this template for each new feature
- Fill in all sections during planning phase (with Gemini)
- Use this as input for execution phase (with Claude Code)

**Success Criteria**:
- Template exists at `/.memory_bank/specs/feature_spec_template.md`
- All sections are clearly defined
- Examples show proper level of detail

---

#### Task 1.1.4.3: Create example_feature_spec.md

**File**: `/.memory_bank/specs/example_feature_spec.md`

**Purpose**: Provide real example based on article content

**Dependencies**: specs/ directory exists

**Content Structure** (from article):

```markdown
# FT-052: Разработка API для управления парком IoT-устройств (Command & Control)

**Эпик:** [EPIC-05: IoT Platform Core](EPIC-05-IoT-Platform-Core.md)

**Аннотация:** Реализовать центральный API-шлюз (Command & Control API), который служит единой точкой для отправки команд на парк IoT-устройств. API должен принимать команды, валидировать их, логировать и публиковать в Kafka для асинхронной доставки.

## Описание задачи
Этот API заменяет старый RPC-сервис, который работал нестабильно. Новый API не доставляет команды сам, а лишь быстро регистрирует их. Специализированные воркеры будут слушать топик Kafka и отвечать за доставку.

## Ключевые компоненты для реализации
1.  **FastAPI Application**: Основа для API. Расположить в `services/command_control/main.py`.
2.  **Pydantic Schemas**: Модели для валидации запросов.
    - **Важно:** Базовые схемы, такие как `BatchCommandRequest`, уже реализованы в `core/src/schemas.py`. **Ты должен импортировать и расширять их**, а не создавать новые.
3.  **Kafka Producer**: Для отправки команд в топик `device-commands`.
    - **Важно:** Взаимодействие с Kafka должно осуществляться через готовый клиент, реализованный в `core/src/kafka/kafka_client.py`. **Импортируй и используй `kafka_producer` из этого модуля.**

## Структура события в Kafka
Каждая команда, отправляемая в Kafka, должна соответствовать этой JSON-схеме:
```json
{
  "command_id": "uuid",
  "device_id": "string",
  "command_type": "UPDATE_FIRMWARE" | "REBOOT",
  "metadata": { "source": "admin_dashboard", "issued_at": "timestamp" }
}
```

## API Endpoints для реализации

### 1. Отправка команды на одно устройство

- **Endpoint:** `POST /commands/send`
- **Request Body:** `SendCommandRequest(device_id: str, command_type: str, payload: dict)`
- **Действие:** Валидировать запрос, создать запись в `CommandHistoryDB` со статусом `queued`, опубликовать событие в Kafka.
- **Response:** `202 Accepted` `{ "success": true, "command_id": "...", "status": "queued" }`

### 2. Отправка команды на группу устройств

- **Endpoint:** `POST /commands/send/batch`
- **Request Body:** `BatchCommandRequest(device_ids: List[str], command_type: str, payload: dict)`
- **Действие:** Сгенерировать `batch_id`. Для каждого `device_id` из списка выполнить те же действия, что и для одиночного эндпоинта.
- **Response:** `202 Accepted` `{ "success": true, "batch_id": "...", "status": "queued" }`

## Критерии приемки

- [ ]  Вся валидация реализована с помощью Pydantic **с использованием схем из `core/src/schemas.py`**.
- [ ]  Взаимодействие с Kafka реализовано **исключительно через клиент из `core/src/kafka/kafka_client.py`**.
- [ ]  Все эндпоинты реализованы и возвращают корректные статусы и тела ответов.
- [ ]  Написаны unit-тесты, проверяющие успешную отправку команды в Kafka для каждого эндпоинта.
```

**Success Criteria**:
- Example spec exists at `/.memory_bank/specs/example_feature_spec.md`
- Shows proper level of detail
- Demonstrates reuse of existing components
- Includes clear acceptance criteria

---

## COMPONENT 2: Workflows Directory

**Purpose**: Create step-by-step instructions for standard development tasks

**Location**: `/.memory_bank/workflows/`

**Dependencies**:
- Memory Bank core files should exist
- guides/ and patterns/ directories should be created

**Success Criteria**:
- Directory exists
- At least 2 workflow files are created
- Workflows reference relevant guides and patterns

---

### 2.1 Create /workflows directory

#### Task 2.1.1: Create workflows directory

**Location**: `/.memory_bank/workflows/`

**Dependencies**: Memory Bank root directory exists

**Success Criteria**:
- Directory exists at `/.memory_bank/workflows/`

---

### 2.2 Core Workflow Files

#### Task 2.2.1: Create bug_fix.md workflow

**File**: `/.memory_bank/workflows/bug_fix.md`

**Purpose**: Standardize bug fixing process

**Dependencies**:
- coding_standards.md exists
- current_tasks.md exists

**Content Structure** (from article):

```markdown
# Процесс исправления бага

## 1. Подготовка и анализ
- [ ] Создать ветку от `develop` по шаблону `bugfix/TICKET-NUMBER-short-description`.
- [ ] Сгенерировать гипотезы о причинах бага
- [ ] Локализовать проблему в кодовой базе. Найти все релевантные файлы.
- [ ] Проанализировать связанные документы в `guides/` и `patterns/` для понимания контекста затронутой системы.

## 2. Разработка
- [ ] Внести исправления в код, следуя **[стандартам кодирования](../guides/coding_standards.md)**.
- [ ] Запустить весь набор тестов (`npm test`), чтобы убедиться, что ничего не сломалось.

## 3. Завершение
- [ ] Обновить документацию, если исправление затронуло публичное поведение компонента.
- [ ] Обновить статус задачи в **[../current_tasks.md](../current_tasks.md)**.
- [ ] Создать Pull Request и краткое описание решения.
```

**Customization Notes**:
- Adjust branch naming convention to your team's standard
- Update test command to match your project
- Add additional steps if needed (e.g., notify stakeholders)

**Success Criteria**:
- File exists at `/.memory_bank/workflows/bug_fix.md`
- All steps are actionable and clear
- Links to related documents work
- Checklist format allows progress tracking

---

#### Task 2.2.2: Create new_feature.md workflow

**File**: `/.memory_bank/workflows/new_feature.md`

**Purpose**: Standardize new feature development process

**Dependencies**:
- coding_standards.md exists
- testing_strategy.md exists
- current_tasks.md exists
- specs/ directory exists

**Content Structure**:

```markdown
# Процесс разработки новой фичи

## 1. Подготовка
- [ ] Создать ветку от `develop` по шаблону `feature/TICKET-NUMBER-short-description`.
- [ ] Прочитать спецификацию в **[../specs/](../specs/)** для понимания полного объема работ.
- [ ] Изучить **[стандарты кодирования](../guides/coding_standards.md)** и **[архитектурные паттерны](../patterns/)**.
- [ ] Обновить статус задачи в **[../current_tasks.md](../current_tasks.md)** на "In Progress".

## 2. Анализ и проектирование
- [ ] Идентифицировать существующие компоненты для переиспользования.
- [ ] Проверить **[tech_stack.md](../tech_stack.md)** на разрешенные технологии.
- [ ] Составить список файлов для создания/изменения.

## 3. Разработка
- [ ] Создать необходимые модели данных/схемы.
- [ ] Реализовать бизнес-логику согласно спецификации.
- [ ] Следовать паттернам из **[../patterns/](../patterns/)**.
- [ ] Переиспользовать существующие утилиты и компоненты.

## 4. Тестирование
- [ ] Написать unit-тесты согласно **[стратегии тестирования](../guides/testing_strategy.md)**.
- [ ] Запустить все тесты: `npm test`
- [ ] Проверить code coverage (минимум 80%).
- [ ] Провести ручное тестирование ключевых сценариев.

## 5. Документация
- [ ] Обновить **[../tech_stack.md](../tech_stack.md)**, если добавлены новые зависимости.
- [ ] Создать/обновить гайд в **[../guides/](../guides/)**, если это новая подсистема.
- [ ] Добавить комментарии к сложным участкам кода.

## 6. Завершение
- [ ] Запустить линтер и форматтер.
- [ ] Обновить статус задачи в **[../current_tasks.md](../current_tasks.md)** на "Done".
- [ ] Создать Pull Request с подробным описанием изменений.
- [ ] Перечислить все измененные файлы и их назначение.

## 7. Self-Review
- [ ] Проверить, что все критерии приемки из спецификации выполнены.
- [ ] Убедиться, что не нарушены архитектурные принципы.
- [ ] Проверить, что нет дублирования кода.
```

**Success Criteria**:
- File exists at `/.memory_bank/workflows/new_feature.md`
- Covers complete feature lifecycle
- References all relevant guides and patterns
- Includes self-review step

---

#### Task 2.2.3: Create code_review.md workflow

**File**: `/.memory_bank/workflows/code_review.md`

**Purpose**: Standardize code review process for AI agent

**Dependencies**:
- coding_standards.md exists
- testing_strategy.md exists

**Content Structure**:

```markdown
# Процесс ревью кода

## 1. Общая проверка
- [ ] Pull Request содержит понятное описание изменений.
- [ ] Все измененные файлы связаны с решаемой задачей.
- [ ] Нет закомментированного или мертвого кода.

## 2. Соответствие стандартам
- [ ] Код соответствует **[стандартам кодирования](../guides/coding_standards.md)**.
- [ ] Именование переменных, функций и файлов следует конвенциям.
- [ ] Форматирование согласовано с настройками линтера.

## 3. Архитектура и паттерны
- [ ] Изменения не нарушают архитектурные принципы из **[../patterns/](../patterns/)**.
- [ ] Новые компоненты следуют установленным паттернам.
- [ ] Нет дублирования функционала, существующего в других частях проекта.

## 4. Качество кода
- [ ] Функции имеют единственную ответственность (SRP).
- [ ] Нет чрезмерно сложных функций (>50 строк).
- [ ] Используется обработка ошибок согласно **[../patterns/error_handling.md](../patterns/error_handling.md)**.
- [ ] Нет "магических" чисел - используются именованные константы.

## 5. Тесты
- [ ] Все новые функции покрыты unit-тестами.
- [ ] Тесты следуют AAA паттерну (Arrange-Act-Assert).
- [ ] Все тесты проходят успешно.
- [ ] Code coverage не снизился.

## 6. Безопасность
- [ ] Нет хардкод паролей, токенов, API ключей.
- [ ] Пользовательский ввод валидируется.
- [ ] Нет SQL-инъекций или XSS уязвимостей.

## 7. Производительность
- [ ] Нет очевидных проблем производительности (N+1 queries, лишние циклы).
- [ ] Большие данные обрабатываются эффективно.

## 8. Документация
- [ ] Обновлена документация, если изменилось публичное API.
- [ ] Сложные алгоритмы имеют пояснительные комментарии.
- [ ] **[../tech_stack.md](../tech_stack.md)** обновлен при добавлении зависимостей.

## 9. Финальная проверка
- [ ] Нет merge конфликтов.
- [ ] CI/CD pipeline проходит успешно.
- [ ] Все критерии приемки из спецификации выполнены.
```

**Success Criteria**:
- File exists at `/.memory_bank/workflows/code_review.md`
- Comprehensive checklist for review
- References relevant standards and patterns
- Can be used by AI for self-review

---

## COMPONENT 3: Claude Code Configuration

**Purpose**: Set up Claude Code to automatically load Memory Bank context

**Location**: Project root or Claude config directory

**Dependencies**: Memory Bank must be fully set up

**Success Criteria**:
- Claude Code reads Memory Bank on every session
- Configuration is persistent
- Agent knows to update Memory Bank documents

---

### 3.1 Create CLAUDE.md (Session Initializer)

#### Task 3.1.1: Create CLAUDE.md in project root

**File**: `/CLAUDE.md`

**Purpose**: Instruct Claude Code to load Memory Bank context at session start

**Dependencies**: Memory Bank README.md exists

**Content Structure**:

```markdown
# Claude Code Configuration

## При начале ЛЮБОЙ рабочей сессии

**ОБЯЗАТЕЛЬНО** выполни следующие действия:

1. Прочитай файл **`.memory_bank/README.md`** полностью.
2. Следуй инструкциям по обязательной последовательности чтения из этого файла.
3. Перейди по ссылкам на релевантные документы в зависимости от типа задачи:
   - Для новой фичи → изучи спецификацию в `.memory_bank/specs/`
   - Для бага → изучи workflow `.memory_bank/workflows/bug_fix.md`
   - Для вопросов по технологиям → проверь `.memory_bank/tech_stack.md`

## Принцип самодокументирования

**ВАЖНО**: Ты не только читаешь из Memory Bank, но и **обновляешь его**.

При выполнении задач ты ДОЛЖЕН:
- Обновлять статус в `.memory_bank/current_tasks.md` (To Do → In Progress → Done)
- Создавать/обновлять документацию в `.memory_bank/guides/` при реализации новых подсистем
- Обновлять `.memory_bank/tech_stack.md` при добавлении новых зависимостей
- Создавать новые паттерны в `.memory_bank/patterns/` при принятии архитектурных решений

## Запрещенные действия

❌ **НИКОГДА** не добавляй новые зависимости без обновления `.memory_bank/tech_stack.md`
❌ **НИКОГДА** не нарушай паттерны из `.memory_bank/patterns/`
❌ **НИКОГДА** не изобретай заново то, что уже существует в проекте

## При потере контекста

Если ты чувствуешь, что контекст был потерян или сжат:
1. Используй команду `/refresh_context`
2. Перечитай `.memory_bank/README.md`
3. Изучи последние коммиты для понимания текущего состояния

---

**Помни**: Memory Bank - это единый источник истины. Доверяй ему больше, чем своим предположениям.
```

**Success Criteria**:
- File exists at `/CLAUDE.md`
- Contains clear instructions for session initialization
- Explains self-documentation principle
- Lists forbidden actions

---

### 3.2 Alternative: Add to existing project documentation

#### Task 3.2.1: Update existing README or setup docs

**Note**: If your project already has comprehensive documentation, you can add a section instead of creating CLAUDE.md

**Location**: `/README.md` or `/docs/AI_AGENT_GUIDE.md`

**Content to Add**:

```markdown
## For AI Agents

If you are an AI agent (like Claude Code), follow these instructions at the start of every session:

1. **Load Memory Bank**: Read `.memory_bank/README.md` first
2. **Follow Navigation**: Use links to find relevant documentation
3. **Update as you work**: Keep `.memory_bank/current_tasks.md` and other documents up to date
4. **Never violate**: Forbidden practices in `.memory_bank/tech_stack.md`
5. **When lost**: Use `/refresh_context` command

See **[.memory_bank/README.md](.memory_bank/README.md)** for complete navigation.
```

**Success Criteria**:
- AI agent instructions are visible in project documentation
- Points to Memory Bank as source of truth

---

## COMPONENT 4: Custom Commands Setup

**Purpose**: Create custom Claude Code commands for common workflows

**Location**: `~/.config/claude/commands/`

**Dependencies**:
- Memory Bank workflows must exist
- Claude Code must be installed

**Success Criteria**:
- Custom commands are created
- Commands can be invoked with `/command_name`
- Commands integrate with Memory Bank workflows

---

### 4.1 Setup Commands Directory

#### Task 4.1.1: Create commands directory

**Command**:
```bash
mkdir -p ~/.config/claude/commands/
```

**Success Criteria**:
- Directory exists at `~/.config/claude/commands/`

---

### 4.2 Core Custom Commands

#### Task 4.2.1: Create refresh_context.md command

**File**: `~/.config/claude/commands/refresh_context.md`

**Purpose**: Restore AI agent's context when it becomes compressed

**Dependencies**: Memory Bank exists

**Content Structure** (from article):

```markdown
Контекст мог быть утерян или сжат. Необходимо освежить память. Выполни следующие шаги:

1.  Перечитай `.memory_bank/README.md` полностью, чтобы понять общую структуру.
2.  Изучи текущие задачи в `.memory_bank/current_tasks.md`, чтобы понять, над чем мы работаем.
3.  Просмотри последние изменения в коде, чтобы быть в курсе актуального состояния.

После этого выведи сообщение "Контекст обновлен" и кратко опиши текущий статус проекта и активную задачу.
```

**Usage**: `/refresh_context`

**Success Criteria**:
- File exists at `~/.config/claude/commands/refresh_context.md`
- Command successfully reloads context
- Agent provides status summary after execution

---

#### Task 4.2.2: Create m_bug.md command

**File**: `~/.config/claude/commands/m_bug.md`

**Purpose**: Initiate bug fix workflow

**Dependencies**:
- Memory Bank bug_fix workflow exists
- current_tasks.md exists

**Content Structure** (from article):

```markdown
Ты получил команду /m_bug. Это означает, что мы начинаем работу над исправлением бага.

Твоя задача: $ARGUMENTS.

Выполни следующую процедуру:
1.  Внимательно изучи `.memory_bank/workflows/bug_fix.md`.
2.  Следуй описанному там процессу шаг за шагом.
3.  Задавай уточняющие вопросы на каждом этапе, если что-то неясно.
4.  По завершении всей работы не забудь обновить `.memory_bank/current_tasks.md` и другую релевантную документацию, как указано в workflow.

Начинай с первого шага.
```

**Usage**: `/m_bug Fix login button not responding on mobile`

**Success Criteria**:
- File exists at `~/.config/claude/commands/m_bug.md`
- Command accepts arguments via $ARGUMENTS
- Agent follows bug_fix workflow
- Agent updates current_tasks.md automatically

---

#### Task 4.2.3: Create m_feature.md command

**File**: `~/.config/claude/commands/m_feature.md`

**Purpose**: Initiate new feature development workflow

**Dependencies**:
- Memory Bank new_feature workflow exists
- specs/ directory exists

**Content Structure**:

```markdown
Ты получил команду /m_feature. Это означает, что мы начинаем работу над новой функцией.

Твоя задача: $ARGUMENTS.

Выполни следующую процедуру:
1.  Найди соответствующую спецификацию в `.memory_bank/specs/`. Если ее нет, запроси у пользователя путь к спецификации.
2.  Внимательно изучи `.memory_bank/workflows/new_feature.md`.
3.  Следуй описанному там процессу шаг за шагом.
4.  Обязательно проверь `.memory_bank/tech_stack.md` перед добавлением любых зависимостей.
5.  По завершении всей работы обновь:
    - `.memory_bank/current_tasks.md`
    - `.memory_bank/tech_stack.md` (если добавлены зависимости)
    - Создай/обнови гайд в `.memory_bank/guides/` (если это новая подсистема)

Начинай с первого шага.
```

**Usage**: `/m_feature Implement user authentication`

**Success Criteria**:
- File exists at `~/.config/claude/commands/m_feature.md`
- Command accepts arguments
- Agent follows new_feature workflow
- Agent updates relevant Memory Bank files

---

#### Task 4.2.4: Create m_review.md command

**File**: `~/.config/claude/commands/m_review.md`

**Purpose**: Initiate code review process

**Dependencies**: code_review workflow exists

**Content Structure**:

```markdown
Ты получил команду /m_review. Это означает, что нужно провести ревью кода.

Код для ревью: $ARGUMENTS.

Выполни следующую процедуру:
1.  Внимательно изучи `.memory_bank/workflows/code_review.md`.
2.  Проверь код по всем пунктам чек-листа.
3.  Для каждого найденного нарушения или проблемы:
    - Укажи конкретное место (файл, строка)
    - Объясни, почему это проблема
    - Предложи конкретное решение
4.  Проверь соответствие:
    - **[Стандартам кодирования](.memory_bank/guides/coding_standards.md)**
    - **[Архитектурным паттернам](.memory_bank/patterns/)**
    - **[Технологическому стеку](.memory_bank/tech_stack.md)**
5.  Предоставь итоговый отчет:
    - ✅ Что сделано хорошо
    - ⚠️ Что нужно улучшить
    - ❌ Что нужно исправить обязательно

Начинай ревью.
```

**Usage**: `/m_review` or `/m_review path/to/changed/files`

**Success Criteria**:
- File exists at `~/.config/claude/commands/m_review.md`
- Agent performs systematic code review
- Agent references Memory Bank standards
- Agent provides actionable feedback

---

## COMPONENT 5: Three-Phase Workflow Setup

**Purpose**: Establish the Planning-Execution-Review process

**Dependencies**: All previous components

**Success Criteria**:
- Planning templates exist
- Execution workflows are integrated
- Review checklists are created

---

### 5.1 Planning Phase Setup (Gemini)

#### Task 5.1.1: Create planning prompt template

**File**: `/.memory_bank/templates/planning_prompt.md`

**Purpose**: Template for generating specifications with Gemini

**Content Structure**:

```markdown
# Planning Prompt Template (для использования с Gemini)

## Контекст
Я работаю над проектом [PROJECT_NAME]. Вот полный контекст кодовой базы (упакованный через repomix):

[PASTE REPOMIX OUTPUT OR ATTACH FILE]

## Задача
[DETAILED TASK DESCRIPTION]

## Требования к результату

**Ты не должен писать код сразу. Твоя задача - создать детальное техническое задание.**

Сгенерируй подробную спецификацию в формате Markdown, которая включает:

1. **Аннотация**: Краткое описание (1-2 предложения) что и зачем делаем.

2. **Описание задачи**:
   - Текущее состояние/проблема
   - Желаемый результат
   - Как это вписывается в общую систему

3. **Ключевые компоненты для реализации**:
   - Список всех компонентов/модулей, которые нужно создать или изменить
   - Для каждого компонента:
     - Расположение (путь к файлу)
     - Назначение
     - Важные ограничения или существующий код для переиспользования

4. **Структура данных**:
   - API Request/Response схемы (если применимо)
   - Модели данных
   - Схемы БД (если применимо)

5. **API Endpoints** (если применимо):
   - Method, Endpoint path
   - Request Body структура
   - Действие (пошагово)
   - Response структура

6. **Файлы для создания/изменения**:
   - Чек-лист файлов с описанием назначения каждого

7. **Критерии приемки**:
   - Список конкретных, тестируемых требований
   - Обязательно включи: тесты, соответствие стандартам, обновление документации

8. **Зависимости**:
   - Какие существующие компоненты нужно использовать
   - Откуда импортировать
   - Важные ограничения

## Важные инструкции

- Анализируй существующую кодовую базу и ОБЯЗАТЕЛЬНО переиспользуй существующие компоненты
- Указывай точные пути к файлам
- Делай акцент на том, что НЕЛЬЗЯ делать (forbidden practices)
- Будь максимально конкретным и детальным

## Формат выхода

Верни результат в формате, готовом для сохранения в `.memory_bank/specs/[FEATURE-ID]-[feature-name].md`
```

**Usage**:
1. Use repomix to package project
2. Paste this template into Gemini
3. Iterate 3-5 times to refine
4. Save result in `.memory_bank/specs/`

**Success Criteria**:
- Template exists
- Clear instructions for Gemini
- Produces specs matching required format

---

#### Task 5.1.2: Create repomix configuration

**File**: `/repomix.config.json`

**Purpose**: Configure repomix for consistent project packaging

**Content Structure**:

```json
{
  "output": {
    "filePath": "repomix-output.xml",
    "style": "xml",
    "removeComments": false,
    "showLineNumbers": true
  },
  "include": ["**/*"],
  "ignore": {
    "useGitignore": true,
    "useDefaultPatterns": true,
    "customPatterns": [
      "node_modules/**",
      ".git/**",
      "dist/**",
      "build/**",
      "*.log",
      ".env*",
      "repomix-output.*"
    ]
  }
}
```

**Usage**: `npx repomix`

**Success Criteria**:
- Configuration file exists
- Generates XML output suitable for Gemini
- Excludes sensitive and unnecessary files

---

### 5.2 Execution Phase Setup (Claude Code)

#### Task 5.2.1: Create execution checklist template

**File**: `/.memory_bank/templates/execution_checklist.md`

**Purpose**: Template for tracking execution progress

**Content Structure**:

```markdown
# Execution Checklist: [FEATURE-NAME]

**Spec**: [Link to spec file]

**Status**: In Progress

## Pre-Execution
- [ ] Spec has been read completely
- [ ] All referenced documents in Memory Bank have been reviewed
- [ ] Existing components for reuse have been identified
- [ ] Branch created: `feature/[ID]-[name]`
- [ ] Task updated in `.memory_bank/current_tasks.md` to "In Progress"

## Development
- [ ] All files listed in spec have been created/modified
- [ ] All API endpoints implemented (if applicable)
- [ ] Data models/schemas created
- [ ] Business logic implemented
- [ ] Existing components reused where specified
- [ ] No new dependencies added OR `.memory_bank/tech_stack.md` updated

## Testing
- [ ] Unit tests written for all new functions
- [ ] All tests pass: `[TEST_COMMAND]`
- [ ] Code coverage meets minimum (80%)
- [ ] Manual testing completed for key scenarios

## Documentation
- [ ] Code comments added for complex logic
- [ ] `.memory_bank/guides/` updated (if new subsystem)
- [ ] API documentation updated (if applicable)

## Quality
- [ ] Code follows `.memory_bank/guides/coding_standards.md`
- [ ] Patterns from `.memory_bank/patterns/` are followed
- [ ] No code duplication
- [ ] Error handling follows `.memory_bank/patterns/error_handling.md`

## Completion
- [ ] All acceptance criteria from spec are met
- [ ] Linter/formatter run
- [ ] Task updated in `.memory_bank/current_tasks.md` to "Done"
- [ ] Pull request created with detailed description
- [ ] Ready for review

## Blockers / Issues
[List any blockers or issues encountered]
```

**Success Criteria**:
- Template exists
- Comprehensive checklist
- Can be customized per feature
- Tracks blockers

---

### 5.3 Review Phase Setup

#### Task 5.3.1: Create review prompt template for Gemini

**File**: `/.memory_bank/templates/review_prompt.md`

**Purpose**: Template for generating review checklists with Gemini

**Content Structure**:

```markdown
# Review Checklist Generation Prompt (для Gemini)

## Контекст

Ранее в нашей сессии мы создали детальное техническое задание для фичи: [FEATURE_NAME]

Вот финальная спецификация:
[PASTE FINAL SPEC]

## Задача

На основе этой спецификации, создай детальный чек-лист для проверки выполненной работы.

## Требования к чек-листу

Чек-лист должен включать проверки:

1. **Функциональная полнота**:
   - Каждый компонент из спецификации реализован
   - Все endpoints работают согласно описанию
   - Все структуры данных соответствуют схемам

2. **Критерии приемки**:
   - Каждый критерий из секции "Критерии приемки" спецификации

3. **Переиспользование компонентов**:
   - Все указанные существующие компоненты действительно используются
   - Нет дублирования функционала

4. **Технические требования**:
   - Тесты написаны и проходят
   - Документация обновлена
   - Код следует стандартам

5. **Конкретные детали реализации**:
   - Проверки специфичные для этой фичи
   - Граничные случаи обработаны
   - Интеграция с существующими модулями корректна

## Формат выхода

Верни чек-лист в формате Markdown с чекбоксами, готовый для передачи AI-агенту.

Каждый пункт должен быть:
- Конкретным и проверяемым
- Ссылаться на конкретные файлы/компоненты
- Включать ожидаемое поведение
```

**Usage**:
1. After execution phase, go back to Gemini (context is preserved)
2. Use this prompt
3. Pass generated checklist to Claude Code
4. Claude Code performs self-review

**Success Criteria**:
- Template exists
- Generates actionable checklists
- Checklists are specific to the feature
- Can be used by Claude Code for self-review

---

#### Task 5.3.2: Create self-review command

**File**: `~/.config/claude/commands/m_self_review.md`

**Purpose**: Command for AI agent to perform self-review

**Content Structure**:

```markdown
Ты получил команду /m_self_review. Это означает, что нужно проверить свою собственную работу.

Чек-лист для проверки: $ARGUMENTS

Выполни следующую процедуру:

1. **Внимательно изучи предоставленный чек-лист**.

2. **Для каждого пункта чек-листа**:
   - Проверь соответствующий код/файл
   - Отметь ✅ если требование выполнено
   - Отметь ❌ если требование НЕ выполнено
   - Добавь комментарий с объяснением

3. **Для каждого невыполненного требования**:
   - Объясни, почему оно не выполнено
   - Предложи план исправления
   - Если это блокер - обозначь как "CRITICAL"

4. **Автоматически исправь** простые проблемы:
   - Форматирование кода
   - Отсутствующие импорты
   - Простые синтаксические ошибки

5. **Для сложных проблем**:
   - Опиши проблему детально
   - Предложи варианты решения
   - Попроси подтверждения у пользователя перед изменениями

6. **Итоговый отчет**:
   - Сколько пунктов выполнено
   - Сколько требует исправлений
   - Список критических проблем (если есть)
   - Оценка готовности к merge (Ready / Needs Work)

Начинай проверку.
```

**Usage**: `/m_self_review` (paste checklist from Gemini)

**Success Criteria**:
- Command exists
- Agent systematically checks all items
- Agent auto-fixes simple issues
- Agent reports complex problems
- Provides readiness assessment

---

## Summary: Complete Directory Structure

After completing all tasks, your project should have this structure:

```
project_root/
├── .memory_bank/
│   ├── README.md                          # Main navigation hub
│   ├── product_brief.md                   # Business context
│   ├── tech_stack.md                      # Technical passport
│   ├── current_tasks.md                   # Kanban board
│   │
│   ├── patterns/                          # Architectural patterns
│   │   ├── api_standards.md
│   │   └── error_handling.md
│   │
│   ├── guides/                            # Practical guides
│   │   ├── coding_standards.md
│   │   └── testing_strategy.md
│   │
│   ├── specs/                             # Feature specifications
│   │   ├── feature_spec_template.md
│   │   └── example_feature_spec.md
│   │
│   ├── workflows/                         # Step-by-step workflows
│   │   ├── bug_fix.md
│   │   ├── new_feature.md
│   │   └── code_review.md
│   │
│   └── templates/                         # Workflow templates
│       ├── planning_prompt.md
│       ├── execution_checklist.md
│       └── review_prompt.md
│
├── CLAUDE.md                              # Claude Code initializer
├── repomix.config.json                    # Repomix configuration
│
└── [your project files]

~/.config/claude/commands/                 # Custom commands (global)
├── refresh_context.md
├── m_bug.md
├── m_feature.md
├── m_review.md
└── m_self_review.md
```

---

## Implementation Order

### Phase 1: Foundation (Critical Path)
1. Create `.memory_bank/` directory
2. Create `README.md` (navigation hub)
3. Create `tech_stack.md` (technical passport)
4. Create `current_tasks.md` (Kanban board)
5. Create `product_brief.md` (business context)

### Phase 2: Core Structure
6. Create `patterns/` directory and core patterns
   - `api_standards.md`
   - `error_handling.md`
7. Create `guides/` directory and core guides
   - `coding_standards.md`
   - `testing_strategy.md`
8. Create `specs/` directory and templates
   - `feature_spec_template.md`
   - `example_feature_spec.md`

### Phase 3: Workflows
9. Create `workflows/` directory and core workflows
   - `bug_fix.md`
   - `new_feature.md`
   - `code_review.md`
10. Create `templates/` directory for three-phase process
    - `planning_prompt.md`
    - `execution_checklist.md`
    - `review_prompt.md`

### Phase 4: Integration
11. Create `CLAUDE.md` in project root
12. Create `repomix.config.json`
13. Create custom commands in `~/.config/claude/commands/`:
    - `refresh_context.md`
    - `m_bug.md`
    - `m_feature.md`
    - `m_review.md`
    - `m_self_review.md`

### Phase 5: Customization
14. Customize all files to match your specific:
    - Tech stack
    - Coding standards
    - Project structure
    - Team practices
15. Add project-specific patterns and guides
16. Create initial specs for current features

---

## Success Criteria for Complete Implementation

### Memory Bank Verification
- [ ] All core files exist and are populated
- [ ] Navigation links in README.md work correctly
- [ ] Tech stack accurately reflects project
- [ ] At least one example spec exists
- [ ] All workflows reference correct paths

### Claude Code Integration
- [ ] CLAUDE.md exists and instructs to read Memory Bank
- [ ] Custom commands are created and functional
- [ ] Commands can be invoked with `/command_name`
- [ ] Commands correctly reference Memory Bank paths

### Three-Phase Workflow
- [ ] Planning template exists and can be used with Gemini
- [ ] Execution checklists can be generated from specs
- [ ] Review checklists can be generated by Gemini
- [ ] Self-review command works correctly

### Testing the System
- [ ] Start new Claude Code session → agent reads Memory Bank
- [ ] Use `/refresh_context` → context is restored
- [ ] Use `/m_feature` → agent follows new_feature workflow
- [ ] Use `/m_bug` → agent follows bug_fix workflow
- [ ] Agent updates `current_tasks.md` automatically
- [ ] Agent references patterns and guides in its work

---

## Maintenance Guidelines

### Keep Memory Bank Updated
- Update `current_tasks.md` after every work session
- Add new patterns when architectural decisions are made
- Create new guides when new subsystems are added
- Update `tech_stack.md` when dependencies change

### Evolve Workflows
- Refine workflows based on what works
- Add new workflows for new types of tasks
- Update acceptance criteria based on learnings

### Periodic Review
- Monthly: Review all Memory Bank documents for accuracy
- Quarterly: Assess if new patterns/guides are needed
- After major features: Update example specs

---

## Troubleshooting

### Agent Not Reading Memory Bank
- Check if CLAUDE.md exists in project root
- Verify paths in CLAUDE.md are correct
- Try `/refresh_context` command

### Agent Not Following Workflows
- Ensure workflow files exist at specified paths
- Check that custom commands reference correct workflow paths
- Verify checklist format is correct (markdown checkboxes)

### Agent Making Forbidden Changes
- Review `tech_stack.md` - are forbidden practices clearly listed?
- Add more specific constraints to relevant patterns
- Use `/m_review` to check compliance

### Context Still Getting Lost
- Use more frequent `/refresh_context` calls
- Break tasks into smaller subtasks
- Use subagents for specialized tasks (future enhancement)

---

## Next Steps After Implementation

1. **Test the System**: Run through complete workflow for one feature
2. **Gather Learnings**: Document what works and what doesn't
3. **Iterate**: Refine prompts, workflows, and patterns
4. **Scale**: Add more patterns, guides, and workflows as needed
5. **Share with Team**: If working with others, onboard them to the system

---

## References

- **Original Article**: `/Users/alexanderfedin/Projects/hapyy/due_diligence_bot/AI_SWE_article.md`
- **Cline Memory Bank Docs**: https://docs.cline.bot/prompting/cline-memory-bank
- **Repomix**: https://github.com/yamadashy/repomix
- **Claude Code**: https://claude.com/claude-code

---

*This implementation plan is based on the AI SWE methodology from the article. Adapt it to your specific project needs while maintaining the core principles of structured knowledge management and systematic workflows.*
