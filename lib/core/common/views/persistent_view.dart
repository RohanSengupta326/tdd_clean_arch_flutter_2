import 'package:clean_arch_bloc_2/core/common/app/providers/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersistentView extends StatefulWidget {
  const PersistentView({this.body, super.key});

  final Widget? body;

  @override
  State<PersistentView> createState() => _PersistentViewState();
}

class _PersistentViewState extends State<PersistentView>
    with AutomaticKeepAliveClientMixin {
  // this mixin is to keep page alive, when coming back to this page
  // it shouldn't reset itself.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.body ?? context.watch<TabNavigator>().currentPage.child;
    //   either return a received body or just return currentPage's child body
    //   by calling it.
    //   context.watch() will search upwards to search for the nearest
    //   TabNavigator
    //   and will get the currentPage from there.
  }

  @override
  bool get wantKeepAlive => true;
}
