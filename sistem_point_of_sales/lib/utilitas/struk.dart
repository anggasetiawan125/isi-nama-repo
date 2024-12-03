import '../class/keranjang.dart';

void cetakStruk(Keranjang keranjang) {
  print('---------------------');
  print('--- Struk Belanja ---');
  print('---------------------');
  for (var item in keranjang.items) {
    print(
        'Produk: ${item.produk.nama}, Harga: ${item.produk.harga} x ${item.jumlah}');
  }
  print('---------------------');
  print('Total: ${keranjang.total}');
  print('---------------------');
}
