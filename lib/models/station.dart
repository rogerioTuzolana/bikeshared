class Station{
  String stationId;
  String name;
  String address;
  double lat;
  double long;
  int capacity;
  int freeDocks;
  int totalGets;
  int totalReturns;
  int availableBikeShared;


  Station({
    required this.stationId,
    required this.name,
    required this.address,
    required this.lat,
    required this.long,
    required this.capacity,
    required this.freeDocks,
    required this.totalGets,
    required this.totalReturns,
    required this.availableBikeShared,
  });
}