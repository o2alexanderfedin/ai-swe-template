# Claude Code Configuration for Due Diligence Bot

## При начале ЛЮБОЙ рабочей сессии

**ОБЯЗАТЕЛЬНО** выполни следующие действия:

1. Прочитай файл **`.memory_bank/README.md`** полностью.
2. Следуй инструкциям по обязательной последовательности чтения из этого файла:
   - **[Технический стек](.memory_bank/tech_stack.md)**: Узнай, какие технологии, библиотеки и версии мы используем
   - **[Стандарты кодирования](.memory_bank/guides/coding_standards.md)**: Правила форматирования, именования и лучшие практики
   - **[Текущие задачи](.memory_bank/current_tasks.md)**: Список активных задач и текущий фокус команды
3. Перейди по ссылкам на релевантные документы в зависимости от типа задачи:
   - Для новой фичи → изучи спецификацию в `.memory_bank/specs/`
   - Для бага → изучи workflow `.memory_bank/workflows/bug_fix.md`
   - Для вопросов по технологиям → проверь `.memory_bank/tech_stack.md`

---

## О проекте: Due Diligence Bot

**Due Diligence Bot** - это интеллектуальный Telegram-бот для автоматизированной комплексной проверки (due diligence) компаний и проектов.

### Ключевые особенности проекта:

#### 1. Архитектура бота на Python
- Используем **Python 3.11+** с полной типизацией
- **Telegram Bot Framework**: aiogram или python-telegram-bot
- **Асинхронная архитектура**: все I/O операции через async/await
- Обработчики команд и callback queries в модуле `bot/`

#### 2. AI/LLM Integration
- **OpenAI API (GPT-4)** для анализа и генерации отчетов
- **LangChain** для оркестрации AI-агентов
- Все LLM вызовы должны быть обернуты в retry механизмы
- Использовать structured outputs для парсинга ответов LLM

#### 3. Async/Await Patterns
**КРИТИЧЕСКИ ВАЖНО:**
- Все I/O операции (HTTP requests, database queries, file operations) ДОЛЖНЫ быть асинхронными
- Используй `async def` и `await` для всех функций с I/O
- Для HTTP запросов используй **httpx**, НЕ requests
- Для database queries используй async drivers (asyncpg для PostgreSQL)
- **ЗАПРЕЩЕНО** блокировать event loop синхронными вызовами

Пример правильного подхода:
```python
import httpx
from typing import Dict, Any

async def fetch_company_data(company_id: str) -> Dict[str, Any]:
    """Асинхронная загрузка данных о компании."""
    async with httpx.AsyncClient() as client:
        response = await client.get(f"https://api.example.com/companies/{company_id}")
        response.raise_for_status()
        return response.json()
```

#### 4. External API Integrations
Все внешние интеграции должны:
- Находиться в модуле `integrations/`
- Иметь четкий интерфейс (Pydantic models для request/response)
- Включать обработку ошибок согласно `.memory_bank/patterns/error_handling.md`
- Использовать retry механизмы для нестабильных API
- Иметь fallback стратегии при недоступности сервиса
- Логировать все запросы для отладки

Пример структуры интеграции:
```python
# integrations/company_registry.py
from typing import Optional
from pydantic import BaseModel
import httpx

class CompanyInfo(BaseModel):
    """Модель данных о компании."""
    name: str
    inn: str
    registration_date: str
    status: str

class CompanyRegistryClient:
    """Клиент для работы с реестром компаний."""

    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://api.example.com"

    async def get_company(self, inn: str) -> Optional[CompanyInfo]:
        """Получить информацию о компании по ИНН."""
        async with httpx.AsyncClient() as client:
            response = await client.get(
                f"{self.base_url}/companies/{inn}",
                headers={"Authorization": f"Bearer {self.api_key}"}
            )
            if response.status_code == 404:
                return None
            response.raise_for_status()
            return CompanyInfo(**response.json())
```

