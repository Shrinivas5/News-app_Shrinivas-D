class Article {
  final String title;
  final String? description;
  final String? urlToImage;
  final String? content;
  final String url;
  final String publishedAt;
  final String? author;
  final String source;

  Article({
    required this.title,
    this.description,
    this.urlToImage,
    this.content,
    required this.url,
    required this.publishedAt,
    this.author,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'],
      urlToImage: json['urlToImage'],
      content: json['content'],
      url: json['url'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      author: json['author'],
      source: json['source']['name'] ?? '',
    );
  }
} 