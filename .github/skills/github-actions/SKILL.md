---
name: github-actions
description: "Створення кросплатформного CI для TypeScript Hello World через GitHub Actions, ci.sh і ci.bat. Застосовуй після project-scaffold та build-and-test, коли npm run build, npm test і npm start уже працюють."
---

# GitHub Actions

## Призначення

Цей skill створює кросплатформний CI для проєкту TypeScript, npm scripts і
Vitest. Він працює після `project-scaffold` та `build-and-test` і відповідає
лише за CI-скрипти й workflow GitHub Actions.

Структуру проєкту, `src/hello.ts`, `README.md` і `.gitignore` створює
`project-scaffold`. `package.json`, npm scripts, TypeScript-конфігурацію,
функцію `add` і тести створює `build-and-test`. Не відтворюй і не змінюй
ці файли в межах цього skill.

## Коли застосовувати

Застосовуй skill, коли:

- `project-scaffold` і `build-and-test` уже завершили роботу;
- `npm run build`, `npm test` і `npm start` успішно працюють локально;
- потрібно перевіряти проєкт на Linux, Windows і macOS у GitHub Actions;
- потрібно зберігати результат складання як artifact.

## Вхідні дані

Очікується готовий проєкт, у якому доступні:

```text
package.json
package-lock.json (бажано)
src/
tests/
dist/ (створюється під час build)
```

Перед змінами перевір, що scripts `build`, `test` і `start` визначені в
`package.json`, а локальні команди відповідають вимогам `build-and-test`.
Якщо вони не працюють або відсутні, спочатку виправ проблему через
`build-and-test`.

## Що створюється

Створи лише відсутні файли:

```text
ci.sh
ci.bat
.gitattributes
.github/
  workflows/
    ci.yml
```

### `ci.sh`

Скрипт для Linux і macOS має послідовно виконувати:

1. `npm ci`, якщо наявний `package-lock.json`, або `npm install`, якщо lock-файл
   відсутній;
2. `npm run build`;
3. `npm test`;
4. `npm start`.

Скрипт має зупинятися при першій помилці. Використовуй перевірку коду
завершення, сумісну з POSIX shell, без абсолютних шляхів і без команд,
специфічних для однієї операційної системи.

### `ci.bat`

Скрипт для Windows `cmd` має виконувати ті самі кроки в тому самому порядку.
Кожну npm-команду викликай через `call` (наприклад, `call npm run build`),
оскільки npm у Windows є пакетним файлом; без `call` виконання `ci.bat`
завершується після першої npm-команди. Після кожного `call` перевіряй
`%ERRORLEVEL%` і негайно завершуйся з ненульовим кодом при помилці. Для
наявного `package-lock.json` використовуй `call npm ci`, інакше
`call npm install`.

### `.gitattributes`

Створи файл із правилами нормалізації закінчень рядків:

```gitattributes
*.sh text eol=lf
*.bat text eol=crlf
```

Це запобігає перетворенню `ci.sh` на CRLF-файл, через яке POSIX shell може
не запустити скрипт.

### `.github/workflows/ci.yml`

Workflow має:

- запускатися при `push` і `pull_request` до гілок `develop` і `master`;
- містити одну job із matrix:
  `ubuntu-latest`, `windows-latest`, `macos-latest`;
- мати лише такі кроки:
  1. checkout репозиторію;
  2. налаштування Node.js;
  3. виклик `bash ci.sh` на Linux/macOS або `ci.bat` на Windows із явним
     `shell: cmd`;
  4. завантаження `dist/` як artifact;
- виконувати всю інсталяцію, збірку, тестування і запуск лише всередині
  `ci.sh` або `ci.bat`, а не окремими командами в YAML;
- не містити секретів, токенів або їхніх значень у змінних, аргументах чи
  коментарях.

Для кроку виклику скрипта використовуй умовні `if` для ОС matrix. Назви
artifact мають відрізнятися для різних ОС, щоб результати не перезаписували
один одного.

## Правила ідемпотентності

- Якщо `ci.sh`, `ci.bat`, `.gitattributes` або `ci.yml` уже існує, не
  перезаписуй його.
