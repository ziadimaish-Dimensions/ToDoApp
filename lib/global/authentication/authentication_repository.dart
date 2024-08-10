import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Signs up a new user with the provided [email], [password], and [name].
  /// Returns the [User] if sign-up is successful, or `null` if an error occurs.
  Future<User?> signUpWithEmailPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        //Store user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Error: The email address is already in use by another account.');
      } else {
        print('Error: $e');
      }
      return null;
    }
  }

  /// Signs in an existing user with the provided [email] and [password].
  /// Returns the [User] if sign-in is successful, or `null` if an error occurs.
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  /// Fetches the user data from Firestore for the given [uid].
  /// Returns a [Map] containing the user data if successful, or `null` if an error occurs.
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
