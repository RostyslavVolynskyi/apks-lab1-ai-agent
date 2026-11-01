---
description: "Налаштувати складання, npm scripts і Vitest через skill build-and-test"
agent: "build-engineer"
---

# create-build

## Призначення

Викликати skill `build-and-test` для налаштування TypeScript-збірки,
npm scripts і юніт-тесту `BasicAddition`.

## Передумови

- Команду `create-project` виконано успішно.
- Існують `src/hello.ts`, `tests/`, `docs/`, `README.md` і `.gitignore`.
- `src/hello.ts` виводить `Hello World`.
- Доступний skill `build-and-test`.

## Дії

1. Перевір передумови та наявність структури від `create-project`.
2. Виклич skill `build-and-test`.
3. Дозволь йому створити `package.json`, `tsconfig.json`,
   `vitest.config.ts`, `src/math.ts` і `tests/math.test.ts`.
4. Переконайся, що scripts `build`, `start` і `test` налаштовані.
5. Виконай перевірки, визначені skill `build-and-test`.

Не змінюй структуру каталогів, `README.md`, `.gitignore` або
`src/hello.ts`, якщо немає окремого дозволу користувача.

## Очікувані файли

```text
package.json
tsconfig.json
vitest.config.ts
src/math.ts
tests/math.test.ts
```

Збірка має створювати запускний результат `hello` у `dist/`, тест
`BasicAddition` має перевіряти `add(a, b)`.

## Команди перевірки

```text
npm install
npm run build
npm test
npm start
```

Очікується успішна збірка, пройдений `BasicAddition` і виведення
`Hello World` командою `npm start`.

## Повідомлення про помилку

- Якщо передумови не виконані, виведи:
  `ПОМИЛКА КРОКУ 1: спочатку успішно виконайте create-project.`
  Зупинись до виклику skill.
- Якщо збірка падає, виведи:
  `ПОМИЛКА КРОКУ 5: npm run build завершився з помилкою.`
  Зупинись і наведи діагностику.
- Якщо тест падає, виведи:
  `ПОМИЛКА КРОКУ 5: тест BasicAddition не пройшов.`
  Зупинись і не вважай крок успішним.
- Якщо `npm start` не виводить `Hello World`, виведи:
  `ПОМИЛКА КРОКУ 5: npm start не вивів Hello World.`
  Зупинись.

## Ідемпотентність

Повторний запуск дотримується правил `build-and-test`: наявні файли,
scripts, залежності та тести не перезаписуються й не дублюються. Конфлікти
лише повідомляються з точним шляхом і причиною.
