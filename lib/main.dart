import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_in_flutter/db/db_helper.dart';
import 'package:todo_in_flutter/services/theme_services.dart';

import 'constant/my_themes.dart';
import 'screen/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeServices _themeServices = Get.put(ThemeServices());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Todo',
      //
      theme: MyThemes.light,
      darkTheme: MyThemes.dark,
      themeMode: _themeServices.theme,
      //
      initialRoute: '/homePage',
      routes: {
        '/homePage': (context) => HomePage(),
      },
    );
  }
}
