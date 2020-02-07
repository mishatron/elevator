import 'dart:io';

import 'package:elevator/res/values/colors.dart';
import 'package:elevator/res/values/styles.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/view/custom/BaseButton.dart';
import 'package:elevator/src/view/main/profile/profile_bloc.dart';
import 'package:elevator/src/view/utils/image_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends BaseStatefulScreen<ProfileScreen>
    with BaseBlocListener {
  ProfileBloc _bloc = ProfileBloc();

  @override
  Widget buildAppbar() {
    return getAppBar(context, 'Профіль');
  }

  @override
  Widget buildBody() {
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocListener(
        bloc: _bloc,
        listener: blocListener,
        child: BlocBuilder<ProfileBloc, DoubleBlocState>(
          builder: (context, state) {
            if (_bloc.user == null) {
              return getProgress(background: false);
            } else {
              return getProfileContent();
            }
          },
        ),
      ),
    );
  }

  Widget getProfileContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              getUserAvatar(_bloc.user.photoUrl, 100),
              Positioned(
                right: -16,
                child: InkWell(
                  onTap: _pickPhoto,
                  child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: colorAccent, shape: BoxShape.circle),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _bloc.user.firstName + " " + _bloc.user.lastName,
              style: getBigFont().apply(color: colorAccent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _bloc.user.email,
              style: getMidFont(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _bloc.user.phone,
              style: getMidFont(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: BaseButton(
              text: 'Вийти',
              onClick: _askToLogout,
            ),
          ),
        ],
      ),
    );
  }

  void _askToLogout() {
    showAlert(context, 'Вихід', 'Ви впевнені, що хочете вийти?', () {
      _bloc.logout();
    });
  }

  Future _pickPhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      image = await _cropLogo(image);
    }
  }

  Future<File> _cropLogo(File imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: colorAccent,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
