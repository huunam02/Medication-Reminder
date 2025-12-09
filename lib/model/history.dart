class History {
  int? id;
  int? reminderId;
  String? title;
  int? amount;
  String? dateTime;
  String? unit;

  // Constructor
  History({this.id, this.reminderId, this.title, this.amount, this.dateTime, this.unit});
  // Tạo đối tượng từ Map (dùng khi đọc dữ liệu từ DB hoặc JSON)
  factory History.fromMap(Map<String, dynamic> map) {
    return History(
        id: map['id'],
        reminderId: map['reminderId'],
        title: map['title'],
        amount: map['amount'],
        dateTime: map['datetime'],
        unit: map['unit']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reminderId': reminderId,
      'title': title,
      'amount': amount,
      'datetime': dateTime,
      'unit': unit
    };
  }
}
