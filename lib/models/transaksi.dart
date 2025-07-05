class Transaksi {
  final int? id;
  final String tanggal;
  final int total;
  final int kasir_id;

  Transaksi({
    this.id,
    required this.tanggal,
    required this.total,
    required this.kasir_id,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'tanggal': tanggal,
    'total': total,
    'kasir_id': kasir_id,
  };

  factory Transaksi.fromMap(Map<String, dynamic> map) => Transaksi(
    id: map['id'],
    tanggal: map['tanggal'],
    total: map['total'],
    kasir_id: map['kasir_id'],
  );
}
