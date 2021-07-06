import 'package:flutter/material.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/models/MyParams.dart';
import 'package:gestmob/services/push_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  MyParams _myParams;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PushNotificationsManagerState data = PushNotificationsManager.of(context);
    _myParams = data.myParams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        centerTitle: true,
        title: Text(S.current.support),
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                color: Theme.of(context).selectedRowColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.current.service_ticket,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColorDark)),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Theme.of(context).primaryColorDark,
                      height: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      onPressed: () async {
                        var url = "https://cirtait.com";
                        if (await canLaunch(url)) {
                          await launch(
                            url,
                            forceSafariVC: false,
                            forceWebView: false,
                            headers: <String, String>{
                              'my_header_key': 'my_header_value'
                            },
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Container(
                        width: 250,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            S.current.get_ticket,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              (_myParams.versionType != "demo")
                  ? Container(
                      padding: EdgeInsets.all(20),
                      color: Theme.of(context).selectedRowColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.current.service_comercial,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark)),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Theme.of(context).primaryColorDark,
                            height: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("- +213 (0) 31-74-75-77",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("- +213 (0) 697-62-28-88",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("- +213 (0) 797-82-86-36",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.alternate_email,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("commercial@cirtait.com",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              ),
              (_myParams.versionType != "demo")
                  ? Container(
                      padding: EdgeInsets.all(20),
                      color: Theme.of(context).selectedRowColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.current.service_technique,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColorDark)),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Theme.of(context).primaryColorDark,
                            height: 2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("- +213 (0) 31 74 75 43",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("- +213 (0) 31 74 75 44",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("- +213 (0) 31 74 75 45",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.alternate_email,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 20),
                            child: Text("sav@cirtait.com",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColorDark)),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          )),
    );
  }
}