#### 5. Telegram Bot Patterns
**При работе с Telegram ботом:**
- Используй handlers для команд (`/start`, `/help`, `/check`)
- Используй callback_query handlers для inline кнопок
- Используй FSM (Finite State Machine) для сложных диалогов
- Обрабатывай ошибки gracefully - всегда отправляй понятное сообщение пользователю
- Используй typing indicators (`send_chat_action`) для длительных операций
- Ограничивай размер сообщений (Telegram limit: 4096 символов)

Пример handler:
```python
from aiogram import Router, types
from aiogram.filters import Command

router = Router()

@router.message(Command("check"))
async def handle_check_command(message: types.Message) -> None:
    """Обработчик команды /check для запуска проверки."""
    await message.answer("Отправляю запрос на проверку...")
    # Логика обработки
```

#### 6. Data Processing & Storage
- **PostgreSQL** для хранения структурированных данных (компании, отчеты, пользователи)
- **Redis** для кэширования и очередей задач
- Все database models должны быть в `data/models.py`
- Используй миграции (Alembic) для изменений схемы БД
- Валидация данных через Pydantic перед сохранением

---

## Принцип самодокументирования

**ВАЖНО**: Ты не только читаешь из Memory Bank, но и **обновляешь его**.

При выполнении задач ты ДОЛЖЕН:
- Обновлять статус в `.memory_bank/current_tasks.md` (To Do → In Progress → Done)
- Создавать/обновлять документацию в `.memory_bank/guides/` при реализации новых подсистем
- Обновлять `.memory_bank/tech_stack.md` при добавлении новых зависимостей
- Создавать новые паттерны в `.memory_bank/patterns/` при принятии архитектурных решений
- Добавлять спецификации в `.memory_bank/specs/` для новых фич

---

## Workflow Selection: Выбор правильного процесса

Перед началом любой задачи определи её тип и выбери соответствующий workflow:

### 1. Новая функция (Feature)
**Когда использовать**: Добавление новой возможности в бота
**Workflow**: `.memory_bank/workflows/new_feature.md`
**Примеры**:
- Добавление новой команды бота
- Интеграция с новым внешним API
- Создание нового типа отчета

### 2. Исправление бага (Bug Fix)
**Когда использовать**: Что-то работает не так, как ожидается
**Workflow**: `.memory_bank/workflows/bug_fix.md`
**Примеры**:
- Бот не отвечает на команду
- Ошибка при обработке данных
- Неправильная логика в существующей функции

### 3. Code Review
**Когда использовать**: Проверка качества кода перед merge
**Workflow**: `.memory_bank/workflows/code_review.md`
**Что проверять**:
- Соответствие coding standards
- Правильное использование async/await
- Обработка ошибок
- Type hints
- Тесты

---

## Запрещенные действия

**НИКОГДА** не делай следующее:

1. **Не добавляй новые зависимости** без обновления `.memory_bank/tech_stack.md`
2. **Не нарушай паттерны** из `.memory_bank/patterns/`
3. **Не изобретай заново** то, что уже существует в проекте
4. **Не используй `Any`** в type hints - всегда указывай конкретные типы
5. **Не делай синхронные I/O** в асинхронном коде
6. **Не храни секреты** в коде - только через environment variables
7. **Не пиши SQL вручную** - используй ORM или параметризованные запросы
8. **Не игнорируй ошибки** через пустые `except` блоки

---

## Обязательные проверки перед началом работы

Перед написанием кода ВСЕГДА проверь:

1. **Технический стек** (`.memory_bank/tech_stack.md`):
   - Какие библиотеки разрешены для этой задачи?
   - Какие практики запрещены?

2. **Существующие компоненты**:
   - Может ли эта функциональность уже существовать?
   - Какие модули можно переиспользовать?

3. **Паттерны** (`.memory_bank/patterns/`):
   - Как правильно обрабатывать ошибки в этом проекте?
   - Какие API стандарты использовать?

4. **Текущие задачи** (`.memory_bank/current_tasks.md`):
   - Не конфликтует ли моя задача с другими?
   - Нужно ли обновить статус?

---

## При потере контекста

