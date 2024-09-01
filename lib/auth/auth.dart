import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<FirebaseApp> initializeFirebase() async {
  final firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}

Future<User?> getCurrentUser() async {
  return _auth.currentUser;
}

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount == null) {
      // User cancelled the sign-in process
      return null;
    }
    
    final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  } catch (e) {
    print('Error during Google sign in: $e');
    return null;
  }
}

Future<void> signOut() async {
  await _auth.signOut();
  await _googleSignIn.signOut();
}