import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  User? currentUser() {
    // 현재 유저(로그인 되지 않은 경우 null 반환)
  }

  void signUp({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 이메일 검사
    if(email.isEmpty){
      onError("이메일을 입력해 주세요");
      return;
    }
    // 비밀번호 검사
    if(password.isEmpty) {
      onError("비밀번호를 입력해 주세요");
      return;
    }

    // firebase auth 회원 가입
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 성공 함수 호출
      onSuccess();
    } on FirebaseAuthException catch (e) {
      // Firebase auth 에러 발생
      if(e.message != null) {
        if (e.code == 'weak-password') {
          onError('비밀번호를 6자리 이상 입력해 주세요.');
        } else if (e.code == 'email-already-in-use') {
          onError('이미 가입된 이메일 입니다.');
        } else if (e.code == 'invalid-email') {
          onError('이메일 형식을 확인해주세요.');
        } else if (e.code == 'user-not-found') {
          onError('일치하는 이메일이 없습니다.');
        } else if (e.code == 'wrong-password') {
          onError('비밀번호가 일치하지 않습니다.');
        } else {
          onError(e.message!);
        }
      }else {
        onError('에러가 발생하였습니다.');
      }
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }
  }

  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function() onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 로그인
  }

  void signOut() async {
    // 로그아웃
  }
}