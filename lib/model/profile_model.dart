class ProfileModel {
  int id;
  String name;
  int age;
  String gender;
  String email;
  String phone;
  String occupation;
  String location;
  String aboutMe;
  String profileImage;
  bool favorite;

  ProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.phone,
    required this.occupation,
    required this.location,
    required this.aboutMe,
    required this.profileImage,
    this.favorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'email': email,
      'phone': phone,
      'occupation': occupation,
      'location': location,
      'aboutMe': aboutMe,
      'profileImage': profileImage,
      'favorite': favorite,
    };
  }

  factory ProfileModel.fromJson(Map<dynamic, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      email: json['email'],
      phone: json['phone'] ?? '',
      occupation: json['occupation'],
      location: json['location'],
      aboutMe: json['aboutMe'],
      profileImage: json['profileImage'],
      favorite: json['favorite'] ?? false,
    );
  }
}
