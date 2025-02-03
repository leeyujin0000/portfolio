import 'package:flutter/material.dart';
import 'package:laundry/auth/login_page.dart';
import 'package:laundry/services/user_services.dart';

class SignUpPage2 extends StatefulWidget {
  final String email;

  const SignUpPage2({required this.email, super.key});

  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {

  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _sex = '';

  @override
  void dispose() {
    _pwController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _invalid = false;

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
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                  '내 정보 입력',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  const Text(
                      '이메일',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                  ),
                  const SizedBox(width: 16),
                  Text(widget.email)
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pwController,
                keyboardType: TextInputType.text,
                obscureText: true,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: '비밀번호',
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
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: '이름',
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
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              _sex = 'm';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: _sex == 'm' ? Colors.black12 : Colors.transparent,
                              side: const BorderSide(color: Colors.black26),
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.5,
                                  vertical: 8
                              ),
                          ),
                          child: const Text(
                              '남',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold
                              )
                          )
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                          onPressed: (){
                            setState(() {
                              _sex = 'f';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                              backgroundColor: _sex == 'f' ? Colors.black12 : Colors.transparent,
                              side: const BorderSide(color: Colors.black26),
                              minimumSize: Size.zero,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.5,
                                  vertical: 8
                              ),
                          ),
                          child: const Text(
                              '여',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold
                              )
                          )
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                  visible: _invalid == false,
                  child: const SizedBox(height: 50)
              ),
              Visibility(
                visible: _invalid == true,
                child: const Column(
                  children: [
                    SizedBox(height: 18),
                    Text(
                      '입력되지 않았거나 잘못된 부분이 있습니다.',
                      style: TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_pwController.text.isEmpty ||
                        _nameController.text.isEmpty ||
                        _sex == '') {
                      setState(() {
                        _invalid = true;
                      });
                    }
                    else {
                      setState(() {
                        _invalid = false;
                      });
                      String email = widget.email;
                      String pw = _pwController.text;
                      String sex = _sex;
                      String name = _nameController.text;
                      bool signUpSuccess = await UserServices().signUp(email, pw, name, sex);
                      if (signUpSuccess) {
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
                                      Icons.person_outline,
                                      size: 80,
                                      color: Colors.orangeAccent,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '회원가입 완료',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 47,
                                            child: OutlinedButton(
                                                onPressed: (){
                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LogInPage()), (route) => false);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                      color: Colors.black26,
                                                  ),
                                                ),
                                                child: const Text(
                                                    '로그인',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      } else {
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
                                      Icons.warning_amber_rounded,
                                      size: 80,
                                      color: Colors.orangeAccent,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '회원가입 실패',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const Text(
                                      '예기치 못한 오류가 발생했습니다.',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 47,
                                            child: OutlinedButton(
                                                onPressed: (){
                                                  Navigator.popUntil(context, (route) => route.isFirst);
                                                },
                                                style: OutlinedButton.styleFrom(
                                                  side: const BorderSide(
                                                    color: Colors.black26,
                                                  ),
                                                ),
                                                child: const Text(
                                                    '확인',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold
                                                    )
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                        );
                      }
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                  ),
                  child: const Text(
                    '가입',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}