import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:rekatracking/screens/loginpage.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class MobilePage extends StatefulWidget {
  const MobilePage({super.key});

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: _buildBody(),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blue,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(Icons.home),
          Icon(Icons.camera),
          Icon(Icons.history),
          Icon(Icons.settings),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const ScannerContent();
      case 2:
        return _buildHistoryContent();
      case 3:
        return _buildSettingsContent();
      default:
        return Container();
    }
  }

// Beranda Navigation
  Widget _buildHomeContent() {
    // Tambahkan konten untuk halaman beranda di sini
    return const Center(
      child: Text('Beranda'),
    );
  }

// Settings Navigation
  Widget _buildSettingsContent() {
    // Tambahkan konten untuk halaman pengaturan di sini
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          child: const Text("Logout"),
          onPressed: () async {
            //  await AuthServices.signInWithGoogle();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage1()));
          },
        ),
      ],
    ));
  }
}

// Scanner Navigation
class ScannerContent extends StatefulWidget {
  const ScannerContent({super.key});

  @override
  State<ScannerContent> createState() => _ScannerContentState();
}

class _ScannerContentState extends State<ScannerContent> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(),
                  ));
              setState(() {
                if (res is String) {
                  result = res;
                }
              });
            },
            child: const Text('Open Scanner'),
          ),
          Text('Barcode Result: $result'),
        ],
      ),
    );
  }
}

// History Navigation
Widget _buildHistoryContent() {
  // Tambahkan konten untuk halaman beranda di sini
  return const Center(
    child: Text('History'),
  );
}
