# News App

A Flutter news application that fetches and displays news articles from NewsAPI.

## Features

- Clean and minimalistic UI
- Display news articles with thumbnails, titles, and descriptions
- Detailed view for each article
- Search functionality
- Pull-to-refresh support
- Dark mode support
- Error handling and loading states
- Cached images for better performance

## Setup Instructions

1. Clone the repository:
```bash
git clone <repository-url>
cd news-app
```

2. Create a `.env` file in the root directory and add your NewsAPI key:
```
NEWS_API_KEY=your_api_key_here
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Dependencies

- flutter_dotenv: For environment variables
- provider: For state management
- http: For API calls
- cached_network_image: For image caching
- pull_to_refresh: For pull-to-refresh functionality

## Project Structure

```
lib/
├── models/
│   └── article.dart
├── providers/
│   ├── news_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── home_screen.dart
│   └── news_detail_screen.dart
├── services/
│   └── news_service.dart
└── main.dart
```

## API Integration

The app uses the NewsAPI (https://newsapi.org/) to fetch news articles. You'll need to sign up for a free API key.

## Error Handling

The app includes proper error handling for:
- API errors
- Network issues
- Image loading errors
- Empty states

## Contributing

Feel free to submit issues and enhancement requests! 