# Лабораторна робота №1: AI-агент для автоматизації розробки та CI/CD

- **ПІБ:** Волинський Ростислав Андрійович
- **Група:** КІ-405
- **Варіант:** 6 (TypeScript, npm scripts, Vitest)

## Опис
Спеціалізований AI-агент `build-engineer` для генерації, складання,
тестування та перевірки кросплатформного TypeScript-проєкту Hello World.
Проєкт використовує npm scripts, Vitest і GitHub Actions для Windows, Linux
та macOS.

## Запуск агента

У VS Code відкрий Copilot Chat у режимі Agent і виконай:

```text
/init-agent
Назва проєкту: apks-lab1-hello
Мова: TypeScript
```

Альтернативно відкрий `Ctrl+Shift+P` → `Chat: Run Prompt` →
`init-agent`. Оркестратор запускає `git-init`, `create-project`,
`create-build`, `create-actions` і `check` послідовно.

## Проєкт Hello World

Назва проєкту: `apks-lab1-hello`

Після налаштування npm scripts skill `build-and-test` доступні команди:

```bash
npm install
npm run build
npm test
npm start
```

`npm run build` створює JavaScript у `dist/`, `npm test` запускає тест
`BasicAddition`, а `npm start` виводить `Hello World`.

Детальні команди наведено в [docs/usage.md](docs/usage.md), а опис етапів
агента — у [docs/architecture.md](docs/architecture.md).