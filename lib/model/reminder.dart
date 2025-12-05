class Reminder {
   int? id;
   String? title;
   String dateTime;
   bool isOn;

  // Constructor
  Reminder({
    this.id,
    this.title,
    required this.dateTime,
   required this.isOn,
  });

  // Tạo một object từ Map (dùng khi lấy dữ liệu từ database)
  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      title: map['title'] as String,
      dateTime: map['datetime'] as String,
      isOn: map['isOn'] == 1 ? true : false, // SQLite lưu bool dưới dạng 0 và 1
    );
  }

  // Chuyển object thành Map (dùng khi insert/update database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime,
      'isOn': isOn == true ? 1 : 0, // Chuyển bool thành 0 hoặc 1
    };
  }

  // Hàm copyWith để sao chép object và thay đổi giá trị
  Reminder copyWith({
    int? id,
    String? title,
    String? dateTime,
    bool? isOn,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isOn: isOn ?? this.isOn,
    );
  }

  // Chuyển object thành String (debug/logging)
  @override
  String toString() {
    return 'Reminder(id: $id, title: $title, dateTime: $dateTime, isOn: $isOn)';
  }
}