- Не дублюй workflow-кроки, triggers, matrix-цілі або команди в скриптах.
- Не дублюй правила `*.sh text eol=lf` і `*.bat text eol=crlf` у
  `.gitattributes`.
- Якщо файл уже частково відповідає вимогам, збережи сумісний вміст.
- Конфліктну або несумісну конфігурацію лише повідомляй: вкажи шлях,
  конфлікт і запропонуй точкову зміну.
- Не змінюй `package.json`, `README.md`, `.gitignore`, вихідний код чи тести.
- Повторний запуск не повинен створювати дублікати workflow або CI-команд.

## Перевірки результату

Перевір без зміни файлів:

1. YAML у `.github/workflows/ci.yml` валідний.
2. Workflow реагує на `push` і `pull_request` лише для `develop` та `master`.
3. У matrix є рівно `ubuntu-latest`, `windows-latest` і `macos-latest`.
4. У job є checkout, setup Node.js, виклик відповідного скрипта та
   завантаження `dist/` як artifact.
5. У YAML немає секретів або токенів.
6. `ci.sh` викликає встановлення залежностей, `npm run build`, `npm test` і
   `npm start`, зупиняючись при помилці.
7. `ci.bat` викликає кожну npm-команду через `call` і перевіряє
   `%ERRORLEVEL%` після кожного виклику.
8. `.gitattributes` містить `*.sh text eol=lf` і `*.bat text eol=crlf`.
9. Крок Windows у workflow має явний `shell: cmd`.
10. На Linux/macOS `ci.sh` має право на виконання або workflow викликає його
   явно через `bash ci.sh`.

Фактичний CI-запуск має підтвердити `npm install` або `npm ci`,
`npm run build`, `npm test` і `npm start`. Результат `npm start` має містити
`Hello World`, а artifact має містити `dist/`.

## Приклад

**Вхід:**

Проєкт `cross-platform-hello`, підготовлений двома попередніми skills, у
якому вже працюють `npm run build`, `npm test` і `npm start`.

**Очікуваний результат:**

- створено `ci.sh` для Linux/macOS і `ci.bat` для Windows;
- створено `.gitattributes` із правилами `*.sh text eol=lf` та
  `*.bat text eol=crlf`;
- створено `.github/workflows/ci.yml`;
- workflow запускається для `push` і `pull_request` до `develop` та `master`;
- одна job перевіряє `ubuntu-latest`, `windows-latest` і `macos-latest`;
- Windows викликає `ci.bat` із явним `shell: cmd`;
- збірка, тест і запуск виконуються скриптами;
- `dist/` завантажується окремим artifact для кожної ОС;
- попередні файли та npm scripts не змінені й не продубльовані, а правила
  `.gitattributes` не повторюються.

## Типові помилки

### Невалідний YAML

Перевір відступи, лапки, двокрапки, структуру `on`, `jobs` і matrix.
Виправляй лише синтаксичну або безпосередньо пов’язану помилку, потім
повтори YAML-перевірку. Не додавай паралельні job, якщо потрібна одна job
із matrix.

### `ci.sh` не має права на виконання

Надай файлу executable permission у Git або залиш виклик `bash ci.sh` у
workflow, який не залежить від permission біта. Не замінюй POSIX-скрипт
Windows-командами.

### `ci.sh` не запускається через CRLF

Перевір закінчення рядків і переконайся, що `.gitattributes` містить
`*.sh text eol=lf` та `*.bat text eol=crlf`. Нормалізуй файл через Git,
збережи POSIX LF для `ci.sh` і повтори запуск через `bash ci.sh`.

### Тест падає на одній з операційних систем

Визнач, чи помилка походить від тесту, залежностей, шляху або різниці
середовища. Повідом точну ОС і команду, що впала. Виправляй проблему в
`build-and-test` або вихідному коді, а не приховуй її умовою в CI.

### Відсутній Node.js або npm

Не вважай job успішною. Перевір крок setup Node.js і його версію, а потім
повтори workflow. Не додавай локальні абсолютні шляхи чи ручне встановлення
інструментів у CI-скрипти.

### Файл workflow або скрипт уже існує

Не перезаписуй його і не зливай конфігурації автоматично. Перевір вимоги,
повідом про конфлікт і запропонуй користувачу явно дозволити точкову зміну.
