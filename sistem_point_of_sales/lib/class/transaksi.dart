import 'keranjang.dart';

class Transaksi {
  DateTime tanggal;
  Keranjang keranjang;
  double total;

  Transaksi({required this.tanggal, required this.keranjang})
      : total = keranjang.total;
}
