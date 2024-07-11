import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:times_news/const/model/news_model.dart';

import '../const/color_const.dart';

class DetailScreen extends StatefulWidget {
  final NewsModel newsModel;

  DetailScreen({super.key, required this.newsModel});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ColorConst.foregroundColor,
        backgroundColor:  ColorConst.appBar,
        title: const Text('Detail Screen' ,style: TextStyle(
          color: Colors.white,
        ),),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            widget.newsModel.title!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '- ${widget.newsModel.author!}',
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Image.network(widget.newsModel.urlToImage!),
          const SizedBox(height: 10),
          Text(
            widget.newsModel.content!,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
