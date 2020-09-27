import 'package:draggable_container/draggable_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/cubit/home_cubit.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/HomeItem.dart';
import 'package:google_fonts/google_fonts.dart';


Widget getDrawerItemWidget(_context, data) {
  return ListTile(
    dense: true,
    leading: iconsSet(data.id, 20),
    title: Text(
      data.title,
      style: TextStyle(color: Colors.white, fontSize: 15),
    ),
    onTap: () => {
      print(data.title),
      Navigator.of(_context).pop(),
      Helpers.handleIdClick(_context, data.id),
    },
    trailing: Icon(Icons.keyboard_arrow_right),
  );
}

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

    this.child = GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (context != null) {
          print(title);
          Helpers.handleIdClick(context, data.id);
        }
      },
      child: Container(
        width: 92.0,
        height: 92.0,
        decoration: BoxDecoration(
          color: colorSet(id),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            iconsSet(id, 40),
            SizedBox(
              width: 10.0,
              height: 2.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)
              ),
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

