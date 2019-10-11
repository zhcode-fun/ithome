import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ithome_lite/my_widget/news_card.dart';
import 'package:ithome_lite/state/enum_theme.dart';
import 'package:ithome_lite/state/state_container.dart';
import 'package:ithome_lite/util/api.dart';
import 'package:ithome_lite/util/request.dart';
import 'package:ithome_lite/util/theme.dart';
import 'package:ithome_lite/util/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    return MaterialApp(
        title: 'IT之家极速版',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: state.activedTheme.theme['background'],
        ),
        home: HomeApp());
  }
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    DateTime lastPopTime;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IT之家',
          style: TextStyle(
            color: state.activedTheme.theme['fontColor'],
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Image.asset(
              state.activedTheme.activedIndex == ActivedThemeIndex.LIGHT
                  ? 'assets/moon_icon.png'
                  : 'assets/sun_icon.png',
              width: 24,
              height: 24,
            ),
            onPressed: () async {
              // var size = MediaQuery.of(context).size;
              // print(size.width);
              final isLight =
                  state.activedTheme.activedIndex == ActivedThemeIndex.LIGHT;
              state.switchTheme(
                  theme: isLight ? MyTheme.NIGHT : MyTheme.LIGHT,
                  index: isLight
                      ? ActivedThemeIndex.NIGHT
                      : ActivedThemeIndex.LIGHT);
              final sp = await SharedPreferences.getInstance();
              sp.setBool('themeIsLight', !isLight);
            },
          ),
        ],
      ),
      backgroundColor: state.activedTheme.theme['background'],
      body: WillPopScope(
        child: NewsListWidget(),
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            Util.simpleToast('再按一次退出');
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          return false;
        },
      ),
      // body: NewsListWidget(),
    );
  }
}

class NewsListWidget extends StatefulWidget {
  NewsListWidget({Key key}) : super(key: key);
  _NewsListWidgetState createState() => _NewsListWidgetState();
}

class _NewsListWidgetState extends State<NewsListWidget> {
  final Request _request = Request();
  List<Map<String, dynamic>> _newsList = [];
  int _lastRefreshTime;
  String _lastPostTime;
  final ScrollController _scrollController = new ScrollController();
  bool _loadingMore = false;
  bool _initLoading = true;

  @override
  void initState() {
    super.initState();
    getNews(init: true);
    _lastRefreshTime = DateTime.now().millisecondsSinceEpoch;
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_loadingMore) {
        setState(() {
          _loadingMore = true;
        });
        await getMoreNews();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = StateContainer.of(context);
    return _initLoading
        ? Container(
            child: SpinKitRing(
              color: Color(0xffff584e),
              lineWidth: 4,
              size: 50,
            ),
          )
        : Container(
            child: RefreshIndicator(
              color: Color(0xffff584e),
              backgroundColor: state.activedTheme.theme['background'],
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _newsList.length + 1,
                itemBuilder: buildNewsItem,
                controller: _scrollController,
              ),
              onRefresh: refreshNews,
            ),
          );
  }

  Future<void> getNews({bool init = false}) async {
    final newsJson = await loadLatestNews();
    if (newsJson[0]['postdate'] == _lastPostTime) {
      Util.simpleToast('当前新闻列表已是最新');
      return;
    }
    _lastPostTime = newsJson[0]['postdate'];
    final newsList = formatNewsData(newsJson);
    setState(() {
      _newsList = newsList;
      if (init) {
        _initLoading = false;
      }
    });
  }

  Future<void> getMoreNews() async {
    final newsJson = await loadMoreNews();
    final newsList = formatNewsData(newsJson);
    setState(() {
      _newsList.addAll(newsList);
      _loadingMore = false;
    });
  }

  List<Map<String, dynamic>> formatNewsData(dynamic newsJson) {
    final newsList = List<Map<String, dynamic>>();
    for (var news in newsJson) {
      if (news['aid'] == null) {
        newsList.add({
          "image": news['image'],
          "title": news['title'],
          "date": Util.formatDateTime(news['postdate']),
          "newsid": news['newsid'],
          "orderdate": news['orderdate']
        });
      }
    }
    return newsList;
  }

  Widget buildNewsItem(BuildContext context, int index) {
    if (index < _newsList.length) {
      return NewsCard(
        image: _newsList[index]['image'],
        title: _newsList[index]['title'],
        date: _newsList[index]['date'],
        newsid: _newsList[index]['newsid'],
      );
    } else {
      return _loadingMore
          ? SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitRing(
                    color: Color(0xffff584e),
                    lineWidth: 2,
                    size: 20,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    '正在加载',
                    style: TextStyle(
                      color: Color(0xff999999),
                    ),
                  )
                ],
              ),
            )
          : null;
    }
  }

  /// 刷新，距上次刷新时间3分钟内不响应刷新
  Future<void> refreshNews() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final isRefresh = (now - _lastRefreshTime >= 180000);
    if (isRefresh) {
      _lastRefreshTime = now;
      await getNews();
    }
  }

  dynamic loadLatestNews() async {
    try {
      final res = await _request.get(Api.getLatestNews);
      if (res.statusCode == HttpStatus.ok) {
        return res.data['newslist'];
      } else {
        Util.simpleToast('网络异常');
      }
    } catch (exception) {
      Util.simpleToast('网络异常');
    }
    return {};
  }

  dynamic loadMoreNews() async {
    final orderdate =
        DateTime.parse(_newsList.last['orderdate']).millisecondsSinceEpoch;
    final nextPageParam = await Util.encryDES(orderdate.toString());
    try {
      final res = await _request.get('${Api.getMoreNews}$nextPageParam');
      if (res.statusCode == HttpStatus.ok) {
        return res.data['newslist'];
      } else {
        Util.simpleToast('网络异常');
      }
    } catch (exception) {
      Util.simpleToast('网络异常');
    }
    return {};
  }
}
