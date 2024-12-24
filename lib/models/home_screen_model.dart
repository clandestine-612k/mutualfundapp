class MutualFund {
  final int schemeCode;
  final String schemeName;

  MutualFund({required this.schemeCode, required this.schemeName});

  // Factory method to create a MutualFund instance from JSON
  factory MutualFund.fromJson(Map<String, dynamic> json) {
    return MutualFund(
      schemeCode: json['schemeCode'],
      schemeName: json['schemeName'],
    );
  }

  // Method to convert a MutualFund instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'schemeCode': schemeCode,
      'schemeName': schemeName,
    };
  }
}
