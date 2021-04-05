import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/search/search_input_sliver.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

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

  String feature4 = 'feature4';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(widget.editMode && widget.modification? Icons.cancel: Icons.arrow_back, size: 25),
        onPressed: widget.onCancelPressed
      ),
      title: Text(widget.title, style: GoogleFonts.lato(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
      backgroundColor: widget.editMode ? Colors.green : Theme.of(context).appBarTheme.color,
      centerTitle: true,
      bottom: widget.bottom,
      actions: [
        (widget.onTrensferPressed != null && !widget.editMode)
            ?DescribedFeatureOverlay(
              featureId: feature4,
              tapTarget: Icon(MdiIcons.transfer , color: Colors.black,),
              backgroundColor: Colors.blue,
              contentLocation: ContentLocation.below,
              title: Text(S.current.transformer , style: GoogleFonts.lato(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
              description:  Container(
                  width: 150,
                  child: Text(S.current.msg_transformer, style: GoogleFonts.lato(),)),
              onBackgroundTap: () async{
                await FeatureDiscovery.completeCurrentStep(context);
                return true ;
              },
              child: IconButton(
                tooltip: S.current.transferer,
                icon: Icon(MdiIcons.transfer),
                onPressed: widget.onTrensferPressed
              ),
            )
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