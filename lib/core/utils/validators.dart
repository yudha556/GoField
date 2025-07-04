class Validators {
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    final phoneRegex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,9}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  static String? validatePrice(String? value, {int minPrice = 10000}) {
    if (value == null || value.isEmpty) {
      return 'Harga tidak boleh kosong';
    }
    
    final price = int.tryParse(value);
    if (price == null || price <= 0) {
      return 'Harga harus berupa angka yang valid';
    }
    
    if (price < minPrice) {
      return 'Harga minimal Rp ${_formatCurrency(minPrice)}';
    }
    
    return null;
  }

  static String? validateCapacity(String? value, {int maxCapacity = 100}) {
    if (value == null || value.isEmpty) {
      return 'Kapasitas tidak boleh kosong';
    }
    
    final capacity = int.tryParse(value);
    if (capacity == null || capacity <= 0) {
      return 'Kapasitas harus berupa angka yang valid';
    }
    
    if (capacity > maxCapacity) {
      return 'Kapasitas maksimal $maxCapacity orang';
    }
    
    return null;
  }

  static String? validateCoordinate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Koordinat opsional
    }
    
    final parts = value.split(',');
    if (parts.length != 2) {
      return 'Format koordinat tidak valid. Contoh: -6.200000, 106.816666';
    }
    
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    
    if (lat == null || lng == null) {
      return 'Koordinat harus berupa angka yang valid';
    }
    
    if (lat < -90 || lat > 90) {
      return 'Latitude harus antara -90 dan 90';
    }
    
    if (lng < -180 || lng > 180) {
      return 'Longitude harus antara -180 dan 180';
    }
    
    return null;
  }

  static String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
