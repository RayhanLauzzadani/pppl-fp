import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Memunculkan UI pemilihan akun Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User batal login
        return null;
      }

      // 2. Ambil authentication dari akun Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Buat credential untuk Firebase Auth
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Sign in ke Firebase pakai credential Google
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error sign in with Google: $e');
      // Tampilkan error ke UI jika ingin
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      return null;
    }
  }
}
