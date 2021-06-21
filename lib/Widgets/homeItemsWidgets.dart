import 'package:draggable_container/draggable_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDraggableItem extends DraggableItem {
  int index;
  final String key;
  final data;
  final context;
  Widget child, deleteButton;
  final Function onTap;

  HomeDraggableItem(
      {this.key = 'key', this.index, this.onTap, this.context, this.data}) {
    String title = data == null ? "Add Button" : data.title;
    String id = data == null ? "addButtonHomeItemId" : data.id;

    this.child = InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (context != null) {
          print(title);
          Helpers.handleIdClick(context, data.id);
        }
      },
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 5, end: 5),
        decoration: BoxDecoration(
          color: colorSet(id),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            iconsSet(id, 40),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  String toString() => index.toString();

  Map<String, dynamic> toJson() {
    return {key: index};
  }
}
