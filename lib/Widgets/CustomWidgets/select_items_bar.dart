import 'dart:ui';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// app bar lors de selection de plusieurs items
class SelectItemsBar extends StatefulWidget with PreferredSizeWidget{
  final int itemsCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SelectItemsBar({Key key, this.itemsCount, this.onConfirm, this.onCancel}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return new SelectItemsBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

}

class SelectItemsBarState extends State<SelectItemsBar>{
  @override
  Widget build(BuildContext context) {
    if(widget.itemsCount <= 0){
      widget.onCancel();
    }
    return AppBar(
      leading:IconButton(
        icon: Icon(Icons.cancel,color: Colors.white, size: 25), // change this size and style
        onPressed: () => widget.onCancel(),
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title:  Text(widget.itemsCount.toString(), style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black45,
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            Icons.done_outline,
            color: Colors.white
          ),
          onPressed: () {
            widget.onConfirm();
          },
        )
      ],
    );
  }

}