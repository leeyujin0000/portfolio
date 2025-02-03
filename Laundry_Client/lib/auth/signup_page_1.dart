import 'package:flutter/material.dart';
import 'package:laundry/auth/signup_page_2.dart';
import 'package:laundry/services/user_services.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});

  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  bool _emailInvalid = false;
  bool _codeInvalid = false;
  bool _codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
        automaticallyImplyLeading: false,
        titleSpacing: 16,
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  '중앙대학교 인증',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                TextField(
                  readOnly: _codeSent ? true : false,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '중앙대학교 이메일 (example@cau.ac.kr)',
                    hintStyle: const TextStyle(color: Colors.black26),
                    contentPadding: const EdgeInsets.all(10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Visibility(
                  visible: _emailInvalid == true,
                  child: const Column(
                    children: [
                      Text(
                        '잘못된 형식의 이메일입니다.',
                        style: TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
                SizedBox(
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_emailController.text.endsWith('@cau.ac.kr')) {
                        setState(() {
                          _emailInvalid = false;
                        });
                        String email = _emailController.text;
                        bool sendCodeSuccess = await UserServices().sendCode(email);
                        if (sendCodeSuccess) {
                          setState(() {
                            _codeSent = true;
                          });
                        } else {
                          print('sendCodeFailed');
                        }
                      }
                      else {
                        setState(() {
                          _emailInvalid = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent
                    ),
                    child: const Text(
                      '인증번호 발송',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Visibility(
                  visible: _codeSent == true,
                  child: const Column(
                    children: [
                      Text(
                        '해당 이메일로 인증번호를 발송했습니다.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
                TextField(
                  readOnly: _codeSent ? false : true,
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '인증번호',
                    hintStyle: const TextStyle(color: Colors.black26),
                    contentPadding: const EdgeInsets.all(10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black26),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Visibility(
                  visible: _codeInvalid == true,
                  child: const Column(
                    children: [
                      Text(
                        '인증번호를 잘못 입력했습니다.',
                        style: TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),
                SizedBox(
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_codeSent) {
                        String email = _emailController.text;
                        String code = _codeController.text;
                        bool authenticateSuccess = await UserServices().checkCode(email, code);
                        if (authenticateSuccess) {
                          setState(() {
                            _codeInvalid = false;
                          });
                          if(!mounted) return;
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  elevation: 0,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        color: Colors.orangeAccent,
                                        size: 80,
                                      ),
                                      const SizedBox(height: 8),
                                      const Text(
                                        '인증 완료',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 47,
                                              child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage2(email: email)));
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      side: const BorderSide(color: Colors.black26)
                                                  ),
                                                  child: const Text(
                                                      '다음',
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.bold
                                                      )
                                                  )
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                          );
                        } else {
                          setState(() {
                            _codeInvalid = true;
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent
                    ),
                    child: const Text(
                      '인증',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: const Align(
                      child: Text(
                          '로그인',
                          textAlign: TextAlign.center,
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
