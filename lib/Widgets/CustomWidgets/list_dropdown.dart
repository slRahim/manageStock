import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// drop down menu restyle
class ListDropDown extends StatefulWidget {
  final String libelle;
  final bool editMode;
  final value;
  final items;
  final leftIcon;
  final Function(Object value) onChanged;
  final VoidCallback onAddPressed;

  const ListDropDown(
      {Key key,
      this.libelle,
      this.editMode,
      this.value,
      this.items,
      this.onChanged,
      this.onAddPressed,
      this.leftIcon})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ListDropDownState();
  }
}

class ListDropDownState extends State<ListDropDown> {
  final GlobalKey dropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: widget.editMode
          ? new BoxDecoration(
              border: Border.all(
                color: Colors.blueAccent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 6),
          // Icon(Icons.help, color: Colors.grey,),
          widget.leftIcon != null
              ? Icon(widget.leftIcon, size: 25)
              : SizedBox(height: 1),
          SizedBox(width: 13),
          ((widget.value is int) && widget.editMode)
              ? new Text("${widget.libelle}",
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 16,
                          color: widget.editMode
                              ? Theme.of(context).hintColor
                              : Colors.black54)))
              : SizedBox(height: 1),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Object>(
                  key: dropdownKey,
                  disabledHint: (widget.value is int)
                      ? Text(
                          "${widget.libelle} ${widget.value.toString()}",
                          style: GoogleFonts.lato(),
                        )
                      : Text(
                          widget.libelle,
                          style: GoogleFonts.lato(),
                        ),
                  icon: widget.onAddPressed != null
                      ? Row(
                          children: [
                            Icon(Icons.arrow_drop_down),
                            IconButton(
                                icon: Icon(Icons.add),
                                onPressed: widget.editMode
                                    ? widget.onAddPressed
                                    : null),
                          ],
                        )
                      : SizedBox(height: 1),
                  value: widget.value,
                  items: widget.items,
                  onChanged: widget.editMode ? widget.onChanged : null),
            ),
          ),
        ],
      ),
    );
  }
}
