import 'package:flutter/material.dart';
import 'package:laundry/auth/signup_page_1.dart';
import 'package:laundry/services/map_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:laundry/tab/tab_page.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _invalid = false;
  bool _emailInvalid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                    '티끌모아빨래',
                    style: TextStyle(
                      fontFamily: 'MBC 1961',
                      color: Colors.black,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Colors.black,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: '이메일',
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
                TextField(
                  controller: _passwordController,
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
                const SizedBox(height: 12),
                Visibility(
                  visible: _invalid == true,
                  child: const Column(
                    children: [
                      Text(
                        '이메일이나 비밀번호를 잘못 입력하셨습니다.',
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
                    // onPressed: () async {
                    //   SharedPreferences prefs = await SharedPreferences.getInstance();
                    //   await prefs.setString('userEmail', _emailController.text);
                    //   if(!mounted) return;
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => const TabPage()));
                    // },
                    onPressed: () async {
                      String email = _emailController.text;
                      String pw = _passwordController.text;
                      bool logInSuccess = await context.read<UserServices>().logIn(email, pw);
                      if (logInSuccess) {
                        setState(() {
                          _invalid = false;
                          _emailController.clear();
                          _passwordController.clear();
                        });
                        if (!mounted) return;
                        await context.read<MapServices>().getUserLocation();
                        if(!mounted) return;
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TabPage()), (route) => false);
                      } else {
                        setState(() {
                          _invalid = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _invalid = false;
                            _emailController.clear();
                            _passwordController.clear();
                          });
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  elevation: 0,
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '비밀번호 찾기',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        cursorColor: Colors.black,
                                        style: const TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          hintText: '이메일',
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
                                      const SizedBox(height: 16),
                                      Visibility(
                                          visible: _emailInvalid == true,
                                          child: const Column(
                                            children: [
                                              Text(
                                                '가입되지 않은 이메일입니다.',
                                                style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontSize: 14
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                            ],
                                          )
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 47,
                                              child: OutlinedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _emailInvalid = false;
                                                      _emailController.clear();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      side: const BorderSide(color: Colors.black26)
                                                  ),
                                                  child: const Text(
                                                    '취소',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: SizedBox(
                                              height: 47,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (_emailController.text.isNotEmpty) {
                                                      String email = _emailController.text;
                                                      bool sendPWSuccess = await UserServices().sendChangedPW(email);
                                                      if (!mounted) return;
                                                      Navigator.pop(context);
                                                      if (sendPWSuccess) {
                                                        setState(() {
                                                          _emailInvalid = false;
                                                          _emailController.clear();
                                                        });
                                                        showDialog(
                                                            barrierDismissible: false,
                                                            context: context,
                                                            builder: (context) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10)
                                                                ),
                                                                elevation: 0,
                                                                content: SizedBox(
                                                                  width: 150,
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      const Text(
                                                                        '해당 이메일로 임시 비밀번호를',
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                      const Text(
                                                                        '전송했습니다.',
                                                                        textAlign: TextAlign.center,
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
                                                                                  },
                                                                                  style: OutlinedButton.styleFrom(
                                                                                      side: const BorderSide(color: Colors.black26)
                                                                                  ),
                                                                                  child: const Text(
                                                                                    '로그인',
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        color: Colors.black54
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                  )
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                        );
                                                      } else {
                                                        setState(() {
                                                          _emailInvalid = true;
                                                        });
                                                      }
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.black12
                                                  ),
                                                  child: const Text(
                                                    '확인',
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.bold
                                                    ),
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
                        },
                        child: const Text(
                          '비밀번호 찾기',
                          textAlign: TextAlign.center,
                        )
                    ),
                    const SizedBox(
                      width: 32,
                      child: Text('|', textAlign: TextAlign.center),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            _invalid = false;
                            _emailController.clear();
                            _passwordController.clear();
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpPage1()));
                        },
                        child: const Text(
                          '회원가입',
                          textAlign: TextAlign.center,
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
