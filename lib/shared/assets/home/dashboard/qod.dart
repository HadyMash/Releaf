import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class QuoteOfTheDay extends StatelessWidget {
  const QuoteOfTheDay({Key? key}) : super(key: key);

  Future<QODData> getQOD() async {
    var response =
        await http.get(Uri.parse('https://quotes.rest/qod?language=en'));

    Map data = jsonDecode(response.body);

    var qod = QODData(
      quote: data['contents']['quotes'][0]['quote'],
      author: data['contents']['quotes'][0]['author'],
    );

    return qod;
  }

  @override
  Widget build(BuildContext context) {
    final QODData? quoteData = Provider.of<QODData?>(context);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.19),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quote of The Day',
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
              shadows: [
                Shadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.13),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
          Text(
            quoteData != null ? quoteData.quote : '',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(height: 1.5, letterSpacing: -0.2),
          ),
          SizedBox(height: 5),
          Text(
            '- ${quoteData != null ? quoteData.author : ''}',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(height: 1.5, letterSpacing: -0.2),
          ),
        ],
      ),
    );
  }
}

class QODData {
  final String quote;
  final String author;
  const QODData({required this.quote, required this.author});
}
