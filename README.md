# Palazzo AI

AI-first Flutter app for finding new-build apartments in Moscow.

## Stack

- Flutter 3.x + Material Design 3
- Russian UI copy
- `go_router` navigation
- Scoring: **TQS** ball (`scoring_params.json`) — PCQS / BPS / OSAS / LQS from Yandex antifraud model

## Run

```bash
flutter pub get
flutter run
```

## Flow (scaffold)

Splash → Intro → Auth (Telegram / Max stubs) → 3 tabs:

1. **Агент** — chat goal branch, filter widgets, score ball, probability dashboard  
2. **Поиск** — swipe cards + feed  
3. **Сервисы** — tools grid stubs  

Product & DB docs live in the Project Context store (`docs/product-plan.md`, `docs/database-schema.md`).
