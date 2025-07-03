import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../models/makanan.dart';
import '../../databases/db_helper.dart';
import '../../components/custom_snackbar.dart';
import '../../utils/format_number.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final DbHelper db = DbHelper();
  List<Makanan> _makananList = [];
  Map<Makanan, int> _keranjang = {};

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMakanan();
  }

  Future<void> _loadMakanan() async {
    final result = await db.getAllMakanan();
    setState(() {
      _makananList = result;
      _isLoading = false;
    });
  }

  void _tambahKeranjang(Makanan makanan) {
    setState(() => _keranjang[makanan] = (_keranjang[makanan] ?? 0) + 1);
  }

  void _kurangiDariKeranjang(Makanan makanan) {
    if (_keranjang.containsKey(makanan)) {
      setState(() {
        final qty = _keranjang[makanan]!;
        if (qty > 1) {
          _keranjang[makanan] = qty - 1;
        } else {
          _keranjang.remove(makanan);
        }
      });

      if (_keranjang.isEmpty) {
        Navigator.pop(context); // Tutup dialog klo keranjang udh kosong
        showCustomSnackbar(
          context: context,
          message: '${makanan.nama} berhasil dihapus dari keranjang!',
        );
      }
    }
  }

  void _checkOut() {
    if (_keranjang.isEmpty) {
      showCustomSnackbar(
        context: context,
        message: 'Keranjang masih kosong!',
        backgroundColor: Colors.redAccent,
        icon: Icons.warning_amber_outlined,
      );
      return;
    }
    // Proses check out
    // Setelah check out selesai, kosongkan keranjang
    setState(() => _keranjang.clear());
    showCustomSnackbar(context: context, message: 'Transaksi berhasil!');
  }

  int _hitungTotal() {
    if (_keranjang.isEmpty) return 0;

    return _keranjang.entries
        .map((e) => e.key.harga * e.value)
        .reduce((a, b) => a + b);
  }

  void _showKeranjangDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LottieBuilder.asset(
                      'assets/lottie/basket.json',
                      height: 100,
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child:
                          _keranjang.isEmpty
                              ? Center(child: Text('Keranjang masih kosong!'))
                              : ListView.separated(
                                itemCount: _keranjang.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  final item = _keranjang.entries.elementAt(
                                    index,
                                  );
                                  final makanan = item.key;
                                  final qty = item.value;

                                  return Row(
                                    children: [
                                      Expanded(child: Text(makanan.nama)),
                                      Text(formatRupiah(makanan.harga)),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                            ),
                                            onPressed: () {
                                              _kurangiDariKeranjang(makanan);
                                              setStateDialog(() {});
                                            },
                                          ),
                                          Text('$qty'),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                            ),
                                            onPressed: () {
                                              _tambahKeranjang(makanan);
                                              setStateDialog(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                    ),
                    Divider(),
                    Builder(
                      builder: (context) {
                        if (_keranjang.isEmpty) {
                          return SizedBox.shrink();
                        }

                        final total = _hitungTotal();

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total:', style: TextStyle(fontSize: 16)),
                            Text(
                              formatRupiah(total),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(Icons.payment),
                        label: Text('Bayar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _checkOut();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            // HEADER TRANSAKSI
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.teal,
                    size: 24,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Pilih Makanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: _keranjang.isNotEmpty ? _showKeranjangDialog : null,
                    child: Stack(
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.teal,
                          size: 30,
                        ),
                        if (_keranjang.isNotEmpty)
                          Positioned(
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${_keranjang.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // GRID MENU MAKANAN
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: _keranjang.isEmpty ? 100 : 16,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: _makananList.length,
                itemBuilder: (context, index) {
                  final makanan = _makananList[index];
                  return _makananCard(makanan);
                },
              ),
            ),

            // TOMBOL CHECKOUT
            if (_keranjang.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  top: false,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.shopping_cart, color: Colors.teal),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${_keranjang.length} item dalam keranjang ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                            Text(
                              formatRupiah(_hitungTotal()),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => _checkOut(),
                          icon: Icon(Icons.payment, color: Colors.white),
                          label: Text('Bayar Sekarang'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
  }

  Widget _makananCard(Makanan makanan) {
    return GestureDetector(
      onTap: () {
        if (makanan.stok > 0) {
          _tambahKeranjang(makanan);
          showCustomSnackbar(
            context: context,
            message: '${makanan.nama} berhasil ditambahkan ke keranjang!',
          );
        } else {
          showCustomSnackbar(
            context: context,
            message: '${makanan.nama} sedang habis!',
          );
        }
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Bagian gambar + stok di atasnya
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      makanan.gambar,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => const Center(
                            child: Icon(Icons.image_not_supported),
                          ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            makanan.stok == 0
                                ? Colors.redAccent
                                : Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        makanan.stok == 0 ? 'Habis' : 'Stok: ${makanan.stok}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bagian info dan tombol
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      makanan.nama,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(makanan.harga),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.teal[700],
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: ElevatedButton(
                          onPressed:
                              () =>
                                  makanan.stok > 0
                                      ? _tambahKeranjang(makanan)
                                      : showCustomSnackbar(
                                        context: context,
                                        message: 'Stok habis!',
                                        backgroundColor: Colors.redAccent,
                                        icon: Icons.warning_amber_outlined,
                                      ),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: EdgeInsets.zero,
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Icon(Icons.add_shopping_cart, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
