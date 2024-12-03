import 'transaksi.dart';

class Kasir {
  String nama;
  List<Transaksi> transaksiList = [];

  Kasir({required this.nama});

  void buatTransaksi(Transaksi transaksi) {
    transaksiList.add(transaksi);
  }
}
