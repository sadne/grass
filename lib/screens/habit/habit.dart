import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grass/models/habit.dart';
import 'package:grass/screens/habit_edit/habit_edit.dart';
import 'package:grass/stores/habit_store.dart';
import 'package:grass/utils/bridge/native_method.dart';
import 'package:grass/utils/colors.dart';
import 'package:grass/utils/constant.dart';
import 'package:grass/utils/helper.dart';
import 'package:grass/widgets/app_bar/app_bar.dart';
import 'package:grass/widgets/icons/icons.dart';
import 'package:provider/provider.dart';

import 'calendar_tile.dart';
import 'list.dart';

class HabitScreen extends StatefulWidget {
  HabitScreen({Key key}) : super(key: key);

  @override
  _HabitScreenState createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  CalendarTileController _controller = CalendarTileController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final habitStore = Provider.of<HabitStore>(context, listen: false);
      await habitStore.didLoad();
    });
  }

  Widget _appBarMiddle(DateTime selectedDate) {
    final items = <Widget>[Text(dateTimeFromNow(selectedDate, 'yyyy年MM月dd日'))];
    if (calculateDifference(selectedDate, DateTime.now()).abs() > 1) {
      items.addAll([
        SizedBox(width: 5),
        GestureDetector(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: GsColors.of(context).backgroundGray,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              height: 20,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '今天',
                style: TextStyle(fontSize: 12, color: GsColors.of(context).primary),
              ),
            ),
          ),
          onTap: () {
            NativeMethod.impactFeedback(ImpactFeedbackStyle.soft);
            Constant.emitter.emit('habit@close_slidable');
            final habitStore = Provider.of<HabitStore>(context, listen: false);
            habitStore.setSelectedDate(DateTime.now());
            _controller.goToday();
          },
        ),
      ]);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: items,
    );
  }

  Widget _placeholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image(
          image: AssetImage('assets/images/placeholder.png'),
          width: 160,
          color: GsColors.of(context).gray,
        ),
        SizedBox(height: 20),
        Text(
          '您的任务列表为空\n请点击‘+’创建一个新习惯吧',
          textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 14, color: GsColors.of(context).gray),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        final habitStore = Provider.of<HabitStore>(context);
        return Scaffold(
          backgroundColor: GsColors.of(context).background,
          appBar: GsAppBar(
            shadow: false,
            middle: _appBarMiddle(habitStore.selectedDate),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(FeatherIcons.menu, color: GsColors.of(context).gray),
              onPressed: () {
                Constant.emitter.emit('drawer@toggle');
                Constant.emitter.emit('habit@close_slidable');
              },
            ),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(FeatherIcons.plus, color: GsColors.of(context).gray),
              onPressed: () {
                Constant.emitter.emit('habit@close_slidable');
                NativeMethod.impactFeedback(ImpactFeedbackStyle.light);
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HabitEditScreen(habit: Habit())
                  ),
                );
              },
            ),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CalendarTile(
                selectedDate: habitStore.selectedDate,
                controller: _controller,
              ),
              Expanded(
                child: Material(
                  color: GsColors.of(context).background,
                  child: habitStore.isLoaded
                      ? habitStore.habits.isEmpty ? _placeholder() : List(items: habitStore.habits) 
                      : Center(),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
