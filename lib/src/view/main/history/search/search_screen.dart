import 'package:elevator/res/values/styles.dart';
import 'package:elevator/src/core/ui/base_stateless_widget.dart';
import 'package:elevator/src/core/ui/ui_utils.dart';
import 'package:elevator/src/data/repositories/history/history_repository.dart';
import 'package:elevator/src/di/dependency_injection.dart';
import 'package:elevator/src/domain/responses/order/order.dart';
import 'package:elevator/src/view/main/home/list_item.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class SearchScreen extends BaseStatelessWidget {
  final HistoryRepository _historyRepository = injector.get();
  final SearchBarController<Order> _searchBarController = SearchBarController();

  @override
  Widget getLayout(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SearchBar<Order>(
          shrinkWrap: true,
          hintText: "АВ 0000 АВ",
          loader: getProgress(background: false),
          minimumChars: 2,
          searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
          headerPadding: EdgeInsets.symmetric(horizontal: 10),
          onSearch: _historyRepository.getFilteredByNumber,
          searchBarController: _searchBarController,
          placeHolder: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "Введіть текст, щоб здійснити пошук. Мінімальна кількість - 2 символи. Літери і цифри відділені пробілом",
                textAlign: TextAlign.center,
                style: getMidFont(),
              ),
            ),
          ),
          cancellationWidget: Text("Відміна"),
          emptyWidget: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
              "Не знайдено",
              style: getBigFont(),
            )),
          ),
          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RaisedButton(
                child: Text("Найновіші"),
                onPressed: () {
                  _searchBarController.sortList((Order a, Order b) {
                    return a.timeStatus.compareTo(b.timeStatus);
                  });
                },
              ),
              RaisedButton(
                child: Text("Не сортувати"),
                onPressed: () {
                  _searchBarController.removeSort();
                },
              ),
              RaisedButton(
                child: Text("Повторити"),
                onPressed: () {
                  _searchBarController.replayLastSearch();
                },
              ),
            ],
          ),
          onCancelled: () {
            print("Cancelled triggered");
          },
          crossAxisCount: 1,
          onItemFound: (Order order, int index) {
            return ListItem(order);
          },
        ),
      ),
    );
  }
}
