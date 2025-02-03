import 'package:flutter/material.dart';
import 'package:laundry/services/post_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final String laundryId;
  final String laundryName;

  const PostPage({super.key, required this.laundryId, required this.laundryName});

  @override
  State<PostPage> createState() => _PostPageState();
}

enum ExpireDay {two, three, five}

class _PostPageState extends State<PostPage> {

  ExpireDay _selectedExpireDay = ExpireDay.two;

  final List<String> _colorTypes = [];
  String _weight = '';
  final List<String> _machineTypes = [];
  String _extraInfoType = '';
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  bool _invalid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('구인글 작성'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (_colorTypes.isEmpty ||
                    _weight == '' ||
                    _machineTypes.isEmpty ||
                    _extraInfoType == ''||
                    _messageController.text.isEmpty) {
                  setState(() {
                    _invalid = true;
                  });
                }
                else {
                  setState(() {
                    _invalid = false;
                  });
                  String gender = context.read<UserServices>().user.sex;
                  String laundryId = widget.laundryId;
                  String email = context.read<UserServices>().user.email;
                  List<String> colorTypes = _colorTypes;
                  String weight = _weight;
                  List<String> machineTypes = _machineTypes;
                  String extraInfoType = _extraInfoType;
                  String message = _messageController.text;
                  int expireDay = 2;
                  switch (_selectedExpireDay) {
                    case ExpireDay.two: expireDay = 2; break;
                    case ExpireDay.three: expireDay = 3; break;
                    case ExpireDay.five: expireDay = 5; break;
                    default: expireDay = 2; break;
                  }
                  bool postSuccess = await context.read<PostServices>().createPost(
                      gender, laundryId, email, colorTypes,
                      weight, machineTypes, extraInfoType, message, expireDay
                  );
                  if (postSuccess) {
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
                                  Icons.sticky_note_2_outlined,
                                  size: 80,
                                  color: Colors.orangeAccent,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '구인글 업로드 완료',
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
                                    )
                                  ],
                                )
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
                                  color: Colors.black26,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  '구인글 업로드 실패',
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
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent
              ),
              child: const Text(
                '올리기',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12)
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: _invalid == true,
                    child: const Column(
                      children: [
                        Text(
                          '각 항목에 1개 이상 선택하고 구인글을 1자 이상 작성해주세요.',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Text(
                    widget.laundryName,
                    style: const TextStyle(color: Colors.black26),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(
                          width: 100,
                          child: Text('성별',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: (){},
                            style: OutlinedButton.styleFrom(
                                backgroundColor: context.read<UserServices>().user.sex == 'm' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.5,
                                    vertical: 8
                                ),
                            ),
                            child: const Text(
                                '남',
                                style: TextStyle(color: Colors.black54)
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: (){},
                            style: OutlinedButton.styleFrom(
                                backgroundColor: context.read<UserServices>().user.sex == 'f' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.5,
                                    vertical: 8
                                ),
                            ),
                            child: const Text(
                                '여',
                                style: TextStyle(color: Colors.black54)
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          '세탁물 색상',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: (){
                              setState(() {
                                if (!_colorTypes.contains('WHITE')) {
                                  _colorTypes.add('WHITE');
                                } else {
                                  _colorTypes.removeWhere((element) => element == 'WHITE');
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: _colorTypes.contains('WHITE') ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8
                                ),
                            ),
                            child: const Text(
                                '흰색',
                                style: TextStyle(color: Colors.black54)
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  if (!_colorTypes.contains('COLORED')) {
                                    _colorTypes.add('COLORED');
                                  } else {
                                    _colorTypes.removeWhere((element) => element == 'COLORED');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: _colorTypes.contains('COLORED') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                              ),
                              child: const Text(
                                  '유색',
                                  style: TextStyle(color: Colors.black54)
                              )
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  if (!_colorTypes.contains('BLUE')) {
                                    _colorTypes.add('BLUE');
                                  } else {
                                    _colorTypes.removeWhere((element) => element == 'BLUE');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: _colorTypes.contains('BLUE') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.5,
                                      vertical: 8
                                  ),
                              ),
                              child: const Text(
                                  '청',
                                  style: TextStyle(color: Colors.black54)
                              )
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                          width: 100,
                          child: Text(
                            '세탁물 무게',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: (){
                              setState(() {
                                _weight = 'LIGHT';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: _weight == 'LIGHT' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8
                                ),
                            ),
                            child: const Text(
                                '가벼움',
                                style: TextStyle(color: Colors.black54)
                            ),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: (){
                              setState(() {
                                _weight = 'HEAVY';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: _weight == 'HEAVY' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8
                                ),
                            ),
                            child: const Text(
                                '무거움',
                                style: TextStyle(color: Colors.black54)
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                          width: 100,
                          child: Text(
                            '사용 기기',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                          )
                      ),
                      Row(
                        children: [
                          OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  if (!_machineTypes.contains('WASH')) {
                                    _machineTypes.add('WASH');
                                  } else {
                                    _machineTypes.removeWhere((element) => element == 'WASH');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: _machineTypes.contains('WASH') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                              ),
                              child: const Text(
                                  '세탁기',
                                  style: TextStyle(color: Colors.black54)
                              )
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                              onPressed: (){
                                setState(() {
                                  if (!_machineTypes.contains('DRY')) {
                                    _machineTypes.add('DRY');
                                  } else {
                                    _machineTypes.removeWhere((element) => element == 'DRY');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: _machineTypes.contains('DRY') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                              ),
                              child: const Text(
                                  '건조기',
                                  style: TextStyle(color: Colors.black54)
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Text(
                                '특이 사항',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: (){
                                    setState(() {
                                      _extraInfoType = 'ALLERGY';
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: _extraInfoType == 'ALLERGY' ? Colors.black12 : Colors.transparent,
                                      side: const BorderSide(color: Colors.black26),
                                      minimumSize: Size.zero,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8
                                      ),
                                  ),
                                  child: const Text(
                                      '동물 털 알러지',
                                      style: TextStyle(color: Colors.black54)
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                    onPressed: (){
                                      setState(() {
                                        _extraInfoType = 'ETC';
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: _extraInfoType == 'ETC' ? Colors.black12 : Colors.transparent,
                                        side: const BorderSide(color: Colors.black26),
                                        minimumSize: Size.zero,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8
                                        ),
                                    ),
                                    child: const Text(
                                        '기타',
                                        style: TextStyle(color: Colors.black54)
                                    )
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                    onPressed: (){
                                      setState(() {
                                        _extraInfoType = 'NOTHING';
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                        backgroundColor: _extraInfoType == 'NOTHING' ? Colors.black12 : Colors.transparent,
                                        side: const BorderSide(color: Colors.black26),
                                        minimumSize: Size.zero,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8
                                        ),
                                    ),
                                    child: const Text(
                                        '없음',
                                        style: TextStyle(color: Colors.black54)
                                    )
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          '글 삭제',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Radio(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: ExpireDay.two,
                          groupValue: _selectedExpireDay,
                          onChanged: (value) {
                            setState(() {
                              _selectedExpireDay = value!;
                            });
                          },
                      ),
                      const Text('2일 후'),
                      const SizedBox(width: 8),
                      Radio(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: ExpireDay.three,
                          groupValue: _selectedExpireDay,
                          onChanged: (value) {
                            setState(() {
                              _selectedExpireDay = value!;
                            });
                          },
                      ),
                      const Text('3일 후'),
                      const SizedBox(width: 8),
                      Radio(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: ExpireDay.five,
                          groupValue: _selectedExpireDay,
                          onChanged: (value) {
                            setState(() {
                              _selectedExpireDay = value!;
                            });
                          },
                      ),
                      const Text('5일 후')
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '※ 속옷이나 반려동물 용품은 공동 세탁을 삼가주시길 바랍니다.',
                    style: TextStyle(color: Colors.black26),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _messageController,
                maxLines: 10,
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                    hintText: '구인글을 작성해주세요.',
                    hintStyle: TextStyle(color: Colors.black26),
                    border: InputBorder.none
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
