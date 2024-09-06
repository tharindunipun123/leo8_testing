// 
class databases {
  final int id;
  final String name;
  final String address;
  final int count;
  final String? newDate; // Allow null values for the newDate
  bool done;

  databases({
    required this.id,
    required this.name,
    required this.address,
    required this.count,
    this.newDate, // Allow null values for the newDate
    this.done = false,
  });

  factory databases.fromMap(Map<String, dynamic> databasesMap) {
    return databases(
      id: databasesMap['id'],
      name: databasesMap['name'],
      address: databasesMap['address'],
      count: databasesMap['count'],
      newDate: databasesMap['newDate'] ?? 'Unknown', // Provide a default value if null
    );
  }

  void toggle() {
    done = !done;
  }
}
