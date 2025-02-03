import 'package:flutter/material.dart';
import 'package:laundry/auth/login_page.dart';
import 'package:laundry/services/user_services.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _nowPWController = TextEditingController();
  final TextEditingController _newPWController = TextEditingController();

  bool _pwInvalid = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nowPWController.dispose();
    _newPWController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    User user = context.watch<UserServices>().user;
    _nameController.text = user.name;

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ListView(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                    Icons.account_circle,
                    color: Colors.black26,
                    size: 100,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Text(
                      '이름',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: user.name,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                      onTap: () async {
                        if (_nameController.text.isNotEmpty &&
                            _nameController.text != user.name) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        elevation: 0,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              '이름 변경',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            TextField(
                                              controller: _nowPWController,
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
                                            const SizedBox(height: 16),
                                            Visibility(
                                                visible: _pwInvalid == true,
                                                child: const Column(
                                                  children: [
                                                    Text(
                                                      '비밀번호를 잘못 입력했습니다.',
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
                                                          setState((){
                                                            _pwInvalid = false;
                                                            _nowPWController.clear();
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        style: OutlinedButton.styleFrom(
                                                            backgroundColor: Colors.transparent,
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
                                                          String email = user.email;
                                                          String pw = _nowPWController.text;
                                                          String name = _nameController.text;
                                                          bool updateSuccess = await context.read<UserServices>().updateUserInfo(email, pw, name);
                                                          if (updateSuccess) {
                                                            if (!mounted) return;
                                                            Navigator.pop(context);
                                                            setState(() {
                                                              _pwInvalid = false;
                                                              _nowPWController.clear();
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
                                                                            '이름 변경 완료',
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
                                                                                    },
                                                                                    style: OutlinedButton.styleFrom(
                                                                                      side: const BorderSide(color: Colors.black26)
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
                                                          } else {
                                                            _pwInvalid = true;
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
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                );
                              }
                          );
                        }
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 30,
                        color: Colors.black54,
                      )
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Text(
                      '성별',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ),
                  Text(
                      UserServices().genderText(user.sex),
                      style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const SizedBox(
                    width: 70,
                    child: Text(
                      '이메일',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ),
                  Text(
                      user.email,
                    style: const TextStyle(fontSize: 16)
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 47,
                child: OutlinedButton(
                  onPressed: (){
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setState) {
                                List<String> banList = context.watch<UserServices>().user.ban;
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  elevation: 0,
                                  child: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                              border: Border(bottom: BorderSide(color: Colors.black12))
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Stack(
                                                  children: [
                                                    const Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        '차단 사용자',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 16
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: GestureDetector(
                                                        onTap: (){
                                                          Navigator.pop(context);
                                                        },
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: banList.isEmpty,
                                          child: const Expanded(
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.person_outline,
                                                    color: Colors.black12,
                                                    size: 80,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text('차단한 사용자가 없습니다.')
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: banList.isNotEmpty,
                                          child: Expanded(
                                            child: ListView(
                                              children: [
                                                const SizedBox(height: 8),
                                                for (int i = 0; i < banList.length; i++)
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    child: Row(
                                                      children: [
                                                        Expanded(child: Text(banList[i])),
                                                        const SizedBox(width: 8),
                                                        GestureDetector(
                                                          onTap: () async {
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
                                                                          '차단을 해제하시겠습니까?',
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
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  style: OutlinedButton.styleFrom(
                                                                                      side: const BorderSide(color: Colors.black26)
                                                                                  ),
                                                                                  child: const Text(
                                                                                    '아니오',
                                                                                    style: TextStyle(
                                                                                        color: Colors.black54,
                                                                                        fontWeight: FontWeight.bold
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(width: 8),
                                                                            Expanded(
                                                                              child: SizedBox(
                                                                                height: 47,
                                                                                child: ElevatedButton(
                                                                                  onPressed: () async {
                                                                                    String userEmail = user.email;
                                                                                    String partnerEmail = banList[i];
                                                                                    bool unblockSuccess = await context.read<UserServices>().unblockUser(userEmail, partnerEmail);
                                                                                    if (!mounted) return;
                                                                                    Navigator.pop(context);
                                                                                    if (unblockSuccess) {
                                                                                      setState((){
                                                                                        context.read<UserServices>().getUserInfo(user.email);
                                                                                      });
                                                                                      // showDialog(
                                                                                      //     barrierDismissible: false,
                                                                                      //     context: context,
                                                                                      //     builder: (context) {
                                                                                      //       return AlertDialog(
                                                                                      //         shape: RoundedRectangleBorder(
                                                                                      //             borderRadius: BorderRadius.circular(10)
                                                                                      //         ),
                                                                                      //         elevation: 0,
                                                                                      //         content: Column(
                                                                                      //           mainAxisSize: MainAxisSize.min,
                                                                                      //           children: [
                                                                                      //             const Text(
                                                                                      //               '차단 해제 완료',
                                                                                      //               style: TextStyle(color: Colors.black),
                                                                                      //             ),
                                                                                      //             const SizedBox(height: 16),
                                                                                      //             Row(
                                                                                      //               children: [
                                                                                      //                 Expanded(
                                                                                      //                   child: SizedBox(
                                                                                      //                     height: 47,
                                                                                      //                     child: OutlinedButton(
                                                                                      //                         onPressed: () {
                                                                                      //                           setState((){
                                                                                      //                             context.read<UserServices>().getUserInfo(user.email);
                                                                                      //                             print('dsfdsf');
                                                                                      //                           });
                                                                                      //                           Navigator.pop(context);
                                                                                      //                         },
                                                                                      //                         style: OutlinedButton.styleFrom(
                                                                                      //                             side: const BorderSide(color: Colors.black26)
                                                                                      //                         ),
                                                                                      //                         child: const Text(
                                                                                      //                           '확인',
                                                                                      //                           style: TextStyle(fontWeight: FontWeight.bold),
                                                                                      //                         )
                                                                                      //                     ),
                                                                                      //                   ),
                                                                                      //                 ),
                                                                                      //               ],
                                                                                      //             )
                                                                                      //           ],
                                                                                      //         ),
                                                                                      //       );
                                                                                      //     }
                                                                                      // );
                                                                                    } else {
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
                                                                                                  const Icon(
                                                                                                    Icons.warning_amber_rounded,
                                                                                                    color: Colors.black26,
                                                                                                    size: 80,
                                                                                                  ),
                                                                                                  const SizedBox(height: 8),
                                                                                                  const Text(
                                                                                                    '차단 해제 실패',
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
                                                                                                              onPressed: () {
                                                                                                                Navigator.pop(context);
                                                                                                              },
                                                                                                              style: OutlinedButton.styleFrom(
                                                                                                                  side: const BorderSide(color: Colors.black26)
                                                                                                              ),
                                                                                                              child: const Text(
                                                                                                                '확인',
                                                                                                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                                                                    }
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: Colors.black12
                                                                                  ),
                                                                                  child: const Text(
                                                                                    '예',
                                                                                    style: TextStyle(
                                                                                        color: Colors.black54,
                                                                                        fontWeight: FontWeight.bold
                                                                                    ),
                                                                                  ),
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
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: Colors.black26,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                const SizedBox(height: 8),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );
                        }
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black26)
                  ),
                  child: const Text(
                    '차단 사용자 관리',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                  height: 47,
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    elevation: 0,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          '비밀번호 변경',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _nowPWController,
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          cursorColor: Colors.black,
                                          style: const TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: '현재 비밀번호',
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
                                        TextField(
                                          controller: _newPWController,
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          cursorColor: Colors.black,
                                          style: const TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: '새 비밀번호',
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
                                            visible: _pwInvalid == true,
                                            child: const Column(
                                              children: [
                                                Text(
                                                  '비밀번호를 잘못 입력했습니다.',
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
                                                        _pwInvalid = false;
                                                        _nowPWController.clear();
                                                        _newPWController.clear();
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
                                                      if (_newPWController.text.isNotEmpty) {
                                                        String email = user.email;
                                                        String nowPW = _nowPWController.text;
                                                        String newPW = _newPWController.text;
                                                        bool changePWSuccess = await UserServices().changeUserPW(email, nowPW, newPW);
                                                        print(changePWSuccess);
                                                        if (changePWSuccess) {
                                                          if (!mounted) return;
                                                          Navigator.pop(context);
                                                          setState(() {
                                                            _pwInvalid = false;
                                                            _nowPWController.clear();
                                                            _newPWController.clear();
                                                          });
                                                          showDialog(
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
                                                                        '비밀번호 수정 완료',
                                                                        style: TextStyle(color: Colors.black),
                                                                      ),
                                                                      const Text(
                                                                        '다시 로그인 하세요.',
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
                                                                                    String email = user.email;
                                                                                    UserServices().logOut(email);
                                                                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LogInPage()), (route) => false);
                                                                                  },
                                                                                  style: OutlinedButton.styleFrom(
                                                                                    side: const BorderSide(color: Colors.black26)
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
                                                        } else {
                                                          setState(() {
                                                            _pwInvalid = true;
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
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black12
                      ),
                      child: const Text(
                          '비밀번호 변경',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold
                          ),
                      )
                  )
              ),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        String email = user.email;
                        UserServices().logOut(email);
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LogInPage()), (route) => false);
                      },
                      child: const Align(
                        child: Text(
                            '로그아웃',
                            textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  const SizedBox(
                      width: 32,
                      child: Text(
                          '|',
                          textAlign: TextAlign.center,
                      ),
                  ),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      elevation: 0,
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            '계정 삭제',
                                            style: TextStyle(
                                                color: Colors.redAccent,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          TextField(
                                            controller: _nowPWController,
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
                                          const SizedBox(height: 16),
                                          Visibility(
                                              visible: _pwInvalid == true,
                                              child: const Column(
                                                children: [
                                                  Text(
                                                    '비밀번호를 잘못 입력했습니다.',
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
                                                          _pwInvalid = false;
                                                          _nowPWController.clear();
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      style: OutlinedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
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
                                                        String email = user.email;
                                                        String pw = _nowPWController.text;
                                                        bool deleteSuccess = await UserServices().deleteUser(email, pw);
                                                        if (deleteSuccess) {
                                                          setState(() {
                                                            _pwInvalid = false;
                                                            _nowPWController.clear();
                                                          });
                                                          if (!mounted) return;
                                                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LogInPage()), (route) => false);
                                                          showDialog(
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
                                                                          '계정이 삭제되었습니다.',
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
                                                                                  },
                                                                                  style: OutlinedButton.styleFrom(
                                                                                      side: const BorderSide(color: Colors.black26)
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
                                                        } else {
                                                          setState(() {
                                                            _pwInvalid = true;
                                                          });
                                                        }
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.redAccent
                                                      ),
                                                      child: const Text(
                                                        '확인',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold
                                                        ),
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
                        );
                      },
                      child: const Align(
                        child: Text(
                          '계정 삭제',
                          style: TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
