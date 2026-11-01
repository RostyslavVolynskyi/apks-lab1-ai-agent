---
description: "Створити базову структуру TypeScript Hello World через skill project-scaffold"
agent: "build-engineer"
---

# create-project

## Призначення

Викликати skill `project-scaffold` для створення мінімальної структури
TypeScript Hello World проєкту.

## Передумови

- Робочий каталог визначено.
- Користувач надав назву проєкту або готовий її надати.
- Мова проєкту — TypeScript.
- `project-scaffold` доступний.

## Дії

1. Запитай назву проєкту, якщо її не передано.
2. Перевір, що назва непорожня.
3. Передай мову `TypeScript` і назву проєкту до skill
   `project-scaffold`.
4. Дозволь skill створити лише `src/`, `tests/`, `docs/`, `src/hello.ts`,
   `README.md` і початковий `.gitignore`.
5. Перевір результат згідно з вимогами `project-scaffold`.

Не створюй `package.json`, `tsconfig.json`, `vitest.config.ts`, npm scripts
або CI-файли: це відповідальність наступних skills.

## Очікувані файли

```text
src/
  hello.ts
tests/
docs/
README.md
.gitignore
```

`src/hello.ts` має виводити `Hello World`, а `README.md` — містити команду
`npm start` і згадку про skill `build-and-test`.

## Команди перевірки

```text
Перевірити наявність src/hello.ts, tests/, docs/, README.md і .gitignore.
Перевірити, що src/hello.ts містить Hello World.
```

Повні npm-перевірки виконує `create-build` після цього prompt.

## Повідомлення про помилку

- Якщо назва не надана або порожня, виведи:
  `ПОМИЛКА КРОКУ 1: потрібна непорожня назва проєкту.`
  Зупинись до виклику skill.
- Якщо мова не TypeScript, виведи:
  `ПОМИЛКА КРОКУ 3: підтримується лише TypeScript.`
  Зупинись.
- Якщо базовий файл уже має несумісний вміст, виведи:
  `ПОМИЛКА КРОКУ 4: конфлікт у <шлях>; project-scaffold не перезаписує файл.`
  Зупинись і повідом деталі.

## Ідемпотентність

Повторний запуск викликає ідемпотентні правила `project-scaffold`: наявні
файли не перезаписуються, каталоги не видаляються, а вміст і записи не
дублюються.
