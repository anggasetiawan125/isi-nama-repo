import 'produk.dart';

class Keranjang {
  List<ItemKeranjang> items = [];

  void tambahProduk(Produk produk, int jumlah) {
    var item = ItemKeranjang(produk: produk, jumlah: jumlah);
    items.add(item);
  }

  void hapusProduk(Produk produk, int jumlah) {
    for (var item in items) {
      if (item.produk == produk) {
        if (item.jumlah > jumlah) {
          item.jumlah -= jumlah;
        } else {
          items.remove(item);
        }
        break;
      }
    }
  }

  double get total {
    double total = 0;
    for (var item in items) {
      total += item.produk.harga * item.jumlah;
    }
    return total;
  }
}
