import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gestmob/Helpers/Helpers.dart';
import 'package:gestmob/Helpers/QueryCtr.dart';
import 'package:gestmob/generated/l10n.dart';
import 'package:gestmob/services/cloud_backup_restore.dart';
import 'package:googleapis/drive/v3.dart' as ga;

class Selectfromdrive extends StatefulWidget {
  @override
  _SelectfromdriveState createState() => _SelectfromdriveState();
}

class _SelectfromdriveState extends State<Selectfromdrive> {
  GoogleApi googleapi;
  ga.FileList files = new ga.FileList();
  QueryCtr _query = new QueryCtr();

  refreshfileslist()async {
    await googleapi.ListGoogleDriveFiles().then((alist) {
      setState(() {
        files = alist;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    googleapi = GoogleApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: ()async {
                    await googleapi.GoogleLogout();
                    setState(() {
                      files.files.clear();
                    });
                    refreshfileslist();
                  }
              )
            ],
            leading: IconButton(
                icon: Icon(Icons.arrow_back , color: Colors.white,),
                onPressed: () {
                  googleapi.GoogleLogout();
                  Navigator.pop(context);
                }),
            title: Text("${S.current.backups}"),
            centerTitle: true,
            backgroundColor: Theme.of(context).appBarTheme.color,
          ),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return false;
            },
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: new Container(
                            padding: new EdgeInsets.all(5.0),
                            child:FutureBuilder(
                                future: refreshfileslist(),
                                builder: (context, snapshot) {
                                  if (files.files == null) {
                                    return Container(
                                        height: 100.0,
                                        width: 100.0,
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        )
                                    );
                                  } else {
                                    return ListView.builder(
                                        padding: EdgeInsets.all(5),
                                        itemCount: files.files.length,
                                        itemBuilder: (context, i) {
                                          if (files.files[i].name.startsWith('gestmob_'))
                                            return buildList(files.files[i]);
                                        }
                                    );
                                  }
                                })
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
//          ),
      ),
    );
  }

  Widget buildList(ga.File file) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.yellow[700],
          child: CircleAvatar(
            radius: 20,
            child: Icon(Icons.restore , color: Colors.white, size: 26,),
            backgroundColor: Colors.green,
          ),
        ),
        onTap: ()async{
          AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              animType: AnimType.BOTTOMSLIDE,
              title: "${S.current.restore_data}",
              desc: "${S.current.restore_msg}",
              btnCancelText: S.current.non,
              btnCancelOnPress: () {},
              btnOkText: S.current.oui,
              btnOkOnPress: () async {
                File backupFile = await googleapi.DownloadGoogleDriveFile(file.name, file.id);
                _query.restoreBackup(backupFile).then((value){
                  if(value != null){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Helpers.showFlushBar(context, "${S.current.msg_succes_restoration}");

                  }else{
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Helpers.showFlushBar(context, "${S.current.msg_err_restoration}");
                  }
                });
              })
            ..show();
        },
        title: Text(
            '${file.name.replaceAll('.bkp', '')}',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,)),
        subtitle: Text(
            ".bkp" , style: TextStyle(color: Colors.black),
        ),
      ),
    );

  }
}