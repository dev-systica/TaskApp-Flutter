import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:tasks_flutter/screens/task_list/presenter.dart';
import 'package:tasks_flutter/widgets/circle_progress.dart';
import 'package:tasks_flutter/widgets/common_card.dart';
import 'package:tasks_flutter/screens/task_list/view.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../config/routing_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomeView{
  final HomePresenter _presenter = BasicHomePresenter();
  final _list = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _presenter.onViewAttached(this);
    _presenter.onLoad();
  }

  @override
  void dispose() {
    _presenter.onViewDetached();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFFC0392B),
          title: const Text('Tasks'),

      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFC0392B),
          onPressed: () => _displayDialog(context),
          tooltip: 'Add Item',
          child: Icon(Icons.add)),
    );
  }

  Widget _body() {
    if (_isLoading) {
      return Center(child: CircleProgress(size: 50));
    }

    if (_list.isEmpty) {
      return Center(child: Text("No task added yet"));
    }

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: _list.length,
      itemBuilder: (context, index) {
final RecordSnapshot item = _list[index];

        return _buildTodoItem(item);
      },
        );
  }

  Widget _buildTodoItem(RecordSnapshot item) {
    Color clr = Colors.grey;
    if (item.value["color"] != null) {
      clr = Color(item.value["color"]);
    }

    IconData icon;
    final iconObj = item.value["icon"];
    if (iconObj != null) {
      icon = IconData(iconObj["codePoint"], fontFamily: iconObj["fontFamily"], fontPackage: iconObj["fontPackage"], matchTextDirection: iconObj["matchTextDirection"]);
    }

    return InkWell(
      onTap: (){
        _presenter.onCardClick(item.value);
      },
      child: CommonCard(radius: 10,elevation: 0, color: clr,padding: 15,
          child: Row(
            children: [
              Expanded(child: Text(item.value["name"], style: const TextStyle(color: Colors.white, fontSize: 15),)),
              SizedBox(width: 10),
              icon == null ? Container() : Icon(icon, color: Colors.white,),
            ],
          )),
    );
  }

  Future<Future> _displayDialog(BuildContext context) async {
    final _textFieldController = TextEditingController();
    final Map<String, Object> task = Map();
    Color _selectedColor;

    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Add a task to your list'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    maxLines: 3,
                    controller: _textFieldController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Enter task here"
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('Pick a color!'),
                                content: SingleChildScrollView(
                                  child: BlockPicker(
                                    pickerColor: Colors.grey,
                                    onColorChanged: (Color color){
_selectedColor = color;
                                    },
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('DONE'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      if (_selectedColor == null) {
                                        return;
                                      }

                         task["color"] = _selectedColor.value;
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      },
                          child: Text("Choose a Colour", style: TextStyle(fontSize: 13)),
                      style: OutlinedButton.styleFrom(primary: Colors.black,side: BorderSide(width: 0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      ),
                      SizedBox(width: 5),
                      OutlinedButton(onPressed: () async{
                        final IconData result = await showIconPicker(
                            context: context, defalutIcon: Icons.home_repair_service);
if (result == null) {
  return;
}

task["icon"] = {
  "codePoint": result.codePoint,
  "fontFamily": result.fontFamily,
  "fontPackage": result.fontPackage,
  "matchTextDirection": result.matchTextDirection
};
                      },
                          child: Text("Choose an icon", style: TextStyle(fontSize: 13),),
                        style: OutlinedButton.styleFrom(primary: Colors.black,side: BorderSide(width: 0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      )
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('CANCEL', style: TextStyle(color: Color(0xFFE34040)),),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: const Color(0xFFE34040),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      primary: Colors.white
                  ),
                  child: const Text('ADD'),
                  onPressed: () {
if (_textFieldController.text.trim().isEmpty) {
  ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text("Enter task name")));
  return;
}

Navigator.of(context).pop();
task["name"] = _textFieldController.text.trim();
_presenter.onAddTask(task);
                  },
                ),
              ],
            ),
          );
        }
    );
  }

  Future<IconData> showIconPicker(
      { BuildContext context, IconData defalutIcon}) async {

    final List<IconData> allIcons = [
      Icons.umbrella_sharp,
      Icons.favorite,
      Icons.headphones,
      Icons.home,
      Icons.car_repair,
      Icons.settings,
      Icons.flight,
      Icons.ac_unit,
      Icons.run_circle,
      Icons.book,
      Icons.sports_rugby_rounded,
      Icons.alarm,
      Icons.call,
      Icons.snowing,
      Icons.hearing,
      Icons.music_note,
      Icons.note,
      Icons.edit,
      Icons.sunny,
      Icons.radar,

    ];

    IconData selectedIcon = defalutIcon;

    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Pick an Icon'),
          content: Container(
            width: 320,
            height: 400,
            alignment: Alignment.center,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 60,
                    childAspectRatio: 1 / 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: allIcons.length,
                itemBuilder: (_, index) => Container(
                  key: ValueKey(allIcons[index].codePoint),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: IconButton(
                      color: selectedIcon == allIcons[index]
                          ? Colors.blue
                          : Colors.black54,
                      iconSize: 30,
                      icon: Icon(
                        allIcons[index],
                      ),
                      onPressed: () {
                        selectedIcon = allIcons[index];
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'))
          ],
        ));

    return selectedIcon;
  }

  @override
  void onNavigateToMore(task) {
    Navigator.pushNamed(context, MoreViewRoute, arguments: task);
  }

  @override
  void onSetProgress(bool value) {
    setState(() => _isLoading = value);
  }

  @override
  void onLoaded(List list) {
    _list.clear();
    _list.addAll(list);
    setState(() {});
  }

}
