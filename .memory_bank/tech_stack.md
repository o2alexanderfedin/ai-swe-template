# Технологический стек и конвенции

## Core Stack
- **Backend Framework**: Python 3.11+ (современный, type-safe подход)
- **Bot Framework**: Python Telegram Bot / aiogram (для интеграции с Telegram)
- **AI/LLM Integration**:
  - OpenAI API (GPT-4) для анализа и генерации отчетов
  - LangChain для оркестрации AI-агентов
- **Database**:
  - PostgreSQL для хранения структурированных данных
  - Redis для кэширования и очередей задач
- **Web Scraping**:
  - BeautifulSoup4 / lxml для парсинга
  - Selenium для динамических страниц
- **API Integration**:
  - httpx для асинхронных HTTP-запросов
  - pydantic для валидации данных

## Development Tools
- **Dependency Management**: Poetry
- **Code Quality**:
  - black (форматирование)
  - ruff (линтинг)
  - mypy (type checking)
- **Testing**:
  - pytest для unit и integration тестов
  - pytest-asyncio для асинхронных тестов
- **Environment**: python-dotenv для управления конфигурацией

## Project Structure
```
due_diligence_bot/
├── bot/              # Telegram bot handlers
├── core/             # Business logic
├── integrations/     # External API integrations
├── data/             # Data processing and storage
├── reports/          # Report generation
└── tests/            # Test suite
```

## Запрещенные практики
- Использование `Any` в type hints. Все типы должны быть явно определены
- Синхронные I/O операции в асинхронном коде (блокирование event loop)
- Хранение секретов и API ключей в коде (использовать .env файлы)
- Прямые SQL-запросы без параметризации (SQL injection риск)
- Игнорирование ошибок через `pass` или пустые `except` блоки

## API Конвенции
- Все внешние API-запросы должны проходить через модули в `integrations/`
- Обработка ошибок должна соответствовать схеме, описанной в **[./patterns/error_handling.md](./patterns/error_handling.md)**
- Все API responses должны быть обернуты в Pydantic модели для валидации
- Использовать retry механизмы для нестабильных внешних API

## Coding Standards
- Использовать async/await для всех I/O операций
- Следовать PEP 8 для стиля кода
- Максимальная длина строки: 100 символов
- Использовать type hints для всех функций и методов
- Документировать public API через docstrings (Google style)

## Environment Variables
Обязательные переменные окружения:
- `TELEGRAM_BOT_TOKEN` - токен Telegram бота
- `OPENAI_API_KEY` - ключ для OpenAI API
- `DATABASE_URL` - строка подключения к PostgreSQL
- `REDIS_URL` - строка подключения к Redis

## Version Control
- Использовать semantic versioning (MAJOR.MINOR.PATCH)
- Conventional Commits для сообщений коммитов
- Branch naming: `feature/`, `bugfix/`, `hotfix/`, `docs/`