Если ты чувствуешь, что контекст был потерян или сжат:

1. Используй команду `/refresh_context` (если доступна)
2. Перечитай `.memory_bank/README.md`
3. Изучи последние коммиты для понимания текущего состояния:
   ```bash
   git log --oneline -10
   ```
4. Проверь текущий статус проекта:
   ```bash
   git status
   ```

---

## Type Safety Requirements

Все функции ДОЛЖНЫ иметь полные type hints:

```python
from typing import Dict, List, Optional, Any
from pydantic import BaseModel

# ПРАВИЛЬНО
async def process_company(
    company_id: str,
    include_details: bool = False
) -> Dict[str, Any]:
    """Обработка данных компании."""
    ...

# НЕПРАВИЛЬНО (отсутствуют type hints)
async def process_company(company_id, include_details=False):
    ...
```

---

## Testing Requirements

Для каждой новой функции ты ДОЛЖЕН:
1. Написать unit тесты в `tests/`
2. Использовать `pytest` и `pytest-asyncio`
3. Покрытие кода минимум 80%
4. Тестировать edge cases и error handling

Пример теста:
```python
import pytest
from unittest.mock import AsyncMock

@pytest.mark.asyncio
async def test_fetch_company_data():
    """Тест получения данных о компании."""
    # Arrange
    company_id = "test_123"

    # Act
    result = await fetch_company_data(company_id)

    # Assert
    assert result is not None
    assert "name" in result
```

---

## Error Handling Requirements

Все внешние вызовы должны иметь обработку ошибок:

```python
import logging
from typing import Optional

logger = logging.getLogger(__name__)

async def safe_api_call(url: str) -> Optional[dict]:
    """Безопасный вызов внешнего API."""
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(url, timeout=10.0)
            response.raise_for_status()
            return response.json()
    except httpx.HTTPError as e:
        logger.error(f"HTTP error calling {url}: {e}")
        return None
    except Exception as e:
        logger.exception(f"Unexpected error calling {url}: {e}")
        return None
```

---

## Logging Standards

- Используй `logging` module, НЕ `print()`
- Уровни логирования:
  - `DEBUG`: Детальная информация для отладки
  - `INFO`: Общая информация о работе
  - `WARNING`: Предупреждения (что-то не так, но работает)
  - `ERROR`: Ошибки (функциональность нарушена)
  - `CRITICAL`: Критические ошибки (система не может работать)
- Всегда включай контекст в лог-сообщения

```python
logger.info(f"Processing company {company_id}, user {user_id}")
logger.error(f"Failed to fetch data for {company_id}: {error}")
```

---

## Environment Configuration

Все конфигурационные параметры должны быть в `.env` файле:

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    """Настройки приложения."""
    telegram_bot_token: str
    openai_api_key: str
    database_url: str
    redis_url: str

    class Config:
        env_file = ".env"

settings = Settings()
```

**НИКОГДА** не коммить `.env` файл в git!

---

## Git Workflow

1. **Именование веток**:
   - `feature/add-company-search` - новая функция
   - `bugfix/fix-telegram-handler` - исправление бага
   - `docs/update-readme` - документация

2. **Commit messages** (Conventional Commits):
   - `feat: add company search endpoint`
   - `fix: handle timeout in API calls`
   - `docs: update API documentation`
   - `refactor: simplify error handling`
   - `test: add tests for company service`

3. **Перед коммитом**:
   - Запусти тесты: `pytest`
   - Проверь форматирование: `black .`
   - Проверь типы: `mypy .`
   - Проверь линтинг: `ruff check .`

---

## Performance Considerations

1. **Используй connection pooling** для database и HTTP clients
2. **Кэшируй** частые запросы в Redis
3. **Используй batch operations** где возможно
4. **Ограничивай concurrent requests** к внешним API
5. **Используй indices** в database queries

---

**Помни**: Memory Bank - это единый источник истины. Доверяй ему больше, чем своим предположениям.

**Главный принцип**: Если не уверен - спроси у пользователя или перечитай документацию в Memory Bank.
