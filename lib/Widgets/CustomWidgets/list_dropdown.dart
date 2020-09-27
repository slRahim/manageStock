import 'package:flutter/material.dart';

class ListDropDown extends StatefulWidget {
  final String label;
  final bool editMode;
  final value;
  final items;
  final Function(Object value) onChanged;
  final VoidCallback onAddPressed;

  const ListDropDown(
      {Key key,
      this.label,
      this.editMode,
      this.value,
      this.items,
      this.onChanged,
      this.onAddPressed})
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
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.label != null
              ? new GestureDetector(
                  onTap: () {
                    openDropdown();
                  },
                  child: new Text(widget.label,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              widget.editMode ? Colors.black : Colors.black54)),
                )
              : SizedBox(height: 1),
          DropdownButtonHideUnderline(
            child: DropdownButton<Object>(
                key: dropdownKey,
                disabledHint: Text(widget.value.toString()),
                icon: widget.onAddPressed != null
                    ? IconButton(
                        icon: Icon(Icons.add),
                        onPressed: widget.editMode ? widget.onAddPressed : null)
                    : SizedBox(height: 1),
                value: widget.value,
                items: widget.items,
                onChanged: widget.editMode ? widget.onChanged : null),
          ),
        ],
      ),
    );
  }

  void openDropdown() {
    /*dropdownKey.currentContext.visitChildElements((element) {
      if (element.widget != null && element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget != null && element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, Intent());
              return false;
            });
          }
        });
      }
    });*/
  }
}
