import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// app bar lors de selection de plusieurs items
class SelectItemsBar extends StatefulWidget with PreferredSizeWidget {
  final int itemsCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final Function(String search) onSearchChanged;
  final TextEditingController searchController;

  const SelectItemsBar(
      {Key key,
      this.itemsCount,
      this.onConfirm,
      this.onCancel,
      this.onSearchChanged,
      this.searchController})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SelectItemsBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SelectItemsBarState extends State<SelectItemsBar> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    if (widget.itemsCount <= 0) {
      widget.onCancel();
    }
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.cancel,
            color: Colors.white, size: 25), // change this size and style
        onPressed: () => widget.onCancel(),
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Text(widget.itemsCount.toString(),
          style: GoogleFonts.lato(
              textStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      backgroundColor: Colors.black,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.done_outline, color: Colors.white),
          onPressed: () {
            widget.onConfirm();
          },
        )
      ],
    );
  }
}
