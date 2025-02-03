import 'package:flutter/material.dart';
import 'package:laundry/post/post_edit_page.dart';
import 'package:laundry/services/post_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:provider/provider.dart';

class MyPostsPage extends StatefulWidget {

  const MyPostsPage({super.key});

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {

  String email = '';

  @override
  void initState() {
    super.initState();
    email = context.read<UserServices>().user.email;
    context.read<PostServices>().getMyPosts(email).then((_){
      print('MyPostsPageReady');
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Post> myPosts = context.watch<PostServices>().myPosts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 구인글'),
        automaticallyImplyLeading: false,
        titleSpacing: 16.0,
      ),
      body: Column(
        children: [
          Visibility(
            visible: myPosts.isEmpty,
              child: const Expanded(
                child:
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            Icons.sticky_note_2_outlined,
                            color: Colors.black12,
                            size: 80,
                        ),
                        SizedBox(height: 8),
                        Text('작성한 구인글이 없습니다.')
                      ],
                    ),
                  ),
              )
          ),
          Visibility(
            visible: myPosts.isNotEmpty,
            child: Expanded(
              child: ListView.builder(
                  itemCount: myPosts.length,
                  itemBuilder: (context, index) {
                    Post myPost = myPosts[index];
                    return Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16,
                          top: 8, bottom: 16
                      ),
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.black12))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: myPost.matched == true,
                            child: const SizedBox(height: 8),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myPost.laundryName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      myPost.date.substring(0, 10),
                                      style: const TextStyle(color: Colors.black26),
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: myPost.matched == false,
                                child: Row(
                                  children: [
                                    OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => PostEditPage(
                                                  myPost: myPost
                                              )
                                          ));
                                        },
                                        child: const Text(
                                          '수정',
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
                                                        '구인글을 삭제하시겠습니까?',
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
                                                                    '아니오',
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
                                                                    bool deleteSuccess = await context.read<PostServices>().deletePost(
                                                                        email, context.read<PostServices>().myPosts[index].id
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
                                                                                    '구인글 삭제 실패',
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
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black12
                                        ),
                                        child: const Text(
                                          '삭제',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: myPost.matched == true,
                                child: const Icon(
                                  Icons.people,
                                  color: Colors.orangeAccent,
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const SizedBox(
                                  width: 90,
                                  child: Text(
                                    '세탁물 색상',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                              ),
                              Text(PostServices().colorTypesText(myPost.colorTypes))
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                  width: 90,
                                  child: Text(
                                    '세탁물 무게',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                              ),
                              Text(PostServices().weightText(myPost.weight))
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                  width: 90,
                                  child: Text(
                                    '사용 기기',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                              ),
                              Text(PostServices().machineTypesText(myPost.machineTypes))
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                  width: 90,
                                  child: Text(
                                    '특이 사항',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )
                              ),
                              Text(PostServices().extraInfoTypeText(myPost.extraInfoType))
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(myPost.message)
                        ],
                      ),
                    );
                  }
              ),
            ),
          ),
        ],
      )
    );
  }
}