
# FlicksHub

## Overview

**FlicksHub** is a mobile application designed to offer users an engaging and personalized way to explore and discover movies. With features such as advanced search, curated playlists, and real-time synchronization, FlicksHub provides a comprehensive platform for movie enthusiasts. The app leverages TheMovieDB API for detailed movie data and Firebase for user authentication and cloud storage.

## Demo

https://github.com/user-attachments/assets/e871cfb0-2d9e-44e2-a404-5f22346e95dd


---

## Features

### **1. Movie Search**
- **Dynamic Listings**: Get the best rated movies, trending, upcoming and now playing.
- **Infinite Scroll**: Load more movies as you scroll through the list.

### **2. Advanced Search Filters**
- **Search Bar**: Quickly find movies by title.
- **Year Filter**: Choose a specific release year.
- **Genre Filter**: Select one or multiple genres (e.g., Action, Comedy, Drama).
- **Rating Filter**: Set a minimum rating (e.g., above 7.0) to filter movies with high reviews.

### **3. Detailed Movie Information**
- View comprehensive details, including:
  - Title, synopsis, and cover image.
  - Duration and release date.
  - Average rating and total votes.
- **Playlist Integration**: Add movies to favorites or customized playlists with a single tap.

### **4. Personalized User Profile**
- Editable profile details:
  - Username
  - Profile picture
- Display profile information in the "Profile" tab.

### **5. Favorites**
- Create and manage playlists of favorite movies.
- Features include:
  - Dynamic playlist naming and renaming.
  - Remove movies from the playlist with a left swipe.
  - Delete playlists with a left swipe and confirm.
- **Real-Time Sync**: Save playlists and favorites to the cloud using Firebase.

### **6. User Authentication**
- **Registration**: Create an account with email and password.
- **Login**: Access personalized features.
- **Logout**: Log out from the app via the profile tab.

---

## External Resources

- **TheMovieDB API**: Provides detailed movie data.
- **Firebase**: Supports user authentication and stores user data, including:
  - Registration, login, and logout functionality.
  - Storage of user favorites in the cloud.
  - Storage of user playlists and their associated movies.

---

## Setup Instructions

### **1. Prerequisites**
- Ensure you have Xcode installed on your macOS.
- Install SwiftUI dependencies via Xcode.

### **2. API Key Setup**
- Obtain an API key from [TheMovieDB](https://www.themoviedb.org/documentation/api).
- Add the API key to your project configuration file.

### **3. Firebase Setup**
- Set up a Firebase project.
- Download the `GoogleService-Info.plist` file from Firebase.
- Add the file to your Xcode project.

### **4. Running the App**
    1. Open the project in Xcode.
    2. Build and run the app on a simulator or a connected iOS device.

---

## Mockups

- Mockups for the app are available on [Figma](https://www.figma.com/design/mW2BqfGzo9EF17z6dAPfvd/FlicksApp?node-id=0-1&t=mDZKGVf0tapxhc8u-1).

---

## Contributing

    1. Fork the repository.
    2. Create a new branch (`git checkout -b feature-name`).
    3. Commit your changes (`git commit -m "Add feature"`).
    4. Push to the branch (`git push origin feature-name`).
    5. Create a Pull Request.

---

## Contact

For any questions, suggestions, or support, please contact me!
