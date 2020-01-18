import 'package:html/dom.dart';
import '../models/ListItemModel.dart';
import 'package:html/parser.dart' show parse;

class EXParser {
  final _html;
  EXParser(this._html);

  SearchParserModel getSearchList() {
    List<ListItemModel> list = [];

    Document elems = parse(this._html);
    //标题
    List<Element> pElem = elems.querySelectorAll(".gltc>tbody>tr");
    List<Element> pageElems = elems.querySelectorAll(".ptt td");
    Element lastElem = pageElems[pageElems.length-2];
    pElem.getRange(1, pElem.length).forEach((Element elem) {
      Element imgElem = elem.querySelector(".glthumb>div>img");
      String img_src = imgElem.attributes["data-src"] == null
          ? imgElem.attributes["src"]
          : imgElem.attributes["data-src"];
      String category = elem.children[0].children[0].text;

      Element titleElem = elem.querySelector(".glname>a");
      String title = titleElem.children[0].text;
      String detail_url = titleElem.attributes["href"];

      list.add(ListItemModel(
          title: title,
          cover_image_url: img_src,
          detail_url: detail_url,
          category: category));
    });

    return SearchParserModel(int.parse(lastElem.text),list);
  }
}

class SearchParserModel{
  final int max_length;
  final List<ListItemModel> list;
  SearchParserModel(this.max_length,this.list);
}