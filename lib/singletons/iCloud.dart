import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:elib/components/upload_task.dart';
import 'package:elib/models/country.dart';
import 'package:elib/models/user.dart' as ModelUser;
import 'package:elib/singletons/sharedLocalStorage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

class ICloud extends ChangeNotifier{
  static final ICloud _iCloud = new ICloud._internal();
  static get iCloud => _iCloud;


  bool networkConnected;

  ///////////////////////////////////////////////////////REST API/////////////////////////////////////////////

  String apiEndPoint;
  String serverEndPoint;
  String sslEndPoint;
  Options getHttpOptions;
  Options postHttpOptions;
  Options postFormDataOptions;
  Options bytesHttpOptions;
  String serverToken;
  var dio = Dio();

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////


  factory ICloud() {
    return _iCloud;
  }

  Future<String> getCoverDirectory() async {
    try{
      final directory = await getDataDirectory();
      return '${directory.path}/covers';
    }catch(ex){
      print("Path Exception: $ex");
    }
    return 'covers';
  }

  Future<String> getFileDirectory() async {
    final directory = await getDataDirectory();
    return '${directory.path}/items';
  }

  Future<Directory> getDataDirectory() async {
    if(UniversalPlatform.isAndroid){
      return await getApplicationDocumentsDirectory();
    }else if(UniversalPlatform.isLinux){
      return await getLibraryDirectory();
    }else{
      return await getApplicationSupportDirectory();
    }
  }

  Future<String> getSafeDirectory() async {
    final directory = await getDataDirectory();
    bool dirExists = false;
    Directory dir = Directory('${directory.path}/elibs');
    dirExists = await dir.exists();
    if(dirExists==false) await dir.create();
    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    dir = Directory('${directory.path}/elibs/$timeStamp');
    dirExists = await dir.exists();
    if(dirExists==false) dir = await dir.create();
    return dir.path;
  }

