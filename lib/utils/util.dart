import 'dart:io';

write(String text) async {}

/*Future<String> read() async {
  String text = "none";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/saved.json');
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return text;
}
*/
Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}
