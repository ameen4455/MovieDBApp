# MovieDBApp

An iOS application built with SwiftUI that lets users browse popular movies and search for movies using The Movie Database (TMDB) API.

---

## Demo

[Click here to view the video demo on Google Drive](https://drive.google.com/file/d/1-OCiDbAF8CZECj1GDeJ9ySwF-vkU3w6O/view?usp=drive_link)

---

## Getting Started

### Setup Instructions

1. Clone the repository:
   ```bash
   git clone https://github.com/ameen4455/MovieDBApp.git
   ```

2. Open the project in Xcode:
   ```bash
   open MovieDBApp.xcodeproj
   ```

3. TMDB API Key Setup:
   - Visit the [TMDB API Documentation](https://developer.themoviedb.org/docs/authentication) and generate an API v4 access token.
   - Open `Info.plist`
   - Add or update the TMDB_API_KEY entry as follows:
     ```
     Key: TMDB_API_KEY
     Type: String
     Value: YOUR_TMDB_API_KEY
     ```

4. Build and run the app on a simulator or device.

---

## Architecture Overview

This project follows the MVVM (Model-View-ViewModel) architecture using SwiftUI.

- **Model**: Codable structs representing data from the TMDB API.
- **ViewModel**: Manages state and business logic, exposes observable properties.
- **View**: SwiftUI views that bind to the ViewModels.

### Dependency Injection

A `DependencyContainer` is used to inject app dependencies such as:

- `MovieManager`: Handles network calls to TMDB
- `FavouriteManager`: Stores favorites locally using `UserDefaults`

This approach enables testable and modular code.

```swift
let container = DependencyContainer.live() // for production
let container = DependencyContainer.mock() // for ui tests
```

SwiftUI views access dependencies via a custom `EnvironmentKey`.

---

## Features

- Browse popular movies from TMDB
- Search movies by name using TMDB's search endpoint
- Mark movies as favorites
- Store favorites using UserDefaults
- Pagination support for both popular and search results
- Search experience with debounce and loading indicators
- Testable architecture using protocol-based dependencies
- Unit and UI tests using mocked services

---

## Running Tests

To run all tests:

1. Open `MovieDBApp.xcodeproj` in Xcode.
2. Select the `MovieDBApp` scheme.
3. Press `Command + U` or go to **Product > Test**.

Tests use the mock dependency container to ensure isolated and reliable test cases.

---

## Notes

- `UserDefaults` is used instead of more advanced persistence options like CoreData.
- The TMDB API key is stored in Info.plist. Please add your own key to run the project successfully.
- Movie search is implemented using the TMDB API endpoint, not by simply filtering local results.
