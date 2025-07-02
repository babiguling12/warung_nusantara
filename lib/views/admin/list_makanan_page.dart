import 'package:flutter/material.dart';
import '../../databases/db_helper.dart';
import '../../models/makanan.dart';

class ListMakananPage extends StatefulWidget {
  const ListMakananPage({super.key});

  @override
  State<ListMakananPage> createState() => _ListMakananPageState();
}

class _ListMakananPageState extends State<ListMakananPage> {
  List<Makanan> _makananList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMakanan();
  }

  Future<void> _loadMakanan() async {
    final db = await DbHelper();
    final result = await db.getAllMakanan();

    setState(() {
      _makananList = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _makananList.isEmpty
        ? const Center(child: Text('Tidak ada data makanan'))
        : Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            itemCount: _makananList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2 / 3, // Biar lebih tinggi
            ),
            itemBuilder: (context, index) {
              final m = _makananList[index];
              return _buildMakananCard(m);
            },
          ),
        );
  }

  Widget _buildMakananCard(Makanan makanan) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    makanan.gambar,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        makanan.nama,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                          shadows: [
                            Shadow(color: Colors.black45, blurRadius: 2),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        makanan.daerah,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                if (makanan.stok == 0)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Stok Habis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 16,
                        color: Colors.teal,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Rp ${makanan.harga}',
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.inventory, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          makanan.stok > 0 ? 'Stok: ${makanan.stok}' : '-',
                          style: TextStyle(
                            color:
                                makanan.stok > 0 ? Colors.black87 : Colors.red,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite_border, size: 14, color: Colors.white,),
                      label: const Text(
                        'Favorit',
                        style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(100, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
