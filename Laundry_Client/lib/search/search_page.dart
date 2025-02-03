import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:laundry/post/post_page.dart';
import 'package:laundry/services/matching_services.dart';
import 'package:laundry/services/map_services.dart';
import 'package:laundry/services/notification_services.dart';
import 'package:laundry/services/post_services.dart';
import 'package:laundry/services/user_services.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<String> setMap() async {
    await context.read<MapServices>().getLaundries();
    if (!mounted) return '';
    context.read<MapServices>().getLaundryMarkers();
    return 'ready';
  }

  String email = '';
  NLatLng userLocation = const NLatLng(0, 0);
  List<Laundry> laundries = [];
  Set<NMarker> laundryMarkers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('탐색'),
        automaticallyImplyLeading: false,
        titleSpacing: 16,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
              icon: const Icon(Icons.home_outlined)
          ),
        ],
      ),
      body: FutureBuilder(
          future: setMap(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              email = context.read<UserServices>().user.email;
              userLocation = context.read<MapServices>().userLocation;
              laundries = context.read<MapServices>().laundries;
              laundryMarkers = context.read<MapServices>().laundryMarkers;
              //print(laundries[0].name);
              return NaverMap(
                options: NaverMapViewOptions(
                    initialCameraPosition: NCameraPosition(
                      target: userLocation,
                      zoom: 16,
                    ),
                    minZoom: 10,
                    maxZoom: 20,
                    locationButtonEnable: true
                ),
                onMapReady: (controller) async {
                  final NLocationOverlay myLocation = await controller.getLocationOverlay();
                  myLocation.setIsVisible(true);
                  final Set<NMarker> markers = laundryMarkers;
                  controller.addOverlayAll(markers);
                  for (var marker in markers) {
                    marker.setOnTapListener((overlay) async {
                      int laundryIndex = laundries.indexWhere((e) => e.id == marker.info.id);
                      Laundry laundry = laundries[laundryIndex];
                      print(laundry.id);
                      await context.read<PostServices>().getLaundryPosts(laundry.id, email);
                      controller.updateCamera(NCameraUpdate.withParams(
                          target: NLatLng(
                              marker.position.latitude-0.001,
                              marker.position.longitude
                          ),
                          zoom: 17
                      ));
                      if (!mounted) return;
                      showModalBottomSheet(
                          isScrollControlled: true,
                          barrierColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black26),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            List<Post> laundryPosts = context.watch<PostServices>().laundryPosts;
                            return StatefulBuilder(
                                builder: (context, setState) {
                                  return SizedBox(
                                    height: 500,
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8
                                          ),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(color: Colors.black12)
                                              )
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      laundry.name,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      // OutlinedButton(
                                                      //     onPressed: (){
                                                      //       showDialog(
                                                      //           barrierDismissible: false,
                                                      //           context: context,
                                                      //           builder: (context) {
                                                      //             return Dialog(
                                                      //               shape: RoundedRectangleBorder(
                                                      //                   borderRadius: BorderRadius.circular(10)
                                                      //               ),
                                                      //               elevation: 0,
                                                      //               child: SizedBox(
                                                      //                 width: 300,
                                                      //                 height: 300,
                                                      //                 child: Column(
                                                      //                   children: [
                                                      //                     Padding(
                                                      //                       padding: const EdgeInsets.all(8),
                                                      //                       child: Align(
                                                      //                         alignment: Alignment.centerRight,
                                                      //                         child: GestureDetector(
                                                      //                           onTap: () {
                                                      //                             Navigator.pop(context);
                                                      //                           },
                                                      //                           child: const Icon(
                                                      //                             Icons.close,
                                                      //                             color: Colors.black54,
                                                      //                           ),
                                                      //                         ),
                                                      //                       ),
                                                      //                     ),
                                                      //                     Expanded(
                                                      //                       child: ListView(
                                                      //                         children: [
                                                      //                           Padding(
                                                      //                             padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                                      //                             child: Column(
                                                      //                               children: [
                                                      //                                 Container(
                                                      //                                   decoration: const BoxDecoration(
                                                      //                                       border: Border(bottom: BorderSide(color: Colors.black12))
                                                      //                                   ),
                                                      //                                   child: Column(
                                                      //                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                                     children: [
                                                      //                                       Text(
                                                      //                                         laundry.name,
                                                      //                                         style: const TextStyle(
                                                      //                                             color: Colors.black,
                                                      //                                             fontSize: 20,
                                                      //                                             fontWeight: FontWeight.bold
                                                      //                                         ),
                                                      //                                       ),
                                                      //                                       const SizedBox(height: 8),
                                                      //                                       Row(
                                                      //                                         children: [
                                                      //                                           const Icon(
                                                      //                                             Icons.place,
                                                      //                                             color: Colors.black54,
                                                      //                                           ),
                                                      //                                           const SizedBox(width: 4),
                                                      //                                           Expanded(
                                                      //                                               child: Text(laundry.address)
                                                      //                                           )
                                                      //                                         ],
                                                      //                                       ),
                                                      //                                       const SizedBox(height: 16),
                                                      //                                     ],
                                                      //                                   ),
                                                      //                                 ),
                                                      //                                 const SizedBox(height: 16),
                                                      //                                 Row(
                                                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                                   children: [
                                                      //                                     const Icon(
                                                      //                                       Icons.access_time,
                                                      //                                       color: Colors.black54,
                                                      //                                     ),
                                                      //                                     const SizedBox(width: 8),
                                                      //                                     Column(
                                                      //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                                       children: [
                                                      //                                         for (int i = 0; i < laundry.hours.length; i++)
                                                      //                                           Text(laundry.hours[i]),
                                                      //                                       ],
                                                      //                                     )
                                                      //                                   ],
                                                      //                                 ),
                                                      //                                 const SizedBox(height: 16),
                                                      //                                 Row(
                                                      //                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                                   children: [
                                                      //                                     const Padding(
                                                      //                                       padding: EdgeInsets.symmetric(horizontal: 4),
                                                      //                                       child: Text('₩', style: TextStyle(fontSize: 20)),
                                                      //                                     ),
                                                      //                                     const SizedBox(width: 8),
                                                      //                                     Column(
                                                      //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                      //                                       children: [
                                                      //                                         for (int i = 0; i < laundry.fees.length; i++)
                                                      //                                           Text(laundry.fees[i]),
                                                      //                                       ],
                                                      //                                     )
                                                      //                                   ],
                                                      //                                 ),
                                                      //                               ],
                                                      //                             ),
                                                      //                           )
                                                      //                         ],
                                                      //                       ),
                                                      //                     ),
                                                      //                   ],
                                                      //                 ),
                                                      //               ),
                                                      //             );
                                                      //           }
                                                      //       );
                                                      //     },
                                                      //     child: const Text(
                                                      //       '상세',
                                                      //       style: TextStyle(fontWeight: FontWeight.bold),
                                                      //     )
                                                      // ),
                                                      // const SizedBox(width: 8),
                                                      ElevatedButton(
                                                        onPressed: (){
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(
                                                              laundryId: laundry.id, laundryName: laundry.name
                                                          )));
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.orangeAccent,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10)
                                                          ),
                                                        ),
                                                        child: const Text(
                                                          '구인',
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.place,
                                                    color: Colors.black54,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(child: Text(laundry.roadAddress))
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.access_time_outlined,
                                                    color: Colors.black54,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Expanded(child: Text(laundry.time ?? '정보 없음'))
                                                ],
                                              ),
                                              const SizedBox(height: 8)
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                            visible: laundryPosts.isEmpty,
                                            child: const Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.sticky_note_2_outlined,
                                                    color: Colors.black12,
                                                    size: 80,
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text('구인글이 없습니다.'),
                                                ],
                                              ),
                                            )
                                        ),
                                        Visibility(
                                          visible: laundryPosts.isNotEmpty,
                                          child: Expanded(
                                            child: ListView.builder(
                                              itemCount: laundryPosts.length,
                                              itemBuilder: (context, index) {
                                                Post laundryPost = laundryPosts[index];
                                                return Container(
                                                  padding: const EdgeInsets.only(
                                                      left:16, right: 16,
                                                      top: 8, bottom: 16
                                                  ),
                                                  decoration: const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide(color: Colors.black12)
                                                      )
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Visibility(
                                                          visible: laundryPost.email == email,
                                                          child: const SizedBox(height: 8)
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
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
                                                                        laundryPost.email,
                                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                                      ),
                                                                      Visibility(
                                                                          visible: laundryPost.email == email,
                                                                          child: const Text(
                                                                            ' (나)',
                                                                            style: TextStyle(fontWeight: FontWeight.bold),
                                                                          )
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Text(
                                                                    laundryPost.date.substring(0, 10),
                                                                    style: const TextStyle(color: Colors.black26),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          Visibility(
                                                            visible: laundryPost.email != email,
                                                            child: OutlinedButton(
                                                                onPressed: () {
                                                                  if (laundryPost.email != email) {
                                                                    showDialog(
                                                                        barrierDismissible: false,
                                                                        context: context,
                                                                        builder: (context) {
                                                                          return AlertDialog(
                                                                            elevation: 0,
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10)
                                                                            ),
                                                                            content: Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                const Text(
                                                                                  '글쓴이의 세탁물 정보를 확인했고,',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                                const Text(
                                                                                  '함께 세탁해도 문제가 없다는',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                                const Text(
                                                                                  '전제 하에 보내는 요청입니다.',
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                                const SizedBox(height: 8),
                                                                                const Text(
                                                                                  '요청을 보내시겠습니까?',
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
                                                                                            onPressed: () {
                                                                                              Navigator.pop(context);
                                                                                              showDialog(
                                                                                                  barrierDismissible: false,
                                                                                                  context: context,
                                                                                                  builder: (context) {
                                                                                                    return AlertDialog(
                                                                                                      elevation: 0,
                                                                                                      shape: RoundedRectangleBorder(
                                                                                                          borderRadius: BorderRadius.circular(10)
                                                                                                      ),
                                                                                                      content: Column(
                                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                                        children: [
                                                                                                          const Text(
                                                                                                            '상대방과 대화할 오픈채팅방을',
                                                                                                            style: TextStyle(color: Colors.black),
                                                                                                          ),
                                                                                                          const Text(
                                                                                                            '만들어주세요.',
                                                                                                            style: TextStyle(color: Colors.black),
                                                                                                          ),
                                                                                                          const SizedBox(height: 16),
                                                                                                          TextField(
                                                                                                            controller: _urlController,
                                                                                                            keyboardType: TextInputType.text,
                                                                                                            cursorColor: Colors.black,
                                                                                                            style: const TextStyle(color: Colors.black),
                                                                                                            decoration: InputDecoration(
                                                                                                              hintText: '오픈채팅방 링크',
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
                                                                                                          Row(
                                                                                                            children: [
                                                                                                              Expanded(
                                                                                                                child: SizedBox(
                                                                                                                  height: 47,
                                                                                                                  child: OutlinedButton(
                                                                                                                      onPressed: () {
                                                                                                                        Navigator.pop(context);
                                                                                                                      },
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
                                                                                                                        if (_urlController.text.isNotEmpty) {
                                                                                                                          String requestId = laundryPost.id;
                                                                                                                          String nowEmail = email;
                                                                                                                          String openChatUrl = _urlController.text;
                                                                                                                          bool requestSuccess = await context.read<MatchingServices>().createMatching(
                                                                                                                              laundry.id, nowEmail, requestId, openChatUrl
                                                                                                                          );
                                                                                                                          if(!mounted) return;
                                                                                                                          Navigator.pop(context);
                                                                                                                          if (requestSuccess) {
                                                                                                                            showDialog(
                                                                                                                                barrierDismissible: false,
                                                                                                                                context: context,
                                                                                                                                builder: (context) {
                                                                                                                                  return AlertDialog(
                                                                                                                                    elevation: 0,
                                                                                                                                    shape: RoundedRectangleBorder(
                                                                                                                                        borderRadius: BorderRadius.circular(10)
                                                                                                                                    ),
                                                                                                                                    content: Column(
                                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                                      children: [
                                                                                                                                        const Icon(
                                                                                                                                          Icons.people_outline,
                                                                                                                                          size: 80,
                                                                                                                                          color: Colors.orangeAccent,
                                                                                                                                        ),
                                                                                                                                        const SizedBox(height: 8),
                                                                                                                                        const Text(
                                                                                                                                          '매칭 완료',
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
                                                                                                                                                      setState((){
                                                                                                                                                        context.read<PostServices>().getLaundryPosts(laundry.id, email);
                                                                                                                                                      });
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
                                                                                                                            showDialog(
                                                                                                                                barrierDismissible: false,
                                                                                                                                context: context,
                                                                                                                                builder: (context) {
                                                                                                                                  return AlertDialog(
                                                                                                                                    elevation: 0,
                                                                                                                                    shape: RoundedRectangleBorder(
                                                                                                                                        borderRadius: BorderRadius.circular(10)
                                                                                                                                    ),
                                                                                                                                    content: Column(
                                                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                                                      children: [
                                                                                                                                        const Icon(
                                                                                                                                          Icons.close,
                                                                                                                                          size: 80,
                                                                                                                                          color: Colors.black26,
                                                                                                                                        ),
                                                                                                                                        const SizedBox(height: 8),
                                                                                                                                        const Text(
                                                                                                                                          '매칭 실패',
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
                                                                                                                          }
                                                                                                                        }
                                                                                                                      },
                                                                                                                      style: ElevatedButton.styleFrom(
                                                                                                                          backgroundColor: Colors.orangeAccent
                                                                                                                      ),
                                                                                                                      child: const Text(
                                                                                                                        '매칭 요청',
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
                                                                                                    );
                                                                                                  }
                                                                                              );
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
                                                                                )
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }
                                                                    );
                                                                  }
                                                                },
                                                                style: OutlinedButton.styleFrom(
                                                                    side: const BorderSide(color: Colors.orangeAccent),
                                                                    backgroundColor: Colors.transparent
                                                                ),
                                                                child: const Text(
                                                                  '요청',
                                                                  style: TextStyle(
                                                                    color: Colors.orangeAccent,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                              width: 90,
                                                              child: Text(
                                                                '성별',
                                                                style: TextStyle(fontWeight: FontWeight.bold),
                                                              )
                                                          ),
                                                          Text(UserServices().genderText(laundryPost.gender))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 90,
                                                            child: Text(
                                                              '세탁물 색상',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                          Text(PostServices().colorTypesText(laundryPost.colorTypes))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 90,
                                                            child: Text(
                                                              '세탁물 무게',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                              PostServices().weightText(laundryPost.weight)
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 90,
                                                            child: Text(
                                                              '사용 기기',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                          Text(PostServices().machineTypesText(laundryPost.machineTypes))
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                            width: 90,
                                                            child: Text(
                                                              '특이 사항',
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                          Text(PostServices().extraInfoTypeText(laundryPost.extraInfoType))
                                                        ],
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(laundryPost.message),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                            );
                          }
                      );
                    });
                  }
                },
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.orangeAccent)
              );
            }
          }
      )
    );
  }
}
