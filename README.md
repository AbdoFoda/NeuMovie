# Movie App

## Overview
This project is a Swift-based iOS application that fetches and displays movie details using The Movie Database (TMDb) API. It supports features such as fetching latest movies, prefetching images for smooth scrolling, and an autocomplete search feature.

## Features
- **Fetch Latest Movies**: Retrieves the latest movies using TMDb API.
- **Movie Details View**: Displays movie poster, title, release date, rating, and overview.
- **Image Prefetching**: Optimizes user experience by preloading images.
- **Search with Auto-Complete**: Implements real-time search suggestions.

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/yourusername/MovieApp.git
   cd MovieApp
   ```
2. Install dependencies using CocoaPods or Swift Package Manager (SPM) if required.
3. Open `MovieApp.xcodeproj` in Xcode.
4. Build and run the app on a simulator or a physical device.

## Configuration
To access the TMDb API, add your API key in the `APIConstants.swift` file:
```swift
struct APIConstants {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "YOUR_API_KEY"
}
```

## Architecture
- **MVVM (Model-View-ViewModel)**: Ensures a modular and testable structure.
- **Networking Layer**: Handles API requests and responses using `NetworkManager`.
- **ViewModels**: Manage the business logic and UI data.
- **Views**: SwiftUI-based components for a seamless user experience.

## Testing
Unit tests are included for the `LatestMoviesViewModel` and other core components.
Run tests using:
```sh
Cmd + U (in Xcode)
```
### Example Test Case
```swift
func testLoadMoreMovies_Success() {
    let response = NowPlayingResponse(page: 1, results: MovieMockData.sampleMovies, totalPages: 1, totalResults: 50)
    mockNetworkService.mockResult = .success(response)
    
    let expectation = self.expectation(description: "Loading movies should complete")
    
    viewModel.loadMoreMovies { error in
        XCTAssertNil(error)
        expectation.fulfill()
    }
    
    waitForExpectations(timeout: 5, handler: nil)
    XCTAssertEqual(viewModel.moviesToDisplay.count, MovieMockData.sampleMovies.count)
}
```

## Contributing
1. Fork the repository.
2. Create a new branch: `git checkout -b feature-branch`
3. Commit your changes: `git commit -m "Added new feature"`
4. Push to the branch: `git push origin feature-branch`
5. Submit a pull request.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
Made with ❤️ by Your Name.
