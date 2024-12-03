import 'dart:io'; // Import untuk membaca input dari pengguna
import 'package:sistem_point_of_sales/class/produk.dart';
import 'package:sistem_point_of_sales/class/keranjang.dart';
import 'package:sistem_point_of_sales/class/transaksi.dart';
import 'package:sistem_point_of_sales/class/kasir.dart';
import 'package:sistem_point_of_sales/utilitas/struk.dart';

void main() {
  // Membuat beberapa produk
  var produk1 = Produk(nama: 'Produk A', harga: 100, stok: 10);
  var produk2 = Produk(nama: 'Produk B', harga: 200, stok: 5);
  var produk3 = Produk(nama: 'Produk C', harga: 300, stok: 3);

  // Membuat keranjang belanja
  var keranjang = Keranjang();

  // Menampilkan pilihan produk
  print('Daftar Produk yang Tersedia:');
  print('1. Produk A - Harga: 100');
  print('2. Produk B - Harga: 200');
  print('3. Produk C - Harga: 300');

  // Input nama produk dan jumlahnya
  while (true) {
    print(
        '\nMasukkan nomor produk yang ingin dibeli (1/2/3), ketik "hapus" untuk menghapus produk, atau ketik "selesai" untuk selesai:');
    String? inputProduk = stdin.readLineSync();

    if (inputProduk == 'selesai') {
      break; // Keluar dari loop jika pengguna mengetik "selesai"
    }

    if (inputProduk == 'hapus') {
      print('Masukkan nomor produk yang ingin dihapus (1/2/3):');
      String? inputHapus = stdin.readLineSync();
      print('Masukkan jumlah produk yang ingin dihapus:');
      String? inputJumlah = stdin.readLineSync();
      int jumlah = int.tryParse(inputJumlah ?? '') ?? 0;

      // Menghapus produk dari keranjang
      if (inputHapus == '1') {
        keranjang.hapusProduk(produk1, jumlah);
      } else if (inputHapus == '2') {
        keranjang.hapusProduk(produk2, jumlah);
      } else if (inputHapus == '3') {
        keranjang.hapusProduk(produk3, jumlah);
      } else {
        print('Pilihan produk untuk dihapus tidak valid!');
      }
    } else {
      print('Masukkan jumlah produk yang ingin dibeli:');
      String? inputJumlah = stdin.readLineSync();
      int jumlah = int.tryParse(inputJumlah ?? '') ?? 0;

      // Menambah produk ke keranjang
      if (inputProduk == '1') {
        keranjang.tambahProduk(produk1, jumlah);
      } else if (inputProduk == '2') {
        keranjang.tambahProduk(produk2, jumlah);
      } else if (inputProduk == '3') {
        keranjang.tambahProduk(produk3, jumlah);
      } else {
        print('Pilihan produk tidak valid!');
      }
    }
  }

  // Membuat transaksi
  var transaksi = Transaksi(tanggal: DateTime.now(), keranjang: keranjang);

  // Membuat kasir
  var kasir = Kasir(nama: 'John Doe');
  kasir.buatTransaksi(transaksi);

  // Menambahkan output informasi transaksi
  print('\nKasir: ${kasir.nama}');
  print('Tanggal Transaksi: ${transaksi.tanggal}');

  // Mencetak struk
  cetakStruk(keranjang);
}
