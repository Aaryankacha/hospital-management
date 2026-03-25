import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:src/shared/custom_style.dart';

// 1. Fetch function with secure HTTPS and error handling
Future<NewsData> fetchNewsData() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=1fbee980d10644bca6e4c3243034c10a'));

  if (response.statusCode == 200) {
    return NewsData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Healthcare News Data');
  }
}

// 2. Data Models with Null-Safe logic
class NewsData {
  final String? status;
  final int? totalResults;
  final List<News>? articles;

  const NewsData({this.status, this.totalResults, this.articles});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: (json['articles'] as List?)
          ?.map((value) => News.fromJson(value))
          .toList(),
    );
  }
}

class News {
  final String? author;
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? publishedAt;
  final String? content;

  News({
    this.author,
    this.title,
    this.description,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }
}

// 3. Main Widget with proper State Management
class MDNews extends StatefulWidget {
  MDNews({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MDNewsState createState() => _MDNewsState();
}

class _MDNewsState extends State<MDNews> {
  late Future<NewsData> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Healthcare News'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: FutureBuilder<NewsData>(
              future: futureNews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  final articles = snapshot.data?.articles ?? [];
                  return Column(
                    children: [
                      SizedBox(
                        height: 600.0,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: articles.length,
                          itemBuilder: (context, index) =>
                              _buildListItem(context, articles[index]),
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                return const Text("No News Available at the moment.");
              },
            ),
          ),
        ],
      ),
    );
  }

  // 4. Improved List Item UI
  Widget _buildListItem(BuildContext context, News item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          isThreeLine: true,
          title: Text(
            item.title ?? "Healthcare Update",
            style: cBodyText.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 4),
              Text(item.description ??
                  "No description available for this update."),
              const SizedBox(height: 8),
              if (item.urlToImage != null && item.urlToImage!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.urlToImage!,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.author ?? "Medical Staff", style: cBodyText),
                  Text(item.publishedAt?.split('T')[0] ?? "", style: cBodyText),
                ],
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
