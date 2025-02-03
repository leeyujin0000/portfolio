import 'package:flutter/material.dart';
import 'package:laundry/services/post_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:provider/provider.dart';

class PostEditPage extends StatefulWidget {
  final Post myPost;

  const PostEditPage({super.key, required this.myPost});

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messageController.text = widget.myPost.message;
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  bool _invalid = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('구인글 수정'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (widget.myPost.colorTypes.isEmpty ||
                    widget.myPost.weight == '' ||
                    widget.myPost.machineTypes.isEmpty ||
                    _messageController.text.isEmpty) {
                  setState(() {
                    _invalid = true;
                  });
                }
                else {
                  setState(() {
                    _invalid = false;
                  });
                  String email = context.read<UserServices>().user.email;
                  String id = widget.myPost.id;
                  List<String> colorTypes = widget.myPost.colorTypes;
                  String weight = widget.myPost.weight;
                  List<String> machineTypes = widget.myPost.machineTypes;
                  String extraInfoType = widget.myPost.extraInfoType;
                  String message = _messageController.text;
                  bool updateSuccess = await context.read<PostServices>().updatePost(
                      email, id, colorTypes, weight, machineTypes,
                      extraInfoType, message
                  );
                  if (updateSuccess) {
                    if(!mounted) return;
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '구인글 수정 완료',
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
                                    ),
                                  ],
                                )
                              ],
                            ),
                            elevation: 0,
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
                                  '구인글 수정 실패',
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
                '수정',
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
                    widget.myPost.laundryName,
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
                                backgroundColor: widget.myPost.gender == 'm' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.5,
                                    vertical: 8
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)
                                )
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
                                backgroundColor: widget.myPost.gender == 'f' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.5,
                                    vertical: 8
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
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
                                if (!widget.myPost.colorTypes.contains('WHITE')) {
                                  widget.myPost.colorTypes.add('WHITE');
                                } else {
                                  widget.myPost.colorTypes.removeWhere((element) => element == '흰색');
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: widget.myPost.colorTypes.contains('WHITE') ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
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
                                  if (!widget.myPost.colorTypes.contains('COLORED')) {
                                    widget.myPost.colorTypes.add('COLORED');
                                  } else {
                                    widget.myPost.colorTypes.removeWhere((element) => element == '유색');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: widget.myPost.colorTypes.contains('COLORED') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
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
                                  if (!widget.myPost.colorTypes.contains('BLUE')) {
                                    widget.myPost.colorTypes.add('BLUE');
                                  } else {
                                    widget.myPost.colorTypes.removeWhere((element) => element == '청');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: widget.myPost.colorTypes.contains('BLUE') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.5,
                                      vertical: 8
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
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
                                widget.myPost.weight = 'LIGHT';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: widget.myPost.weight == 'LIGHT' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
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
                                widget.myPost.weight = 'HEAVY';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: widget.myPost.weight == 'HEAVY' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
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
                                  if (!widget.myPost.machineTypes.contains('WASH')) {
                                    widget.myPost.machineTypes.add('WASH');
                                  } else {
                                    widget.myPost.machineTypes.removeWhere((element) => element == 'WASH');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: widget.myPost.machineTypes.contains('WASH') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
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
                                  if (!widget.myPost.machineTypes.contains('DRY')) {
                                    widget.myPost.machineTypes.add('DRY');
                                  } else {
                                    widget.myPost.machineTypes.removeWhere((element) => element == 'DRY');
                                  }
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: widget.myPost.machineTypes.contains('DRY') ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
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
                                widget.myPost.extraInfoType = 'ALLERGY';
                              });
                            },
                            style: OutlinedButton.styleFrom(
                                backgroundColor: widget.myPost.extraInfoType == 'ALLERGY' ? Colors.black12 : Colors.transparent,
                                side: const BorderSide(color: Colors.black26),
                                minimumSize: Size.zero,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                )
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
                                  widget.myPost.extraInfoType = 'ETC';
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: widget.myPost.extraInfoType == 'ETC' ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
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
                                  widget.myPost.extraInfoType = 'NOTHING';
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: widget.myPost.extraInfoType == 'NOTHING' ? Colors.black12 : Colors.transparent,
                                  side: const BorderSide(color: Colors.black26),
                                  minimumSize: Size.zero,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              child: const Text(
                                  '없음',
                                  style: TextStyle(color: Colors.black54)
                              )
                          )
                        ],
                      )
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
