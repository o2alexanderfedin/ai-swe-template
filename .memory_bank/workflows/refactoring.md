# Процесс рефакторинга

## Введение

Рефакторинг - это изменение внутренней структуры кода без изменения его внешнего поведения. Цель - улучшить читаемость, поддерживаемость, производительность или архитектуру кода.

**Ключевой принцип**: Рефакторинг должен быть безопасным и инкрементальным. Делайте маленькие шаги, постоянно проверяйте, что ничего не сломалось.

## 1. Подготовка и планирование

### 1.1 Git Branch Setup
- [ ] Создать ветку от `develop` по шаблону `refactor/TICKET-NUMBER-short-description`
  - Пример: `refactor/DD-78-extract-company-validation`
  - Следовать конвенции из **[../tech_stack.md](../tech_stack.md#version-control)**

### 1.2 Task Tracking
- [ ] Обновить статус задачи в **[../current_tasks.md](../current_tasks.md)** на "In Progress"
- [ ] Добавить метку `[REFACTOR]` к задаче

### 1.3 Identify Refactoring Target
- [ ] Определить код, который требует рефакторинга
- [ ] Классифицировать тип рефакторинга:
  - **Extract Method**: Вынести часть кода в отдельную функцию
  - **Extract Class**: Создать новый класс из части существующего
  - **Rename**: Переименовать для улучшения читаемости
  - **Remove Duplication**: Устранить дублирование кода
  - **Simplify Conditional**: Упростить сложные условия
  - **Optimize Performance**: Улучшить производительность
  - **Improve Error Handling**: Улучшить обработку ошибок
  - **Modernize Code**: Обновить до современных практик Python

### 1.4 Understand Current Code
- [ ] Изучить существующий код досконально:
  - Что делает код?
  - Какие есть зависимости?
  - Где используется?
  - Какие тесты покрывают этот код?
- [ ] Проанализировать связанные документы:
  - **[../guides/coding_standards.md](../guides/coding_standards.md)**
  - **[../patterns/](../patterns/)**
- [ ] Определить scope изменений

### 1.5 Safety Check
- [ ] Убедиться, что существующий код покрыт тестами
- [ ] Если тестов нет - написать их ПЕРЕД рефакторингом
- [ ] Запустить все тесты и убедиться, что они проходят
- [ ] Зафиксировать текущее поведение как baseline

## 2. Анализ и проектирование

### 2.1 Define Success Criteria
- [ ] Определить конкретные цели рефакторинга:
  - Что должно улучшиться? (читаемость, производительность, maintainability)
  - Какие метрики использовать? (complexity, coupling, cohesion)
  - Как измерить успех?

### 2.2 Plan Incremental Steps
- [ ] Разбить рефакторинг на маленькие, безопасные шаги
- [ ] Определить порядок изменений
- [ ] Определить контрольные точки для проверки
- [ ] Пример плана для Extract Method:
  1. Выделить код в новую функцию
  2. Добавить type hints и docstring
  3. Заменить оригинальный код вызовом новой функции
  4. Запустить тесты
  5. Commit

### 2.3 Check Existing Components
- [ ] Проверить, нет ли уже готового решения в кодовой базе
- [ ] Найти существующие компоненты для переиспользования
- [ ] Проверить **[../tech_stack.md](../tech_stack.md)** на доступные библиотеки

### 2.4 Assess Risk
- [ ] Оценить риск рефакторинга:
  - **Low risk**: Локальные изменения, хорошо покрыто тестами
  - **Medium risk**: Затрагивает несколько модулей, частично покрыто тестами
  - **High risk**: Затрагивает core функциональность, мало тестов
- [ ] Для high risk рефакторинга - рассмотреть разбиение на несколько PR

## 3. Выполнение рефакторинга

### 3.1 General Principles
- [ ] **Red-Green-Refactor** цикл:
  1. Убедиться, что тесты проходят (Green)
  2. Сделать маленькое изменение
  3. Запустить тесты - они должны пройти
  4. Commit
  5. Повторить
- [ ] Делать маленькие, атомарные коммиты
- [ ] Тесты должны проходить после каждого шага
- [ ] Не добавлять новую функциональность во время рефакторинга

### 3.2 Extract Method Refactoring
Если нужно вынести часть кода в отдельную функцию:

- [ ] Идентифицировать блок кода для извлечения
- [ ] Определить входные параметры и return value
- [ ] Создать новую функцию с понятным именем
- [ ] Добавить type hints для всех параметров и return value
- [ ] Добавить docstring (Google style)
- [ ] Скопировать код в новую функцию
- [ ] Заменить оригинальный код вызовом новой функции
- [ ] Запустить тесты
- [ ] Пример:
  ```python
  # Before
  async def process_company(company_name: str) -> Report:
      # 50 lines of validation logic
      if not company_name:
          raise ValidationError("Empty name")
      if len(company_name) < 2:
          raise ValidationError("Name too short")
      # ... more validation

      # 100 lines of processing logic
      data = await fetch_data(company_name)
      # ... processing

      return Report(data)

  # After - extracted validation
  async def process_company(company_name: str) -> Report:
      _validate_company_name(company_name)
      data = await fetch_data(company_name)
      # ... processing
      return Report(data)

  def _validate_company_name(name: str) -> None:
      """Validate company name.

      Args:
          name: Company name to validate

      Raises:
          ValidationError: If validation fails
      """
      if not name:
          raise ValidationError("Empty name")
      if len(name) < 2:
          raise ValidationError("Name too short")
      # ... more validation
  ```

### 3.3 Extract Class Refactoring
Если класс слишком большой и делает слишком много:

- [ ] Идентифицировать группу связанных методов и данных
- [ ] Создать новый класс с понятным именем
- [ ] Переместить связанные методы в новый класс
- [ ] Обновить original класс - использовать composition
- [ ] Добавить type hints и docstrings
- [ ] Обновить тесты
- [ ] Пример:
  ```python
  # Before - God Object
  class CompanyAnalyzer:
      def analyze(self, company: str) -> Report:
          financial_data = self._fetch_financials(company)
          financial_score = self._calculate_financial_score(financial_data)
          legal_data = self._fetch_legal_records(company)
          legal_risk = self._assess_legal_risk(legal_data)
          news_data = self._fetch_news(company)
          sentiment = self._analyze_sentiment(news_data)
          return Report(financial_score, legal_risk, sentiment)

  # After - extracted classes
  class CompanyAnalyzer:
      def __init__(self):
          self.financial_analyzer = FinancialAnalyzer()
          self.legal_analyzer = LegalAnalyzer()
          self.sentiment_analyzer = SentimentAnalyzer()

      def analyze(self, company: str) -> Report:
          financial_score = self.financial_analyzer.analyze(company)
          legal_risk = self.legal_analyzer.analyze(company)
          sentiment = self.sentiment_analyzer.analyze(company)
          return Report(financial_score, legal_risk, sentiment)
  ```

### 3.4 Remove Duplication
Если есть повторяющийся код:

- [ ] Найти все места с дублированием
- [ ] Определить общую логику
- [ ] Создать общую функцию/класс
- [ ] Заменить все дубликаты вызовами общей функции
- [ ] Параметризовать различия
- [ ] Запустить тесты
- [ ] Пример:
  ```python
  # Before - duplication
  async def fetch_company_from_source_a(inn: str) -> CompanyData:
      try:
          async with httpx.AsyncClient() as client:
              response = await client.get(f"https://source-a.com/api/{inn}")
              response.raise_for_status()
              return CompanyData(**response.json())
      except httpx.HTTPStatusError as e:
          logger.error(f"Failed to fetch from source A: {e}")
          raise ExternalAPIError("Source A unavailable")

  async def fetch_company_from_source_b(inn: str) -> CompanyData:
      try:
          async with httpx.AsyncClient() as client:
              response = await client.get(f"https://source-b.com/companies/{inn}")
              response.raise_for_status()
              return CompanyData(**response.json())
      except httpx.HTTPStatusError as e:
          logger.error(f"Failed to fetch from source B: {e}")
          raise ExternalAPIError("Source B unavailable")

  # After - extracted common logic
  async def fetch_company_from_api(
      url: str,
      source_name: str
  ) -> CompanyData:
      """Fetch company data from external API.

      Args:
          url: API endpoint URL
          source_name: Name of the data source for logging

      Returns:
          CompanyData object

      Raises:
          ExternalAPIError: If API call fails
      """
      try:
          async with httpx.AsyncClient() as client:
              response = await client.get(url)
              response.raise_for_status()
              return CompanyData(**response.json())
      except httpx.HTTPStatusError as e:
          logger.error(f"Failed to fetch from {source_name}: {e}")
          raise ExternalAPIError(f"{source_name} unavailable")

  async def fetch_company_from_source_a(inn: str) -> CompanyData:
      return await fetch_company_from_api(
          url=f"https://source-a.com/api/{inn}",
          source_name="Source A"
      )

  async def fetch_company_from_source_b(inn: str) -> CompanyData:
      return await fetch_company_from_api(
          url=f"https://source-b.com/companies/{inn}",
          source_name="Source B"
      )
  ```

### 3.5 Simplify Conditional Logic
Если условия слишком сложные:

- [ ] Вынести сложные условия в функции с понятными именами
- [ ] Использовать early returns для уменьшения вложенности
- [ ] Применить pattern matching (Python 3.10+) если подходит
- [ ] Пример:
  ```python
  # Before - complex nested conditions
  def calculate_discount(user: User, order: Order) -> Decimal:
      if user.is_premium:
          if order.total > 10000:
              if user.loyalty_points > 1000:
                  return order.total * Decimal("0.25")
              else:
                  return order.total * Decimal("0.15")
          else:
              return order.total * Decimal("0.10")
      else:
          if order.total > 5000:
              return order.total * Decimal("0.05")
          else:
              return Decimal("0")

  # After - simplified with extracted functions
  def calculate_discount(user: User, order: Order) -> Decimal:
      if not user.is_premium:
          return _calculate_regular_discount(order)
      return _calculate_premium_discount(user, order)

  def _calculate_regular_discount(order: Order) -> Decimal:
      """Calculate discount for regular users."""
      if order.total > 5000:
          return order.total * Decimal("0.05")
      return Decimal("0")

  def _calculate_premium_discount(user: User, order: Order) -> Decimal:
      """Calculate discount for premium users."""
      if order.total <= 10000:
          return order.total * Decimal("0.10")

      discount_rate = Decimal("0.25") if user.loyalty_points > 1000 else Decimal("0.15")
      return order.total * discount_rate
  ```

### 3.6 Improve Async Code
Если async код можно улучшить:

- [ ] Заменить blocking операции на async
- [ ] Использовать `asyncio.gather()` для параллельных операций
- [ ] Использовать async context managers
- [ ] Убрать race conditions
- [ ] Пример:
  ```python
  # Before - sequential async calls
  async def fetch_all_data(company: str) -> CompanyReport:
      financial = await fetch_financial_data(company)
      legal = await fetch_legal_data(company)
      news = await fetch_news_data(company)
      return CompanyReport(financial, legal, news)

  # After - parallel async calls
  async def fetch_all_data(company: str) -> CompanyReport:
      financial, legal, news = await asyncio.gather(
          fetch_financial_data(company),
          fetch_legal_data(company),
          fetch_news_data(company)
      )
      return CompanyReport(financial, legal, news)
  ```

### 3.7 Modernize Code
Если код использует устаревшие паттерны:

- [ ] Заменить старые type hints на современные (Python 3.10+):
  - `list[str]` вместо `List[str]`
  - `dict[str, int]` вместо `Dict[str, int]`
  - `X | None` вместо `Optional[X]`
- [ ] Использовать f-strings вместо `.format()` или `%`
- [ ] Использовать dataclasses или Pydantic вместо обычных классов
- [ ] Использовать pathlib вместо os.path
- [ ] Пример:
  ```python
  # Before - old style
  from typing import List, Optional, Dict
  import os

  def process_files(
      file_paths: List[str],
      config: Optional[Dict[str, str]] = None
  ) -> List[str]:
      results = []
      for path in file_paths:
          full_path = os.path.join("/data", path)
          if os.path.exists(full_path):
              results.append("File exists: %s" % path)
      return results

  # After - modern Python 3.11+
  from pathlib import Path

  def process_files(
      file_paths: list[str],
      config: dict[str, str] | None = None
  ) -> list[str]:
      results = []
      base_path = Path("/data")

      for path in file_paths:
          full_path = base_path / path
          if full_path.exists():
              results.append(f"File exists: {path}")

      return results
  ```

## 4. Тестирование

### 4.1 Continuous Testing
- [ ] Запускать тесты после каждого маленького изменения
- [ ] Команда: `pytest -v`
- [ ] Для async тестов: `pytest -v --asyncio-mode=auto`
- [ ] Убедиться, что все тесты проходят

### 4.2 Test Coverage
- [ ] Проверить, что test coverage не снизился
- [ ] Команда: `pytest --cov=. --cov-report=html`
- [ ] Убедиться, что coverage >= 80%

### 4.3 Add New Tests (if needed)
- [ ] Если рефакторинг создал новые публичные функции - добавить для них тесты
- [ ] Если выявили untested edge cases - добавить тесты
- [ ] Следовать **[стратегии тестирования](../guides/testing_strategy.md)**

### 4.4 Integration Testing
- [ ] Запустить integration тесты (если есть)
- [ ] Протестировать вручную в development окружении
- [ ] Для Telegram bot - протестировать в тестовом боте

## 5. Code Quality Verification

### 5.1 Linting and Formatting
- [ ] Запустить Black: `poetry run black .`
- [ ] Запустить Ruff: `poetry run ruff check .`
- [ ] Запустить mypy: `poetry run mypy .`
- [ ] Исправить все найденные проблемы

### 5.2 Code Quality Metrics
- [ ] Проверить, что рефакторинг действительно улучшил код:
  - Уменьшилась сложность функций?
  - Улучшилась читаемость?
  - Уменьшилось дублирование?
  - Улучшилась структура?

### 5.3 Performance Check (if applicable)
- [ ] Если цель рефакторинга - производительность:
  - Измерить производительность до и после
  - Убедиться, что есть улучшение
  - Добавить performance тесты (если применимо)

## 6. Документация

### 6.1 Code Documentation
- [ ] Обновить docstrings для измененных функций/классов
- [ ] Добавить комментарии, объясняющие WHY (если нужно)
- [ ] Удалить устаревшие комментарии

### 6.2 Update Memory Bank (if needed)
- [ ] Обновить **[../guides/](../guides/)** если изменились практики
- [ ] Обновить **[../patterns/](../patterns/)** если изменились паттерны
- [ ] Добавить новые best practices, выявленные при рефакторинге

### 6.3 Document Breaking Changes (if any)
- [ ] Если рефакторинг изменил публичное API:
  - Задокументировать breaking changes
  - Создать migration guide
  - Обновить version (semantic versioning)

## 7. Завершение

### 7.1 Self Review
- [ ] Провести self-review:
  - Все цели рефакторинга достигнуты?
  - Код действительно улучшился?
  - Не добавлена ли новая функциональность случайно?
  - Все тесты проходят?

### 7.2 Task Status Update
- [ ] Обновить статус задачи в **[../current_tasks.md](../current_tasks.md)** на "Done"
- [ ] Добавить описание выполненного рефакторинга

### 7.3 Commit and Push
- [ ] Создать осмысленные коммиты (Conventional Commits):
  ```
  refactor(module): краткое описание рефакторинга

  - Что было улучшено
  - Почему было сделано
  - Метрики до/после (если применимо)
  ```
- [ ] Push ветки: `git push -u origin refactor/TICKET-NUMBER-short-description`

### 7.4 Pull Request
- [ ] Создать Pull Request с описанием:
  - **Motivation**: Почему нужен рефакторинг?
  - **Changes**: Что изменилось?
  - **Impact**: Как это улучшило код? (metrics, readability, etc.)
  - **Testing**: Как проверить, что ничего не сломалось?
  - **Breaking Changes**: Есть ли breaking changes? (должно быть "No" для pure refactoring)
- [ ] Добавить "before/after" примеры кода
- [ ] Связать PR с ticket/issue

### 7.5 Final Check
- [ ] Провести full review по чек-листу из **[code_review.md](./code_review.md)**
- [ ] Убедиться, что:
  - Внешнее поведение не изменилось
  - Все тесты проходят
  - Code quality улучшился
  - Нет regression

## 8. Специфичные типы рефакторинга

### 8.1 Database Schema Refactoring
Если рефакторинг затрагивает database schema:

- [ ] Создать backwards-compatible migration
- [ ] Определить стратегию миграции данных:
  1. Добавить новые поля/таблицы
  2. Мигрировать данные
  3. Обновить код для использования новой схемы
  4. Удалить старые поля/таблицы (в отдельном release)
- [ ] Протестировать migration на копии production данных
- [ ] Подготовить rollback план

### 8.2 API Refactoring
Если рефакторинг затрагивает публичное API:

- [ ] Сохранить обратную совместимость
- [ ] Использовать deprecation warnings для старого API
- [ ] Документировать migration path
- [ ] Создать migration guide для users
- [ ] Определить timeline для удаления deprecated API

### 8.3 Performance Refactoring
Если цель - улучшить производительность:

- [ ] Измерить baseline performance (profiling)
- [ ] Идентифицировать bottlenecks
- [ ] Применить оптимизации
- [ ] Измерить улучшение
- [ ] Убедиться, что readability не пострадала значительно
- [ ] Добавить performance тесты для предотвращения regression

## 9. Anti-patterns и ошибки

### Чего НЕ делать при рефакторинге:

- [ ] ❌ **Не добавлять новую функциональность** - рефакторинг должен менять только структуру
- [ ] ❌ **Не делать большие изменения за раз** - маленькие инкрементальные шаги
- [ ] ❌ **Не рефакторить без тестов** - сначала напишите тесты
- [ ] ❌ **Не менять поведение** - внешнее поведение должно остаться таким же
- [ ] ❌ **Не оптимизировать преждевременно** - сначала убедитесь, что это реальный bottleneck
- [ ] ❌ **Не рефакторить ради рефакторинга** - должна быть четкая цель
- [ ] ❌ **Не пропускать тесты** - запускайте после каждого шага

## Чек-лист готовности к merge

- [ ] Все тесты проходят
- [ ] Test coverage не снизился
- [ ] Все linters проходят
- [ ] Type checking проходит
- [ ] Внешнее поведение не изменилось
- [ ] Код стал лучше (более читаемый/поддерживаемый/производительный)
- [ ] Документация обновлена
- [ ] Self-review выполнен
- [ ] Pull Request создан с четким описанием
- [ ] Нет случайно добавленной новой функциональности
- [ ] Все цели рефакторинга достигнуты

## Примеры успешного рефакторинга

### Пример: Extract Validation Logic
```python
# Before - validation mixed with business logic
async def create_company_report(company_name: str, user_id: int) -> Report:
    if not company_name:
        raise ValidationError("Company name is required")
    if len(company_name) < 2:
        raise ValidationError("Company name too short")
    if not company_name.isascii():
        raise ValidationError("Company name must be ASCII")

    # Business logic
    data = await fetch_company_data(company_name)
    return generate_report(data)

# After - extracted validation
async def create_company_report(company_name: str, user_id: int) -> Report:
    _validate_company_name(company_name)
    data = await fetch_company_data(company_name)
    return generate_report(data)

def _validate_company_name(name: str) -> None:
    """Validate company name format.

    Args:
        name: Company name to validate

    Raises:
        ValidationError: If validation fails
    """
    if not name:
        raise ValidationError("Company name is required")
    if len(name) < 2:
        raise ValidationError("Company name too short")
    if not name.isascii():
        raise ValidationError("Company name must be ASCII")
```

Результат:
- ✅ Улучшилась читаемость основной функции
- ✅ Validation логика переиспользуема
- ✅ Легче тестировать
- ✅ Легче поддерживать и расширять
