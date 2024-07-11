import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:times_news/const/model/news_model.dart';

class ApiService {
  List<NewsModel> dataStore = [];

  Future<void> getNews() async {
    Uri url = Uri.parse(
      "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=9f5b9b7361cd4dc4a05b2b53dfcf6b12",
    );

    try {
      http.Response response = await http.get(url);
      var jsonData = jsonDecode(response.body);
      if (jsonData['status'] == 'ok') {
        List articles = jsonData['articles'];

        articles.forEach((element) {
          if (element['urlToImage'] != null &&
              element['description'] != null &&
              element['author'] != null &&
              element['content'] != null) {
            NewsModel newsModel = NewsModel(
              title: element['title'],
              urlToImage: element['urlToImage'],
              description: element['description'],
              author: element['author'],
              content: element['content'], url: null,
            );

            dataStore.add(newsModel);
          }
        });
      } else {
        print('API Error: ${jsonData['message']}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}

