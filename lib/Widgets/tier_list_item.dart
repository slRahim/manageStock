
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/Helpers/Statics.dart';
import 'package:gestmob/models/Article.dart';
import 'package:gestmob/models/Tiers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CustomWidgets/list_tile_card.dart';

// element à afficher lors de listing des clients ou des fournisseurs
class TierListItem extends StatelessWidget {
  TierListItem({
    @required this.tier,
    Key key, this.onItemSelected,
  })  : assert(tier != null),
        super(key: key);

  final Tiers tier;
  final Function(Object) onItemSelected;

  final QueryCtr _queryCtr = new QueryCtr() ;
  bool _confirmDell = false ;

  @override
  Widget build(BuildContext context) => ListTileCard(
    id: tier.id,
    from: tier,
    confirmDismiss: (DismissDirection dismissDirection) async {
      print("call: " + tier.mobile);
      if(dismissDirection == DismissDirection.endToStart){
        await _makePhoneCall("tel:${tier.mobile}");
      }else{
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return dellDialog(context);
            });
        return _confirmDell ;
      }
    },
    onLongPress:  () => onItemSelected != null? onItemSelected(tier) : null,
    onTap: () => {
      if(onItemSelected == null){
        Navigator.of(context)
            .pushNamed(RoutesKeys.addTier, arguments: tier)
      }
    },
    leading: InkWell(
      onTap: (){

      },
      child: CircleAvatar(
        radius: 20,
        backgroundImage:(tier.imageUint8List == null) ? MemoryImage(tier.imageUint8List) : null,
      ),
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

  Future<void> _makePhoneCall(String phone) async {
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      throw 'Could not launch $phone';
    }
  }


  Widget dellDialog(BuildContext context) {
    return AlertDialog(
      title:  Text('Delete ?'),
      content: Text('do you wont to delete the item'),
      actions: [
        FlatButton(
          child: Text('No'),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
            child: Text('YES'),
            onPressed: ()async {
              if(tier.id == 1 || tier.id == 2){
                Navigator.pop(context);
                var message ="You can't dell a default tier";
                Helpers.showFlushBar(context, message);
              }else{
               int res = await _queryCtr.removeItemFromTable(DbTablesNames.tiers, tier);
               var message = "" ;
               if(res > 0){
                 message ="Tier deleted successfully";
                 _confirmDell =true ;
                 Navigator.pop(context);
               }else{
                 message ="Error has occured";
                 Navigator.pop(context);
               }
               Helpers.showFlushBar(context, message);
              }
            }
        ),
      ],
    );
  }
}
