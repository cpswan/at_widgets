import 'dart:typed_data';

import 'package:at_contact/at_contact.dart';
import 'package:at_contacts_group_flutter/services/group_service.dart';
import 'package:at_contacts_group_flutter/services/image_picker.dart';
import 'package:at_contacts_group_flutter/utils/colors.dart';
import 'package:at_contacts_group_flutter/utils/text_constants.dart';
import 'package:at_contacts_group_flutter/widgets/bottom_sheet.dart';
import 'package:at_contacts_group_flutter/widgets/custom_toast.dart';
import 'package:at_contacts_group_flutter/widgets/person_vertical_tile.dart';
import 'package:flutter/material.dart';
import 'package:at_common_flutter/at_common_flutter.dart';

class NewGroup extends StatefulWidget {
  @override
  _NewGroupState createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  List<AtContact> selectedContacts;
  String groupName;
  Uint8List selectedImageByteData;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  getContacts() {
    if (GroupService().selecteContactList.length > 0) {
      selectedContacts = GroupService().selecteContactList;
    } else
      selectedContacts = [];
  }

  createGroup() async {
    print('object');
    if (groupName != null) {
      if (groupName.contains(RegExp(TextConstants().GROUP_NAME_REGEX))) {
        CustomToast().show(TextConstants().INVALID_NAME, context);
        return;
      }

      if (groupName.trim().length > 0) {
        AtGroup group = new AtGroup(
          groupName,
          description: 'group desc',
          members: Set.from(selectedContacts),
          createdBy: GroupService().currentAtsign,
          updatedBy: GroupService().currentAtsign,
        );

        if (this.selectedImageByteData != null) {
          group.groupPicture = this.selectedImageByteData;
          print('adding group image: ${group.groupPicture}');
        }

        var result = await GroupService().createGroup(group);

        if (result is AtGroup) {
          Navigator.of(context).pop();
        } else if (result != null) {
          if (result.runtimeType == AlreadyExistsException) {
            CustomToast().show(result.toString(), context);
          }
          CustomToast().show(TextConstants().GROUP_ALREADY_EXISTS, context);
        } else {
          CustomToast().show(TextConstants().SERVICE_ERROR, context);
        }
      } else {
        CustomToast().show(TextConstants().EMPTY_NAME, context);
      }
    } else {
      CustomToast().show(TextConstants().EMPTY_NAME, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? AllColors().WHITE
            : AllColors().Black,
        bottomSheet: GroupBottomSheet(
          onPressed: createGroup,
          message: '${selectedContacts.length} Contacts Selected',
          buttontext: 'Done',
        ),
        appBar: CustomAppBar(
            titleText: 'New Group',
            showTitle: true,
            showBackButton: true,
            showLeadingIcon: true),
        body: Column(
          children: <Widget>[
            SizedBox(height: 20.toHeight),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 15.toWidth,
                ),
                InkWell(
                  onTap: () async {
                    var image = await ImagePicker().pickImage();
                    setState(() {
                      selectedImageByteData = image;
                    });
                  },
                  child: Container(
                    width: 68.toWidth,
                    height: 68.toWidth,
                    decoration: new BoxDecoration(
                      color: AllColors().MILD_GREY,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: this.selectedImageByteData != null
                          ? SizedBox(
                              width: 68.toWidth,
                              height: 68.toWidth,
                              child: CircleAvatar(
                                backgroundImage:
                                    Image.memory(this.selectedImageByteData)
                                        .image,
                              ),
                            )
                          : Icon(Icons.add, color: AllColors().ORANGE),
                    ),
                  ),
                ),
                SizedBox(width: 10.toWidth),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Group name', style: TextStyle(fontSize: 15.toFont)),
                      SizedBox(height: 5),
                      CustomInputField(
                        icon: Icons.emoji_emotions_outlined,
                        width: 240.toWidth,
                        initialValue: groupName != null ? groupName : '',
                        value: (val) {
                          groupName = val;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: 13.toHeight),
            Divider(),
            SizedBox(height: 13.toHeight),
            Expanded(
              child: Container(
                width: double.infinity,
                child: SingleChildScrollView(
                    child: GridView.count(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 4,
                        // crossAxisSpacing: 15.toWidth,
                        childAspectRatio: ((SizeConfig().screenWidth * 0.25) /
                            (SizeConfig().screenHeight * 0.2)),
                        // childAspectRatio: (85 / 120),
                        children:
                            List.generate(selectedContacts.length, (index) {
                          return CustomPersonVerticalTile(
                            imageLocation: null,
                            title: selectedContacts[index].atSign,
                            subTitle: selectedContacts[index].atSign,
                            icon: Icons.close,
                            isTopRight: true,
                            onCrossPressed: () {
                              setState(() {
                                selectedContacts.removeAt(index);
                              });
                            },
                          );
                        })
                        // List(
                        //   5,
                        //   (index) {
                        //     return CustomPersonVerticalTile(
                        //       imageLocation: AllImages().PERSON1,
                        //       title: 'Thomas',
                        //       subTitle: '@thomas',
                        //       icon: Icons.highlight_off,
                        //       isTopRight: true,
                        //     );
                        //   },
                        // ),
                        )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
