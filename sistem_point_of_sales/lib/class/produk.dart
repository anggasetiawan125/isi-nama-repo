// produk.dart
class Produk {
  String nama;
  int harga;
  int stok;

  Produk({required this.nama, required this.harga, required this.stok});
}

// item_keranjang.dart
class ItemKeranjang {
  Produk produk; 
  int jumlah; 

  // Konstruktor untuk ItemKeranjang
  ItemKeranjang({required this.produk, required this.jumlah});
}
