import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import 'news_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("News App")),
      body: newsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: newsProvider.news.length,
              itemBuilder: (context, index) {
                final article = newsProvider.news[index];
                return ListTile(
                  leading: Image.network(article['urlToImage'] ?? ""),
                  title: Text(article['title']),
                  subtitle: Text(article['description'] ?? ""),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewsDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
