import 'package:flutter/material.dart';
import '../services/news_service.dart';
import '../models/article.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService = NewsService();
  List<Article> _news = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  List<Article> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  Future<void> fetchNews({bool refresh = false}) async {
    if (!refresh && _isLoading) return;
    
    _isLoading = true;
    _error = null;
    if (refresh) _news = [];
    notifyListeners();

    try {
      _news = await _newsService.fetchNews(
        query: _searchQuery.isNotEmpty ? _searchQuery : null
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      _news = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchNews(String query) async {
    _searchQuery = query;
    await fetchNews(refresh: true);
  }

  void clearSearch() {
    _searchQuery = '';
    fetchNews(refresh: true);
  }
}
