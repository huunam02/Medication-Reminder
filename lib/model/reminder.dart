class Reminder {
   int? id;
   String? title;
   String dateTime;
   bool isOn;
   int? quantity;
   String? repeatDays; // "1,2,3,4,5,6,7" for daily, or specific days

  // Constructor
  Reminder({
    this.id,
    this.title,
    required this.dateTime,
   required this.isOn,
   this.quantity,
   this.repeatDays,
  });

  // Tạo một object từ Map (dùng khi lấy dữ liệu từ database)
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      title: map['title'] as String,
      dateTime: map['datetime'] as String,
      isOn: map['isOn'] == 1 ? true : false, // SQLite lưu bool dưới dạng 0 và 1
      quantity: map['quantity'] as int?,
      repeatDays: map['repeatDays'] as String?,
    );
  }

  // Chuyển object thành Map (dùng khi insert/update database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime,
      'isOn': isOn == true ? 1 : 0, // Chuyển bool thành 0 hoặc 1
      'quantity': quantity,
      'repeatDays': repeatDays,
    };
  }

  // Hàm copyWith để sao chép object và thay đổi giá trị
  Reminder copyWith({
    int? id,
    String? title,
    String? dateTime,
    bool? isOn,
    int? quantity,
    String? repeatDays,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isOn: isOn ?? this.isOn,
      quantity: quantity ?? this.quantity,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }

  // Chuyển object thành String (debug/logging)
  @override
  String toString() {
    return 'Reminder(id: $id, title: $title, dateTime: $dateTime, isOn: $isOn)';
  }
}
