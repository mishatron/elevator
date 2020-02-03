import 'package:elevator/src/core/bloc/base_bloc_state.dart';

class MessageState extends BaseBlocState{
  final String text;
  final String textRes;

  MessageState({this.text, this.textRes});
}