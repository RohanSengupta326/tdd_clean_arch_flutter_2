import 'package:clean_arch_bloc_2/src/auth/data/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  LocalUserModel? _user;

  LocalUserModel? get user => _user;

  // when app starts we save userModel if user is already loggedIn through
  // initUser.
  void initUser(LocalUserModel? user) {
    if (_user != user) _user = user;
  }

  // if some userData is changed then we call setUser to update already saved
  // userData and update the UI.
  set user(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
      //   so that when widget tree is getting built , in between if user
      //   changes
      //   occurs then notifyListeners() won't work. so that's why we are giving
      //   it some time to build the widget tree properly, then calling
      //   notifylisteners even if the user changes occurred midway.
    }
  }
}
