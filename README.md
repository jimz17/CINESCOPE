# CineScope

CineScope is an iOS movie exploration app built with SwiftUI using an MVVM architecture.  
It integrates the TMDB API for movie data and Supabase for backend services.

## Features

- Browse trending movies
- Search movies by title
- View detailed movie information and trailers
- Save bookmarks (user-specific, persisted via Supabase)
- Post and view public comments on movies
- Scene Battle feature for comparing movies

## Architecture

- Models: Data structures and API responses
- ViewModels: State management and business logic
- Views: SwiftUI UI components and screens
- Services: Networking (TMDB) and backend (Supabase)

## Backend (Project 3c)

- Authentication using Supabase (email login)
- Bookmarks stored per user (Row Level Security enabled)
- Public comments stored in Supabase and visible to all users
- User data is isolated and scoped per session

## Running the App

1. Open `CINESCOPE.xcodeproj` in Xcode
2. Run on an iOS simulator
3. Sign up or log in to access backend features
