# Процесс ревью кода

## 1. Общая проверка

### 1.1 Pull Request Quality
- [ ] Pull Request содержит понятное описание изменений
- [ ] Описание включает:
  - Контекст: что и зачем делается
  - Техническое решение: как реализовано
  - Тестирование: как проверить
  - Скриншоты/примеры (если применимо)
- [ ] PR связан с соответствующим ticket/issue
- [ ] Название PR следует Conventional Commits формату
- [ ] Размер PR разумный (не более 500 строк изменений, желательно <300)

### 1.2 Scope Check
- [ ] Все измененные файлы связаны с решаемой задачей
- [ ] Нет несвязанных изменений (scope creep)
- [ ] Нет закомментированного кода
- [ ] Нет debug prints или console.log
- [ ] Нет мертвого кода (unused imports, functions)

### 1.3 Commit History
- [ ] Коммиты имеют осмысленные сообщения
- [ ] Следуют Conventional Commits формату
- [ ] История коммитов логична и понятна
- [ ] Нет фиксапов для опечаток (должны быть squashed)

## 2. Соответствие стандартам кодирования

### 2.1 Code Style
- [ ] Код соответствует **[стандартам кодирования](../guides/coding_standards.md)**
- [ ] Именование переменных, функций и классов следует конвенциям:
  - `snake_case` для переменных и функций
  - `PascalCase` для классов
  - `UPPER_SNAKE_CASE` для констант
- [ ] Форматирование согласовано с Black
- [ ] Максимальная длина строки: 100 символов

### 2.2 Type Hints
- [ ] Все функции имеют type hints для параметров и return value
- [ ] Используются правильные типы из `typing`
- [ ] Нет использования `Any` (если есть - должно быть обосновано)
- [ ] Пример:
  ```python
  # Good
  def fetch_data(url: str, timeout: int = 30) -> Dict[str, Any]:
      pass

  # Bad
  def fetch_data(url, timeout=30):  # No type hints
      pass
  ```

### 2.3 Docstrings
- [ ] Все public функции и классы имеют docstrings
- [ ] Docstrings следуют Google style
- [ ] Docstrings содержат:
  - Краткое описание
  - Args с типами и описаниями
  - Returns с описанием
  - Raises для исключений
  - Example (если применимо)
- [ ] Пример:
  ```python
  async def analyze_company(
      company_name: str,
      correlation_id: str
  ) -> CompanyAnalysis:
      """Analyze company data and generate report.

      Args:
          company_name: Name of the company to analyze
          correlation_id: Request correlation ID for tracking

      Returns:
          CompanyAnalysis object with analysis results

      Raises:
          ValidationError: If company_name is invalid
          ExternalAPIError: If external API call fails
      """
      pass
  ```

## 3. Архитектура и паттерны

### 3.1 Architectural Compliance
- [ ] Изменения не нарушают архитектурные принципы из **[../patterns/](../patterns/)**
- [ ] Новые компоненты следуют установленным паттернам
- [ ] Правильное разделение ответственности между модулями:
  - `bot/` - только Telegram handlers
  - `core/` - business logic
  - `integrations/` - external API clients
  - `data/` - data processing and storage

### 3.2 Code Reuse
- [ ] Нет дублирования функционала, существующего в других частях проекта
- [ ] Используются существующие Pydantic модели
- [ ] Используются существующие utility функции
- [ ] Переиспользуются API clients из `integrations/`

### 3.3 Dependency Management
- [ ] Если добавлены новые зависимости:
  - Они действительно необходимы
  - Обновлен **[../tech_stack.md](../tech_stack.md)**
  - Проверена совместимость с текущим стеком
  - Обоснована необходимость (нет lightweight альтернатив)

## 4. Качество кода

### 4.1 Single Responsibility Principle
- [ ] Каждая функция имеет одну ответственность
- [ ] Каждый класс имеет одну ответственность
- [ ] Функции не превышают 50 строк
- [ ] Файлы не превышают 500 строк

### 4.2 Code Complexity
- [ ] Нет чрезмерно сложных функций
- [ ] Уровень вложенности не превышает 3-4
- [ ] Сложные условия вынесены в отдельные функции с понятными именами
- [ ] Пример:
  ```python
  # Good
  def is_eligible_for_discount(user: User) -> bool:
      return (
          user.is_premium
          and user.purchases_count > 10
          and user.account_age_days > 30
      )

  if is_eligible_for_discount(user):
      apply_discount()

  # Bad
  if user.is_premium and user.purchases_count > 10 and user.account_age_days > 30:
      apply_discount()
  ```

### 4.3 Error Handling
- [ ] Обработка ошибок следует **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Используются специфичные исключения (не голый `Exception`)
- [ ] Нет пустых `except` блоков или `except: pass`
- [ ] Все ошибки логируются с контекстом
- [ ] User-facing ошибки не содержат internal details
- [ ] Пример:
  ```python
  # Good
  try:
      result = await fetch_data(url)
  except httpx.HTTPStatusError as e:
      logger.error(f"HTTP error: {e.response.status_code}", extra={"correlation_id": correlation_id})
      raise ExternalAPIError(f"API returned {e.response.status_code}")
  except httpx.TimeoutException:
      logger.error("Request timeout", extra={"correlation_id": correlation_id})
      raise ExternalAPIError("Request timeout")

  # Bad
  try:
      result = await fetch_data(url)
  except:  # Too broad!
      pass  # Silently ignoring!
  ```

