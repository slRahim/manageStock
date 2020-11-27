import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:google_fonts/google_fonts.dart';

// le style des list tiele utiliser ds l'app
class ListTileCard extends StatelessWidget {


  final int id;
  final bool itemSelected;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final List<Widget> trailingChildren;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final ConfirmDismissCallback confirmDismiss;

  const ListTileCard({Key key, this.id, this.leading, this.title, this.subtitle, this.trailingChildren, this.onTap, this.confirmDismiss, this.itemSelected, this.onLongPress}) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.all(2),
    color: Colors.grey[200],
    elevation: 2,
    child: id != null && confirmDismiss != null? Dismissible(
      background: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.green[700],
          /*gradient: LinearGradient(
                  colors: [Colors.white, Colors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),*/
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50, 5, 5, 5),
          child: Align(
            alignment: Alignment.centerLeft, // Align however you like (i.e .centerRight, centerLeft)
            child: Row(
              children: [
                Icon(Icons.call, color: Colors.white,),
                SizedBox(
                  width: 20.0,
                  height: 2.0,
                ),
                Text("Appeler", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              ],
            ),
          ),
        ),
      ),
      key: Key(id.toString()),
      direction: DismissDirection.startToEnd,
      confirmDismiss: confirmDismiss,
      child: listTile(),
    ) : listTile()
  );

  Widget listTile(){
    return Container(
      color: (itemSelected != null && itemSelected) ? Colors.greenAccent : null,
      child: ListTile(
        onTap: onTap,
        onLongPress: onLongPress,
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: trailingChildren,
            )),
      )
    );
  }
}
