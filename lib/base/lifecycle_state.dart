import 'package:flutter/material.dart';

abstract class LifecycleState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState
            .resumed: // Ứng dụng ở trạng thái hoạt động hoàn toàn và người dùng có thể tương tác với nó.
        onResumed();
        break;
      case AppLifecycleState
            .inactive: // Ứng dụng ở trạng thái không hoạt động nhưng vẫn đang chạy. Trạng thái này xảy ra khi ứng dụng đang chuyển đổi giữa các trạng thái khác hoặc có một sự kiện tạm thời như người dùng mở Notification Center hoặc có một cuộc gọi đến.
        onInactive();
        break;
      case AppLifecycleState.paused: // Ứng dụng ở chế độ nền
        onPaused();
        break;
      case AppLifecycleState
            .detached: //Ứng dụng đã tách khỏi hệ điều hành, thường là khi ứng dụng bị đóng hoặc hủy bỏ.
        onDetached();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      onKeyboardShow();
    } else {
      onKeyboardHint();
    }
  }

  void onKeyboardShow();

  void onKeyboardHint();

  void onResumed();

  void onPaused();

  void onInactive();
  
  void onDetached();
}
