class ParcelaOffline {
  int index;
  int id;
  String item;
  int categoryId;
  int plotsId;

  ParcelaOffline({ this.index,this.id, this.item, this.categoryId, this.plotsId});
  ParcelaOffline.fromJson(Map<String, dynamic> json) {
    index = json['id_auto'];
    id = json['id'];
    item = json['item'];
    categoryId = json['category_id'];
    plotsId = json['plots_id'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_auto'] = this.index;
    data['id'] = this.id;
    data['item'] = this.item;
    data['category_id'] = this.categoryId;
    data['plots_id'] = this.plotsId;

    return data;
  }
}