import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

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
  _SearchInputSliverState createState() =>
      _SearchInputSliverState();
}

class _SearchInputSliverState
    extends State<SearchInputSliver> {
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
  Widget build(BuildContext context) => TextFormField(
    controller: widget.searchController,
    style: TextStyle(color: Colors.white),
    autofocus: true,
    cursorColor: Colors.white,
    decoration: new InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
        EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        hintText: "Enter your search"),
    onChanged: _textChangeStreamController.add,
  );

  @override
  void dispose() {
    _textChangeStreamController.close();
    _textChangesSubscription.cancel();
    super.dispose();
  }
}
