import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:my_portfolio/app.dart';
void configureApp() {
  setUrlStrategy(PathUrlStrategy());
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // usePathUrlStrategy();
  // await dotenv.load();
  runApp(const ProviderScope(child: MyApp()));
}