  void setUpRestApiCloud() async {
    serverEndPoint = /*"http://localhost:8000/"*/ "https://phplaravel-532997-1700102.cloudwaysapps.com/";
    sslEndPoint = "https://phplaravel-532997-1700102.cloudwaysapps.com/";
    apiEndPoint = serverEndPoint + "api/zap";
    ModelUser.User user = await myStorage.getFromStore(key:'user');
    serverToken = user!=null? user.deviceRegToken : '';
    getHttpOptions = Options(
      contentType: Headers.jsonContentType,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverToken',
      },
    );
    postHttpOptions = Options(
      contentType: Headers.jsonContentType,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverToken',
      },
    );
    postFormDataOptions = Options(
      //contentType: 'multipart/form-data',
      responseType: ResponseType.json,
      headers: <String, String>{
        //'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $serverToken',
      },
    );
    bytesHttpOptions = Options(
      responseType: ResponseType.bytes,
      headers: <String, String>{
        'Authorization': 'Bearer $serverToken',
      },
    );
  }

  Future<dynamic> get({@required String url, useSSL: false}) async {
    if(useSSL) apiEndPoint = sslEndPoint + "api/zap";
    print("Token: $serverToken");
    dynamic response = isPhone()? await dio.get(
      '$apiEndPoint/$url',
      options: getHttpOptions,
    ): await http.get('$apiEndPoint/$url', headers: {'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverToken',});
    return response;
  }

  Future<dynamic> post({@required String url, @required Map<String,dynamic> body, useSSL: false}) async {
    if(useSSL) apiEndPoint = sslEndPoint + "api/zap";
    print("server url: $apiEndPoint");
    dynamic response = isPhone()? await dio.post(
      '$apiEndPoint/$url',
      options: postHttpOptions,
      data: jsonEncode(body),
    ) : await http.post('$apiEndPoint/$url', headers: { 'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverToken',}, body: jsonEncode(body));
    return response;
  }

  Future<dynamic> postForm({@required String url, @required FormData body, useSSL: false}) async {
    if(useSSL) apiEndPoint = sslEndPoint + "api/zap";
    dynamic response = isPhone()? await dio.post(
      '$apiEndPoint/$url',
      options: postFormDataOptions,
      data: body,
    ) : await http.post('$apiEndPoint/$url', headers: {'Content-Type': 'multipart/form-data', 'Authorization': 'Bearer $serverToken'}, body: body);
    return response;
  }

  Future<Response<List<int>>> getBytes({@required String url, @required Map<String,dynamic> body, useSSL: false}) async {
    if(useSSL) apiEndPoint = sslEndPoint + "api/zap";
    Response<List<int>> response = await dio.post(
      '$apiEndPoint/$url',
      options: bytesHttpOptions,
      data: body,
    );
    return response;
  }

  String displayCloudFile({@required String path}) {
    String res ='';
    try{
      res = /*serverEndPoint*/ 'https://532997-1700102-raikfcquaxqncofqfm.stackpathdns.com/' + 'uploads/' + path;
      print("CloudFile: $res");
    }catch(ex){
      print("Catch Error: ${ex.toString()}");
    }
    //print("res: $res");
    return res;
  }

  Future<RestUploadTask> uploadFilesToCloud({@required File file, @required File cover}) async{
    RestUploadTask rResult = new RestUploadTask(hasErrors: true);
    if(file != null && cover!=null){
      if(isPhone()){
        try{
          String fileName = file.path.split('/').last;
          String coverName = cover.path.split('/').last;
          FormData formData = new FormData.fromMap({
            "file": await MultipartFile.fromFile(file.path, filename: fileName),
            "cover": await MultipartFile.fromFile(cover.path, filename: coverName),
          });
          dynamic photoResponse = await iCloud.postForm(url: 'v2/upload', body: formData);
          final Map<String, dynamic> decodedRep = json.decode(isPhone()? photoResponse.toString() : photoResponse.body.toString());
          if(decodedRep != null && decodedRep['res'] != null) {
            Map<String, dynamic> result = decodedRep["res"];
            rResult.filePath = result['filePath'];
            rResult.coverPath = result['coverPath'];
            rResult.hasErrors = false;
          }else{
            rResult.errors = 'Unrecognized Response From Server.';
          }
        } catch(er){
          rResult.errors = '$er';
        }
      }else{
        try{
          var fileStream = new http.ByteStream(DelegatingStream.typed(file.openRead())),
              coverStream = new http.ByteStream(DelegatingStream.typed(cover.openRead())),
              uri = Uri.parse('$apiEndPoint/v2/upload');
          int fileLength = await file.length();
          int coverLength = await cover.length();

          var request = new http.MultipartRequest('POST', uri),
              multipartFile = new http.MultipartFile('file', fileStream, fileLength, filename: basename(file.path)),
              multipartCover = new http.MultipartFile('cover', coverStream, coverLength, filename: basename(cover.path));
          request.files.add(multipartFile);
          request.files.add(multipartCover);
          request.headers.addAll(postHttpOptions.headers);
          await request.send().then((response) async {
            response.stream.transform(utf8.decoder).listen((value){
              Map<String, dynamic> decodedRep = json.decode(value);
              if(decodedRep != null && decodedRep['res'] != null) {
                Map<String, dynamic> result = decodedRep["res"];
                rResult.filePath = result['filePath'];
                rResult.coverPath = result['coverPath'];
                rResult.hasErrors = false;
              }else{
                rResult.errors = 'Unrecognized Response From Server.';
              }
            });
          }).catchError((error){
            rResult.errors = '$error';
          });
        }catch(er){
          rResult.errors = '$er';
          print("Uploads: $er");
        }
      }
    }
    return rResult;
  }

  Future<RestDownloadTask> downloadFileFromRest({@required RestUploadTask task}) async {
    RestDownloadTask dTask = new RestDownloadTask();
    try{
      String fileName = task.filePath.split('/').last;
      String coverName = task.coverPath.split('/').last;
      String safePath = await getSafeDirectory();
      final File tempFile = File('$safePath/$fileName');
      final File tempCover = File('$safePath/$coverName');
      if (tempFile.existsSync()) await tempFile.delete();
      if (tempCover.existsSync()) await tempCover.delete();

      dynamic fileResponse = isPhone()? await iCloud.getBytes(url: 'v2/download', body: {'path': task.filePath}) : await iCloud.post(url: 'v2/download', body: {'path': task.filePath});
      print("Response: $fileResponse");
      final dynamic decodedFileRep = isPhone()? fileResponse.data : fileResponse.bodyBytes;
      if(decodedFileRep != null) {
        dynamic coverResponse = isPhone()? await iCloud.getBytes(url: 'v2/download', body: {'path': task.coverPath}) : await iCloud.post(url: 'v2/download', body: {'path': task.coverPath});
        final dynamic decodedCoverRep = isPhone()? coverResponse.data : coverResponse.bodyBytes;
        if(decodedCoverRep != null) {
          await tempFile.writeAsBytes(decodedFileRep);
          await tempCover.writeAsBytes(decodedCoverRep);
          String dFilePath = tempFile.path;
          String dCoverPath = tempCover.path;

          //encrypt path//////////////////////////////////////////////////////////////////////
          String ectFilePath = await myStorage.encryptFile(path: dFilePath);
          String ectCoverPath = await myStorage.encryptFile(path: dCoverPath);
          await tempFile.delete();
          await tempCover.delete();
          print("CoverPath: Encrypted: $ectCoverPath");
          print("FilePath: Encrypted: $ectFilePath");
          ///////////////end ////////////////////////////////////////////////////////////////
          dTask = RestDownloadTask(hasError: false, errors: null, encryptedCoverPath: ectCoverPath, encryptedFilePath: ectFilePath);
        }else{
          dTask = RestDownloadTask(hasError: true, errors: 'The server responded with unrecognized data flow while downloading Item cover photo.', encryptedCoverPath: '', encryptedFilePath: '');
        }
      }else{
        dTask = RestDownloadTask(hasError: true, errors: 'The server responded with unrecognized data flow while downloading the Library item.', encryptedCoverPath: '', encryptedFilePath: '');
      }
    } catch(ex) {
      dTask = RestDownloadTask(hasError: true, errors: "Download Error: ${ex.toString()}");
    }
    return dTask;
  }

  ICloud._internal();
}

final iCloud = ICloud();
final bool useRestApiEnvironment = true;