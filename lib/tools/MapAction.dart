class MapAction {
  static Map getUpdateMap(Map old_map, Map new_map) {
    new_map.keys.forEach((key){
      old_map[key] = new_map[key];
    });
    return old_map;
  }
}
