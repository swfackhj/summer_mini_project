import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_game/models/user_model.dart';
import 'package:flame_game/styles/title_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  String gender = '남자';

  void changeGender(String gender) {
    this.gender = gender;
    update();
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (FirebaseAuth.instance.currentUser?.emailVerified == false) {
        signInErrorDialog('이메일을 인증해주세요.');
        FirebaseAuth.instance.signOut();
      }
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'configuration-not-found':
        case 'invalid-email':
        case 'user-not-found':
          return signInErrorDialog('존재하지 않는 계정입니다.');
        case 'wrong-password':
          return signInErrorDialog('비밀번호가 틀렸습니다.');

        default:
      }
    }
  }

  Future<void> signUpWithEamil() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((userCredential) {
        final user = UserModel(
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
            gender: gender,
            uid: userCredential.user!.uid);
        FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user?.uid)
            .set(user.toJson());
        FirebaseAuth.instance.currentUser?.sendEmailVerification();
        Get.back();
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'email-already-in-use':
          return signUpErrorDialog('이미 사용중인 이메일입니다.');
        case 'weak-password':
          return signUpErrorDialog('비밀번호 형식이 잘못되었습니다.');
        default:
      }
    }
  }

  Future<dynamic> signUpErrorDialog(String content) {
    return Get.defaultDialog(
      title: '회원가입 오류',
      content: Text(content),
      textConfirm: '확인',
      buttonColor: Colors.black,
      confirmTextColor: Colors.white,
      onConfirm: Get.back,
    );
  }

  Future<dynamic> signInErrorDialog(String content) {
    return Get.defaultDialog(
      title: '로그인 오류',
      titleStyle: titleStyle,
      content: Text(content),
      textConfirm: '확인',
      buttonColor: Colors.black,
      confirmTextColor: Colors.white,
      onConfirm: Get.back,
    );
  }
}
