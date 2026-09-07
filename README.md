# Pixabay Explorer

A Flutter application that searches and browses images from the
[Pixabay API](https://pixabay.com/api/docs/), built with **Clean
Architecture** and **GetX** (state management, dependency injection,
and routing).

## Features

- Debounced live search against Pixabay's `/api/` endpoint
- Infinite-scroll pagination
- Pull-to-refresh
- Image detail screen (author, views, downloads, likes, tags) with a
  shared Hero transition
- Explicit loading / error / empty states, with retry
- Light & dark themes, Material 3

## Architecture

The project follows Clean Architecture with three strictly separated
layers, each depending only inward (`presentation -> domain <- data`):

```
lib/
├── app/                     # App shell: routes, theme, global bindings
│   ├── routes/
│   ├── theme/
│   ├── app.dart
│   └── app_binding.dart
├── core/                    # Cross-cutting, framework-ish concerns
│   ├── constants/
│   ├── error/               # Failure (domain-facing) & Exception (data-facing)
│   ├── network/             # ApiClient (Dio wrapper), NetworkInfo
│   ├── utils/
│   └── widgets/             # Shared Loading/Error/Empty views
├── domain/                  # Pure Dart, zero Flutter/Dio/JSON imports
│   ├── entities/
│   ├── repositories/        # Abstract contracts only
│   └── usecases/
├── data/                    # Implements domain contracts
│   ├── models/              # JSON <-> Entity mapping
│   ├── datasources/         # Talks to ApiClient
│   └── repositories/        # Implements domain/repositories, maps
│                             # exceptions -> Failures
└── presentation/            # GetX controllers, pages, feature widgets
    ├── home/
    │   ├── bindings/
    │   ├── controllers/
    │   ├── pages/
    │   └── widgets/
    └── image_detail/
        ├── bindings/
        ├── controllers/
        └── pages/
```

**Why it's structured this way**

- **`domain/`** never imports Flutter, Dio, or `dart:convert`. It only
  knows about `Either<Failure, T>` (via `dartz`) and plain Dart
  entities — this is what makes use cases unit-testable with a mocked
  repository, no widget/HTTP setup required (see `test/`).
- **`data/`** owns every Pixabay-specific JSON key name. If Pixabay
  changes their API, only `data/models` and `data/datasources` change.
- **Failures vs. Exceptions**: the data layer throws typed
  `Exception`s (`ServerException`, `NetworkException`, ...); the
  repository catches them and returns typed `Failure`s. The
  presentation layer only ever sees `Failure`, never Dio internals.
- **GetX bindings** are feature-scoped (`HomeBinding`,
  `ImageDetailBinding`) and lazily construct the full dependency chain
  (data source → repository → use case → controller) only when that
  route is visited. Shared singletons (connectivity) live in the
  top-level `AppBinding`.

## Getting started

### 1. Get a free Pixabay API key

Sign up at <https://pixabay.com/api/docs/> and copy your key.

### 2. Configure the environment

```bash
cp .env.example .env
# then edit .env and paste your key:
# PIXABAY_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run

```bash
flutter run
```

### 5. Run tests

```bash
flutter test
```

## Key packages

| Package               | Purpose                                   |
|------------------------|--------------------------------------------|
| `get`                  | State management, DI, routing              |
| `dio`                  | HTTP client                                |
| `dartz`                | `Either<Failure, T>` functional error type |
| `equatable`            | Value equality for entities/models         |
| `flutter_dotenv`       | API key configuration via `.env`           |
| `cached_network_image` | Image loading/caching                      |
| `get_storage`          | Lightweight local persistence              |
| `connectivity_plus`    | Connectivity checks for `NetworkInfo`      |
| `mocktail`             | Mocking in unit tests                      |

## Extending the app

Adding a new feature (e.g. "Favorites") means:

1. Add an entity/params in `domain/entities` if needed.
2. Add the method to `domain/repositories/*.dart` and implement it in
   `data/repositories/*.dart`.
3. Add a `UseCase` in `domain/usecases`.
4. Add a controller + binding + page under `presentation/<feature>/`.
5. Register the route in `app/routes/app_pages.dart`.

Each step touches exactly one layer, which is the main payoff of this
structure as the app grows.
