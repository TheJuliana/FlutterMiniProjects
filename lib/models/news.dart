class News {
  final String author;
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String content;
  News({
    required this.author,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      author: json['author'] ?? 'Unknown author',
      title: json['title'] ?? 'Unknown title',
      description: json['description'] ?? 'Unknown description',
      urlToImage: json['urlToImage'] ?? 'https://cdn-icons-png.flaticon.com/512/1042/1042680.png',
      publishedAt: json['publishedAt'] ?? 'Unknown publishedAt',
      content: json['content'] ?? 'Unknown content',
    );
  }
}