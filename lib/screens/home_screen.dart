import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/news_provider.dart';
import '../providers/theme_provider.dart';
import '../models/article.dart';
import 'news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _refreshController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    await context.read<NewsProvider>().fetchNews(refresh: true);
    _refreshController.refreshCompleted();
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(message),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onRefresh,
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (article.description != null) ...[
              SizedBox(height: 8),
              Text(
                article.description!,
                style: TextStyle(fontSize: 14),
              ),
            ],
            SizedBox(height: 8),
            if (article.urlToImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
            Text(
              'Source: ${article.source}',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News App',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          newsProvider.clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  newsProvider.searchNews(value);
                }
              },
            ),
          ),
          Expanded(
            child: newsProvider.error != null
                ? _buildErrorWidget(newsProvider.error!)
                : SmartRefresher(
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: newsProvider.isLoading && newsProvider.news.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : newsProvider.news.isEmpty
                            ? Center(child: Text('No news found'))
                            : ListView.builder(
                                itemCount: newsProvider.news.length,
                                itemBuilder: (context, index) {
                                  return _buildNewsItem(newsProvider.news[index]);
                                },
                              ),
                  ),
          ),
        ],
      ),
    );
  }
} 