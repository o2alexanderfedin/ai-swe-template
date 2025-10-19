# Процесс самопроверки (Self-Review)

## Введение

Self-Review - это систематическая проверка своей собственной работы перед тем, как представить ее на code review. Это критически важный этап, который:
- Повышает качество кода до code review
- Экономит время reviewers
- Помогает найти и исправить проблемы самостоятельно
- Развивает критическое мышление

**Когда проводить Self-Review:**
- Перед созданием Pull Request
- После получения чек-листа от планировщика (Gemini)
- После завершения реализации фичи или исправления бага

## 1. Подготовка к самопроверке

### 1.1 Сбор контекста
- [ ] Открыть оригинальную спецификацию в **[../specs/](../specs/)**
- [ ] Изучить критерии приемки из спецификации
- [ ] Открыть все измененные файлы для review
- [ ] Подготовить тестовое окружение для проверки

### 1.2 Ментальная подготовка
- [ ] Отдохнуть перед проверкой (fresh eyes)
- [ ] Настроиться на критический анализ своей работы
- [ ] Представить себя в роли code reviewer
- [ ] Забыть о том, как долго работал над кодом (sunk cost fallacy)

## 2. Проверка выполнения критериев приемки

### 2.1 Functional Completeness
- [ ] Сверить каждый пункт критериев приемки со спецификацией
- [ ] Убедиться, что все требования выполнены
- [ ] Проверить, что нет missing features
- [ ] Для каждого невыполненного критерия:
  - Объяснить причину
  - Создать issue для отслеживания
  - Задокументировать как known limitation

### 2.2 Business Logic Verification
- [ ] Проверить, что реализация соответствует бизнес-требованиям
- [ ] Убедиться, что edge cases обработаны
- [ ] Проверить, что граничные условия учтены
- [ ] Протестировать различные user scenarios

## 3. Code Quality Self-Check

### 3.1 Readability Check
- [ ] Прочитать код как будто видишь его первый раз
- [ ] Убедиться, что логика понятна без комментариев
- [ ] Проверить, что имена переменных и функций самодокументирующие
- [ ] Убедиться, что структура кода логична
- [ ] Вопросы для себя:
  - Понятно ли, что делает этот код?
  - Понятно ли, ПОЧЕМУ он это делает?
  - Нужны ли дополнительные комментарии?

### 3.2 Complexity Check
- [ ] Найти сложные функции (>50 строк)
- [ ] Декомпозировать длинные функции на более мелкие
- [ ] Проверить уровень вложенности (максимум 3-4)
- [ ] Упростить сложные условия
- [ ] Вынести магические числа в константы

### 3.3 DRY Principle
- [ ] Найти повторяющийся код
- [ ] Вынести дублирование в отдельные функции
- [ ] Проверить, нет ли дублирования существующего функционала
- [ ] Убедиться, что переиспользуются existing components

## 4. Architectural Compliance

### 4.1 Pattern Adherence
- [ ] Проверить соответствие **[../patterns/api_standards.md](../patterns/api_standards.md)**
- [ ] Проверить соответствие **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Убедиться, что следуем архитектурным решениям проекта
- [ ] Проверить правильное разделение на модули:
  - `bot/` - только Telegram handlers
  - `core/` - business logic
  - `integrations/` - external API clients
  - `data/` - data processing

### 4.2 Dependency Check
- [ ] Убедиться, что не добавлены неразрешенные зависимости
- [ ] Проверить **[../tech_stack.md](../tech_stack.md)** на список allowed libraries
- [ ] Если добавлена новая зависимость:
  - Она действительно необходима?
  - Обновлен **[../tech_stack.md](../tech_stack.md)**?
  - Нет более легковесной альтернативы?

### 4.3 Single Responsibility
- [ ] Каждая функция делает только одну вещь
- [ ] Каждый класс имеет одну ответственность
- [ ] Нет "God objects" или "God functions"

## 5. Type Safety & Standards

### 5.1 Type Hints Verification
- [ ] Все функции имеют type hints для parameters
- [ ] Все функции имеют type hints для return values
- [ ] Нет использования `Any` (или обосновано)
- [ ] Используются правильные типы из `typing`
- [ ] Запустить mypy: `poetry run mypy .`
- [ ] Исправить все type checking errors

### 5.2 Coding Standards Check
- [ ] Код следует **[../guides/coding_standards.md](../guides/coding_standards.md)**
- [ ] Naming conventions соблюдены:
  - `snake_case` для переменных и функций
  - `PascalCase` для классов
  - `UPPER_SNAKE_CASE` для констант