### 4.4 Magic Numbers and Strings
- [ ] Нет "магических" чисел - используются именованные константы
- [ ] Нет hardcoded strings - используются константы или config
- [ ] Пример:
  ```python
  # Good
  MAX_RETRIES = 3
  DEFAULT_TIMEOUT = 30

  @retry(stop=stop_after_attempt(MAX_RETRIES))
  async def fetch_data(url: str, timeout: int = DEFAULT_TIMEOUT):
      pass

  # Bad
  @retry(stop=stop_after_attempt(3))  # What is 3?
  async def fetch_data(url: str, timeout: int = 30):  # What is 30?
      pass
  ```

## 5. Async Code Quality

### 5.1 Async Best Practices
- [ ] Все I/O операции асинхронные
- [ ] Нет blocking операций в async функциях
- [ ] Используется `httpx.AsyncClient` вместо `requests`
- [ ] Используется `aiofiles` для файловых операций
- [ ] Пример:
  ```python
  # Good
  async def fetch_data(url: str) -> Dict[str, Any]:
      async with httpx.AsyncClient() as client:
          response = await client.get(url)
          return response.json()

  # Bad - blocks event loop!
  async def fetch_data(url: str) -> Dict[str, Any]:
      response = requests.get(url)  # Blocking I/O!
      return response.json()
  ```

### 5.2 Resource Management
- [ ] Используются async context managers для ресурсов
- [ ] Proper cleanup of resources (clients, connections, files)
- [ ] Нет resource leaks
- [ ] Пример:
  ```python
  # Good - automatic cleanup
  async with httpx.AsyncClient() as client:
      response = await client.get(url)

  # Bad - risk of resource leak
  client = httpx.AsyncClient()
  response = await client.get(url)
  # What if exception? Client not closed!
  ```

### 5.3 Concurrency
- [ ] Используется `asyncio.gather()` для параллельных операций
- [ ] Нет race conditions
- [ ] Правильное использование locks (если нужны)
- [ ] Пример:
  ```python
  # Good - parallel execution
  results = await asyncio.gather(
      fetch_data(url1),
      fetch_data(url2),
      fetch_data(url3)
  )

  # Bad - sequential execution
  result1 = await fetch_data(url1)
  result2 = await fetch_data(url2)
  result3 = await fetch_data(url3)
  ```

## 6. Тестирование

### 6.1 Test Coverage
- [ ] Все новые функции покрыты unit-тестами
- [ ] Code coverage >= 80% для нового кода
- [ ] Критическая бизнес-логика имеет 100% coverage

### 6.2 Test Quality
- [ ] Тесты следуют AAA паттерну (Arrange-Act-Assert)
- [ ] Тесты независимы друг от друга
- [ ] Тесты имеют понятные имена (`test_function_name_expected_behavior`)
- [ ] Используются fixtures для setup/teardown
- [ ] Пример:
  ```python
  @pytest.mark.asyncio
  async def test_fetch_company_data_returns_valid_data():
      # Arrange
      client = CompanyClient(api_key="test_key")
      expected_company = "Test Corp"

      # Act
      result = await client.fetch_company_data(expected_company)

      # Assert
      assert result.name == expected_company
      assert result.inn is not None
  ```

### 6.3 Test Execution
- [ ] Все тесты проходят: `pytest`
- [ ] Нет warnings в тестах
- [ ] Тесты выполняются быстро (<5 минут для всего suite)

### 6.4 Edge Cases
- [ ] Протестированы граничные случаи
- [ ] Протестирована обработка ошибок
- [ ] Протестирована валидация входных данных
- [ ] Для async кода протестированы timeouts

## 7. Безопасность

### 7.1 Secrets Management
- [ ] Нет hardcoded паролей, API keys, токенов
- [ ] Все секреты в environment variables
- [ ] Используется `python-dotenv` или `pydantic-settings`
- [ ] `.env` файл в `.gitignore`

### 7.2 Input Validation
- [ ] Весь пользовательский ввод валидируется
- [ ] Используются Pydantic модели для валидации
- [ ] Нет возможности injection атак

### 7.3 SQL Security
- [ ] Используются parameterized queries
- [ ] Нет строковых конкатенаций для SQL
- [ ] Пример:
  ```python
  # Good
  query = "SELECT * FROM companies WHERE name = %s"
  cursor.execute(query, (company_name,))

  # Bad - SQL injection risk!
  query = f"SELECT * FROM companies WHERE name = '{company_name}'"
  cursor.execute(query)
  ```

### 7.4 Data Exposure
- [ ] Логи не содержат sensitive data (API keys, passwords, PII)
- [ ] Error messages не показывают internal details пользователям
- [ ] User-facing сообщения не содержат stack traces

