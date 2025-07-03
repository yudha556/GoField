import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/owner/layout/main_owner_schalfold.dart';

class OwnerPage extends StatelessWidget {
  const OwnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: MainOwnerSchallfold(
        child: SafeArea(child: OwnerContent()),
      ),
    );
  }
}

class OwnerContent extends StatefulWidget {
  const OwnerContent({super.key});

  @override
  State<OwnerContent> createState() => _OwnerContentState();
}

class _OwnerContentState extends State<OwnerContent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Ini adalah halaman ownerc'
        ),
      ),
    );
  }
}