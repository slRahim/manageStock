import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';

import 'list_tile_card.dart';

class SelectableListItem extends StatefulWidget {
  const SelectableListItem({
    @required this.article,
    Key key,
    this.onItemSelected,
  })  : assert(article != null),
        super(key: key);

  final Article article;
  final Function(Object) onItemSelected;

  @override
  _SelectableListItemState createState() => _SelectableListItemState();
}

class _SelectableListItemState extends State<SelectableListItem> {
  bool itemSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTileCard(
      onTap: () {
        if(widget.onItemSelected != null){
          setState(() {
            itemSelected = !itemSelected;
          });
          widget.onItemSelected(widget.article);
        } else{
          Navigator.of(context).pushNamed(RoutesKeys.addArticle, arguments: widget.article);
        }
      },

      itemSelected: itemSelected,
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: MemoryImage(widget.article.imageUint8List),
      ),
      title: Text(widget.article.designation),
      subtitle: Text("Ref: " + widget.article.ref),
      trailingChildren: [
        Text(
          widget.article.prixVente1.toString(),
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Text(
          widget.article.quantite.toString(),
          style: TextStyle(
              color: widget.article.quantite <= widget.article.quantiteMinimum
                  ? Colors.redAccent
                  : Colors.black,
              fontSize: 15.0),
        )
      ],
    );
  }
}
