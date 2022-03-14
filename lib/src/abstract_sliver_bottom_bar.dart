part of sliver_bottom_bar;

class AbstractSliverBottomBar extends StatefulWidget {
  final AnimatedWidgetBuilder? mainBody;
  final AnimatedWidgetBuilder? beforeBody;
  final AnimatedWidgetBuilder? afterBody;
  final Duration duration;
  final Curve curve;
  final double snapAfter;
  final bool snap;
  final Axis axis;
  final double deltaDivisionFactor;
  final bool reverseExpansion;
  final bool startsExpanded;
  final AbstractSliverBottomBarController? controller;
  final bool expandOnOverScroll;
  const AbstractSliverBottomBar({
    Key? key,
    this.controller,
    this.mainBody,
    this.beforeBody,
    this.afterBody,
    final Axis? axis,
    final Duration? duration,
    final Curve? curve,
    final double? snapAfter,
    final bool? snap,
    final double? deltaDivisionFactor,
    final bool? reverseExpansion,
    final bool? startsExpanded,
    final bool? expandOnOverScroll,
  })  : axis = axis ?? Axis.vertical,
        duration = duration ?? const Duration(milliseconds: 300),
        curve = curve ?? Curves.ease,
        snapAfter = snapAfter ?? 0.5,
        snap = snap ?? true,
        deltaDivisionFactor = deltaDivisionFactor ?? 100,
        reverseExpansion = reverseExpansion ?? false,
        startsExpanded = startsExpanded ?? true,
        expandOnOverScroll = expandOnOverScroll ?? true,
        super(key: key);

  @override
  State<AbstractSliverBottomBar> createState() =>
      _AbstractSliverBottomBarState();
}

class _AbstractSliverBottomBarState extends State<AbstractSliverBottomBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> animationView;
  ScrollNotification? _lastNotification;
  bool _isInitialized = false;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    animationView =
        CurvedAnimation(curve: widget.curve, parent: _animationController);
    _animationController.value += widget.startsExpanded ? 1 : 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.controller?._init(this);
    super.didChangeDependencies();
  }

  void lazyInit() {
    final ScrollNotificationObserverState? observer =
        ScrollNotificationObserver.of(context)!;

    assert(
        observer != null,
        'The widget tree above doesn\'t contain a [ScrollNotificationObserver].\n'
        'A quick solution is to wrap one of the ancestors with [ScrollNotificationObserver].\n'
        'If after wraping with [ScrollNotificationObserver] the widget didn\'t respond to scroll read open the link below to understand how to fix it');
    // TODO: add the readme link here
    if (!_isInitialized) observer!.addListener(_updateAnimation);
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    lazyInit();
    return Builder(
      builder: (context) {
        return _buildCollectionLayout(
          [
            if (widget.beforeBody != null) _builderWrapper(widget.beforeBody!),
            if (widget.mainBody != null) widget.mainBody!,
            if (widget.afterBody != null) _builderWrapper(widget.afterBody!),
          ]
              .map(
                (e) => e.call(
                  context,
                  animationView,
                ),
              )
              .toList(),
        );
      },
    );
  }

  /// where the magic 🪄 happens ! ✨✨
  void _updateAnimation(ScrollNotification notification) {
    if (Scrollable.of(notification.context!)!.widget.axis != widget.axis) {
      return;
    }
    double diff = notification.metrics.pixels -
        (_lastNotification?.metrics.pixels ?? 0.0).abs();

    _lastNotification = notification;

    if (notification is OverscrollNotification) {
      _snap();
      if (widget.expandOnOverScroll) _animationController.forward();
    }
    if ((notification is UserScrollNotification &&
            notification.direction == ScrollDirection.idle) ||
        notification is ScrollEndNotification) {
      _snap();
      return;
    }
    double delta = 0.0;
    if (notification is ScrollUpdateNotification) {
      delta = notification.dragDetails?.primaryDelta ?? delta;
    }

    // adapting to logic wise
    delta *= widget.reverseExpansion ? -1 : 1;
    // Start animating
    double newValue = _onBound(
        _animationController.value + (delta / widget.deltaDivisionFactor));
    // so that it won't trigger builds if it's not really need it
    if (newValue != _animationController.value) {
      _animationController.value = newValue;
    }
  }

  double _onBound(double value) {
    if (value == 0.0) return 0.0;
    if (value < 0.0) return 0.0;
    if (value > 1.0) return 1.0;
    return value;
  }

  /// Snaps the [_animationController] if [widget.snap]  is true. otherwise does nothing.
  void _snap() {
    if (!widget.snap) return;
    // It's already there!
    if (_animationController.value == 1.0 ||
        _animationController.value == 0.0) {
      return;
    }
    if (_reverse(_animationController.value < 0.5, widget.reverseExpansion)) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  /// Build the right flex for the [widget.axis]
  ///
  /// Uses [CrossAxisAlignment.stretch] to ensure the layout is modifiable for end users
  Flex _buildCollectionLayout(List<Widget> children) {
    return widget.axis == Axis.vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: children,
          );
  }

  /// Wraps [builder] with an [AnimatedBuilder] to shorten caller's code and adding the default sizing animation
  AnimatedWidgetBuilder _builderWrapper(AnimatedWidgetBuilder builder) =>
      (context, animation) => AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return ClipRRect(
              clipBehavior: Clip.hardEdge,
              child: Align(
                heightFactor:
                    widget.axis == Axis.vertical ? animation.value : 1.0,
                widthFactor:
                    widget.axis == Axis.horizontal ? animation.value : 1.0,
                child: builder.call(context, animation),
              ),
            );
          });
  bool _reverse(bool variable, bool reverse) => reverse ? !variable : variable;
}
