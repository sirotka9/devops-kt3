# devops-kt3

Минимальное приложение на Node.js без Express и других зависимостей приложения.

- `GET /` — строка `KT3 App`.
- `GET /health` — JSON `{ "status": "ok" }`.

## Первичная настройка

```bash
bash setup.sh
```

Скрипт устанавливает npm-зависимости, создаёт package-lock.json, запускает ESLint и два Jest-теста, инициализирует Git, создаёт публичный GitHub-репозиторий devops-kt3, публикует main и develop и включает обязательные проверки lint и test для main. Если npm или gh отсутствуют, устанавливает их через Homebrew. Для входа в GitHub следуйте подсказкам gh auth login. Git должен быть установлен и настроен (user.name и user.email).

## Локальный запуск

```bash
npm ci
npm start
```

Открыть http://localhost:3000 или http://localhost:3000/health.

```bash
npm run lint
npm test
```

## Docker

После первичной настройки:

```bash
docker build -t devops-kt3 .
docker run --rm -p 3000:3000 devops-kt3
```

## CI/CD

На push и pull_request в main и develop: lint → test. В test запускается PostgreSQL, а npm test получает DB_HOST, DB_PORT, DB_NAME, DB_USER и DB_PASSWORD. Юнит-тесты проверяют маршруты в изоляции, поэтому к БД не подключаются.

Только push в main запускает build-and-push: Docker-образ публикуется в ghcr.io/<владелец>/devops-kt3 с тегами latest и полным хэшем коммита. Авторизация использует встроенный GITHUB_TOKEN: дополнительные secrets не нужны. Результат запуска находится во вкладке Actions.

Автоматический деплой на сервер заданием не предусмотрен: пайплайн заканчивается публикацией образа.
