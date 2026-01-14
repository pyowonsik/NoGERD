import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:no_gerd/features/auth/presentation/bloc/auth_state.dart';

/// AuthBloc의 상태 변경을 감지하여 GoRouter의 redirect를 재실행하는 리스너
class RouteRefreshListener extends ChangeNotifier {
  RouteRefreshListener(this._authBloc) {
    notifyListeners();
    _authStreamSubscription = _authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  final AuthBloc _authBloc;
  late final StreamSubscription<AuthState> _authStreamSubscription;

  @override
  void dispose() {
    _authStreamSubscription.cancel();
    super.dispose();
  }
}
