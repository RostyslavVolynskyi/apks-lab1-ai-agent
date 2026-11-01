# Архітектура AI-агента

## Які проблеми вирішує агент

Агент `build-engineer` автоматизує створення кросплатформного TypeScript
Hello World-проєкту для варіанта 6. Він розділяє початкову структуру,
налаштування npm/TypeScript/Vitest, CI та фінальну перевірку, щоб повторні
запуски не дублювали файли або конфігурацію.

Агент також готує запускний результат `hello`, юніт-тест `BasicAddition` і
GitHub Actions workflow для Windows, Linux та macOS.

## Skills

| Skill | Відповідальність | Основні результати |
|---|---|---|
| `project-scaffold` | Початкова структура TypeScript-проєкту | `src/`, `tests/`, `docs/`, `src/hello.ts`, `README.md`, `.gitignore` |
| `build-and-test` | Складання, npm scripts і Vitest | `package.json`, `tsconfig.json`, `vitest.config.ts`, `src/math.ts`, `tests/math.test.ts` |
| `github-actions` | Кросплатформний CI | `ci.sh`, `ci.bat`, `.gitattributes`, `.github/workflows/ci.yml` |

Skills не дублюють відповідальність один одного: наступний етап працює
після успішного попереднього.

## Commands

Prompt-команди агента лежать у `.github/prompts/` у форматі Copilot
prompt-файлів (`*.prompt.md`):

- `git-init` — перевіряє Git-репозиторій і створює або оновлює `.gitignore`
  без дублювання записів;
- `create-project` — запускає `project-scaffold` для TypeScript і переданої
  назви проєкту;
- `create-build` — запускає `build-and-test`;
- `create-actions` — запускає `github-actions`;
- `check` — лише читає файли та запускає дозволені build/test/start-перевірки;
- `init-agent` — оркеструє весь сценарій.

Оркестратор названо `init-agent`, бо `/init` є вбудованою командою VS Code.
Його запускають через `/init-agent` у Copilot Chat або через
`Ctrl+Shift+P` → `Chat: Run Prompt` → `init-agent`.

## Дані між етапами

`init-agent` передає кожному наступному кроку статус, створені файли та
діагностику попереднього кроку. Послідовність фіксована:

```text
git-init → create-project → create-build → create-actions → check
```

`project-scaffold` передає `build-and-test` готові `src/hello.ts`, каталоги,
README і `.gitignore`. `build-and-test` передає `github-actions` робочі
`npm run build`, `npm test` і `npm start`. `github-actions` передає `check`
CI-скрипти та workflow для перевірки.

## Обробка помилок оркестратором

Перед запуском `init-agent` перевіряє доступність Git, Node.js і npm. Після
помилки будь-якого кроку оркестратор негайно зупиняється, повідомляє номер
кроку, причину та які наступні кроки не запускалися.

Робота не вважається успішною без PASS від `check`. `check` виводить PASS або
FAIL для кожної перевірки й загальний FAIL, якщо хоча б одна перевірка
провалена. Повторний запуск не перезаписує файли та не дублює конфігурацію.

## Відповідність файлів ролям

| Файли | Роль |
|---|---|
| `.github/agents/build-engineer.agent.md` | Manifest ролі, обмежень, skills, commands і критеріїв завершення |
| `.github/skills/project-scaffold/SKILL.md` | Інструкції початкової структури |
| `.github/skills/build-and-test/SKILL.md` | Інструкції npm, TypeScript, Vitest і тесту |
| `.github/skills/github-actions/SKILL.md` | Інструкції CI-скриптів і workflow |
| `.github/prompts/*.prompt.md` | Команди Copilot для окремих етапів і оркестрації |
| `src/hello.ts` | Hello World, який компілюється в `dist/hello.js` |
| `src/math.ts`, `tests/math.test.ts` | Функція `add` і тест `BasicAddition` |
| `package.json`, `tsconfig.json`, `vitest.config.ts` | npm scripts і конфігурація build/test |
| `ci.sh`, `ci.bat`, `.github/workflows/ci.yml` | Локальний і GitHub Actions CI |
| `docs/usage.md`, `docs/architecture.md` | Користувацька та архітектурна документація |

## Обмеження

- Для TypeScript Hello World запускний результат — `dist/hello.js`, а не
  `.exe`.
- `bash ci.sh` на Windows перевіряється через Git Bash; у звичайному
  Windows PowerShell команда `bash` може бути недоступною.
- `ci.bat` викликає кожну npm-команду через `call` і перевіряє код
  завершення.
- `npm audit` повідомляє про вразливості dev-залежностей, встановлених для
  TypeScript і Vitest; це повідомлення не є результатом тесту або збірки.
- CI workflow запускає build і тести всередині `ci.sh` або `ci.bat`, а не
  окремими npm-командами в YAML.