- [ ] Запустить Black: `poetry run black .`
- [ ] Запустить Ruff: `poetry run ruff check .`
- [ ] Исправить все найденные проблемы

### 5.3 Documentation Check
- [ ] Все public функции имеют docstrings (Google style)
- [ ] Docstrings содержат:
  - Описание функции
  - Args с типами
  - Returns
  - Raises
- [ ] Сложные алгоритмы имеют комментарии
- [ ] Комментарии объясняют WHY, а не WHAT

## 6. Async Code Review

### 6.1 Async Best Practices
- [ ] Все I/O операции асинхронные
- [ ] Нет blocking operations в async функциях
- [ ] Используется `httpx.AsyncClient` вместо `requests`
- [ ] Проверить критические ошибки:
  ```python
  # BAD - blocks event loop!
  async def fetch_data():
      response = requests.get(url)  # ❌
      data = open('file.txt').read()  # ❌
      time.sleep(5)  # ❌

  # GOOD - async all the way
  async def fetch_data():
      async with httpx.AsyncClient() as client:  # ✅
          response = await client.get(url)
      async with aiofiles.open('file.txt') as f:  # ✅
          data = await f.read()
      await asyncio.sleep(5)  # ✅
  ```

### 6.2 Resource Management
- [ ] Используются async context managers
- [ ] Proper cleanup of resources
- [ ] Нет resource leaks
- [ ] Проверить каждый `AsyncClient`, `connection`, `file`:
  - Используется ли `async with`?
  - Гарантирован ли cleanup при exception?

### 6.3 Concurrency Check
- [ ] Параллельные операции используют `asyncio.gather()`
- [ ] Нет race conditions
- [ ] Правильное использование locks (если есть)
- [ ] Пример проверки:
  ```python
  # BAD - sequential execution
  result1 = await fetch1()
  result2 = await fetch2()

  # GOOD - parallel execution
  result1, result2 = await asyncio.gather(fetch1(), fetch2())
  ```

## 7. Error Handling Review

### 7.1 Exception Handling
- [ ] Следует **[../patterns/error_handling.md](../patterns/error_handling.md)**
- [ ] Используются специфичные исключения (не голый `Exception`)
- [ ] Нет пустых `except` блоков
- [ ] Нет `except: pass` (silent failures)
- [ ] Все ошибки логируются с контекстом

### 7.2 User-Facing Errors
- [ ] User не видит internal error details
- [ ] Error messages понятны пользователю
- [ ] Error messages на русском языке (для Telegram bot)
- [ ] Нет stack traces в user-facing messages

### 7.3 Logging Quality
- [ ] Все важные операции логируются
- [ ] Используется `correlation_id` для трейсинга
- [ ] Логи не содержат sensitive data
- [ ] Log levels правильные (DEBUG, INFO, WARNING, ERROR)

## 8. Security Self-Review

### 8.1 Secrets Management
- [ ] Нет hardcoded паролей, API keys, токенов
- [ ] Все секреты в environment variables
- [ ] `.env` файл в `.gitignore`
- [ ] Примеры для поиска:
  ```bash
  # Search for potential secrets
  git grep -i "api_key.*=" | grep -v "env"
  git grep -i "password.*=" | grep -v "env"
  git grep -i "token.*=" | grep -v "env"
  ```

### 8.2 Input Validation
- [ ] Весь пользовательский ввод валидируется
- [ ] Используются Pydantic модели
- [ ] Нет возможности injection атак
- [ ] SQL queries используют parameterization

### 8.3 Data Exposure
- [ ] Логи не содержат PII или sensitive data
- [ ] API responses не возвращают больше данных, чем нужно
- [ ] Database queries не возвращают sensitive fields без необходимости

## 9. Testing Self-Review

### 9.1 Test Coverage
- [ ] Все новые функции покрыты тестами
- [ ] Запустить coverage: `pytest --cov=. --cov-report=html`
- [ ] Coverage >= 80% для нового кода
- [ ] Критическая логика имеет 100% coverage

### 9.2 Test Quality
- [ ] Тесты следуют AAA паттерну (Arrange-Act-Assert)
- [ ] Тесты независимы друг от друга
- [ ] Тесты имеют понятные имена
- [ ] Используются fixtures для setup/teardown
- [ ] Проверить каждый тест:
  - Понятно ли, что он тестирует?
  - Тестирует ли он одну вещь?
  - Проходит ли тест?

