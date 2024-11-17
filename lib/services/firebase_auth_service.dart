import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthLib; // Dando prefixo para FirebaseAuth
import '../models/user_model.dart' as AppModels; // Dando prefixo para o seu modelo


class FirebaseAuthService {
  final FirebaseAuthLib.FirebaseAuth _auth = FirebaseAuthLib.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up user
  Future<FirebaseAuthLib.User?> signUpUser({
    required String email,
    required String password,
    required AppModels.User userData, // Usando o modelo do seu projeto
  }) async {
    try {
      FirebaseAuthLib.UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      FirebaseAuthLib.User? user = userCredential.user;

      // Save additional user data to Firestore
      if (user != null) {
        await _firestore.collection('usuarios').doc(user.uid).set(userData.toJson());
      }

      return user;
    } catch (e) {
      print("Error during sign up: $e");
      throw Exception('Erro ao criar usuário: $e');
    }
  }

  // Login user
  Future<FirebaseAuthLib.User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      FirebaseAuthLib.UserCredential userCredential =
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print("Error during login: $e");
      throw Exception('Erro ao fazer login: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error during password reset: $e");
      throw Exception('Erro ao redefinir senha: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Error during sign out: $e");
      throw Exception('Erro ao fazer logout: $e');
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('usuarios').doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      throw Exception('Erro ao buscar dados do usuário: $e');
    }
  }

  // Check current user
  FirebaseAuthLib.User? get currentUser => _auth.currentUser;
}