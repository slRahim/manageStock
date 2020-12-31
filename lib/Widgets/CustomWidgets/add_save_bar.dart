import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// app bar de la partie detail et modification
class AddEditBar extends StatefulWidget with PreferredSizeWidget{
  final bool editMode;
  final bool modification;
  final String title;
  final TabBar bottom;
  
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onTrensferPressed ;

  const AddEditBar({Key key, this.editMode, this.modification, this.title, this.bottom, this.onEditPressed, this.onSavePressed, this.onCancelPressed,this.onTrensferPressed}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return new AddEditBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(58);

}

class AddEditBarState extends State<AddEditBar>{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(widget.editMode && widget.modification? Icons.cancel: Icons.arrow_back, size: 25),
        onPressed: widget.onCancelPressed
      ),
      title: Text(widget.title),
      backgroundColor: widget.editMode ? Colors.green : Colors.blue,
      centerTitle: true,
      bottom: widget.bottom,
      actions: [
        (widget.onTrensferPressed != null && !widget.editMode)
            ?IconButton(
            tooltip: S.current.transferer,
            icon: Icon(MdiIcons.transfer),
            onPressed: widget.onTrensferPressed)
            : SizedBox() ,
        widget.editMode
            ? IconButton(
            icon: Icon(Icons.save),
            onPressed: widget.onSavePressed)
            : IconButton(
            icon: Icon(Icons.mode_edit),
            onPressed: widget.onEditPressed),

      ],
    );
  }


}