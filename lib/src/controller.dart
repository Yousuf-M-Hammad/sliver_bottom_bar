part of sliver_bottom_bar;

class AbstractSliverBottomBarController {
  AbstractSliverBottomBarController();
  late _AbstractSliverBottomBarState _state;
  void _init(_AbstractSliverBottomBarState state) => _state = state;

  TickerFuture animateOpen({double? from}) =>
      _state._animationController.forward(from: from);

  TickerFuture animateClose({double? from}) =>
      _state._animationController.reverse(from: from);

  Animation<double> get animationView => _state.animationView;
}

class SliverBottomNavigationBarController {
  int intialIndex;
  SliverBottomNavigationBarController([this.intialIndex = 0]);
  late _SliverBottomNavigationBarState _state;
  void _init(_SliverBottomNavigationBarState state) => _state = state;

  TickerFuture expandBar({double? from}) =>
      _state._ASBController.animateOpen(from: from);

  TickerFuture shrinkBar({double? from}) =>
      _state._ASBController.animateClose(from: from);

  int get index => _state._index;
  int get lastIndex => _state._lastIndex;
  void animateToIndex(int index) => _state._animateToIndex(index);
}