### 9.3 Edge Cases Testing
- [ ] Протестированы граничные случаи
- [ ] Протестирована обработка ошибок
- [ ] Протестирована валидация входных данных
- [ ] Для async кода протестированы timeouts

### 9.4 Test Execution
- [ ] Запустить все тесты: `pytest`
- [ ] Все тесты проходят
- [ ] Нет warnings в тестах
- [ ] Тесты выполняются быстро

## 10. Performance Self-Review

### 10.1 Efficiency Check
- [ ] Нет N+1 queries
- [ ] Нет избыточных API calls
- [ ] Используется кэширование где уместно
- [ ] Batch операции для массовых обработок

### 10.2 Resource Usage
- [ ] Большие данные обрабатываются потоково
- [ ] Используются generators для больших коллекций
- [ ] Memory leaks отсутствуют
- [ ] Connection pooling для database

### 10.3 Async Optimization
- [ ] Параллельные операции выполняются concurrently
- [ ] Нет избыточных `await`
- [ ] Используется `asyncio.gather()` для параллелизма

## 11. Git & Version Control

### 11.1 Commit Quality
- [ ] Коммиты имеют осмысленные сообщения
- [ ] Следуют Conventional Commits
- [ ] История коммитов логична
- [ ] Нет фиксапов (или squashed)

### 11.2 Branch Hygiene
- [ ] Branch name следует конвенции
- [ ] Нет merge conflicts
- [ ] Branch up-to-date с develop

### 11.3 Changed Files Review
- [ ] Просмотреть diff для каждого файла
- [ ] Убедиться, что все изменения связаны с задачей
- [ ] Нет случайных изменений (debug code, formatting)
- [ ] Нет закомментированного кода

## 12. Documentation & Memory Bank

### 12.1 Code Documentation
- [ ] Все public API задокументировано
- [ ] README обновлен (если нужно)
- [ ] API documentation обновлена (если нужно)
- [ ] Примеры использования добавлены

### 12.2 Memory Bank Updates
- [ ] Обновлен **[../tech_stack.md](../tech_stack.md)** (если добавлены зависимости)
- [ ] Создан/обновлен guide в **[../guides/](../guides/)** (если новая подсистема)
- [ ] Создан/обновлен pattern в **[../patterns/](../patterns/)** (если новый паттерн)
- [ ] Обновлен **[../current_tasks.md](../current_tasks.md)** (задача в Done)

### 12.3 Specification Compliance
- [ ] Реализация соответствует спецификации
- [ ] Все acceptance criteria выполнены
- [ ] Отклонения от spec задокументированы

## 13. Automated Checks

### 13.1 Code Quality Tools
```bash
# Запустить все инструменты последовательно
poetry run black .                    # Форматирование
poetry run ruff check .               # Линтинг
poetry run mypy .                     # Type checking
```

**Checklist:**
- [ ] Black прошел без изменений (или изменения зафиксированы)
- [ ] Ruff не нашел проблем
- [ ] Mypy не нашел type errors

### 13.2 Testing Tools
```bash
# Запустить все тесты с coverage
pytest --cov=. --cov-report=html --cov-report=term

# Для async кода
pytest -v tests/ --asyncio-mode=auto
```

**Checklist:**
- [ ] Все тесты проходят
- [ ] Coverage >= 80%
- [ ] Нет warnings
- [ ] Нет failed tests

### 13.3 Security Scanning (Optional)
```bash
# Проверка зависимостей на уязвимости
poetry show --outdated
pip-audit

# Поиск потенциальных проблем безопасности
bandit -r .
```

**Checklist:**
- [ ] Нет критичных уязвимостей в зависимостях
- [ ] Нет security warnings от bandit

## 14. Специфичные проверки для проекта

### 14.1 Telegram Bot Features
- [ ] Все сообщения на русском языке
- [ ] Help тексты понятны пользователю
- [ ] Graceful error handling
- [ ] correlation_id используется везде
- [ ] User не видит internal errors
- [ ] Протестировано с некорректным вводом

### 14.2 External API Integration
- [ ] Responses обернуты в Pydantic модели
- [ ] Retry mechanism реализован
- [ ] Timeout handling реализован
- [ ] API calls логируются с correlation_id
- [ ] API keys из environment variables

