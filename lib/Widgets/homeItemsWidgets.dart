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
        decoration: BoxDecoration(
          color: Theme.of(context).selectedRowColor,
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
            homeIcons(id, 45),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)
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

