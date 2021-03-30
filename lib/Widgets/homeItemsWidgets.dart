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

// element de menu de home
class HomeDraggableItem extends DraggableItem {
  int index;
  final String key;
  final data;
  final context;
  Widget child, deleteButton;
  final Function onTap;

  HomeDraggableItem({this.key = 'key', this.index, this.onTap, this.context, this.data}) {
    String title = data == null ? "Add Button" : data.title;
    String id = data == null ? "addButtonHomeItemId" : data.id;

    this.child = GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (context != null) {
          print(title);
          Helpers.handleIdClick(context, data.id );
        }
      },
      child: Container(
        padding: EdgeInsetsDirectional.only(start: 5 , end :5),
        width: 92.0,
        height: 92.0,
        decoration: BoxDecoration(
          color: colorSet(id),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(2, 1), // changes position of shadow
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
                      fontSize: 14,
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

