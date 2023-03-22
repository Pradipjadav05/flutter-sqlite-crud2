// ignore_for_file: public_member_api_docs, sort_constructors_first

class Users {
  int id = 0;
  String name = "";
  String password = "";

  Users({required this.id, required this.name, required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'password': password,
    };
  }

  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'] as int,
      name: map['name'] as String,
      password: map['password'] as String,
    );
  }
}
