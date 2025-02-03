import 'package:flutter/material.dart';
import 'package:laundry/services/matching_services.dart';
import 'package:laundry/services/post_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchingPage extends StatefulWidget {
  const MatchingPage({super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {

  String email = '';

  @override
  void initState() {
    super.initState();
    email = context.read<UserServices>().user.email;
    context.read<MatchingServices>().getMatchingList(email).then((_){
      print('MatchingPageReady');
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Matching> matchingList = context.watch<MatchingServices>().matchingList;

    return Scaffold(
      appBar: AppBar(
        title: const Text('매칭'),
        automaticallyImplyLeading: false,
        titleSpacing: 16.0,
      ),
      body: Column(
        children: [
          Visibility(
              visible: matchingList.isEmpty,
              child: const Expanded(
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.people_outline,
                            color: Colors.black12,
                            size: 80,
                        ),
                        SizedBox(height: 8),
                        Text('매칭된 상대가 없습니다.')
                      ],
                  ),
                ),
              )
          ),
          Visibility(
            visible: matchingList.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                  itemCount: matchingList.length,
                  itemBuilder: (context, index) {
                    Matching matching = matchingList[index];
                    String partnerEmail = MatchingServices().partnerText(matching.users, email);
                    return ListTile(
                      title: GestureDetector(
                        onLongPress: (){
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
                                        '해당 사용자를 차단하시겠습니까?',
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
                                                  '뒤로',
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
                                                  bool blockSuccess = await context.read<UserServices>().blockUser(email, partnerEmail);
                                                  if (!mounted) return;
                                                  Navigator.pop(context);
                                                  if (blockSuccess) {
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
                                                                  '차단 완료',
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
                                                                              setState(() {
                                                                                context.read<MatchingServices>().deleteMatching(email, matching.id);
                                                                              });
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
                                                                  '차단 실패',
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
                                                  '차단',
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
                        child: Text(
                          partnerEmail,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                          ),
                        ),
                      ),
                      leading: const Icon(
                        Icons.account_circle,
                        color: Colors.black26,
                        size: 40,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton(
                              onPressed: () {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        elevation: 0,
                                        child: SizedBox(
                                          width: 300,
                                          height: 350,
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: const BoxDecoration(
                                                    border: Border(bottom: BorderSide(color: Colors.black12))
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Stack(
                                                        children: [
                                                          const Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              '상세 정보',
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
                                                              )
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(16),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            matching.laundryRequest.laundryName,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 16),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons.account_circle,
                                                                color: Colors.black26,
                                                                size: 30,
                                                              ),
                                                              const SizedBox(width: 8),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        matching.laundryRequest.email,
                                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Visibility(
                                                                        visible: matching.laundryRequest.email == email,
                                                                        child: const Text(
                                                                          ' (나)',
                                                                          style: TextStyle(fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    matching.laundryRequest.date.substring(0, 10),
                                                                    style: const TextStyle(color: Colors.black26),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  '성별',
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Text(
                                                                  UserServices().genderText(
                                                                      matching.laundryRequest.gender
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  '세탁물 색상',
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Text(
                                                                  PostServices().colorTypesText(
                                                                      matching.laundryRequest.colorTypes
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  '세탁물 무게',
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Text(
                                                                  PostServices().weightText(
                                                                      matching.laundryRequest.weight
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  '사용 기기',
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Text(
                                                                  PostServices().machineTypesText(
                                                                      matching.laundryRequest.machineTypes
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 100,
                                                                child: Text(
                                                                  '특이 사항',
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Text(
                                                                  PostServices().extraInfoTypeText(
                                                                      matching.laundryRequest.extraInfoType
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(height: 8),
                                                          Text(matching.laundryRequest.message),
                                                          const SizedBox(height: 16),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: SizedBox(
                                                                  height: 47,
                                                                  child: ElevatedButton(
                                                                      onPressed: () {
                                                                        launchUrl(Uri.parse(matching.url));
                                                                      },
                                                                      style: ElevatedButton.styleFrom(
                                                                          backgroundColor: Colors.orangeAccent
                                                                      ),
                                                                      child: const Text(
                                                                        '오픈채팅방',
                                                                        style: TextStyle(
                                                                            color: Colors.white,
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
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                              },
                              child: const Text(
                                '상세',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                              onPressed: () {
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
                                            const Text(
                                              '매칭을 해지하시겠습니까?',
                                              style: TextStyle(color: Colors.black),
                                            ),
                                            const SizedBox(height: 16),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
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
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black54
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
                                                          bool deleteSuccess = await context.read<MatchingServices>().deleteMatching(
                                                              email, matching.id
                                                          );
                                                          if(!mounted) return;
                                                          Navigator.pop(context);
                                                          if (deleteSuccess) {
                                                            print('deleteSuccess');
                                                          } else {
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
                                                                          '매칭 삭제 실패',
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
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.black12
                                                        ),
                                                        child: const Text(
                                                          '예',
                                                          style: TextStyle(
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.bold,
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
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black12
                              ),
                              child: const Text(
                                '해지',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold
                                ),
                              )
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
