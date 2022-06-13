import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/router.dart' as router;

import 'config/routing_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
          (_) {
            runApp(MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Tasks',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              onGenerateRoute: router.generateRoute,
              initialRoute: HomeViewRoute,
            ));
          });
}
