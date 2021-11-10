import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';

class KeeperPage extends StatefulWidget {
  static const route = "home_page";

  KeeperPage({Key? key}) : super(key: key);

  @override
  _KeeperPageState createState() => _KeeperPageState();
}

class _KeeperPageState extends State<KeeperPage> {
  ChoosedPage choosedPage = ChoosedPage.home;
  Blur blurItem = Blur.rename;

  void changePage(ChoosedPage newPage) {
    setState(() {
      choosedPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 150,
        height: 150,
      ),
    );
  }
}
