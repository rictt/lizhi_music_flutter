import 'package:fluttertoast/fluttertoast.dart';

class UserToast {
  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: 14.0
    );
  }
}