import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg, {int? duration, int? gravity}) {
  // Toast.show(msg, duration: duration, gravity: gravity);
  Fluttertoast.showToast(msg: msg);
}
