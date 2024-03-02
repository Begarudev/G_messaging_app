import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_messaging_app/models/chat_user.dart';

import '../helper/dialogs.dart';
import '../main.dart';
import '../services/apis.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE45855)),
            label: const Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            onPressed: () {
              Dialogs.showProgressBar(context);
              signOut();
              Navigator.pop(context);
              context.pushReplacement('/loginScreen');
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      (_image != null)
                          ? CircleAvatar(
                              radius: mq.height * .09,
                              foregroundImage: FileImage(File(_image!)),
                            )
                          : CircleAvatar(
                              radius: mq.height * .09,
                              foregroundImage: NetworkImage(widget.user.image),
                            ),
                      MaterialButton(
                        elevation: 1,
                        color: Theme.of(context).primaryColorDark,
                        shape: const CircleBorder(),
                        onPressed: () {
                          _showBottomSheet();
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                  const Gap(
                    15,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 20,
                    ),
                  ),
                  const Gap(
                    30,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.blue),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. Happy Singh',
                        label: const Text('Name')),
                  ),
                  const Gap(
                    10,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? '',
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.info_outline_rounded,
                            color: Colors.blue),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: 'eg. Happy Singh',
                        label: const Text('About')),
                  ),
                  const Gap(
                    30,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        APIs.updateUserInfo().then((value) {
                          Dialogs.showSnackBar(
                              context, 'Profile Updated Successfully!');
                        });
                        log('inside validator');
                      }
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("UPDATE"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(shape: const CircleBorder()),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        Icons.photo_album_outlined,
                        size: mq.width * 0.3,
                      )),
                  ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(shape: const CircleBorder()),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? photo = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (photo != null) {
                          log('Image Path: ${photo.path}');
                          setState(() {
                            _image = photo.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: mq.width * 0.3,
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
