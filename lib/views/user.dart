import 'package:flutter/material.dart';
import '../api/api.dart';
import '../components/user/user.dart';

class UserView extends StatefulWidget {
  final Function onGo2home;

  UserView({Key key, this.onGo2home}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UserViewState();
  }
}

class UserViewState extends State<UserView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController controller;
  bool wantKeepAlive = true;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void go2home() {
    widget.onGo2home();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的书单'),
        bottom: new TabBar(
          controller: controller, 
          tabs: <Widget>[
            Tab(text: '已收藏'),
            Tab(text: '已下载'),
            Tab(text: '正在下载'),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          UserBooks(status: BookStatus.COLLECTED, onClickEmptyButton: go2home),
          UserBooks(status: BookStatus.DOWNLOADED, onClickEmptyButton: go2home,),
          UserDownloadingBooks(onClickEmptyButton: go2home),
        ],
      ),
    );
  }
}