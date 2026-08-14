import 'package:flutter/widgets.dart';

class UISpacing {
  static double h(BuildContext context, double percent) {
    return MediaQuery.of(context).size.height * percent;
  }

  static double w(BuildContext context, double percent) {
    return MediaQuery.of(context).size.width * percent;
  }
}
