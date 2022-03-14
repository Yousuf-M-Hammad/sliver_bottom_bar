// ignore_for_file: prefer_initializing_formals

part of sliver_bottom_bar;

const Duration _kDefaultNavigationTransitionDuration =
    Duration(milliseconds: 300);
const Curve _kDefaultNavigationTransitionCurve = Curves.ease;

class SliverBottomNavigationBar extends StatefulWidget {
  final List<AnimatedWidgetBuilder>? items;
  final List<Widget>? _buldkItems;
  final AnimatedWidgetBuilder? beforeBody;
  final AnimatedWidgetBuilder? afterBody;
  final Duration? expansionDuration;
  final Curve? curve;
  final double? snapAfter;
  final bool? snap;
  final double? deltaDivisionFactor;
  final bool? reverseExpansion;
  final bool? startsExpanded;
  final SliverBottomNavigationBarController? controller;
  final bool? expandOnOverScroll;
  final Duration selectionDuration;
  final Curve selectionCurve;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final IconThemeData? selectedIconTheme;
  final IconThemeData? unselectedIconTheme;

  /// The (always there) [onSelected] but with a little tweek, it returns an [int] to the desired page but if returned null nothing will happen.
  final int? Function(int) onSelected;
  const SliverBottomNavigationBar({
    Key? key,
    required List<AnimatedWidgetBuilder> items,
    required this.onSelected,
    this.beforeBody,
    this.afterBody,
    this.expansionDuration,
    this.curve,
    this.snapAfter,
    this.snap,
    this.deltaDivisionFactor,
    this.reverseExpansion,
    this.startsExpanded,
    this.controller,
    this.expandOnOverScroll,
    this.selectionCurve = _kDefaultNavigationTransitionCurve,
    this.selectionDuration = _kDefaultNavigationTransitionDuration,
  })  : _buldkItems = null,
        items = items,
        selectedTextStyle = null,
        unselectedTextStyle = null,
        selectedIconTheme = null,
        unselectedIconTheme = null,
        super(key: key);

  const SliverBottomNavigationBar.ready({
    Key? key,
    required this.onSelected,
    required List<Widget> items,
    this.beforeBody,
    this.afterBody,
    this.expansionDuration,
    this.curve,
    this.snapAfter,
    this.snap,
    this.deltaDivisionFactor,
    this.reverseExpansion,
    this.startsExpanded,
    this.controller,
    this.expandOnOverScroll,
    this.selectionDuration = _kDefaultNavigationTransitionDuration,
    this.selectionCurve = _kDefaultNavigationTransitionCurve,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.selectedIconTheme,
    this.unselectedIconTheme,
  })  : items = null,
        _buldkItems = items,
        super(key: key);
  @override
  State<SliverBottomNavigationBar> createState() =>
      _SliverBottomNavigationBarState();
}

class _SliverBottomNavigationBarState extends State<SliverBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animationForward;
  late final Animation<double> _animationReverse;
  // ignore: non_constant_identifier_names
  final AbstractSliverBottomBarController _ASBController =
      AbstractSliverBottomBarController();

  late int _index;
  late int _lastIndex;

  IconThemeData get _selectedIcon =>
      widget.selectedIconTheme ??
      Theme.of(context).bottomNavigationBarTheme.selectedIconTheme ??
      const IconThemeData.fallback().copyWith(
        color: Theme.of(context).primaryColor,
      );

  IconThemeData get _unselectedIcon =>
      widget.unselectedIconTheme ??
      Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme ??
      const IconThemeData.fallback().copyWith(
        color: Theme.of(context).unselectedWidgetColor,
      );

  TextStyle get _selectedStyle =>
      widget.selectedTextStyle ??
      Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle ??
      DefaultTextStyle.of(context).style.apply(
            color: Theme.of(context).primaryColor,
          );

  TextStyle get _unselectedStyle =>
      widget.unselectedTextStyle ??
      Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle ??
      DefaultTextStyle.of(context).style.apply(
            color: Theme.of(context).unselectedWidgetColor,
          );
  List<AnimatedWidgetBuilder> get _items {
    if (widget.items != null) return widget.items!;

    return widget._buldkItems!
        .asMap()
        .entries
        .map(
          (e) => (BuildContext context, Animation<double> animation) =>
              IconTheme.merge(
                data: IconThemeData.lerp(
                  _unselectedIcon,
                  _getSelected<IconThemeData>(
                    _selectedIcon,
                    _unselectedIcon,
                    e.key,
                  ),
                  animation.value,
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle.lerp(
                    _unselectedStyle,
                    _getSelected<TextStyle>(
                      _selectedStyle,
                      _unselectedStyle,
                      e.key,
                    ),
                    animation.value,
                  ),
                  child: e.value,
                ),
              ),
        )
        .toList();
  }

  T _getSelected<T>(T selected, T unselected, int index) =>
      index == _index || index == _lastIndex ? selected : unselected;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: widget.selectionDuration,
    );
    _animationForward = CurvedAnimation(
        parent: _animationController, curve: widget.selectionCurve);
    _animationReverse = ReverseAnimation(_animationForward);
    _index = widget.controller?.intialIndex ?? 0;
    _lastIndex = _index;
    widget.controller?._init(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AbstractSliverBottomBar(
      mainBody: (context, animation) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (var index = 0; index < _items.length; index++)
            InkResponse(
              onTap: () {
                int? newIndex = widget.onSelected(index);
                _animateToIndex(newIndex);
              },
              child: AnimatedBuilder(
                  animation: _getAnimationFor(index),
                  builder: (context, _) {
                    return _items[index].call(context, _getAnimationFor(index));
                  }),
            ),
        ],
      ),
      beforeBody: widget.beforeBody,
      afterBody: widget.afterBody,
      duration: widget.expansionDuration,
      curve: widget.curve,
      snapAfter: widget.snapAfter,
      snap: widget.snap,
      deltaDivisionFactor: widget.deltaDivisionFactor,
      reverseExpansion: widget.reverseExpansion,
      startsExpanded: widget.startsExpanded,
      controller: _ASBController,
      expandOnOverScroll: widget.expandOnOverScroll,
    );
  }

  Animation<double> _getAnimationFor(int index) {
    if (index == _index) {
      return _animationForward;
    }
    if (index == _lastIndex) return _animationReverse;
    return const AlwaysStoppedAnimation(0.0);
  }

  void _animateToIndex(int? newIndex) {
    if (newIndex != null && newIndex != _index) {
      _lastIndex = _index;
      _index = newIndex;
      _animationController.value = 0.0;
      setState(() {});
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _animationController.forward();
      });
    }
  }
}
