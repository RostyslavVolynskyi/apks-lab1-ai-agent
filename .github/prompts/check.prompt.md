---
description: "Перевірити повноту TypeScript-проєкту, збірку, тести, запуск, CI та відсутність артефактів у Git"
agent: "build-engineer"
---

# check

## Призначення

Виконати повну read-only перевірку проєкту build-engineer і вивести PASS або
FAIL для кожної перевірки та загальний результат.

## Передумови

- Поточний каталог є коренем Git-репозиторію.
- Доступні Node.js, npm і Git.
- Файли проєкту доступні для читання.
- Перевірка не має змінювати проєкт або стан Git.

## Дії

1. Прочитай manifest
   `[build-engineer.agent.md](../agents/build-engineer.agent.md)` і перевір
   наявність ролі, обмежень і критеріїв завершення.
2. Знайди кожен skill build-engineer та перевір, що він має розділи
   призначення, входів/передумов, виходів/очікуваних файлів і перевірок.
3. Перевір наявність усіх командних prompt-файлів: `git-init`,
   `create-project`, `create-build`, `create-actions`, `check`, `init`.
4. Перевір структуру проєкту: `src/`, `tests/`, `docs/`, `src/hello.ts`,
   `src/math.ts`, `tests/math.test.ts`, `README.md`, `.gitignore`,
   `package.json`, `tsconfig.json`, `vitest.config.ts`, `ci.sh`, `ci.bat`,
   `.gitattributes` і `.github/workflows/ci.yml`. Перевір, що
   `.gitattributes` містить `*.sh text eol=lf` та `*.bat text eol=crlf`.
5. Перевір npm scripts `build`, `test` і `start`.
6. Запусти `npm run build`, потім `npm test` і `npm start`; переконайся, що
   `BasicAddition` проходить, а запуск виводить `Hello World`.
7. Перевір валідність `.github/workflows/ci.yml`, наявність matrix із
   `ubuntu-latest`, `windows-latest` і `macos-latest`, потрібних тригерів і
   CI-кроків. Переконайся, що workflow лише викликає `ci.sh`/`ci.bat` і не
   містить команд `npm install`, `npm run build` або `npm test` напряму.
   Перевір, що Windows-крок має `shell: cmd`.
8. Перевір, що `.gitignore` містить рівно по одному запису для кожного з:
   `node_modules/`, `dist/`, `build/`, `.env`, `*.log`, `logs/`.
9. Перевір, що `.github/prompts/init.prompt.md` містить кроки в порядку:
   `git-init`, `create-project`, `create-build`, `create-actions`, `check`.
10. Прочитай `git ls-files` і перевір, що tracked-файли не містять
    `node_modules/`, `dist/`, `build/` або секретів/токенів.
11. Для кожної перевірки виведи окремий статус `PASS` або `FAIL`.
12. Виведи загальний `PASS` лише якщо всі перевірки пройшли; якщо хоча б одна
    має `FAIL`, загальний результат — `FAIL`.

Не створюй, не редагуй і не видаляй файли. Не виконуй Git-операцій, що
змінюють стан, зокрема commit, reset, clean, push або зміну індексу.
Артефакти `dist/` і `node_modules/`, створені дозволеними npm-командами,
ігноруються Git і не є змінами проєкту.

## Очікувані файли

```text
.github/agents/build-engineer.agent.md
.github/skills/project-scaffold/SKILL.md
.github/skills/build-and-test/SKILL.md
.github/skills/github-actions/SKILL.md
.github/prompts/git-init.prompt.md
.github/prompts/create-project.prompt.md
.github/prompts/create-build.prompt.md
.github/prompts/create-actions.prompt.md
.github/prompts/check.prompt.md
.github/prompts/init.prompt.md
ci.sh
ci.bat
.gitattributes
src/hello.ts
src/math.ts
tests/math.test.ts
tests/
docs/
README.md
.gitignore
package.json
tsconfig.json
vitest.config.ts
.github/workflows/ci.yml
```

Фактичний список може містити інші легітимні файли, але перелічені файли та
каталоги мають існувати.

## Команди перевірки

Дозволені команди:

```text
git rev-parse --show-toplevel
git ls-files
npm run build
npm test
npm start
```

Також дозволені read-only перевірки вмісту файлів і YAML. Не запускай
`npm install`, якщо це змінює lock-файл або створює залежності; перевіряй
наявні залежності без модифікації проєкту. Перевір також `.gitignore`,
`.gitattributes`, структуру workflow та порядок кроків у `init.prompt.md`.

## Повідомлення про помилку

- На кроці 1: `ПОМИЛКА КРОКУ 1: відсутній або неповний manifest агента.`
- На кроці 2: `ПОМИЛКА КРОКУ 2: skill <шлях> не має обов'язкового розділу.`
- На кроці 3: `ПОМИЛКА КРОКУ 3: відсутня команда <назва>.`
- На кроці 4: `ПОМИЛКА КРОКУ 4: відсутній файл або каталог <шлях>.`
- На кроці 5: `ПОМИЛКА КРОКУ 5: відсутній npm script <назва>.`
- На кроці 6: `ПОМИЛКА КРОКУ 6: команда <команда> завершилася з помилкою.`
- На кроці 7: `ПОМИЛКА КРОКУ 7: workflow невалідний, має зайві npm-команди або не містить потрібної ОС/shell.`
- На кроці 8: `ПОМИЛКА КРОКУ 8: .gitignore неповний або містить дублікати записів.`
- На кроці 9: `ПОМИЛКА КРОКУ 9: init.prompt.md має неправильний порядок кроків.`
- На кроці 10: `ПОМИЛКА КРОКУ 10: у Git знайдено артефакт або секрет.`

Для кожної помилки наведи фактичний шлях, команду або діагностику. Не
виправляй помилку в межах `check`; заверш перевірку з загальним `FAIL`.

## Ідемпотентність

Повторний запуск не змінює файли, npm-конфігурацію, lock-файли або Git-стан.
Однаковий стан проєкту дає однакові результати PASS/FAIL, окрім змін,
створених дозволеними командами перевірки.
