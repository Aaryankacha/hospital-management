import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:src/shared/custom_style.dart';

// 1. Fetch function with basic error handling
Future<NewsData> fetchNewsData() async {
  final response = await http.get(Uri.parse(
      'http://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=1fbee980d10644bca6e4c3243034c10a'));

  if (response.statusCode == 200) {
    return NewsData.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Medical News Data');
  }
}

// 2. Data Models with safe JSON parsing
class NewsData {
  final String? status;
  final int? totalResults;
  final List<News>? articles;

  const NewsData({this.status, this.totalResults, this.articles});

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      status: json['status'],
      totalResults: json['totalResults'],
      // Safe casting to List? prevents crashes if 'articles' is missing or null
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

// 3. Main Widget with Safe FutureBuilder
class BussNews extends StatefulWidget {
  BussNews({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _BussNewsState createState() => _BussNewsState();
}

class _BussNewsState extends State<BussNews> {
  late Future<NewsData> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: FutureBuilder<NewsData>(
            future: futureNews,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Safeguard against null articles list
                final articlesList = snapshot.data?.articles ?? [];

                return Column(
                  children: [
                    SizedBox(
                      height: 600.0, // Adjusted for better layout
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: articlesList.length,
                        itemBuilder: (context, index) {
                          return _buildListItem(context, articlesList[index]);
                        },
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
              return const CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }

  // 4. Clean & Safe UI Builder
  Widget _buildListItem(BuildContext context, News item) {
    return Card(
      // Changed to Card for a cleaner medical dashboard look
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        isThreeLine: true,
        title: Text(
          item.title ?? "No Title Available",
          style: cBodyText.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 4),
            Text(item.description ?? "No description provided."),
            const SizedBox(height: 8),

            // Safe Image Loading
            if (item.urlToImage != null && item.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.urlToImage!,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                ),
              ),

            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.author ?? "Staff", style: cBodyText),
                Text(item.publishedAt?.split('T')[0] ?? "", style: cBodyText),
              ],
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
