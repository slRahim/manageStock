import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';

import 'CustomWidgets/list_tile_card.dart';

class ArticleListItem extends StatelessWidget {
  const ArticleListItem({
    @required this.article,
    Key key,
  })  : assert(article != null),
        super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) => ListTileCard(
    onTap: () => {
      Navigator.of(context).pushNamed(
          RoutesKeys.addArticle,
          arguments: article
      )
    },
    leading: CircleAvatar(
      radius: 20,
      backgroundImage: MemoryImage(article.imageUint8List),
    ),
    title: Text(article.designation),
    subtitle: Text("Ref: " + article.ref),
    trailingChildren: [
      Text(article.prixVente1.toString(), style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
      SizedBox(height: 5),
      Text(article.quantite.toString(), style: TextStyle(color: article.quantite <= article.quantiteMinimum? Colors.redAccent : Colors.black, fontSize: 15.0),)
    ],
  );
}
