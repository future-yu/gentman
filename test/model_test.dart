import 'package:flutter_test/flutter_test.dart';
import 'package:gentman/api/Remote.dart';
import 'package:gentman/models/ItemDetail.dart';
import 'package:gentman/tools/EXParser.dart';

void main(){
  test("itemdetail test", ()async{
    ItemDetail itemDetail = ItemDetail();
    Remote remote = Remote();
    remote.addProxy("localhost:1087");
    String html = await remote.getHtml("https://exhentai.org/g/1556166/e66daab32c/");
    EXParser.getItemDetail(html,"https://exhentai.org/g/1556166/e66daab32c/");
  });
}