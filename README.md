# Swift Code Review Automation

Автоматическая проверка Swift проектов через GitHub Actions с запуском по API.

---

## 🚀 API Endpoints для запуска проверок

### 1. Code Review (быстрый, ~90 сек)

Проверяет стиль кода и утечки памяти без компиляции проекта.

```bash
POST https://api.github.com/repos/{OWNER}/{REPO}/dispatches

Headers:
  Authorization: Bearer {GITHUB_TOKEN}
  Accept: application/vnd.github+json
  X-GitHub-Api-Version: 2022-11-28

Body:
{
  "event_type": "code-review"
}
```

**cURL:**
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/dispatches \
  -d '{"event_type":"code-review"}'
```

---

### 2. Build Check (медленный, ~3-5 мин)

Компилирует проект для iOS Simulator.

```bash
POST https://api.github.com/repos/{OWNER}/{REPO}/dispatches

Headers:
  Authorization: Bearer {GITHUB_TOKEN}
  Accept: application/vnd.github+json
  X-GitHub-Api-Version: 2022-11-28

Body:
{
  "event_type": "build-check"
}
```

**cURL:**
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/OWNER/REPO/dispatches \
  -d '{"event_type":"build-check"}'
```

---

## 📊 Получение результатов

Результаты отправляются POST запросом на ваш backend.

### Настройка webhook:

1. Откройте: `https://github.com/{OWNER}/{REPO}/settings/secrets/actions`
2. Добавьте secrets:
   - **BACKEND_URL** - URL вашего backend для получения результатов
   - **BACKEND_TOKEN** - токен авторизации (опционально)

### Формат результатов Code Review:

```json
{
  "repository": "owner/repo",
  "branch": "main",
  "commit": "abc123",
  "author": "username",
  "timestamp": "2025-11-24T12:00:00Z",
  "reports": {
    "style": {
      "summary": {"errors": 1, "warnings": 5, "infos": 0}
    },
    "memory": {
      "summary": {"errors": 0, "warnings": 2, "infos": 0}
    }
  }
}
```

### Формат результатов Build Check:

```json
{
  "repository": "owner/repo",
  "branch": "main",
  "commit": "abc123",
  "build_status": "success"
}
```

---

## 🔑 Получение GitHub Token

1. https://github.com/settings/tokens
2. Generate new token (classic)
3. Выберите права: **repo** (все подпункты)
4. Скопируйте токен (начинается с `ghp_...`)

---

## 📝 Параметры

Замените в URL:
- `{OWNER}` - владелец репозитория (например: `myorg`)
- `{REPO}` - название репозитория (например: `apptesterV2`)
- `{GITHUB_TOKEN}` - Personal Access Token

---

## ✅ Что проверяется

**Code Review (~90 сек):**
- 🎨 Стиль кода (SwiftLint)
- 💾 Утечки памяти (статический анализ)
- 🗑️ Мертвый код (отключен - требует компиляции)

**Build Check (~3-5 мин):**
- 🔨 Компиляция проекта

---

## 🧪 Тестирование

Подробная инструкция в файле: **READY_TO_USE.txt**

Локальное тестирование:
```bash
# Настройте test-triggers.sh с вашим токеном
./trigger-workflows.sh
```

---

## 📄 Дополнительные файлы

- **READY_TO_USE.txt** - готовые примеры для вашего репозитория
- **test-triggers.sh** - скрипт для локального тестирования

---

**Успешный HTTP ответ:** `204 No Content`

**Ошибки:**
- `401` - неверный токен
- `404` - репозиторий не найден
- `422` - неверный формат запроса
