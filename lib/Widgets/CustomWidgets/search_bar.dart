import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchBar extends StatefulWidget with PreferredSizeWidget{
  final String title;
  final BuildContext mainContext;
  final bool isFilterOn;
  final VoidCallback onFilterPressed;
  final Function(String search) onSearchChanged;

  const SearchBar({Key key, @required this.title, this.onFilterPressed, this.onSearchChanged, this.isFilterOn, this.mainContext}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SearchBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class SearchBarState extends State<SearchBar>{
  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.mainContext != null? IconButton(
        icon: Icon(Icons.menu, size: 25), // change this size and style
        onPressed: () => Scaffold.of(widget.mainContext).openDrawer(),
      ) : null,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: !isSearching
          ? Text(widget.title)
          : SearchInputSliver(
        onChanged: (String search) => widget.onSearchChanged(search),
      ),
      backgroundColor: Colors.blue,
      centerTitle: true,
      actions: [
        widget.onSearchChanged != null? IconButton(
          icon: Icon(
            isSearching ? Icons.cancel : Icons.search,
          ),
          onPressed: () {
            setState(() {
              widget.onSearchChanged("");
              this.isSearching = !this.isSearching;
            });
          },
        ) : SizedBox(height: 5),
        widget.onFilterPressed != null?IconButton(
          color: widget.isFilterOn?Colors.greenAccent:Colors.white,
          icon: Icon(
            MdiIcons.filter,
          ),
          onPressed: widget.onFilterPressed,
        ) : SizedBox(height: 5),
      ],
    );
  }


}