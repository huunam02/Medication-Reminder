class History {
  int? id;
  String? dateTime;
  int? ml;
  String? unit;

  // Constructor
  History({this.id, this.dateTime, this.ml, this.unit});
  // Tạo đối tượng từ Map (dùng khi đọc dữ liệu từ DB hoặc JSON)
  factory History.fromMap(Map<String, dynamic> map) {
    return History(
        id: map['id'],
        dateTime: map['datetime'],
        ml: map['ml'],
        unit: map['unit']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'dateTime': dateTime, 'ml': ml, 'unit': unit};
  }
}
