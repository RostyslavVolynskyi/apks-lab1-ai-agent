# Використання

## Запуск агента

У VS Code відкрий Copilot Chat у режимі **Agent** і виконай:

```text
/init-agent
Назва проєкту: apks-lab1-hello
Мова: TypeScript
```

Або відкрий `Ctrl+Shift+P` → `Chat: Run Prompt` → `init-agent`.

Оркестратор виконує команди в такому порядку:

```text
git-init
create-project
create-build
create-actions
check
```

Окремі команди агента запускаються як відповідні prompt-файли в
`.github/prompts/`:

- `git-init` — перевіряє Git-репозиторій і готує `.gitignore`;
- `create-project` — викликає skill `project-scaffold`;
- `create-build` — викликає skill `build-and-test`;
- `create-actions` — викликає skill `github-actions`;
- `check` — виконує read-only перевірку проєкту.

## Локальна перевірка

У корені репозиторію виконай:

```bash
npm install
npm run build
npm test
npm start
```

Очікувано `npm test` завершується успішно, а `npm start` виводить:

```text
Hello World
```

Для запуску окремого тестового файла:

```bash
npm test -- tests/math.test.ts
```

## CI-скрипти

На Windows через `cmd`:

```bat
ci.bat
```

На Linux або macOS:

```bash
bash ci.sh
```

Скрипти встановлюють залежності (`npm ci` за наявності
`package-lock.json`, інакше `npm install`), виконують build, тест і запуск.

## Запуск зібраного проєкту

Після `npm run build`:

```bash
node dist/hello.js
```

Очікуваний вивід:

```text
Hello World
```
