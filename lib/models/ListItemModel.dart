
class ListItemModel{
  ListItemModel({this.title,this.cover_image_url,this.detail_url,this.category,this.author,this.tags,this.thumb});
  final String title;
  final String cover_image_url;
  final String detail_url;
  String category;//类别(Image Set/Manga)
  String author;//作者
  int rating;//评分
  Map<String,Map<String,String>> tags;//标签及其地址
  List<String> thumb;//缩略图地址
}