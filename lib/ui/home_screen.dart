import 'package:flutter/material.dart';
import 'package:times_news/const/color_const.dart';
import 'package:times_news/services/api_service.dart';
import 'package:times_news/ui/detail_screens.dart';

import '../const/model/news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsModel> articles = [];
  List<NewsModel> favoriteArticles = [];
  List<CategoryModel> categories = [];
  bool isLoading = true;

  void getNews() async {
    ApiService apiService = ApiService();
    await apiService.getNews();
    setState(() {
      articles = apiService.dataStore;
      isLoading = false;
    });
  }

  void toggleFavorite(NewsModel article) {
    setState(() {
      if (favoriteArticles.contains(article)) {
        favoriteArticles.remove(article);
      } else {
        favoriteArticles.add(article);
      }
    });
  }

  @override
  void initState() {
    getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.appBar,
        title: const Center(
          child: Text(
            'Times News',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteScreen(
                    favoriteArticles: favoriteArticles,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  const SizedBox(height: 20),
                  ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final article = articles[index];
                      final isFavorite = favoriteArticles.contains(article);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(newsModel: article),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  article.urlToImage ?? '',
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                article.title ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color:
                                          isFavorite ? Colors.red : Colors.grey,
                                    ),
                                    onPressed: () => toggleFavorite(article),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 2),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
class FavoriteScreen extends StatefulWidget {
  final List<NewsModel> favoriteArticles;

  FavoriteScreen({required this.favoriteArticles});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  void deleteFavorite(int index) {
    setState(() {
      widget.favoriteArticles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        title: const Text('Favorites', style: TextStyle(
          color: Colors.white,

        ),),
      ),
      body: ListView.builder(
        itemCount: widget.favoriteArticles.length,
        itemBuilder: (context, index) {
          final article = widget.favoriteArticles[index];
          return Dismissible(
            key: Key(article.title!),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              color: Colors.red,
            ),
            onDismissed: (direction) {
              deleteFavorite(index);
            },
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(newsModel: article),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            article.urlToImage ?? '',
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              deleteFavorite(index);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      article.title ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(thickness: 2),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
