class Transaksi {
  final int? id;
  final String tanggal;
  final int total;

  Transaksi({this.id, required this.tanggal, required this.total});

  Map<String, dynamic> toMap() => {
        'id': id,
        'tanggal': tanggal,
        'total': total,
      };

  factory Transaksi.fromMap(Map<String, dynamic> map) => Transaksi(
        id: map['id'],
        tanggal: map['tanggal'],
        total: map['total'],
      );
}
