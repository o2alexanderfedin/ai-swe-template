# Процесс разработки новой фичи

## 1. Подготовка и планирование

### 1.1 Git Branch Setup
- [ ] Создать ветку от `develop` по шаблону `feature/TICKET-NUMBER-short-description`
  - Пример: `feature/DD-45-company-financial-analysis`
  - Следовать конвенции из **[../tech_stack.md](../tech_stack.md#version-control)**

### 1.2 Task Tracking
- [ ] Обновить статус задачи в **[../current_tasks.md](../current_tasks.md)** на "In Progress"
- [ ] Добавить метку `[FEATURE]` к задаче

### 1.3 Read Specification
- [ ] Прочитать полную спецификацию в **[../specs/](../specs/)** для понимания объема работ
- [ ] Убедиться, что понятны:
  - Бизнес-цели фичи (ЗАЧЕМ)
  - Критерии приемки (acceptance criteria)
  - API contracts (если применимо)
  - Структуры данных
  - Зависимости от других компонентов
- [ ] Задать уточняющие вопросы, если что-то неясно

### 1.4 Study Context
- [ ] Изучить **[стандарты кодирования](../guides/coding_standards.md)**
- [ ] Изучить **[архитектурные паттерны](../patterns/)** релевантные для фичи
- [ ] Изучить **[стратегию тестирования](../guides/testing_strategy.md)**
- [ ] Проверить **[../product_brief.md](../product_brief.md)** для понимания бизнес-контекста

## 2. Анализ и проектирование

### 2.1 Identify Existing Components
- [ ] Найти существующие компоненты для переиспользования:
  - Pydantic модели в `core/models/`
  - API clients в `integrations/`
  - Utility функции
  - Database models
- [ ] Проверить **[../tech_stack.md](../tech_stack.md)** на список доступных библиотек
- [ ] Убедиться, что не дублируется существующий функционал

### 2.2 Technology Check
- [ ] Проверить, что все необходимые технологии разрешены в **[../tech_stack.md](../tech_stack.md)**
- [ ] Если нужна новая зависимость:
  - Обосновать необходимость
  - Проверить совместимость с существующим стеком
  - Согласовать добавление
  - **ОБЯЗАТЕЛЬНО** обновить **[../tech_stack.md](../tech_stack.md)**

### 2.3 Design Plan
- [ ] Составить список файлов для создания/изменения:
  - Models (Pydantic schemas)
  - Business logic (core/)
  - API integrations (integrations/)
  - Bot handlers (bot/)
  - Database migrations (if needed)
  - Tests
- [ ] Определить public API новых модулей
- [ ] Спроектировать структуры данных
- [ ] Определить error handling strategy для фичи

## 3. Разработка

### 3.1 Data Models
- [ ] Создать/обновить Pydantic модели для валидации данных
- [ ] Следовать паттернам из **[../guides/coding_standards.md](../guides/coding_standards.md#pydantic-models-for-data-validation)**
- [ ] Добавить validators для business rules
- [ ] Использовать type hints для всех полей
- [ ] Пример структуры:
  ```python
  from pydantic import BaseModel, Field, validator

  class CompanyFinancialData(BaseModel):
      company_name: str = Field(..., min_length=1)
      revenue: Optional[Decimal] = None
      profit: Optional[Decimal] = None

      @validator('revenue', 'profit')
      def validate_positive(cls, v):
          if v is not None and v < 0:
              raise ValueError('Must be non-negative')
          return v
  ```

### 3.2 Business Logic Implementation
- [ ] Реализовать core бизнес-логику согласно спецификации
- [ ] Следовать **[архитектурным паттернам](../patterns/)**
- [ ] Использовать async/await для всех I/O операций
- [ ] Добавить proper error handling согласно **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Переиспользовать существующие утилиты и компоненты
- [ ] Максимальная длина функции: 50 строк (если больше - декомпозировать)

### 3.3 External API Integration (if applicable)
- [ ] Создать client класс в `integrations/`
- [ ] Использовать `httpx.AsyncClient` для async HTTP requests
- [ ] Обернуть все responses в Pydantic модели
- [ ] Следовать **[../patterns/api_standards.md](../patterns/api_standards.md)**
- [ ] Добавить retry логику для transient errors
- [ ] Добавить circuit breaker для предотвращения cascading failures
- [ ] Пример структуры:
  ```python
  from tenacity import retry, stop_after_attempt, wait_exponential

  class FinancialDataClient:
      def __init__(self, api_key: str):
          self.api_key = api_key
          self._client = httpx.AsyncClient()

      @retry(stop=stop_after_attempt(3), wait=wait_exponential())
      async def get_company_financials(self, inn: str) -> CompanyFinancialData:
          try:
              response = await self._client.get(
                  f"{self.base_url}/companies/{inn}/financials",
                  headers={"Authorization": f"Bearer {self.api_key}"}
              )
              response.raise_for_status()
              return CompanyFinancialData(**response.json())
          except httpx.HTTPStatusError as e:
              raise ExternalAPIError(
                  message="Failed to fetch financial data",
                  service="financial_api",
                  original_error=e
              )
  ```

### 3.4 Telegram Bot Handlers (if applicable)
- [ ] Создать/обновить handlers в `bot/`
- [ ] Использовать async handlers
- [ ] Добавить proper error handling для user-facing errors
- [ ] Все сообщения на русском языке
- [ ] Генерировать `correlation_id` для трейсинга
- [ ] Добавить валидацию пользовательского ввода
- [ ] Пример структуры:
  ```python
  async def handle_financial_analysis(
      update: Update,
      context: ContextTypes.DEFAULT_TYPE
  ) -> None:
      correlation_id = str(uuid.uuid4())

      try:
          company_name = " ".join(context.args)

          if not company_name:
              await update.message.reply_text(
                  "Пожалуйста, укажите название компании.\n"
                  "Пример: /financial ООО Ромашка"
              )
              return

          # Process and respond
          result = await analyze_company_financials(company_name, correlation_id)
          await update.message.reply_text(format_financial_report(result))

      except ValidationError as e:
          await update.message.reply_text(f"Ошибка: {e.message}")
      except ExternalAPIError:
          await update.message.reply_text(
              "Не удалось получить данные. Попробуйте позже."
          )
  ```

### 3.5 Database Operations (if applicable)
- [ ] Создать/обновить database models
- [ ] Использовать parameterized queries (НИКОГДА не конкатенировать SQL)
- [ ] Добавить proper transaction management
- [ ] Добавить logging для всех DB operations
- [ ] Создать database migration (если нужно)

### 3.6 Code Quality During Development
- [ ] Все функции имеют type hints
- [ ] Все public функции имеют docstrings (Google style)
- [ ] Следовать Single Responsibility Principle
- [ ] Нет "магических" чисел - использовать именованные константы
- [ ] Нет дублирования кода
- [ ] Async code не содержит blocking operations

## 4. Тестирование

### 4.1 Unit Tests
- [ ] Написать unit-тесты для всех новых функций
- [ ] Следовать AAA паттерну (Arrange-Act-Assert)
- [ ] Следовать **[стратегии тестирования](../guides/testing_strategy.md)**
- [ ] Использовать pytest для всех тестов
- [ ] Для async кода использовать `pytest-asyncio`
- [ ] Пример структуры теста:
  ```python
  import pytest
  from unittest.mock import AsyncMock, patch

  @pytest.mark.asyncio
  async def test_fetch_company_financials_success():
      # Arrange
      client = FinancialDataClient(api_key="test_key")
      expected_data = CompanyFinancialData(
          company_name="Test Corp",
          revenue=Decimal("1000000")
      )

      # Act
      with patch.object(client._client, 'get') as mock_get:
          mock_response = AsyncMock()
          mock_response.json.return_value = expected_data.dict()
          mock_get.return_value = mock_response

          result = await client.get_company_financials("1234567890")

      # Assert
      assert result.company_name == "Test Corp"
      assert result.revenue == Decimal("1000000")
  ```

### 4.2 Integration Tests
- [ ] Написать integration тесты для проверки взаимодействия компонентов
- [ ] Тестировать end-to-end flows
- [ ] Использовать test fixtures для setup/teardown

### 4.3 Test Coverage
- [ ] Запустить тесты: `pytest`
- [ ] Проверить coverage: `pytest --cov=. --cov-report=html`
- [ ] Убедиться, что coverage >= 80% для нового кода
- [ ] Все тесты проходят без warnings

### 4.4 Manual Testing
- [ ] Протестировать фичу вручную в development окружении
- [ ] Проверить все user flows
- [ ] Проверить edge cases
- [ ] Для Telegram bot - протестировать в тестовом боте

## 5. Code Quality

### 5.1 Linting and Formatting
- [ ] Запустить Black: `poetry run black .`
- [ ] Запустить Ruff: `poetry run ruff check .`
- [ ] Запустить mypy: `poetry run mypy .`
- [ ] Исправить все найденные проблемы

### 5.2 Security Review
- [ ] Нет hardcoded secrets, API keys, паролей
- [ ] Пользовательский ввод валидируется
- [ ] Нет SQL injection уязвимостей
- [ ] Логи не содержат sensitive data
- [ ] Async resources properly managed (using context managers)

### 5.3 Performance Review
- [ ] Нет N+1 queries
- [ ] Нет избыточных API calls
- [ ] Большие данные обрабатываются эффективно
- [ ] Используется async для параллельных операций

## 6. Документация

### 6.1 Code Documentation
- [ ] Все public функции имеют docstrings
- [ ] Сложные алгоритмы имеют пояснительные комментарии
- [ ] Комментарии объясняют WHY, а не WHAT
- [ ] TODO комментарии содержат имя автора и контекст

### 6.2 Update Memory Bank
- [ ] Обновить **[../tech_stack.md](../tech_stack.md)** если добавлены новые зависимости
- [ ] Создать/обновить guide в **[../guides/](../guides/)** если это новая подсистема
- [ ] Создать/обновить pattern в **[../patterns/](../patterns/)** если введен новый архитектурный паттерн
- [ ] Добавить примеры использования новой фичи

### 6.3 API Documentation (if applicable)
- [ ] Документировать все новые API endpoints
- [ ] Добавить примеры запросов/ответов
- [ ] Документировать error codes

## 7. Завершение

### 7.1 Acceptance Criteria Check
- [ ] Проверить, что все критерии приемки из спецификации выполнены
- [ ] Пройтись по чек-листу из спецификации
- [ ] Убедиться, что нет missing requirements

### 7.2 Architecture Review
- [ ] Убедиться, что не нарушены архитектурные принципы
- [ ] Проверить, что нет дублирования кода
- [ ] Убедиться, что используются существующие компоненты
- [ ] Проверить, что новый код следует установленным паттернам

### 7.3 Task Status Update
- [ ] Обновить статус задачи в **[../current_tasks.md](../current_tasks.md)** на "Done"
- [ ] Добавить краткое описание реализации

### 7.4 Commit and Push
- [ ] Создать коммиты с осмысленными сообщениями (Conventional Commits):
  ```
  feat(module): краткое описание фичи

  - Детали реализации
  - Основные изменения
  - Closes #TICKET-NUMBER
  ```
- [ ] Push ветки: `git push -u origin feature/TICKET-NUMBER-short-description`

### 7.5 Pull Request
- [ ] Создать Pull Request с подробным описанием:
  - **Описание фичи**: Что реализовано?
  - **Бизнес-ценность**: Зачем это нужно?
  - **Техническое решение**: Как реализовано?
  - **Тестирование**: Как протестировано?
  - **Скриншоты/примеры**: Визуальные примеры работы (если применимо)
  - **Чек-лист**: Все критерии приемки выполнены
- [ ] Перечислить все измененные/созданные файлы и их назначение
- [ ] Связать PR с ticket/issue

### 7.6 Self Review
- [ ] Провести self-review по чек-листу из **[code_review.md](./code_review.md)**
- [ ] Убедиться, что код готов к review другими разработчиками

## 8. Специфичные для проекта проверки

### Для Telegram Bot Features
- [ ] Все user-facing сообщения на русском языке
- [ ] Добавлены help текста для новых команд
- [ ] Реализована graceful error handling для user errors
- [ ] Добавлено логирование с correlation_id для всех операций
- [ ] Протестировано поведение при некорректном вводе
- [ ] User не видит internal error details

### Для External API Integration
- [ ] Все responses обернуты в Pydantic модели
- [ ] Реализован retry mechanism для transient errors
- [ ] Добавлен timeout handling
- [ ] Логируются все API calls с correlation_id
- [ ] Добавлен circuit breaker (если применимо)
- [ ] API keys хранятся в environment variables

### Для Async Code
- [ ] Нет blocking I/O в async функциях
- [ ] Используются async context managers для resources
- [ ] Proper cleanup of resources
- [ ] Нет race conditions
- [ ] Используется `asyncio.gather()` для параллельных операций

### Для Database Features
- [ ] Используются parameterized queries
- [ ] Proper transaction management
- [ ] Connection pooling настроен правильно
- [ ] Все DB operations логируются
- [ ] Созданы необходимые indexes
- [ ] Database migration создан и протестирован

### Для AI/LLM Integration
- [ ] API keys в environment variables
- [ ] Реализован rate limiting
- [ ] Добавлен retry mechanism
- [ ] Логируются все LLM calls с correlation_id и token usage
- [ ] Реализован fallback для случаев недоступности API
- [ ] User prompts sanitized для предотвращения injection

## Чек-лист готовности к merge
- [ ] Все тесты проходят
- [ ] Code coverage >= 80% для нового кода
- [ ] Все linters проходят без ошибок
- [ ] Type checking (mypy) проходит без ошибок
- [ ] Все критерии приемки из спецификации выполнены
- [ ] Документация обновлена (code docs + Memory Bank)
- [ ] Self-review выполнен
- [ ] Pull Request создан с полным описанием
- [ ] Нет TODO комментариев (или они задокументированы в issues)
- [ ] Нет дублирования существующего функционала
- [ ] Используются существующие компоненты где возможно
- [ ] Новые зависимости добавлены в **[../tech_stack.md](../tech_stack.md)**
- [ ] Архитектурные принципы не нарушены
