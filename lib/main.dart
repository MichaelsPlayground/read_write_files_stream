import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_sodium/flutter_sodium.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'crypto_util.dart';

import 'encryption_result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Read & write files with stream'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //_incrementCounter;

          // get internal directory
          Directory directory = await getApplicationDocumentsDirectory();

          // write a text file
          print('write a text file');
          //final f1 = 'file1.txt';
          final f1 = '${directory.path}/file1.txt';
          new File(f1)
              .writeAsString('my string to write' '\nmeine 2. Zeile')
              .then((File file) {
            // you could do something here when done
          });
          print('write a text file ended');

          // read a text file
          print('read a text file');
          new File('${directory.path}/file1.txt')
              .readAsString()
              .then((String myData1) {
            print('from read a text file: ' + myData1);
          });
          print('read a text file ended');

          //read a text file await
          // read a text file
          print('read a text file await');
          File file = new File('${directory.path}/file1.txt');
          String f1Read = await _readText(file);
          print('read a text file await f1Read: ' + f1Read);
          print('read a text file await ended');

          // write a text file with a stream
          print('write a text file stream');
          var f2 = new File('${directory.path}/file2.txt');
          var sink = f2.openWrite();
          sink.write('stream my line of data 1\n');
          sink.write('stream my line of data 2\n');
          sink.write('FILE ACCESSED ${new DateTime.now()}\n');
          sink.close();
          print('write a text file stream ended');

          // read a text file with a stream
          print('read a text file stream');
          final f3 = new File('${directory.path}/file2.txt');
          Stream<List<int>> inputStream = f3.openRead();
          inputStream
              .transform(utf8.decoder) // UTF-8 decoded from bytes
              .transform(new LineSplitter()) // split into lines
              .listen((String line) {
            // string for each line
            print('read a textFile stream ' +
                '$line: ${line.length} bytes'); // work on a single line
            print('read a textFile stream ' + line);
          }, onDone: () {
            print('read a text file stream File closed.');
          }, onError: (e) {
            print(e.toString());
          });
          print('read a text file stream ended');

          // read a text file with a stream multiple lines
          print('read a text file stream multiple lines');
          final f4 = new File('${directory.path}/file2.txt');
          Stream<List<int>> inputStream4 = f4.openRead();

          Stream<String> f4Lines = inputStream4
              .transform(utf8.decoder)
              .transform(new LineSplitter());
          try {
            await for (String line in f4Lines) {
              print('f4:');
              print('$line: ${line.length} bytes');
              print('read a text file stream multiples lines ' +
                  'Got ${line.length} characters from stream');
              print('read a text file stream multiple lines ' + line);
            }
            print('read a text file stream multiple lines file is now closed');
          } catch (e) {
            print(e);
          }
          print('read a text file stream multiple lines ended');

          print('F5 read a text file stream multiple lines v2');
          final f5 = new File('${directory.path}/file2.txt');
          Stream<List<int>> inputStream5 = f5.openRead();
          Stream<String> f5Lines = inputStream5
              // Decode to UTF8.
              .transform(utf8.decoder)
              // Convert stream to individual lines.
              .transform(new LineSplitter());
          try {
            await for (String line in f5Lines) {
              print('f5:');
              print('$line: ${line.length} bytes');
            }
          } catch (e) {
            print(e.toString());
          }
          print('f5 File is now closed.');
          print('F5 read a text file stream multiple lines v2 ended');

          print('F6 read a text file stream multiple lines v3');
          // https://www.bradcypert.com/dart-futures-and-streams/
          // Open README.md as a byte stream
          Stream<List<int>> inputStream6 =
          File('${directory.path}/file2.txt').openRead();
          final outputStream6 = new File('${directory.path}/file2o.txt');
          var sink6 = outputStream6.openWrite();
          sink6.write('stream my line of data 1\n');
          // Read all bytes from the stream
          try {
            inputStream6.listen((List<int> byteChunk) {
              print(byteChunk);
              sink6.write(byteChunk);
            }, onDone: () {
              sink6.close();
            });
          } catch (e) {
            print(e.toString());
          }

          //final Uint8List bytes = await readByteStream(fileStream);

          // Convert content to string using utf8 codec from dart:convert and print
          //print(utf8.decode(bytes));

          print('F6 read a text file stream multiple lines v3 ended');

          print('F7 encrypt & decrypt a file using libsodium');
          // libsodium ente
          //Map<String, dynamic> args;
          final args = <String, dynamic>{};
          /*
          args["sourceFilePath"] = sourceFilePath;
          args["destinationFilePath"] = destinationFilePath;
          args["key"] = key;
           */

          args["sourceFilePath"] = '${directory.path}/file2.txt';
          var destinationFilePath = '${directory.path}/file7.txt';
          args["destinationFilePath"] = destinationFilePath;
          Uint8List key = new Uint8List(32);
          args["key"] = key;

          // important: check if the destinationFile exist and then delete the old one
          // the file encryption appends the (newly) encrypted data to the old data
          var destinationFile = new File(destinationFilePath);
          var destinationFileExist = await destinationFile.exists();
          if (destinationFileExist == true) {
            print('filePath ' + destinationFilePath + ' exist: ' + 'true');
            destinationFile.delete();
          } else {
            print('filePath ' + destinationFilePath + ' exist: ' + 'false');
          }

          //Future<EncryptionResult> result = chachaEncryptFile(args);
          final result = await chachaEncryptFile(args);

          print('result Enc: ' + result.toString());

          // now decryption

          // important: check if the destinationFile exist and then delete the old one
          // the file encryption appends the (newly) encrypted data to the old data

          args["key"] = key;

          final header = result.header;
          print('header:');
          print(header);

          args["header"] = header;
          args["sourceFilePath"] = '${directory.path}/file7.txt';
          args["destinationFilePath"] = '${directory.path}/file7d.txt';

          //Future<void> decryptionResult = chachaDecryptFile(args);
          await chachaDecryptFile(args);
          print('file decrypted');
          print('F7 encrypt & decrypt a file using libsodium ended');

          print('F8 encrypt & decrypt a file using libsodium');
          // libsodium ente
          //Map<String, dynamic> args;
          final argsF8 = <String, dynamic>{};
          /*
          args["sourceFilePath"] = sourceFilePath;
          args["destinationFilePath"] = destinationFilePath;
          args["key"] = key;
           */

          // real app 84 MB groß
          // CleanMyMacX.dmg
          //args["sourceFilePath"] = '${directory.path}/CleanMyMacX.dmg';
          args["sourceFilePath"] = '${directory.path}/file2.txt';
          var destinationFilePathF8 = '${directory.path}/file8.txt';
          args["destinationFilePath"] = destinationFilePathF8;
          Uint8List keyF8 = new Uint8List(32);
          args["key"] = keyF8;

          // important: check if the destinationFile exist and then delete the old one
          // the file encryption appends the (newly) encrypted data to the old data
          var destinationFileF8 = new File(destinationFilePathF8);
          var destinationFileExistF8 = await destinationFileF8.exists();
          if (destinationFileExistF8 == true) {
            print('filePath ' + destinationFilePathF8 + ' exist: ' + 'true');
            destinationFileF8.delete();
          } else {
            print('filePath ' + destinationFilePathF8 + ' exist: ' + 'false');
          }

          //Future<EncryptionResult> result = chachaEncryptFile(args);
          final resultF8 = await chachaEncryptFileOwn(args);

          print('result Enc: ' + resultF8.toString());

          // now decryption

          args["key"] = keyF8;

          final headerF8 = resultF8.header;
          print('headerF8:');
          print(headerF8);
          print('headerF8Length: ' + headerF8.length.toString());

          args["header"] = headerF8;
          args["sourceFilePath"] = '${directory.path}/file8.txt';
          var destinationFilePathF8Dec = '${directory.path}/file8d.txt';
          args["destinationFilePath"] = destinationFilePathF8Dec;

          // important: check if the destinationFile exist and then delete the old one
          // the file encryption appends the (newly) encrypted data to the old data
          var destinationFileF8Dec = new File(destinationFilePathF8Dec);
          var destinationFileExistF8Dec = await destinationFileF8Dec.exists();
          if (destinationFileExistF8Dec == true) {
            print('filePath ' + destinationFilePathF8Dec + ' exist: ' + 'true');
            destinationFileF8Dec.delete();
          } else {
            print('filePath ' + destinationFilePathF8Dec + ' exist: ' + 'false');
          }

          //Future<void> decryptionResult = chachaDecryptFile(args);
          await chachaDecryptFileOwn(args);
          print('file F8 decrypted');
          print('F8 encrypt & decrypt a file using libsodium ended');


          // derive key from Password
          String passphrase = 'mein geheimes Passwort';
          final salt = PasswordHash.randomSalt();

          int memLimitModerate = Sodium.cryptoPwhashMemlimitModerate;
          int opsLimitModerate = Sodium.cryptoPwhashOpslimitModerate;
          int memLimitSensitive = Sodium.cryptoPwhashMemlimitSensitive;
          int opsLimitSensitive = Sodium.cryptoPwhashOpslimitSensitive;
          var keyResultModerate = '';
          var keyResultSensitive = '';
          try {
            keyResultModerate = await PasswordHash.hashStringStorageModerate(passphrase);
            // do not use Sensitive on Android !!
            //keyResultSensitive = await PasswordHash.hashStringStorageSensitive(passphrase);
          } catch (e, s) {
            // todo logger.severe(e, s);
            print('error e: ' + e.toString() + ' s: ' + s.toString());
          }
          print('MemModerate:  ' + memLimitModerate.toString() + ' OpsModerate: ' + opsLimitModerate.toString());
          print('MemSensitive: ' + memLimitSensitive.toString() + ' OpsSensitive: ' + opsLimitSensitive.toString());
          // MemModerate:  268435456 OpsModerate: 3
          // MemSensitive: 1073741824 OpsSensitive: 4
          print('keyResult Moderate:  ' + keyResultModerate);
          print('keyResult Sensitive: ' + keyResultSensitive);
          // keyResult Moderate: $argon2id$v=19$m=262144,t=3,p=1$OF779YL5NU7lcSakq7Ga4A$f5n3kkBnOgINQHZCRkEjv0xBGZZw3D2R2/i9Ab3RKAE

          // android
          // I/flutter ( 7450): keyResult Moderate:  $argon2id$v=19$m=262144,t=3,p=1$yzT7d09oH0YS8JLHD2Uyeg$whyscSwPr+IPTScre8SgVoKeKM/1X6KExmu7lHkEtdg
          // I/flutter ( 7450): keyResult Sensitive:

          // ios
          // flutter: keyResult Moderate:  $argon2id$v=19$m=262144,t=3,p=1$/ZaH1sgEUNIAv6oV/LKGQQ$snRX2NF5Mkrmz/NH+kz3416rZ6/UjlBNvjk7Zet0Hks
          // flutter: keyResult Sensitive: $argon2id$v=19$m=1048576,t=4,p=1$990p53fKUCOJg0BXr2tMAA$xAazm6RwD1HrE3ixSRfElGq5Ao8cWMMJHGqlDKN2UBU

          //var derivedKeyResult = await CryptoUtil.deriveSensitiveKey(createUint8ListFromString(passphrase), salt);
          //var pwdHashKey = derivedKeyResult.key;
          //print('hashedKey: ' + Sodium.bin2hex(pwdHashKey) + ' length: ' + pwdHashKey.length.toString());


        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  // Reading from a text file
  Future<String> _readText(File file) async {
    String text = '';
    try {
      //final Directory directory = await getApplicationDocumentsDirectory();
      //final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsString();
    } catch (e) {
      print("Couldn't read file");
    }
    return text;
  }

  // Reading from a binary file
  Future<Uint8List> _readUint8List(File file) async {
    Uint8List bytes = new Uint8List(0);
    await file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  // Reading from a binary file
  Future<Uint8List> _readUint8ListStream(Stream stream) async {
    Uint8List bytes = new Uint8List(0);
    /*
    await stream.pipe(streamConsumer) file.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });*/
    return bytes;
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }
}
