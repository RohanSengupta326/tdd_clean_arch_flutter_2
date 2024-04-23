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

import 'dart:convert';
import 'dart:io';

import 'package:clean_arch_bloc_2/core/enums/update_user.dart';
import 'package:clean_arch_bloc_2/core/errors/exceptions.dart';
import 'package:clean_arch_bloc_2/core/usecases/constants.dart';
import 'package:clean_arch_bloc_2/core/utils/typdefs.dart';
import 'package:clean_arch_bloc_2/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:clean_arch_bloc_2/src/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  // we can't leave this id to be 'Test uid' because when testing,
  // after user signs up the id will be set to something,
  // then our tests will fail, so we have to get that id from
  // documentReference and set this uid to that received uid.

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
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

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore cloudStoreClient;
  late MockFirebaseStorage dbClient;
  late AuthRemoteDataSource dataSource;
  late UserCredential userCredential;
  late DocumentReference<DataMap> documentReference;
  late MockUser mockUser;

  const tUser = LocalUserModel.empty();

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    cloudStoreClient = FakeFirebaseFirestore();
    documentReference = cloudStoreClient.collection('users').doc();
    await documentReference.set(
      tUser.copyWith(uid: documentReference.id).toMap(),
    );
    dbClient = MockFirebaseStorage();
    mockUser = MockUser()..uid = documentReference.id;
    // cascade notation '..' : first, a instance of MockUser() is set in the
    // variable mockUser, then mockUser.uid is accessed like ..uid directly,
    // then it is set with documentReference.id
    //

    userCredential = MockUserCredential(mockUser);
    dataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      cloudStoreClient: cloudStoreClient,
      dbClient: dbClient,
    );

    // here stubbing is like : when authClient.currentUser is called
    // it has to return mockUser.
    // we are stubbing here , else, when authClient.currentUser will be
    // called the mock doesn't have currentUser field, we have to manually
    // create that, then we would have to rearrange the setUps as per their
    // definition and usage meaning define first then use order.
    // so by this stub hack we don't have to do any of those.
    when(() => authClient.currentUser).thenReturn(mockUser);
  });

  const tPassword = 'Test password';
  const tFullName = 'Test full name';
  const tEmail = 'Test email';

  final tFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifier. '
        'The user may have been deleted',
  );

  group('forgotPassword', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenAnswer((_) async => Future.value());

        // even though its a Future<void> function, we can't expect void cause
        // else we can't check 'completes' in expect(). if used await.
        final call = dataSource.forgotPassword(tEmail);

        expect(call, completes);

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.forgotPassword;

        expect(() => call(tEmail), throwsA(isA<ServerException>()));

        verify(() => authClient.sendPasswordResetEmail(email: tEmail))
            .called(1);
        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signIn', () {
    test(
      'should return [LocalUserModel] when no [Exception] is thrown',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        final result = await dataSource.signIn(
          email: tEmail,
          password: tPassword,
        );
        expect(result.uid, userCredential.user!.uid);
        expect(result.points, 0);
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when user is null after signing in',
      () async {
        final emptyUserCredential = MockUserCredential();
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => emptyUserCredential);

        final call = dataSource.signIn;

        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );

    test(
      'should throw [ServerException] when [FirebaseAuthException] is '
      'thrown',
      () async {
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signIn;

        expect(
          () => call(email: tEmail, password: tPassword),
          throwsA(isA<ServerException>()),
        );
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('signUp', () {
    test(
      'should complete successfully when no [Exception] is thrown',
      () async {
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        when(() => userCredential.user?.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value(),
        );

        when(() => userCredential.user?.updatePhotoURL(any())).thenAnswer(
          (_) async => Future.value(),
        );

        // even though its a Future<void> function, we can't expect void cause
        // else we can't check 'completes' in expect(). if used await.
        final call = dataSource.signUp(
          email: tEmail,
          fullName: tFullName,
          password: tPassword,
        );

        expect(call, completes);

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);

        // because these awaited calls  ( .updateDisplayNam..) are getting
        // called inside
        // signUp function itself, and we are not awaiting the signup func
        // in expect so these functions won't wait for the answers. so we have
        // to await them separately using await untilCalled().
        await untilCalled(() => userCredential.user?.updateDisplayName(any()));
        await untilCalled(() => userCredential.user?.updatePhotoURL(any()));

        verify(() => userCredential.user?.updateDisplayName(tFullName))
            .called(1);
        verify(() => userCredential.user?.updatePhotoURL(kDefaultAvatar))
            .called(1);

        verifyNoMoreInteractions(authClient);
      },
    );
    test(
      'should throw [ServerException] when [FirebaseAuthException] is thrown',
      () async {
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(tFirebaseAuthException);

        final call = dataSource.signUp;

        expect(
          () => call(
            email: tEmail,
            password: tPassword,
            fullName: tFullName,
          ),
          throwsA(isA<ServerException>()),
        );

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ),
        ).called(1);
        verifyNoMoreInteractions(authClient);
      },
    );
  });

  group('updateUser', () {
    setUp(() {
      registerFallbackValue(MockAuthCredential());
    });
    test(
      'should update user displayName successfully when no [Exception] is '
      'thrown',
      () async {
        when(() => mockUser.updateDisplayName(any())).thenAnswer(
          (_) async => Future.value(),
        );

        await dataSource.updateUser(
          action: UpdateUserAction.displayName,
          userData: tFullName,
        );

        // We are not calling 'expect()' here because we checked already
        // updateDisplayName and updatePhotoURL previously signUp.

        verify(() => mockUser.updateDisplayName(tFullName)).called(1);

        // verifyNever that only updateDisplayName was called , now we are not
        // testing for other calls.
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final userData =
            await cloudStoreClient.collection('users').doc(mockUser.uid).get();

        expect(userData.data()!['fullName'], tFullName);
      },
    );

    test(
      'should update user email successfully when no [Exception] '
      'is thrown',
      () async {
        when(() => mockUser.updateEmail(any()))
            .thenAnswer((_) async => Future.value());

        await dataSource.updateUser(
          action: UpdateUserAction.email,
          userData: tEmail,
        );

        verify(() => mockUser.updateEmail(tEmail)).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final user =
            await cloudStoreClient.collection('users').doc(mockUser.uid).get();

        expect(user.data()!['email'], tEmail);
      },
    );

    test(
      'should update user bio successfully when no [Exception] '
      'is thrown',
      () async {
        const newBio = 'new bio';

        await dataSource.updateUser(
          action: UpdateUserAction.bio,
          userData: newBio,
        );
        final user = await cloudStoreClient
            .collection('users')
            .doc(
              documentReference.id,
            )
            .get();

        expect(user.data()!['bio'], newBio);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));
      },
    );

    test(
      'should update user password successfully when no [Exception] is '
      'thrown',
      () async {
        when(() => mockUser.updatePassword(any())).thenAnswer(
          (_) async => Future.value(),
        );

        when(() => mockUser.reauthenticateWithCredential(any()))
            .thenAnswer((_) async => userCredential);

        when(() => mockUser.email).thenReturn(tEmail);

        await dataSource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode({
            'oldPassword': 'oldPassword',
            'newPassword': tPassword,
          }),
        );

        verify(() => mockUser.updatePassword(tPassword));

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateEmail(any()));

        final user = await cloudStoreClient
            .collection('users')
            .doc(
              documentReference.id,
            )
            .get();

        expect(user.data()!['password'], null);
      },
    );

    test(
      'should update user profilePic successfully when no [Exception] is '
      'thrown',
      () async {
        final newProfilePic = File('assets/images/onBoarding_background.png');

        when(() => mockUser.updatePhotoURL(any())).thenAnswer(
          (_) async => Future.value(),
        );

        await dataSource.updateUser(
          action: UpdateUserAction.profilePic,
          userData: newProfilePic,
        );

        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.updateEmail(any()));

        expect(dbClient.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });
}
