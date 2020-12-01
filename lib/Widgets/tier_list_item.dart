import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des clients ou des fournisseurs
class TierListItem extends StatelessWidget {
  const TierListItem({
    @required this.tier,
    Key key, this.onItemSelected,
  })  : assert(tier != null),
        super(key: key);

  final Tiers tier;
  final Function(Object) onItemSelected;

  @override
  Widget build(BuildContext context) => ListTileCard(
    id: tier.id,
    from: tier,
    confirmDismiss: (DismissDirection dismissDirection) async {
      print("call: " + tier.mobile);
      return false;
    },
    onLongPress:  () => onItemSelected != null? onItemSelected(tier) : null,
    onTap: () => {
      if(onItemSelected == null){
        Navigator.of(context)
            .pushNamed(RoutesKeys.addTier, arguments: tier)
      }
    },
    leading: CircleAvatar(
      radius: 20,
      backgroundImage:(tier.imageUint8List == null) ? MemoryImage(tier.imageUint8List) : null,
    ),
    title: Text(tier.raisonSociale),
    subtitle: Text("Tel: " + tier.mobile),
    trailingChildren: [
      Text(
        tier.credit.toString(),
        style: TextStyle(
            color: tier.credit > 0 ? Colors.redAccent : Colors.black,
            fontSize: 15.0),
      )
      // fournisseur reverse colors
    ],
  );
}
