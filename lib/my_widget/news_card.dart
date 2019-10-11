import 'package:flutter/material.dart';
import 'package:ithome_lite/pages/news_detail.dart';
import 'package:ithome_lite/state/state_container.dart';

class NewsCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final int newsid;

  const NewsCard({Key key, this.image, this.title, this.date, this.newsid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: state.activedTheme.theme['borderBottom']),
          ),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 96,
              height: 72,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(4.0),
                ),
                child: Image.network(image),
              ),
            ),
            SizedBox(width: 16),
            Column(
              children: <Widget>[
                Container(
                  width: 210,
                  height: 48,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(color: state.activedTheme.theme['fontColor']),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 210,
                  height: 24,
                  alignment: Alignment.bottomRight,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xff999999),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => NewsDetail(
              newsid: newsid,
              title: title,
            ),
          ),
        );
      },
    );
  }
}
