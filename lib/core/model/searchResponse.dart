class SearchResponse {
  String? status;
  int? dataFound;
  List<Data>? data;

  SearchResponse({this.status, this.dataFound, this.data});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    dataFound = json['dataFound'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['dataFound'] = dataFound;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? visitorID;
  String? visitorName;
  String? company;
  String? address;
  String? city;
  String? pincode;
  String? gstN;
  String? mobileNumber;
  String? photoURL;
  String? registrationID;
  int? status;
  String? badgeCategory;

  Data(
      {this.visitorID,
        this.visitorName,
        this.company,
        this.address,
        this.city,
        this.pincode,
        this.gstN,
        this.mobileNumber,
        this.photoURL,
        this.registrationID,
        this.status,
        this.badgeCategory});

  Data.fromJson(Map<String, dynamic> json) {
    visitorID = json['visitorID'];
    visitorName = json['visitorName'];
    company = json['company'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    gstN = json['gstN'];
    mobileNumber = json['mobileNumber'];
    photoURL = json['photoURL'];
    registrationID = json['registrationID'];
    status = json['status'];
    badgeCategory = json['badgeCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorID'] = visitorID;
    data['visitorName'] = visitorName;
    data['company'] = company;
    data['address'] = address;
    data['city'] = city;
    data['pincode'] = pincode;
    data['gstN'] = gstN;
    data['mobileNumber'] = mobileNumber;
    data['photoURL'] = photoURL;
    data['registrationID'] = registrationID;
    data['status'] = status;
    data['badgeCategory'] = badgeCategory;
    return data;
  }
}