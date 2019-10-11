import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';

class HtmlView extends StatelessWidget {
  final htmlText;
  final color;

  const HtmlView({Key key, this.htmlText, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Html(
      data: htmlText,
      defaultTextStyle: TextStyle(fontSize: 16, height: 1.8, color: color),
      customTextStyle: (dom.Node node, TextStyle baseStyle) {
        if (node is dom.Element) {
          if (node.localName == 'strong') {
            return baseStyle.merge(TextStyle(fontWeight: FontWeight.w900));
          }
          if (node.className == 'font-color-red') {
            return baseStyle.merge(TextStyle(color: Colors.red));
          }
          return baseStyle;
        } else {
          return baseStyle;
        }
      },
      onLinkTap: (String url) {
        launch(url);
      },
    );
  }
}
