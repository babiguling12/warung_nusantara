import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNav({required this.currentIndex, required this.onTap});

  @override
  State<CustomBottomNav> createState() => _CustomButtonNavState();
}

class _CustomButtonNavState extends State<CustomBottomNav> {
  final List<IconData> _icons = [
    Icons.fastfood,
    Icons.favorite,
    Icons.add_box,
    Icons.history,
    Icons.people,
  ];

  final List<String> _labels = [
    'Makanan',
    'Favorite',
    'Stok',
    'Riwayat',
    'Kasir',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82, // sedikit lebih tinggi untuk label bawah
      decoration: BoxDecoration(
        color: Colors.teal[600],
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (index) {
          final selected = index == widget.currentIndex;

          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border:
                    selected
                        ? Border.all(color: Colors.teal, width: 2)
                        : null,
              ),
              child: Column(
                // Ubah ke Column supaya label dibawah ikon
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _icons[index],
                    color: selected ? Colors.teal : Colors.white70,
                    size: 24,
                  ),
                  SizedBox(height: 2),
                  AnimatedSize(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child:
                        selected
                            ? Text(
                              _labels[index],
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                            : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
