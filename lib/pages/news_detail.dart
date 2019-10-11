import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ithome_lite/my_widget/html_view.dart';
import 'package:ithome_lite/state/state_container.dart';
import 'package:ithome_lite/util/api.dart';
import 'package:ithome_lite/util/request.dart';
import 'package:ithome_lite/util/util.dart';

class NewsDetail extends StatelessWidget {
  final int newsid;
  final String title;

  const NewsDetail({Key key, this.newsid, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    final StreamController<String> sc = StreamController();
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder<String>(
            stream: sc.stream,
            initialData: '',
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              return new Text(
                snapshot.data,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              );
            },
          ),
          backgroundColor: state.activedTheme.theme['background'],
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: state.activedTheme.theme['background'],
        body: NewsContent(
          title,
          newsid,
          sc: sc,
        ));
  }
}

class NewsContent extends StatefulWidget {
  final String title;
  final int newsid;
  final StreamController sc;

  NewsContent(this.title, this.newsid, {Key key, this.sc}) : super(key: key);

  _NewsContentState createState() => _NewsContentState(title, newsid, sc);
}

class _NewsContentState extends State<NewsContent> {
  final ScrollController _scrollController = new ScrollController();
  final String title;
  final int newsid;
  final StreamController sc;
  final _request = Request();
  String _postDateTime = '';
  String _source = '';
  String _author = '';
  String _content = '';
  bool _emptyTitle = true;

  _NewsContentState(this.title, this.newsid, this.sc);

  @override
  void initState() {
    super.initState();
    _loadNewsDetail();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 20 && _emptyTitle) {
        sc.sink.add(title);
        _emptyTitle = false;
      } else if (_scrollController.position.pixels < 20 && !_emptyTitle) {
        sc.sink.add('');
        _emptyTitle = true;
      }
    });
  }

  @override
  void dispose() {
    sc.close();
    super.dispose();
  }

  Future<void> _loadNewsDetail() async {
    try {
      final res = await _request.get('${Api.getNewsDetail}/$newsid');
      if (res.statusCode == HttpStatus.ok) {
        if (res.data['success']) {
          final data = res.data;
          setState(() {
            _source = data['newssource'];
            _author = data['newsauthor'];
            _content = data['detail'];
            _postDateTime = '2019-10-10 12:20';
          });
        } else {
          Util.simpleToast('接口数据异常');
        }
      } else {
        Util.simpleToast('网络异常');
      }
    } catch (exception) {
      Util.simpleToast('网络异常');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: _scrollController,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          children: <Widget>[
            Container(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: state.activedTheme.theme['fontColor'],
                ),
                softWrap: true,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 14, bottom: 16),
              child: Text(
                _author.length > 0 ? '$_postDateTime  $_source($_author)' : '',
                style: TextStyle(
                  color: state.activedTheme.theme['fontColor'],
                ),
              ),
            ),
            Container(
              child: HtmlView(
                htmlText: _content,
                color: state.activedTheme.theme['fontColor'],
              ),
            )
          ],
        ),
      ),
    );
  }
}
