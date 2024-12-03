import 'dart:io';
import '../lib/class/produk.dart';
import '../lib/class/keranjang.dart';
import '../lib/class/transaksi.dart';
import '../lib/class/kasir.dart';
import '../lib/utilitas/struk.dart';

List<Transaksi> listTransaksi = []; // Daftar untuk menyimpan transaksi

void main() {
  // Membuat beberapa produk dengan nama yang lebih spesifik
  var produk1 = Produk(nama: 'Indomie Goreng', harga: 3000, stok: 100);
  var produk2 = Produk(nama: 'Kopi Kapal Api', harga: 22000, stok: 50);
  var produk3 = Produk(nama: 'Teh Botol Sosro', harga: 5000, stok: 200);

  // Membuat keranjang belanja
  var keranjang = Keranjang();

  // Menampilkan pilihan produk
  print('Daftar Produk yang Tersedia:');
  print('1. Indomie Goreng - Harga: 3000');
  print('2. Kopi Kapal Api - Harga: 22000');
  print('3. Teh Botol Sosro - Harga: 5000');

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

  // Menyimpan transaksi ke daftar transaksi
  listTransaksi.add(transaksi);

  // Membuat kasir
  var kasir = Kasir(nama: 'John Doe');
  kasir.buatTransaksi(transaksi);

  // Menambahkan output informasi transaksi
  print('\nKasir: ${kasir.nama}');
  print('Tanggal Transaksi: ${transaksi.tanggal}');

  // Mencetak struk
  cetakStruk(keranjang);

  // Menampilkan laporan penjualan
  tampilkanLaporanPenjualan();
}

void tampilkanLaporanPenjualan() {
  double totalPenjualan = 0;
  Map<String, int> produkTerjual = {};

  // Menghitung total penjualan dan produk yang terjual
  for (var transaksi in listTransaksi) {
    totalPenjualan += transaksi.keranjang.total;
    for (var item in transaksi.keranjang.items) {
      produkTerjual[item.produk.nama] =
          (produkTerjual[item.produk.nama] ?? 0) + item.jumlah;
    }
  }

  // Menampilkan laporan
  print('\nLaporan Penjualan:');
  print('Total Penjualan: Rp ${totalPenjualan}');
  print('Produk yang Terjual:');
  produkTerjual.forEach((produk, jumlah) {
    print('$produk: $jumlah');
  });
}
