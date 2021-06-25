class ResidenceStatus {
  final String address;
  final String residenceNo;
  final String residenceType;
  final String visaExpireDate;

  ResidenceStatus({
    required this.address,
    required this.residenceNo,
    required this.residenceType,
    required this.visaExpireDate,
  });

  factory ResidenceStatus.fromJson(Map<String, dynamic> data) {
    return ResidenceStatus(
      address: data['address'],
      residenceNo: data['residence_no'],
      residenceType: data['residence_type'],
      visaExpireDate: data['visa_expire_date'],
    );
  }
}