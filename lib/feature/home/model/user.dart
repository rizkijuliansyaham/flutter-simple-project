class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? avatar;
  final String? job;

  UserModel({ this.id,  this.name,  this.email,  this.avatar, this.job});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['first_name'] + ' ' + json['last_name'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> tojson() => <String, dynamic>{
        'name': name,
        'job': job
      };

}
