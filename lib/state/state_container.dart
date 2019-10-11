import 'package:flutter/material.dart';
import 'package:ithome_lite/state/enum_theme.dart';

class ActivedTheme {
  Map<String, Color> theme;
  ActivedThemeIndex activedIndex;

  ActivedTheme(this.theme, this.activedIndex);
}

class StateContainer extends StatefulWidget {
  // You must pass through a child.
  final Widget child;
  final ActivedTheme activedTheme;

  StateContainer({
    @required this.child,
    this.activedTheme,
  });

  // 这个是所有一切的秘诀. 写一个你自己的'of'方法，像MediaQuery.of and Theme.of
  // 简单的说，就是：从指定的Widget类型获取data.
  static _StateContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
            as _InheritedStateContainer)
        .data;
  }

  @override
  _StateContainerState createState() => _StateContainerState(this.activedTheme);
}

class _StateContainerState extends State<StateContainer> {
  // Whichever properties you wanna pass around your app as state
  ActivedTheme activedTheme;

  _StateContainerState(this.activedTheme);

  // You can (and probably will) have methods on your StateContainer
  // These methods are then used through our your app to
  // change state.
  // Using setState() here tells Flutter to repaint all the
  // Widgets in the app that rely on the state you've changed.
  void switchTheme({Map<String, Color> theme, ActivedThemeIndex index}) {
    if (activedTheme == null) {
      activedTheme = ActivedTheme(theme, index);
      setState(() {
        activedTheme = activedTheme;
      });
    } else {
      setState(() {
        activedTheme.theme = theme ?? activedTheme.theme;
        activedTheme.activedIndex = index ?? activedTheme.activedIndex;
      });
    }
  }

  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  final _StateContainerState data;

  // 必须传入一个 孩子widget 和你的状态.
  _InheritedStateContainer({
    Key key,
    @required this.data,
    @required Widget child,
  }) : super(key: key, child: child);

  // 这个一个内建方法可以在这里检查状态是否有变化. 如果没有变化就不需要重新创建所有Widget.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
}
