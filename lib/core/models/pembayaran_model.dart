class PembayaranModel {
  final String idReservasi;
  final double jumlahPembayaran;
  final String metodePembayaran;

  PembayaranModel({
    required this.idReservasi,
    required this.jumlahPembayaran,
    required this.metodePembayaran,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_reservasi': idReservasi,
      'jumlah_pembayaran': jumlahPembayaran,
      'metode_pembayaran': metodePembayaran,
    };
  }
}
