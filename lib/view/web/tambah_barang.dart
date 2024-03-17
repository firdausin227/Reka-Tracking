import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rekatracking/view/web/webpage.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarangPage> {
  final _nomorBarcodeController = TextEditingController();
  final _namaBarangController = TextEditingController();
  final _jumlahBarangController = TextEditingController();
  final _date = TextEditingController();
  final statusProsesBarang = TextEditingController();
  final _keteranganBarangController = TextEditingController();

  String? _selectedStatus;

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
    final statusProsesBarang = _selectedStatus;
    final tanggalTarget = _date.text;

    if (_selectedStatus != null) {
      try {
        await FirebaseFirestore.instance.collection('barang').add({
          'nomorBarcode': nomorBarcode,
          'namaBarang': namaBarang,
          'jumlahBarang': jumlahBarang,
          'keteranganBarang': keteranganBarang,
          'statusProsesBarang': _selectedStatus,
          'tanggalTarget': tanggalTarget,
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WebPage()),
        );
      } catch (e) {
        print('Error saving data: $e');
      }
    } else {
      print('Selected status is null!');
    }
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
              controller: _nomorBarcodeController,
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
              controller: _namaBarangController,
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
              controller: _jumlahBarangController,
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
                child: const StatusBarangDropDown()),

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
              controller: _keteranganBarangController,
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

class StatusBarangDropDown extends StatefulWidget {
  const StatusBarangDropDown({super.key});

  @override
  _StatusBarangDropDownState createState() => _StatusBarangDropDownState();
}

class _StatusBarangDropDownState extends State<StatusBarangDropDown> {
  String? _selectedStatus;
  List<String> _statusOptions = [];

  @override
  void initState() {
    super.initState();
    _getStatusOptions();
  }

  Future<void> _getStatusOptions() async {
    try {
      // Ambil data dari koleksi 'statusProsesBarang'
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('statusProsesBarang')
          .get();

      // Ubah data Firestore menjadi list string
      List<String> statusList = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .map((data) => data['status'] as String?)
          .where((status) => status != null)
          .cast<String>()
          .toList();

      // Perbarui state dengan data yang diperoleh
      setState(() {
        _statusOptions = statusList;
      });
    } catch (error) {
      // Tangani kesalahan jika terjadi
      print('Error fetching status options: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      onChanged: (String? newValue) {
        setState(() {
          _selectedStatus = newValue;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Status Proses Barang',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _statusOptions
          .map((status) => DropdownMenuItem<String>(
                value: status,
                child: Text(status),
              ))
          .toList(),
    );
  }
}
