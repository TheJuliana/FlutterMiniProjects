import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/news.dart';
import 'news_profile.dart';


class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NewsPage(),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
   final List<News> _newsList = [];

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<List<News>> _fetchNews() async {
      String apiKey = 'ENTER_YOUR_API_KEY';

      DateTime now = DateTime.now();
      DateTime twoMonthsEarlier = DateTime(now.year, now.month - 1, now.day);
      String formattedDate = DateFormat('yyyy-MM-dd').format(twoMonthsEarlier);


      final response = await http.get(Uri.parse('https://newsapi.org/v2/everything?q=tesla&from=$formattedDate&sortBy=publishedAt&apiKey=$apiKey'));

      final jsonData = json.decode(response.body);
      print(jsonData);
      if (jsonData['status'] == 'ok') {
        final List<dynamic> articles = jsonData['articles'];
        // Очищаем список перед добавлением новых элементов
        _newsList.clear();

        return articles.map((jsonItem) => News.fromJson(jsonItem)).toList();
      } else {
        throw Exception('Error: unable to load news');
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent News'),
      ),
      body: FutureBuilder<List<News>> (
        future: _fetchNews(),
        builder: (BuildContext context, AsyncSnapshot<List<News>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  News news = snapshot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewsDetailScreen(news: news,)));
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            news.urlToImage,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              // Если загрузка изображения по URL не удалась, используется запасное изображение
                              return Image.asset('../assets/images/news.png');
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              news.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              news.description,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('ERROR: ${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        
      ),
    );
  }
    /*body: FutureBuilder<List<News>>(
    future: _fetchNews(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: _newsList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        NewsDetailScreen(
                          news: _newsList[index], // Передаем данные новости
                        ),
                  ),
                );
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    Image.network(_newsList[index].urlToImage),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _newsList[index].title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_newsList[index].content),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
    );
  }*/
}