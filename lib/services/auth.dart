import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bidding_app/services/firebase_messaging.dart';
import 'package:bidding_app/services/userDbService.dart';
import 'package:bidding_app/models/user.dart';
import 'dart:async';

class VerificationError {
  final String message =
      'It seems you have not verified your email yet. Check your mail inbox for the verication link';
  final String? email;
  final String? password;
  VerificationError({this.email, this.password});
}

class _AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  ///Stream of firebase user
  Stream<User?> currentUserStream() => _auth.authStateChanges().map((event) {
        if (event == null || !event.emailVerified) {
          return null;
        }
        return event;
      });

  ///Useless stream
  Stream<AppUser?> currentUserDataStream() {
    var controller = StreamController<AppUser?>();
    Stream<AppUser?> dataStream;
    _auth.authStateChanges().listen((event) async* {
      // if (event == null) {
      // controller.add(null);
      // } else {
      dataStream = UserDBServices().streamData(event!.uid);
      dataStream.listen((event) async* {
        controller.add(event);
      });
      // }
    });
    return controller.stream;
  }

  //Return ruccent user
  bool isLoggedIn() => _auth.currentUser != null;

  /// Create new user and implement data
  Future<User?> createUser({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    final creds = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User user = creds.user!;
    await UserDBServices().createUserData(user, overides: data);
    await user.sendEmailVerification();
    return user;
  }

  /// sign out user
  Future signOut() async {
    final u = _auth.currentUser;
    try {
      // if (u != null)
      await UserDBServices().removeNotificationToken(u!.uid);
      await _auth.signOut();
    } catch (e) {
      //
    } finally {
      await _auth.signOut();
      print('done');
      final t = _auth.currentUser;
      print(t);
    }
  }

  /// Reset user `password`
  Future passwordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  /// resend verification email
  Future sendVerificationEmail({
    required String email,
    required String password,
  }) async {
    final creds = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = creds.user!;
    await user.sendEmailVerification();
    await _auth.signOut();
  }

  Future<User> loginUser(
      {required String email,
      required String password,
      Map<String, dynamic>? data}) async {
    final t = _auth.currentUser;
    print(t);

    try {
      final creds = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = creds.user!;

      if (!user.emailVerified) {
        throw VerificationError(email: email, password: password);
      }
      bool dataExists = (await UserDBServices().getData(user.uid)) != null;
      if (dataExists) {
        String? token = await FirebaseMessage().getToken();
        await UserDBServices().updateNotificationToken(user.uid, token!);
        return user;
      }
      String? token = await FirebaseMessage().getToken();
      data!['notificationToken'] = token;
      await UserDBServices().createUserData(user, overides: data);
      return user;
    } catch (e) {
      _auth.signOut();
      if (e is VerificationError || e is String) {
        throw e;
      }
      throw "Something went wrong. Please try again.";
    }
  }

  Future<User> googleSign() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          (await _googleSignIn.signIn())!;
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      bool dataExists = (await UserDBServices().getData(user.uid)) != null;
      if (dataExists) {
        return user;
      }
      await UserDBServices().createUserData(
        user,
      );
      return user;
    } catch (e) {
      _auth.signOut();
      throw "Something went wrong. Please try again.";
    }
  }
}

final _AuthService authService = _AuthService();
