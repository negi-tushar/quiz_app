// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint; // For web-specific handling

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Stream of authentication state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Google Sign-In method
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels sign-in
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential with the Google access token and ID token
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // For web, sometimes the displayName or photoURL might be null initially.
      // You can prompt the user for a name or update if needed after successful sign-in.
      if (kIsWeb && userCredential.user?.displayName == null) {
        // Optional: Handle web specific user info update if needed
        // For example, if you want a user to set a display name if it's missing on web.
        // This is a placeholder; actual implementation depends on your UX.
        debugPrint("User display name is null on web. Might need to prompt user.");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase specific errors
      debugPrint('Firebase Auth Error: ${e.code} - ${e.message}');
      rethrow; // Re-throw to be caught by the UI
    } catch (e) {
      // Handle other potential errors (network, Google Sign-In specific)
      debugPrint('General Sign-In Error: $e');
      rethrow;
    }
  }

  // Sign out method
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await _auth.signOut(); // Sign out from Firebase
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }
}
