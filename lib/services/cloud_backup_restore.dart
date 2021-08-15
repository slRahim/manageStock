import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http/io_client.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pathprovider;


class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  send(BaseRequest request) => super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}

class GoogleApi {
  final _googleSignIn = signIn.GoogleSignIn.standard(scopes: [
    ga.DriveApi.DriveFileScope,
  ]);

  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    var user ;
    if (_googleSignIn.currentUser == null){
     user = await GoogleLogin();
    }

    final authHeaders = await user.authHeaders;
    if (authHeaders == null) {
      GoogleLogout();
      return null;
    }
    final httpClient = GoogleHttpClient(authHeaders);
    return httpClient;
  }

  //logout from account
  GoogleLogout() async {
    await _googleSignIn.signOut();
  }

  //login to account
  GoogleLogin() async {
    if (_googleSignIn.currentUser == null) await GoogleLogout();
    await _googleSignIn.signIn();
    var user = _googleSignIn.currentUser;
    // _GoogleLogout();
    return user;
  }

  //listing des files ds le drive
  Future<ga.FileList> ListGoogleDriveFiles() async {
    var client = await getHttpClient();
    if (client == null) return null;
    var drive = ga.DriveApi(client);

    var files = await drive.files.list();

    return files;
  }

  //Upload File to drive
  Future upload(File file) async {
    if (file == null) {
      GoogleLogout();
      return;
    }
    var client = await getHttpClient();
    if (client == null) return;
    var drive = ga.DriveApi(client);
    //
    ga.File fileToUpload = ga.File();

    fileToUpload.name = p.basename(file.absolute.path);
    var response = await drive.files.create(fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));

    GoogleLogout();
    return (response.toJson());
  }

  //download file from drive
  DownloadGoogleDriveFile(String fName, String gdID) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);
    ga.Media file = await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.FullMedia);
    print(file.stream);

    final directory = await pathprovider.getTemporaryDirectory();
    print(directory.path);
    final saveFile = File('${directory.path}/$fName');
    List<int> dataStore = [];
    await file.stream.listen((data) {
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      print("Task Done");
      await saveFile.writeAsBytes(dataStore);
    }, onError: (error) {
      print("Some Error");
    });

    return saveFile;
  }
}
