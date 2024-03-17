import 'package:flutter/material.dart';
import 'package:rekatracking/view/web/data_barang_page.dart';
import 'package:rekatracking/view/web/laporan_page.dart';
import 'package:rekatracking/loginpage.dart';
import 'package:rekatracking/view/web/beranda_page.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  final PageController _pageController = PageController();

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  void _onItemTapped(int index) {
    setState(() {});
    _pageController.jumpToPage(index);
  }
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.didChangeDependencies();
    final width = MediaQuery.of(context).size.width;
    final bool isLargeScreen = width > 800;

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.blue,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          titleSpacing: 0,
          leading: isLargeScreen
              ? null
              : IconButton(
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
          title: Row(
            children: [
              Image.asset(
                'assets/images/LogoReka.png',
                height: 64,
                width: 128,
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                child: _ProfileIcon(),
              ),
            ),
          ],
        ),
        drawer: isLargeScreen ? _drawer() : null,
        body: PageView(
          controller: _pageController,
          onPageChanged: _onItemTapped,
          children: const [
            BerandaPage(),
            DataBarangPage(),
            LaporanPage(),
          ],
        ),
      ),
    );
  }

  Widget _drawer() => Drawer(
        child: ListView(
          children: _menuItems
              .map((item) => ListTile(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                      _onItemTapped(_menuItems.indexOf(item));
                    },
                    title: Text(item),
                  ))
              .toList(),
        ),
      );
}

final List<String> _menuItems = <String>[
  'Beranda',
  'Data Barang',
  'Laporan',
];

enum Menu { itemOne, itemTwo, itemThree }

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        icon: const Icon(Icons.person),
        offset: const Offset(0, 40),
        onSelected: (Menu item) {
          if (item == Menu.itemThree) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage1()),
            );
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              const PopupMenuItem<Menu>(
                value: Menu.itemOne,
                child: Text('Account'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemTwo,
                child: Text('Settings'),
              ),
              const PopupMenuItem<Menu>(
                value: Menu.itemThree,
                child: Text('Sign Out'),
              ),
            ]);
  }
}
