class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "AccountEntity") {
      // return AccountEntity.fromJson(json) as T;
    } else if(T.toString() == "String") {
      return json;
    }
//    else if (T.toString() == "UserEntity") {
//      return UserEntity.fromJson(json) as T;
//    }
  }
}