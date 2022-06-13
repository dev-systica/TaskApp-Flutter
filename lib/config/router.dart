import 'package:flutter/material.dart';
import 'package:tasks_flutter/config/routing_constants.dart';
import 'package:tasks_flutter/screens/more_page/page.dart';
import 'package:tasks_flutter/screens/task_list/page.dart';

import '../widgets/undefined_view.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeViewRoute:
      return MaterialPageRoute(builder: (context) => const HomePage(), settings: settings);
    case MoreViewRoute:
      return MaterialPageRoute(builder: (context) => MorePage(settings.arguments), settings: settings);

    default:
      return MaterialPageRoute(builder: (context) => UndefinedView(name: settings.name), settings: settings);
  }
}
