import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/splash/page.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/app/views/auth/register/page.dart';
import 'package:gofield/app/views/auth/signIn/page.dart';
import 'package:gofield/app/views/auth/register/components/otpVerify.dart';
import 'package:gofield/app/views/admin/app/home/page.dart' as AdminHome;
import 'package:gofield/app/views/owner/app/home/page.dart' as OwnerHome;
import 'package:gofield/app/views/user/app/home/page.dart' as UserHome;
import 'package:gofield/app/views/user/app/search/page.dart' as UserSearchPage;
import 'package:gofield/app/views/user/app/profile/page.dart' as UserProfile;
import 'package:gofield/app/views/user/app/promo/page.dart' as UserPromo;
import 'package:gofield/app/views/user/app/transaksi/page.dart'
    as UserTransaksi;
import 'package:gofield/app/views/user/app/home/components/list.dart'
    as userListPage;
import 'package:gofield/app/views/user/app/transaksi/[id]/page.dart'
    as UserTransaksiDetail;
import 'package:gofield/app/views/user/app/profile/components/settingPage.dart'
    as UserSettingPage;
import 'package:gofield/app/views/user/app/registerOwner/page.dart'
    as UserRegisterToOwner;
import 'package:gofield/app/views/user/app/registerOwner/components/daftarLapangan.dart'
    as OwnerRegisterForm;
import 'package:gofield/app/views/user/app/registerOwner/components/waitingRegister.dart'
    as WaitingRegisterToOwner;

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // splash
      GoRoute(
        path: AppRoutes.splash,
        name: 'SplashPage',
        builder: (context, state) {
          print("Router: Building splash page");
          return const SplashPage();
        },
      ),

      // auth
      GoRoute(
        path: AppRoutes.login,
        name: 'Login',
        builder: (context, state) {
          print("Router: Building Login page");
          return const LoginPage();
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'Register',
        builder: (context, state) {
          print('Router: Building Register page');
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: AppRoutes.verify,
        name: 'verify',
        builder: (context, state) {
          print('Router: Building verify page');
          return const VerifyPage();
        },
      ),

      // role-based dashboard
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'AdminDashboard',
        builder: (context, state) {
          print('Router: Building Admin Dashboard');
          return const AdminHome.AdminPage();
        },
      ),
      GoRoute(
        path: AppRoutes.ownerDashboard,
        name: 'OwnerDashboard',
        builder: (context, state) {
          print('Router: Building Owner Dashboard');
          return const OwnerHome.OwnerPage();
        },
      ),
      GoRoute(
        path: AppRoutes.userDashboard,
        name: 'UserDashboard',
        builder: (context, state) {
          print('Router: Building User Dashboard');
          return const UserHome.UserHomePage();
        },
      ),

      // user page
      GoRoute(
        path: AppRoutes.userSearchPage,
        name: 'JadwalPage',
        builder: (context, state) {
          print('Router: Building User Page');
          return const UserSearchPage.SearchPage();
        },
      ),
      GoRoute(
        path: AppRoutes.usertransaksiPage,
        name: 'TransaksiPage',
        builder: (context, state) {
          print('Router: Building Transaksi Page');
          return const UserTransaksi.TransaksiPage();
        },
      ),
      GoRoute(
        path: AppRoutes.userpromoPage,
        name: 'PromoPage',
        builder: (context, state) {
          print('Router: Building Promo Page');
          return const UserPromo.PromoPage();
        },
      ),
      GoRoute(
        path: AppRoutes.userprofilePage,
        name: 'ProfilPage',
        builder: (context, state) {
          print('Router: Building Profile Page');
          return const UserProfile.ProfilePage();
        },
      ),
      GoRoute(
        path: AppRoutes.userListPage,
        name: 'List Id',
        builder: (context, state) {
          print('Builder List Page');
          return const userListPage.ListPage();
        },
      ),
      GoRoute(
        path: AppRoutes.userTransactionDetail,
        name: 'Transaction Detail',
        builder: (context, state) {
          return const UserTransaksiDetail.TransactionDetail();
        },
      ),
      GoRoute(
        path: AppRoutes.userSettingPage,
        name: 'Settings',
        builder: (context, state) {
          return const UserSettingPage.Settingpage();
        },
      ),

      // user register ke owner
      GoRoute(
        path: AppRoutes.userRegisterToOwner,
        name: 'Register To Owner',
        builder: (context, state) {
          return const UserRegisterToOwner.OwnerRegister();
        },
      ),
      GoRoute(
        path: AppRoutes.OwnerRegisterForm,
        name: 'Owner Register Form',
        builder: (context, state) {
          return const OwnerRegisterForm.Daftarlapangan();
        },
      ),
      GoRoute(
        path: AppRoutes.waitingRegister,
        name: 'waiting Register Page',
        builder: (context, state) {
          return const WaitingRegisterToOwner.WaitingPage();
        },
      ),
    ],

    errorBuilder: (context, state) {
      print('Router Error: ${state.error}');
      print('Router Error Location: ${state.uri}');
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Page not found: ${state.uri}'),
              Text('Error: ${state.error}'),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
