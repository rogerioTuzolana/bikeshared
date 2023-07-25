class Station{
  String name;
  String address;
  double lat;
  double long;
  int capacity;
  int freeDocks;
  int totalGets;
  int totalReturns;

  Station({

    required this.name,
    required this.address,
    required this.lat,
    required this.long,
    required this.capacity,
    required this.freeDocks,
    required this.totalGets,
    required this.totalReturns,
  });
}