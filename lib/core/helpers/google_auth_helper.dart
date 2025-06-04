import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  clientId: "<YOUR_CLIENT_ID_FROM_GOOGLE_CLOUD>", // هتلاقيه في Google Cloud Console
);

Future<String?> signInAndGetIdToken() async {
  try {
    final account = await googleSignIn.signIn();
    if (account == null) return null; // المستخدم لغى تسجيل الدخول

    final auth = await account.authentication;
    return auth.idToken; // Identity Token
  } catch (e) {
    print(e);
    return null;
  }
}
