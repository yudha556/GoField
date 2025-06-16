import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/router/app_routes.dart';

void useLoginHook(BuildContext context, String role) {
  String routePath;

  switch (role) {
    case 'admin':
      routePath = AppRoutes.adminDashboard;
      break;
    case 'owner':
      routePath = AppRoutes.ownerDashboard;
      break;
    default:
      routePath = AppRoutes.userDashboard;
  }

  context.go(routePath);
}
