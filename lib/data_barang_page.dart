import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rekatracking/tambah_barang.dart';

class DataBarangPage extends StatelessWidget {
  const DataBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Barang'),
        centerTitle: false,
        actions: [
          TextButton.icon(
            onPressed: () async {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TambahBarangPage()));
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Data'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('barang').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    minVerticalPadding: 16,
                    tileColor: Colors.white12,
                    title: Row(
                      children: [
                        const Text('Nomor Barcode : '),
                        Text(data['nomorBarcode'].toString()),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Nama Barang : '),
                            Text(data['namaBarang']),
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Jumlah : '),
                            Text(
                              data['jumlahBarang'].toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigasi ke halaman detail barang
                    },
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
