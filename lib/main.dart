import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app/sotong_app.dart';
import 'services/crisis_session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // Path-based URLs for web refresh/share.
  final controller = CrisisSessionController();
  await controller.init();
  runApp(SotongApp(controller: controller));
}
