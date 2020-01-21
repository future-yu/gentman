
import 'package:gentman/models/ItemDetail.dart';
import 'package:html/dom.dart';
import '../models/ListItemModel.dart';
import 'package:html/parser.dart' show parse;

class EXParser {
  //搜索页解析
  static SearchParserModel getSearchList(html) {
    List<ListItemModel> list = [];

    Document elems = parse(html);
    //标题
    List<Element> pElem = elems.querySelectorAll(".gltc>tbody>tr");
    List<Element> pageElems = elems.querySelectorAll(".ptt td");
    Element lastElem = pageElems[pageElems.length - 2];
    pElem.getRange(1, pElem.length).forEach((Element elem) {
      Element imgElem = elem.querySelector(".glthumb>div>img");
      String img_src = imgElem.attributes["data-src"] == null
          ? imgElem.attributes["src"]
          : imgElem.attributes["data-src"];
      String category = elem.children[0].children[0].text;

      Element titleElem = elem.querySelector(".glname>a");
      String title = titleElem.children[0].text;
      String detail_url = titleElem.attributes["href"];

      list.add(
        ListItemModel(
          title: title,
          cover_image_url: img_src,
          detail_url: detail_url,
          category: category,
        ),
      );
    });

    return SearchParserModel(int.parse(lastElem.text), list);
  }

  //详情页解析
  static ItemDetail getItemDetail(html,targetUrl){
    Document elems = parse(html);
    List<Element> allTr = elems.querySelectorAll("#taglist>table>tbody>tr");
    ItemDetail itemDetail = ItemDetail();
    allTr.forEach((Element element){
        Map<String,String> tags = {};
        String tagName = element.children[0].text;
        element.children[1].children.forEach((Element element){
          Element aElem = element.querySelector("a");
          tags[aElem.text] = aElem.attributes["href"];
        });
        itemDetail.tags[tagName] = tags;
    });
    itemDetail.ENTitle = elems.querySelector("#gn").text;
    itemDetail.JapanTitle = elems.querySelector("#gj").text;
    List<Element> pageInfo = elems.querySelectorAll(".ptt>tbody>tr>td");
    Element lastPageElem = pageInfo.elementAt(pageInfo.length-2);
    int maxPage = int.parse(lastPageElem.text);
    for(int i=1;i<=maxPage;i++){
      itemDetail.allPages.add("$targetUrl?p=$i");
    }
    List<Element> detailImg = elems.querySelectorAll("#gdt>.gdtl");
    detailImg.forEach((Element element){
      Element targetElem = element.children[0];
      itemDetail.imageSrc.add({
        "thumb":targetElem.children[0].attributes["src"],
        "targetImg":targetElem.attributes["href"],
      });
    });
    itemDetail.targetUrl = targetUrl;
    Element thumbElem = elems.querySelector("#gd1>div");
    RegExp reg = RegExp(r"\http.+\.jpg");
    var match = reg.firstMatch(thumbElem.attributes["style"]);
    itemDetail.thumbUrl = match.group(0);


    return itemDetail;
  }
}

class SearchParserModel {
  final int max_length;
  final List<ListItemModel> list;
  SearchParserModel(this.max_length, this.list);
}
