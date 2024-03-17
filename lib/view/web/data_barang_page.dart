import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rekatracking/view/web/tambah_barang.dart';

class DataBarangPage extends StatefulWidget {
  const DataBarangPage({super.key});

  @override
  State<DataBarangPage> createState() => _DataBarangPageState();
}

class _DataBarangPageState extends State<DataBarangPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Barang'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton.icon(
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

            List<DataRow> rows = [];

            for (var doc in snapshot.data!.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              rows.add(DataRow(
                cells: [
                  DataCell(Text(data['nomorBarcode'].toString())),
                  DataCell(Text(data['namaBarang'])),
                  DataCell(Text(data['jumlahBarang'].toString())),
                  DataCell(Text(data['statusProsesBarang'])),
                  DataCell(Text(data['tanggalTarget'])),
                  DataCell(Text(data['keteranganBarang'])),
                ],
              ));
            }

            return SingleChildScrollView(
              child: Expanded(
                child: DataTable(
                  headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                  columns: const [
                    DataColumn(label: Text('Nomor Barcode')),
                    DataColumn(label: Text('Nama Barang')),
                    DataColumn(label: Text('Jumlah Barang')),
                    DataColumn(label: Text('Status Proses')),
                    DataColumn(label: Text('Tanggal Target')),
                    DataColumn(label: Text('Keterangan')),
                  ],
                  rows: rows,
                ),
              ),
            );

            // return ListView(
            //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
            //     Map<String, dynamic> data =
            //         document.data() as Map<String, dynamic>;
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ListTile(
            //         minVerticalPadding: 16,
            //         tileColor: Colors.white12,
            //         title: Row(
            //           children: [
            //             const Text('Nomor Barcode : '),
            //             Text(data['nomorBarcode'].toString()),
            //           ],
            //         ),
            //         subtitle: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Row(
            //               children: [
            //                 const Text('Nama Barang : '),
            //                 Text(data['namaBarang']),
            //               ],
            //             ),
            //             Row(
            //               children: [
            //                 const Text('Jumlah : '),
            //                 Text(
            //                   data['jumlahBarang'].toString(),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //         onTap: () {
            //           // Navigasi ke halaman detail barang
            //         },
            //       ),
            //     );
            //   }).toList(),
            // );
          }),
    );
  }
}
