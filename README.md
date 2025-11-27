# MovieFlix

MovieFlix is an iOS app built using **SwiftUI** that allows users to search for movies, view details, and save favorites. It follows the **MVVM architecture** for a clean separation of concerns, with a robust network layer and offline storage.
                                                                                    
---

## **Architecture & Design**

- **MVVM Pattern**: Separation of UI (Views), business logic (ViewModels), and data layer (Models) for better testability and maintainability.
- **Network Layer**:
  - Protocol-oriented design for easy mocking and unit testing.
  - Routers for API requests, improving reusability and scalability.
- **Core Data**:
  - Stores previously searched movies and favorite movies.
  - Enables offline access to movie data.

---

## **Features**

- Search for movies using the TMDB API.
- View movie details including overview, rating, and poster image.
- Save and remove favorite movies.
- Infinite scroll/pagination for large search results.
- Offline storage for recent searches and favorites.
- SwiftUI UI/UX with responsive layout and smooth animations.

---

## **Tech Stack**

- **Language:** Swift
- **Framework:** SwiftUI
- **Persistence:** Core Data
- **Networking:** URLSession + Protocol-oriented design
- **Image Loading:** Kingfisher

---

## **Setup**

1. Clone the repository:
2. Open MovieFlix.xcodeproj in Xcode.
3. Run the app on a simulator or device.

---
                                                                                    
Notes / Compatibility

This app has been developed and tested on iOS 26. Some features, such as the favorite list badge count on the navigation bar, may not appear correctly on older iOS versions like iOS 18 due to differences in SwiftUI APIs. Other functionalities, including search, movie details, and offline storage with Core Data, work as expected across supported versions.
