class Solicitation{
  int id;
  String station;
  String address;
  double lat;
  double long;
  bool hasBikeShared;
  String stationReturn;

  Solicitation({
    required this.id,
    required this.station,
    required this.address,
    required this.lat,
    required this.long,
    required this.hasBikeShared,
    required this.stationReturn,
  });

}