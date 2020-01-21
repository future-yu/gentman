class ItemDetail{
  String ENTitle;
  String JapanTitle;
  String author;
  String thumbUrl="";
  String targetUrl;

  //标签
  /*
  * {
  *   languge:{
  *     chinese:"https://ssss",
  *     english:"https://ascasascw"
  *   }
  * }
  *
  * */
  Map<String,Map<String,String>> tags={};
  List<String> allPages=[];
  List<Map<String,String>> imageSrc = [];

}