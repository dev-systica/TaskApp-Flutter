import 'package:tasks_flutter/data/database.dart';
import 'package:tasks_flutter/screens/task_list/view.dart';

abstract class HomePresenter{
  void onViewAttached(HomeView view);
  void onViewDetached();
  void onLoad();
  void onAddTask(task);
  void onCardClick(task);
}

class BasicHomePresenter implements HomePresenter{
   HomeView _view;
   final DatabaseHelper _databaseHelper = DatabaseHelper();

  BasicHomePresenter();

  @override
  void onViewAttached(HomeView view) {
    _view = view;
  }

  @override
  void onViewDetached() {
     _view = null;
  }

   @override
   void onCardClick(task) {
     _view?.onNavigateToMore(task);
   }

  @override
  void onLoad() async {
    _view?.onSetProgress(true);
    final tasks = await _databaseHelper.getTasks();
_view?.onLoaded(tasks??[]);
    _view?.onSetProgress(false);
  }

  @override
  void onAddTask(task) async {
await _databaseHelper.addTask(DateTime.now().millisecondsSinceEpoch.toString(), task);
onLoad();
  }

}
