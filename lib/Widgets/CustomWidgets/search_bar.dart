import 'dart:ui';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// la bar de recherche utiliser ds les fragements de listing
class SearchBar extends StatefulWidget with PreferredSizeWidget{
  final String title;
  final BuildContext mainContext;
  final bool isFilterOn;
  final VoidCallback onFilterPressed;
  final Function(String search) onSearchChanged;
  final TextEditingController searchController;

  const SearchBar({Key key, @required this.title, this.onFilterPressed, this.onSearchChanged, this.isFilterOn, this.mainContext, this.searchController}) : super(key: key);

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
    if(widget.searchController != null && widget.searchController.text.isNotEmpty){
      isSearching = true;
    }
    return AppBar(
      leading: widget.mainContext != null? IconButton(
        icon: Icon(Icons.menu, size: 25), // change this size and style
        onPressed: () => Scaffold.of(widget.mainContext).openDrawer(),
      ) : IconButton(
        icon: Icon(Icons.arrow_back, size: 25), // change this size and style
        onPressed: () => Navigator.of(context).pop(),
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: !isSearching
          ? Text(widget.title)
          : SearchInputSliver(
        searchController: widget.searchController,
        onChanged: (String search) => widget.onSearchChanged(search),
      ),
      backgroundColor: Theme.of(context).appBarTheme.color,
      centerTitle: true,
      actions: [
        widget.onSearchChanged != null? IconButton(
          icon: Icon(
            isSearching ? Icons.cancel : Icons.search,
          ),
          onPressed: () {
            setState(() {
              widget.searchController.text = "";
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