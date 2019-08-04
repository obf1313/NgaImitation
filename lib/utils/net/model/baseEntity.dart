class BaseEntity<T>{
  String flag;
  String msg;
  T data;

  BaseEntity(this.flag, this.msg, this.data);
}