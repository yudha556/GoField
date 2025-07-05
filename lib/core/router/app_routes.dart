class AppRoutes {
  // splash
  static const String splash = '/';

  // auth
  static const String login = '/signIn';
  static const String register = '/register';
  static const String verify = '/verify';

  // on boarding
  static const String onboarding = '/onboarding';

  // role based dashboard
  static const String adminDashboard = '/admin/home';
  static const String ownerDashboard = '/owner/home';
  static const String userDashboard = '/user/home';

  // user page
  static const String userSearchPage = '/user/jadwal';
  static const String usertransaksiPage = '/user/transaksi';
  static const String userprofilePage = '/user/profile';
  static const String userpromoPage = '/user/promo';
  static const String userhomePage = '/user/home';
  static const String userListPage = '/home/list';
  static const String userTransactionDetail = '/transaksi/id';
  static const String userSettingPage = '/settings';
  static const String userLapanganDetailPage = '/user/lapangan/:id';
  static String userLapanganDetailPath(String id) => '/user/lapangan/$id';


  // register owner
  static const String userRegisterToOwner = '/registerToOwner';
  static const String OwnerRegisterForm = '/registerForm';
  static const String waitingRegister = '/waitingRegister';

  // admin route
  static const String adminPeninjauanPage = '/admin/peninjauan';
static const String adminPeninjauanId = '/admin/peninjauan/:id';
static String adminPeninjauanDetail(String id) => '/admin/peninjauan/$id';

  static const String adminProfile = '/admin/profile';

  // owner route
  static const String ownerLapanganPage = '/owner/lapangan';
  static const String ownerProfilePage = '/owner/profile';
  static const String tambahLapangan = '/owner/lapangan/tambah';
  static const String tambahLane = '/owner/lapangan/tambah-lane';
  static const String ownerLapanganDetail = '/owner/lapangan/:id';
  static String ownerLapanganDetailPath(String id) => '/owner/lapangan/$id';
  static String tambahLaneWithParams(String lapanganId, String namaLapangan) {
    return '$tambahLane?lapanganId=$lapanganId&namaLapangan=${Uri.encodeComponent(namaLapangan)}';
  }
}
