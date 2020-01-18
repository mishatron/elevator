import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elevator/src/core/bloc/base_bloc_listener.dart';
import 'package:elevator/src/core/bloc/base_bloc_state.dart';
import 'package:elevator/src/core/bloc/content_loading_state.dart';
import 'package:elevator/src/core/ui/base_statefull_screen.dart';
import 'package:elevator/src/core/ui/base_statefull_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/view/profile/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends BaseStatefulScreen<ProfileScreen> with BaseBlocListener {
  ProfileBloc _bloc = ProfileBloc();

  @override
  Widget buildAppbar() {
    return getAppBar(context, 'Профіль');
  }

  @override
  Widget buildBody() {
    return BlocProvider(
      create: (context) => _bloc,
      child:  BlocListener(
        bloc: _bloc,
        listener: blocListener,
        child: BlocBuilder<ProfileBloc, DoubleBlocState>(
          builder: (context, state){
            if(_bloc.user==null){
              return getProgress(background: false);
            }
            else{
              return Column(
                children: <Widget>[
                  Text(_bloc.user.firstName+" "+_bloc.user.lastName),
                  Text(_bloc.user.email),
                  Text(_bloc.user.phone),

                  RaisedButton(
                    child: Text('Logout'),
                    onPressed: _bloc.logout,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
