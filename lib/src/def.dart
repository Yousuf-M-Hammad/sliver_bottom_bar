part of sliver_bottom_bar;

typedef AnimatedWidgetBuilder = Widget Function(
    BuildContext context, Animation<double> animation);

typedef ItemsSelector = List<int> Function(int index);