## 8. Производительность

### 8.1 Efficiency
- [ ] Нет N+1 queries
- [ ] Нет избыточных API calls
- [ ] Используется кэширование где уместно
- [ ] Batch операции для массовых обработок

### 8.2 Resource Usage
- [ ] Большие данные обрабатываются потоково (не загружаются целиком в память)
- [ ] Используются generators для больших коллекций
- [ ] Connection pooling для database

### 8.3 Async Optimization
- [ ] Параллельные операции выполняются concurrently
- [ ] Нет избыточных `await` (блокирующих параллелизм)

## 9. Документация

### 9.1 Code Documentation
- [ ] Обновлена документация, если изменилось публичное API
- [ ] Сложные алгоритмы имеют пояснительные комментарии
- [ ] Комментарии объясняют WHY, а не WHAT
- [ ] TODO комментарии содержат контекст и assignee

### 9.2 Memory Bank Updates
- [ ] **[../tech_stack.md](../tech_stack.md)** обновлен при добавлении зависимостей
- [ ] **[../guides/](../guides/)** обновлены при добавлении новых подсистем
- [ ] **[../patterns/](../patterns/)** обновлены при введении новых паттернов
- [ ] **[../current_tasks.md](../current_tasks.md)** обновлен (задача в Done)

### 9.3 API Documentation
- [ ] Новые API endpoints задокументированы
- [ ] Примеры запросов/ответов добавлены
- [ ] Error codes задокументированы

## 10. Специфичные для проекта проверки

### 10.1 Telegram Bot Code
- [ ] Все user-facing сообщения на русском языке
- [ ] Добавлены help тексты для новых команд
- [ ] Graceful error handling для user errors
- [ ] Логирование с `correlation_id` для всех операций
- [ ] User не видит internal error details
- [ ] Обработка некорректного ввода пользователя

### 10.2 External API Integration
- [ ] Все responses обернуты в Pydantic модели
- [ ] Retry mechanism для transient errors
- [ ] Timeout handling
- [ ] Логирование всех API calls с `correlation_id`
- [ ] Circuit breaker (для критичных интеграций)
- [ ] API keys из environment variables

### 10.3 Database Code
- [ ] Parameterized queries (нет SQL injection риска)
- [ ] Proper transaction management
- [ ] Connection pooling
- [ ] Логирование всех DB operations
- [ ] Indexes для часто запрашиваемых полей

### 10.4 AI/LLM Integration
- [ ] API keys в environment variables
- [ ] Rate limiting реализован
- [ ] Retry mechanism для API errors
- [ ] Логирование LLM calls с token usage
- [ ] Fallback для случаев недоступности API
- [ ] User prompts sanitized

## 11. Финальная проверка

### 11.1 CI/CD
- [ ] Нет merge конфликтов
- [ ] CI/CD pipeline проходит успешно
- [ ] Все linters проходят (Black, Ruff, mypy)
- [ ] Все тесты проходят

### 11.2 Acceptance Criteria
- [ ] Все критерии приемки из спецификации выполнены
- [ ] Фича работает согласно требованиям
- [ ] Нет known bugs или limitations (или они задокументированы)

### 11.3 Backwards Compatibility
- [ ] Изменения не ломают существующую функциональность
- [ ] API contracts не нарушены
- [ ] Database migrations backwards compatible (если применимо)

### 11.4 Deployment Readiness
- [ ] Environment variables задокументированы
- [ ] Deployment инструкции обновлены (если нужно)
- [ ] Database migrations готовы (если нужно)
- [ ] Нет breaking changes (или они задокументированы)

## Чек-лист финальной готовности

- [ ] Все секции этого чек-листа пройдены
- [ ] Код соответствует **[стандартам кодирования](../guides/coding_standards.md)**
- [ ] Архитектурные паттерны из **[../patterns/](../patterns/)** соблюдены
- [ ] Обработка ошибок следует **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Технологический стек соответствует **[../tech_stack.md](../tech_stack.md)**
- [ ] Все тесты проходят с coverage >= 80%
- [ ] Документация обновлена
- [ ] Нет security issues
- [ ] Нет performance problems
- [ ] Код готов к production deployment

## Шаблон комментария review

### Для одобрения (LGTM)
```
✅ Code Review LGTM

Проверено:
- Архитектура и паттерны
- Code quality и стандарты
- Тесты и coverage
- Безопасность
- Документация

Отличная работа! 🚀
```

### Для запроса изменений
```
⚠️ Code Review - Changes Requested

Основные замечания:
1. [Критичная проблема 1 с reference на код]
2. [Критичная проблема 2 с reference на код]

Рекомендации:
- [Некритичная рекомендация 1]
- [Некритичная рекомендация 2]

После исправления критичных проблем готов к повторному review.
```

### Для комментариев
```
💬 Комментарий

Вопрос/предложение по [конкретному месту кода]:
[Детали]

Не блокирует merge, но стоит обсудить.
```
