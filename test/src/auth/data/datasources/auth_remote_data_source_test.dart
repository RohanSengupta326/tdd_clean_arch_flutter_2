/* 
import 'package:clean_arch_bloc_2/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// we can't normally test firebase_remote_data_source test
// like we normally test other RemoteDataSources.
// Firebase Remote Data Source tests differs.

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUser extends Mock implements User {
  final String _uid = 'Test uid';

  @override
  String get uid => _uid;
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late FirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late UserCredential userCredential;

  setUp(() {
    authClient = MockFirebaseAuth();
    cloudStoreClient = MockFirebaseFirestore();
    dbClient = MockFirebaseStorage();
    final mockUser = MockUser();
    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );
  });

  group('signIn', () {
    test(
      'should complete successfully when call to the server is successful',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async => userCredential,
          // if we returne Future.value(), it won't work cause it returns
          // UserCredential type. but then we have to create a mock of
          // UserCredential type too.
          // but this UserCredential will be null, so we will have to
          // insert data of type 'User' to the UserCredential so we will have
          // to create another mock of User type. and give fake uid data inside
          // the mock class and recieve that type inside Mock UserCredential
          //
        );

        // sign in won't work without stubbing signup .
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: 'email',
            password: 'password',
          ),
        );

        await dataSource.signUp(
            email: 'email', fullName: 'fullName', password: 'password');
        // act
        final result = await dataSource.signIn(
          email: 'email',
          password: 'password',
        );

        // in expect if we use the whole result, we will have to equate it with
        // LocalUserModel with the empty data, but we wil know only the email
        // and password but the other data we don't have access to so how can we
        // equate completely. so then we have to just equate the email only.
        expect(result.email, equals('email'));
      },
    );
  });
}
*/
// As you can see testing this way, will have to create a lot of mocks and
// still
//will cause many errors as we don't have the saved data that the firestore has.
// so how can we match that.

// so thats why firebase/flutter has created packages to actually 
// create mocks for firebase data types.
