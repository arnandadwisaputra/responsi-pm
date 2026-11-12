/// Validasi dan sanitasi input pengguna secara aman
class Validators {
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Judul tidak boleh kosong';
    }
    if (value.length < 3 || value.length > 50) {
      return 'Judul harus antara 3 - 50 karakter';
    }
    return null;
  }

  static String? validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Isi catatan tidak boleh kosong';
    }
    if (value.length < 10 || value.length > 1000) {
      return 'Isi catatan harus antara 10 - 1000 karakter';
    }
    return null;
  }

  /// Membersihkan karakter berbahaya untuk mencegah injeksi dasar
  static String sanitize(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }
}