### 14.3 Database Code
- [ ] Используются parameterized queries
- [ ] Transaction management корректный
- [ ] Connection pooling настроен
- [ ] DB operations логируются
- [ ] Indexes созданы для часто запрашиваемых полей

### 14.4 AI/LLM Integration
- [ ] API keys в environment variables
- [ ] Rate limiting реализован
- [ ] Retry mechanism реализован
- [ ] Token usage логируется
- [ ] Fallback механизм реализован
- [ ] User prompts sanitized

## 15. Pull Request Preparation

### 15.1 PR Description
- [ ] Написать понятное описание изменений
- [ ] Включить:
  - **Контекст:** Что и зачем?
  - **Решение:** Как реализовано?
  - **Тестирование:** Как проверить?
  - **Скриншоты:** (если применимо)

### 15.2 PR Checklist
- [ ] Все файлы reviewed
- [ ] Все automated checks прошли
- [ ] Все acceptance criteria выполнены
- [ ] Documentation обновлена
- [ ] Tests написаны и проходят

### 15.3 Self-Review Commit
- [ ] Создать отдельный коммит с исправлениями после self-review
- [ ] Сообщение коммита: `chore: self-review fixes`

## 16. Final Readiness Check

### 16.1 Pre-Merge Checklist
- [ ] Все тесты проходят
- [ ] Все linters проходят
- [ ] Code coverage >= 80%
- [ ] Документация обновлена
- [ ] Memory Bank обновлен
- [ ] Нет TODO комментариев (или они в issues)
- [ ] Нет debug code
- [ ] Нет закомментированного кода

### 16.2 Quality Gates
- [ ] Код готов к production
- [ ] Нет known bugs
- [ ] Нет security issues
- [ ] Performance acceptable
- [ ] Backwards compatible (или breaking changes документированы)

### 16.3 Confidence Check
- [ ] Уверен в качестве кода
- [ ] Готов защитить технические решения
- [ ] Понимаю возможные риски
- [ ] Готов к code review

## 17. Continuous Improvement

### 17.1 Learning from Self-Review
- [ ] Записать найденные проблемы
- [ ] Понять, почему они возникли
- [ ] Как предотвратить в будущем?
- [ ] Обновить свои практики

### 17.2 Patterns Recognition
- [ ] Есть ли повторяющиеся проблемы?
- [ ] Нужно ли обновить **[../guides/coding_standards.md](../guides/coding_standards.md)**?
- [ ] Нужно ли создать новый pattern в **[../patterns/](../patterns/)**?
- [ ] Можно ли автоматизировать проверку?

## Self-Review Score Card

После завершения self-review, оцените готовность по каждой категории:

```markdown
## Self-Review Score

- [ ] ✅ Functional Completeness (100%)
- [ ] ✅ Code Quality (100%)
- [ ] ✅ Architecture Compliance (100%)
- [ ] ✅ Type Safety (100%)
- [ ] ✅ Async Code Quality (100%)
- [ ] ✅ Error Handling (100%)
- [ ] ✅ Security (100%)
- [ ] ✅ Testing (Coverage: __%)
- [ ] ✅ Performance (100%)
- [ ] ✅ Documentation (100%)

### Found Issues:
1. [Issue 1 - Status: Fixed/Documented/Tracked in issue]
2. [Issue 2 - Status: Fixed/Documented/Tracked in issue]

### Overall Readiness: [Ready/Needs Work]
```

## Шаблон Self-Review Comment

Добавить в PR как первый комментарий:

```markdown
## Self-Review Completed ✅

### Checks Performed:
- ✅ All acceptance criteria met
- ✅ Code quality tools passed (Black, Ruff, mypy)
- ✅ All tests passing (Coverage: __%)
- ✅ Security review completed
- ✅ Documentation updated
- ✅ Memory Bank updated

### Changes Made During Self-Review:
- [Change 1]
- [Change 2]

### Known Limitations:
- [Limitation 1 - tracked in issue #XX]

### Ready for Code Review
Code is ready for peer review. All self-review criteria have been met.
```

## Заключение

Self-Review - это не просто формальность, а критически важный этап, который:
- Улучшает качество вашего кода
- Экономит время команды
- Развивает ваши навыки
- Предотвращает проблемы в production

**Помните:** Время, потраченное на качественный self-review, многократно окупается экономией времени на code review iterations и исправлении bugs в production.

**Best Practice:** Проводите self-review на следующий день после завершения работы - свежий взгляд помогает найти больше проблем.
