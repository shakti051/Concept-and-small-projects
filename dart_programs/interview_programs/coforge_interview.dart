import 'dart:convert';


void main() {
  var data = {
    "status": "success",
    "data": {
      "users": [
        {
          "id": 1,
          "name": "Shakti",
          "roles": ["admin", "editor"],
          "profile": {
            "email": "shakti@test.com",
            "address": {
              "city": "Delhi",
              "geo": {"lat": "28.61", "lng": "77.23"},
            },
          },
        },
        {"id": 2, "name": "Amit", "roles": [], "profile": null},
      ],
      "meta": {"total": 2, "page": 1},
    },
  };

  //data.forEach((key,value)=>print("$key:$value"));
  print("status ${data["status"]}");
  var ourData = data["data"] as Map<String, dynamic>?;
  // var users = ourData?["users"] as List;
  // for (var user in users) {
  //   print("id: ${user?["id"]}");
  //   print("name: ${user?["name"]}");
  //   var roles = user["roles"] as List?;
  //   if (roles != null && roles.isNotEmpty) {
  //     print("roles: ${roles.join(", ")}");
  //   }
  //   var profile = user?["profile"] as Map<String, dynamic>?;
  //   print(profile?["email"]);
  //   var address = profile?["address"] as Map<String, dynamic>?;
  //   if (address != null) {
  //     print("address ${address["city"]}");
  //     var geo = address["geo"] as Map<String, dynamic>?;
  //     print("Geo lat ${geo?["lat"]}");
  //     print("Geo lug ${geo?["lng"]}");
  //   }
  // }
  // var meta = ourData?["meta"] as Map<String, dynamic>?;
  // print("total ${meta?["total"]}");
  // print("page ${meta?["page"]}");
  var user = User.fromJson(data);
  for (var element in user.data?.users ?? []) {
    print("id ${element.id}");
    print("name ${element.name}");
    var roles = element.roles;
    if (roles != null && roles.isNotEmpty) {
      print("roles ${roles.join(",")}");
    }
    var profile = element.profile;
    if (profile != null) {
      print("Email: ${profile.email}");
      var address = profile.address;
      print("city ${address.city}");
      print("Geo lat ${address.geo.lat}");
      print("Geo lat ${address.geo.lng}");
    }
  }
  print("mata total${user.data?.meta?.total}");
  print("mata page${user.data?.meta?.page}");
}

class User {
  String? status;
  Data? data;

  User({this.status, this.data});

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Users>? users;
  Meta? meta;

  Data({this.users, this.meta});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Users {
  int? id;
  String? name;
  List<String>? roles;
  Profile? profile;

  Users({this.id, this.name, this.roles, this.profile});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roles = json['roles'].cast<String>();
    profile = json['profile'] != null
        ? new Profile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['roles'] = this.roles;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? email;
  Address? address;

  Profile({this.email, this.address});

  Profile.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    address = json['address'] != null
        ? new Address.fromJson(json['address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    return data;
  }
}

class Address {
  String? city;
  Geo? geo;

  Address({this.city, this.geo});

  Address.fromJson(Map<String, dynamic> json) {
    city = json['city'];
    geo = json['geo'] != null ? new Geo.fromJson(json['geo']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    if (this.geo != null) {
      data['geo'] = this.geo!.toJson();
    }
    return data;
  }
}

class Geo {
  String? lat;
  String? lng;

  Geo({this.lat, this.lng});

  Geo.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Meta {
  int? total;
  int? page;

  Meta({this.total, this.page});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['page'] = this.page;
    return data;
  }
}
