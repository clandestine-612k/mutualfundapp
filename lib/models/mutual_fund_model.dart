class MutualFund2 {
  Meta? meta;
  List<Data>? data;
  String? status;

  MutualFund2({this.meta, this.data, this.status});

  MutualFund2.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Meta {
  String? fundHouse;
  String? schemeType;
  String? schemeCategory;
  int? schemeCode;
  String? schemeName;

  Meta(
      {this.fundHouse,
      this.schemeType,
      this.schemeCategory,
      this.schemeCode,
      this.schemeName});

  Meta.fromJson(Map<String, dynamic> json) {
    fundHouse = json['fund_house'];
    schemeType = json['scheme_type'];
    schemeCategory = json['scheme_category'];
    schemeCode = json['scheme_code'];
    schemeName = json['scheme_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fund_house'] = this.fundHouse;
    data['scheme_type'] = this.schemeType;
    data['scheme_category'] = this.schemeCategory;
    data['scheme_code'] = this.schemeCode;
    data['scheme_name'] = this.schemeName;
    return data;
  }
}

// class Data {
//   String? date;
//   String? nav;

//   Data({this.date, this.nav});

//   Data.fromJson(Map<String, dynamic> json) {
//     date = json['date'];
//     nav = json['nav'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['date'] = this.date;
//     data['nav'] = this.nav;
//     return data;
//   }
// }

class Data {
  String? date;
  String? nav;

  Data({this.date, this.nav});

  Data.fromJson(Map<String, dynamic> json) {
    date = _parseDate(json['date']);
    nav = json['nav'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['nav'] = nav;
    return data;
  }

  // Function to parse and format the date
  static String? _parseDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;
    try {
      final date = DateTime.parse(rawDate);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      // Handle other formats (e.g., DD-MM-YYYY)
      final parts = rawDate.split('-'); // Adjust for your format
      if (parts.length == 3) {
        final day = parts[0];
        final month = parts[1];
        final year = parts[2];
        return '$year-$month-$day';
      }
      return rawDate; // Fallback: return the raw date if it can't be parsed
    }
  }
}
