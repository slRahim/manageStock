import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:rxdart/rxdart.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchInputSliver extends StatefulWidget {
  const SearchInputSliver({
    Key key,
    this.onChanged,
    this.debounceTime, this.searchController,
  }) : super(key: key);
  final ValueChanged<String> onChanged;
  final Duration debounceTime;
  final TextEditingController searchController;

  @override
  _SearchInputSliverState createState() => _SearchInputSliverState();
}

class _SearchInputSliverState extends State<SearchInputSliver> {
  final StreamController<String> _textChangeStreamController =
      StreamController();
  StreamSubscription _textChangesSubscription;

  @override
  void initState() {
    _textChangesSubscription = _textChangeStreamController.stream
        .debounceTime(
          widget.debounceTime ?? const Duration(seconds: 1),
        )
        .distinct()
        .listen((text) {
      if (widget.onChanged != null) {
        widget.onChanged(text);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: widget.searchController,
    style: GoogleFonts.lato(textStyle : TextStyle(color: Colors.white),),
    autofocus: true,
    cursorColor: Colors.white,
    decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsetsDirectional.only(start: 15, bottom: 11, top: 11, end: 15),
        hintStyle: GoogleFonts.lato(textStyle: TextStyle(color: Colors.white),),
        hintText: S.current.msg_search

    ),
    onChanged: _textChangeStreamController.add,
  );


}
