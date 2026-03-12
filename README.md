CineScope

CineScope is an iOS movie exploration application built with SwiftUI.
It connects to The Movie Database (TMDB) API to fetch real-time movie data, allows users to search films, save favorites, watch trailers, and participate in an interactive “Scene Battle” feature.

⸻

Overview

CineScope demonstrates API integration, Swift concurrency, MVVM architecture, and interactive UI design. The application retrieves live movie data from TMDB and presents it in a responsive grid layout with detailed movie views.

⸻

Core Features

Trending Movies
	•	Fetches trending movies from the TMDB API
	•	Displays posters in a responsive grid
	•	Allows navigation to a detailed movie screen

Search Functionality
	•	Real-time search using TMDB search endpoint
	•	Async networking using Swift concurrency
	•	Loading and error state handling

Favorites
	•	Users can mark movies as favorites
	•	Favorites are stored locally in memory
	•	Visual heart indicator reflects saved state

Trailer Integration
	•	Fetches YouTube trailer key from TMDB
	•	Opens trailer via YouTube link
	•	Trailer loads asynchronously per movie

Scene Battle (Interactive Feature)
	•	Randomly selects two movies
	•	User votes for a winner
	•	Generates new battle pairs dynamically

⸻

Technical Stack
	•	SwiftUI
	•	MVVM Architecture
	•	Async/Await Concurrency
	•	URLSession Networking
	•	TMDB REST API
	•	Git and GitHub for version control

⸻

Architecture

CineScope follows a structured MVVM design:

Models
	•	Movie
	•	MovieResponse
	•	VideoResponse

Services
	•	TMDBService
	•	Fetch trending movies
	•	Search movies
	•	Fetch trailer videos

ViewModels
	•	MovieViewModel
	•	Manages application state
	•	Coordinates networking
	•	Handles search and favorites logic

Views
	•	ContentView
	•	MovieDetailView
	•	BattleView
	•	YouTubeView

⸻

API Integration

This project uses The Movie Database (TMDB) API.

Endpoints implemented:
	•	Trending movies
	•	Search movies
	•	Movie videos (trailers)

Networking is implemented using async/await with proper error handling and HTTP response validation.

⸻

Concurrency
	•	Async/await for network requests
	•	UI updates performed on MainActor
	•	Loading and error states handled explicitly
	•	No blocking calls on the main thread
  
⸻

Installation
	1.	Clone the repository:
  git clone https://github.com/jimz17/CINESCOPE.git

	2.	Open the project in Xcode
	3.	Build and run on an iOS simulator

⸻

Project Objectives

This project demonstrates:
	•	Integration with a real external API
	•	Use of modern Swift concurrency
	•	Clean separation of concerns using MVVM
	•	Interactive UI feature design
	•	Proper Git version control workflow

⸻

Author

Jimmy Aguilar
University of Southern California
IDSN 599
