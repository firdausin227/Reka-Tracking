import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rekatracking/services/firebase_services.dart';
import 'package:rekatracking/webpage.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarangPage> {
  final CollectionReference _dataBarang =
      FirebaseFirestore.instance.collection('barang');

  final _nomorBarcodeController = TextEditingController();
  final _namaBarangController = TextEditingController();
  final _jumlahBarangController = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final statusProsesBarang = TextEditingController();
  final _keteranganBarangController = TextEditingController();

  String? _selectedStatusBarang;

  @override
  void dispose() {
    _nomorBarcodeController.dispose();
    _namaBarangController.dispose();
    _jumlahBarangController.dispose();
    _keteranganBarangController.dispose();
    _date.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    final nomorBarcode = _nomorBarcodeController.text;
    final namaBarang = _namaBarangController.text;
    final jumlahBarang = int.parse(_jumlahBarangController.text);
    final keteranganBarang = _keteranganBarangController.text;
    final statusProsesBarang = _selectedStatusBarang!;
    final tanggalTarget = _date.text;

    await FirebaseService().addBarang(
      nomorBarcode,
      namaBarang,
      jumlahBarang,
      keteranganBarang,
      statusProsesBarang,
      tanggalTarget,
    );

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const WebPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Form Tambah Data Barang',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Form Kode Barcode
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Kode Barcode',
                  hintText: 'Input Kode Barcode',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white),
            ),

            // Form Nama Barang
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  hintText: 'Input Nama Barang',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white),
            ),

            // Form Jumlah Barang
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Jumlah Barang',
                  hintText: 'Input Jumlah Barang',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white),
            ),

            // Form Status Proses Barang
            const SizedBox(height: 16),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const SimpleDropDown()),

            // Form Tanggal Target
            const SizedBox(height: 16),
            TextFormField(
              controller: _date,
              decoration: const InputDecoration(
                  labelText: 'Tanggal Target',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_month_outlined),
                  filled: true,
                  fillColor: Colors.white),
              onTap: () async {
                DateTime? pickeddate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100));

                if (pickeddate != null) {
                  setState(() {
                    _date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
                  });
                }
              },
            ),

            // Form Keterangan Barang
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Keterangan Barang',
                  hintText: 'Input Keterangan Barang',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white),
            ),

            // Button cancel dan simpan
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WebPage()));
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _saveData,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleDropDown extends StatefulWidget {
  const SimpleDropDown({super.key});

  @override
  State<SimpleDropDown> createState() => _SimpleDropDownState();
}

class _SimpleDropDownState extends State<SimpleDropDown> {
  String? _selectedStatusBarang;
  final List<String> _status = [
    'Perencanaan Produksi',
    'Pengendalian Produksi',
    'Gudang',
    'Produksi Mekanik',
    'QC (In-Proccess)',
    'Produksi Elektrik',
    'QC (Final)',
    'Ekspedisi',
    'AfterSales',
  ];
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedStatusBarang,
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatusBarang = newValue;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Status Proses Barang',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _status
          .map((status) => DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              ))
          .toList(),
    );
  }
}
