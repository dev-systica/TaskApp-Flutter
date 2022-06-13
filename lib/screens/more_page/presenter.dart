import 'package:tasks_flutter/screens/more_page/view.dart';

abstract class MorePresenter{
  void onViewAttached(MoreView view);
  void onViewDetached();
}

class BasicMorePresenter implements MorePresenter{
  MoreView _view;
  BasicMorePresenter();

  @override
  void onViewAttached(MoreView view) {
    _view = view;
  }

  @override
  void onViewDetached() {
    _view = null;
  }
}