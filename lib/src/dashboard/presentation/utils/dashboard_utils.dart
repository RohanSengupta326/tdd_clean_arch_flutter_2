import 'package:clean_arch_bloc_2/core/services/injection_container.dart';
import 'package:clean_arch_bloc_2/src/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardUtils {
  const DashboardUtils._();

  // here using already injected dependency of firestore
  // but we are not putting this in proper clean architecture
  // and then not even testing, because these things are
  // already tested by firebase. so no need.

  // we are fetching new user details again because after checking
  // user is signed in or not, then we are storing details in
  // router file, but there we are not able to get the full data.
  // There we are fetching little details. More user details might
  // be saved in firestore but we are not fetching those there.
  // that's why we are fetching it here properly.

  static Stream<LocalUserModel> get userDataStream => sl<FirebaseFirestore>()
      .collection('users')
      .doc(sl<FirebaseAuth>().currentUser!.uid)
      .snapshots()
      .map(
        (event) => LocalUserModel.fromMap(event.data()!),
      );
}
