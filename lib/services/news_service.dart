import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static String get _apiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  static const String _baseUrl = "https://newsapi.org/v2";

  Future<List<Article>> fetchNews({String? query}) async {
    try {
      final String url = query != null
          ? "$_baseUrl/everything?q=$query&apiKey=$_apiKey"
          : "$_baseUrl/top-headlines?country=us&apiKey=$_apiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .toList();
        return articles;
      } else {
        throw Exception("Failed to load news: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching news: ${e.toString()}");
    }
  }
}
