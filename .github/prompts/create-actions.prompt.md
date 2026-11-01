---
description: "Створити кросплатформний CI через skill github-actions"
agent: "build-engineer"
---

# create-actions

## Призначення

Викликати skill `github-actions` для створення кросплатформних CI-скриптів
і workflow GitHub Actions.

## Передумови

- Команду `create-build` виконано успішно.
- Працюють `npm run build` і `npm test`.
- Доступні `npm start` і результат запуску містить `Hello World`.
- Існують npm scripts `build`, `test` і `start`.
- Доступний skill `github-actions`.

## Дії

1. Перевір усі передумови командами `npm run build`, `npm test` і `npm start`.
2. Якщо вони успішні, виклич skill `github-actions`.
3. Дозволь йому створити `ci.sh`, `ci.bat`, `.gitattributes` і
   `.github/workflows/ci.yml`.
4. Перевір matrix для Linux, Windows і macOS, тригери `push` і
   `pull_request` для `develop` та `master`, а також завантаження `dist/`.
5. Перевір, що вся збірка й тести запускаються зі скриптів, без секретів і
   токенів у workflow.

Не змінюй структуру проєкту, npm scripts, вихідний код або тести.

## Очікувані файли

```text
ci.sh
ci.bat
.gitattributes
.github/workflows/ci.yml
```

`ci.bat` викликає кожну npm-команду через `call` і перевіряє
`%ERRORLEVEL%`; Windows-крок workflow має `shell: cmd`.

## Команди перевірки

```text
npm run build
npm test
npm start
```

Додатково перевір YAML, три matrix-ОС, відсутність секретів, виклики build і
test у `ci.sh` та `ci.bat`, а також правила `.gitattributes`:
`*.sh text eol=lf` і `*.bat text eol=crlf`.

## Повідомлення про помилку

- Якщо `create-build` не виконано або передумови не підтверджені, виведи:
  `ПОМИЛКА КРОКУ 1: спочатку успішно виконайте create-build і перевірте npm-команди.`
  Зупинись до виклику skill.
- Якщо `npm run build` або `npm test` падає, виведи:
  `ПОМИЛКА КРОКУ 1: передумовна npm-команда завершилася з помилкою.`
  Зупинись і наведи точну команду та діагностику.
- Якщо YAML невалідний або містить секрет, виведи:
  `ПОМИЛКА КРОКУ 4: workflow має помилку конфігурації або секрет.`
  Зупинись і не вважай CI готовим.

## Ідемпотентність

Повторний запуск дотримується правил `github-actions`: наявні скрипти,
`.gitattributes` і workflow не перезаписуються, а triggers, matrix-цілі,
кроки та правила закінчень рядків не дублюються. Конфлікти лише
повідомляються.
