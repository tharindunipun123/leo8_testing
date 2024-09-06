// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter_application_1/pages/group/MemberProfile.dart';
// //import 'package:zego_zimkit/zego_zimkit.dart';
//
// class GroupMembersPage extends StatelessWidget {
//   final String groupID;
//   final String myId;
//   const GroupMembersPage({Key? key, required this.groupID, required this.myId})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group Members'),
//       ),
//       body: _buildMemberList(context, groupID),
//     );
//   }
//
//   // Widget _buildMemberList(BuildContext context, String groupID) {
//   //   return ValueListenableBuilder<List<ZIMGroupMemberInfo>>(
//   //     valueListenable: ZIMKit().queryGroupMemberList(groupID),
//   //     builder: (context, memberList, _) {
//   //       if (memberList.isEmpty) {
//   //         return Center(child: Text('No members found.'));
//   //       }
//   //       return ListView.separated(
//   //         padding: const EdgeInsets.all(10),
//   //         separatorBuilder: (context, index) =>
//   //             const Divider(color: Colors.transparent),
//   //         itemCount: memberList.length,
//   //         itemBuilder: (context, index) {
//   //           final memberItem = memberList[index];
//   //           final memberItemName = memberItem.memberNickname.isNotEmpty
//   //               ? memberItem.memberNickname
//   //               : memberItem.userName;
//   //
//   //           return GestureDetector(
//   //             onTap: () async {
//   //               Navigator.push(
//   //                 context,
//   //                 MaterialPageRoute(
//   //                     builder: (context) => MemberProfile(
//   //                           userId: memberItem.userID,
//   //                           myId: myId,
//   //                         )),
//   //               );
//   //               debugPrint('Clicked member: ${memberItem.userID}');
//   //             },
//   //             child: Row(
//   //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //               children: [
//   //                 Row(
//   //                   children: [
//   //                     _memberAvatar(memberItem, memberItemName),
//   //                     const SizedBox(width: 10),
//   //                     _memberInfo(memberItem, memberItemName),
//   //                   ],
//   //                 ),
//   //                 _memberMenu(context, memberItem, groupID),
//   //               ],
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   );
//   // }
//   //
//   // Widget _memberAvatar(ZIMGroupMemberInfo memberItem, String memberItemName) {
//   //   return CachedNetworkImage(
//   //     width: 60,
//   //     height: 60,
//   //     imageUrl: memberItem.memberAvatarUrl.isEmpty
//   //         ? 'https://robohash.org/${memberItem.userID}.png?set=set4'
//   //         : memberItem.memberAvatarUrl,
//   //     fit: BoxFit.cover,
//   //     progressIndicatorBuilder: (context, url, downloadProgress) =>
//   //         CircleAvatar(
//   //       child: Text(memberItemName[0]),
//   //     ),
//   //   );
//   // }
//   //
//   // Widget _memberInfo(ZIMGroupMemberInfo memberItem, String memberItemName) {
//   //   final memberItemIsMe =
//   //       memberItem.userID == ZIMKit().currentUser()!.baseInfo.userID;
//   //
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     mainAxisAlignment: MainAxisAlignment.center,
//   //     children: [
//   //       Row(
//   //         children: [
//   //           Text(memberItemName, maxLines: 1, overflow: TextOverflow.clip),
//   //           Text(memberItem.memberRole == ZIMGroupMemberRole.owner
//   //               ? '(Owner)'
//   //               : ''),
//   //           Text(memberItem.memberRole == 2 ? '(Manager)' : ''),
//   //           Text(memberItemIsMe ? '(Me)' : ''),
//   //         ],
//   //       ),
//   //       Text('ID:${memberItem.userID}'),
//   //     ],
//   //   );
//   }
//
//   Widget _memberMenu(
//       BuildContext context, ZIMGroupMemberInfo memberItem, String groupID) {
//     final memberItemIsMe =
//         memberItem.userID == ZIMKit().currentUser()!.baseInfo.userID;
//
//     return FutureBuilder<ZIMGroupMemberInfo?>(
//       future: ZIMKit().queryGroupMemberInfo(
//           groupID, ZIMKit().currentUser()?.baseInfo.userID ?? ''),
//       builder: (context, snapshot) {
//         final imGroupManager =
//             snapshot.hasData && (snapshot.data?.memberRole == 2);
//
//         return ValueListenableBuilder<ZIMGroupMemberInfo?>(
//           valueListenable: ZIMKit().queryGroupOwner(groupID),
//           builder: (context, owner, _) {
//             if (memberItemIsMe) {
//               return const SizedBox.shrink();
//             }
//
//             final imGroupOwner =
//                 owner?.userID == ZIMKit().currentUser()?.baseInfo.userID;
//             return PopupMenuButton(
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(15)),
//               ),
//               position: PopupMenuPosition.under,
//               icon: const Icon(Icons.more_horiz),
//               itemBuilder: (context) {
//                 return [
//                   if (imGroupOwner || imGroupManager) ...[
//                     PopupMenuItem(
//                       child: const ListTile(
//                         leading: Icon(Icons.group_remove),
//                         title: Text('Remove User'),
//                       ),
//                       //onTap: () => ZIMKit().removeUsersFromGroup(groupID, [memberItem.userID]),
//                     ),
//                   ],
//                   if (imGroupOwner) ...[
//                     PopupMenuItem(
//                       child: const ListTile(
//                         leading: Icon(Icons.handshake),
//                         title: Text('Transfer Group Owner'),
//                       ),
//                       onTap: () => ZIMKit()
//                           .transferGroupOwner(groupID, memberItem.userID),
//                     ),
//                     PopupMenuItem(
//                       child: ListTile(
//                         leading: const Icon(Icons.diversity_3),
//                         title: (memberItem.memberRole == 3)
//                             ? const Text('Set Group Manager')
//                             : const Text('Unset Group Manager'),
//                       ),
//                       onTap: () => ZIMKit().setGroupMemberRole(
//                         conversationID: groupID,
//                         userID: memberItem.userID,
//                         role: (memberItem.memberRole == 3) ? 2 : 3,
//                       ),
//                     ),
//                   ],
//                   PopupMenuItem(
//                     child: const ListTile(
//                       leading: Icon(Icons.chat),
//                       title: Text('Private Chat'),
//                     ),
//                     onTap: () {
//                       // Navigator.pushReplacement(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) {
//                       //       return DemoChattingMessageListPage(
//                       //         conversationID: memberItem.userID,
//                       //         conversationType: ZIMConversationType.peer,
//                       //       );
//                       //     },
//                       //   ),
//                       // );
//                     },
//                   ),
//                 ];
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
