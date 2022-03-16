part of sliver_bottom_bar;

class GroupsBottomNavigationBar extends StatefulWidget {
  final ItemsSelector itemsBeneath;
  final double blurSigmaX;
  final double blurSigmaY;
  final List<GroupItem> items;
  final Color backgroundColor;
  final Color cardShrinkedColor;
  final Color cardExpandedColor;
  final ShapeBorder cardShape;
  final EdgeInsets selectedCardInnerPadding;
  final EdgeInsets selectedCardMargin;
  final TextStyle selectedShrinkedStyle;
  final TextStyle selectedExpandedStyle;
  final double? cardWidth;
  final double cardElevation;
  final Widget Function(BuildContext context, int index) pageBuilder;
  final EdgeInsets itemsB;

  const GroupsBottomNavigationBar({
    Key? key,
    required this.items,
    required this.pageBuilder,
    this.blurSigmaX = 4.0,
    this.blurSigmaY = 4.0,
    this.cardElevation = 10.0,
    required this.itemsBeneath,
    this.backgroundColor = const Color.fromARGB(180, 0, 0, 0),
    this.cardShrinkedColor = Colors.white,
    this.cardExpandedColor = Colors.white54,
    this.cardShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    ),
    this.selectedCardInnerPadding = const EdgeInsets.symmetric(vertical: 8.0),
    this.selectedCardMargin =
        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    this.selectedShrinkedStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
    ),
    this.selectedExpandedStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    this.cardWidth,
    this.itemsB = const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 12.0,
    ),
  }) : super(key: key);

  @override
  State<GroupsBottomNavigationBar> createState() =>
      _GroupsBottomNavigationBarState();

  static ItemsSelector generateDefaultItemsBeneath({
    required int itemsLength,
    required int returnLength,
  }) {
    assert(
      itemsLength > 1,
      'The itemsLength must be greater than 1, currently = $itemsLength',
    );
    assert(
      returnLength > 1,
      'The returnLength must be greater than 1, currently = $returnLength',
    );
    assert(
      itemsLength >= returnLength,
      'The return length must be less than or equal the total item length, currently $itemsLength >= $returnLength is false',
    );
    int delimiter = returnLength ~/ 2 + (returnLength.isEven ? 0 : 1);
    return (int index) {
      if (index - delimiter < 0) {
        List<int> results = List<int>.generate(returnLength, (index) => index);
        results.remove(index);
        int newMember = results.isEmpty ? 0 : results.last;
        results += [newMember + 1];
        return results;
      }
      if (delimiter + index >= itemsLength) {
        List<int> results = List<int>.generate(
            returnLength, (index) => itemsLength - (returnLength - index));
        results.remove(index);
        int newMember = results.isEmpty ? 0 : results.first;
        results = [newMember - 1] + results;
        return results;
      }
      return [
        for (var i = delimiter; i != 0; i--) index - i,
        for (var i = 1; i <= delimiter - (returnLength.isOdd ? 1 : 0); i++)
          index + i
      ];
    };
  }
}

class _GroupsBottomNavigationBarState extends State<GroupsBottomNavigationBar>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final AbstractSliverBottomBarController _controller =
      AbstractSliverBottomBarController();
  int get _index => _tabController.index;
  int get _lastIndex => _tabController.previousIndex;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.items.length, vsync: this);
  }

  ItemsSelector get _itemsBeneath => widget.itemsBeneath;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        print(notification);
        bool retValue = false;
        if (notification.metrics.axis == Axis.vertical ||
            notification is! ScrollUpdateNotification) return retValue;
        notification = notification as ScrollUpdateNotification;
        // final List<ScrollPosition> candidates = <ScrollPosition>[];

        // final List<ScrollPosition> positions =
        //     pageController.positions.toList();
        // for (var position in positions) {
        //   if (position.activity is! IdleScrollActivity) {
        //     candidates.add(position);
        //   }
        // }
        // ScrollPosition? mostAdvance;
        // for (var candidate in candidates) {
        //   mostAdvance = (mostAdvance?.pixels ?? 0.0) > candidate.pixels
        //       ? mostAdvance
        //       : candidate;
        // }
        // for (var position in positions) {
        //   if (position != mostAdvance) {
        //     position.jumpTo(mostAdvance!.pixels);
        //   }
        // }
        // print('setting to ${mostAdvance?.pixels}');
        // return retValue;
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                for (var index = 0; index < widget.items.length; index++)
                  widget.pageBuilder.call(context, index),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
              ),
              clipBehavior: Clip.antiAlias,
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: widget.blurSigmaX,
                  sigmaY: widget.blurSigmaY,
                ),
                child: AbstractSliverBottomBar(
                  expandOnOverScroll: true,
                  startsExpanded: true,
                  mainBody: (context, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (_, __) {
                        return TabBar(
                          isScrollable: true,
                          indicatorWeight: 0.0,
                          controller: _tabController,
                          padding: EdgeInsets.zero,
                          indicator: const BoxDecoration(),
                          indicatorPadding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.zero,
                          tabs: [
                            for (var i = 0; i < widget.items.length; i++)
                              SizedBox(
                                width: lerpDouble(
                                  MediaQuery.of(context).size.width,
                                  widget.cardWidth ??
                                      MediaQuery.of(context).size.width * .8,
                                  animation.value,
                                ),
                                child: _PreviewCard(
                                  cardElevation: widget.cardElevation,
                                  blurSigmaX: widget.blurSigmaX,
                                  selected: _index == i,
                                  blurSigmaY: widget.blurSigmaY,
                                  cardShrinkedColor: widget.cardShrinkedColor,
                                  cardExpandedColor: widget.cardExpandedColor,
                                  cardShape: widget.cardShape,
                                  selectedCardInnerPadding:
                                      widget.selectedCardInnerPadding,
                                  selectedCardMargin: widget.selectedCardMargin,
                                  selectedShrinkedStyle:
                                      widget.selectedShrinkedStyle,
                                  selectedExpandedStyle:
                                      widget.selectedExpandedStyle,
                                  animation: animation,
                                  item: widget.items[i],
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                  afterBody: (context, animation) {
                    return Transform.scale(
                      scale: animation.value,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: _itemsBeneath(_index)
                            .map(
                              (e) => Padding(
                                padding: widget.itemsB,
                                child: widget.items[e].shrinkedIcon,
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GroupItem {
  final Widget shrinkedIcon;
  final Widget? expandedIcon;
  final String shrinkedLabel;
  final String? expandedLabel;
  final List<Widget>? actions;
  const GroupItem({
    required this.shrinkedIcon,
    required this.shrinkedLabel,
    this.actions,
    this.expandedLabel,
    this.expandedIcon,
  });

  String getExpandedLabel() => expandedLabel ?? shrinkedLabel;
  Widget getExpandedIcon() =>
      expandedIcon ??
      Transform.scale(
        scale: 3.0,
        child: shrinkedIcon,
      );
}

class _PreviewCard extends StatelessWidget {
  final double blurSigmaX;
  final double blurSigmaY;
  final Color cardShrinkedColor;
  final Color cardExpandedColor;
  final ShapeBorder cardShape;
  final EdgeInsets selectedCardInnerPadding;
  final EdgeInsets selectedCardMargin;
  final TextStyle selectedShrinkedStyle;
  final TextStyle selectedExpandedStyle;
  final GroupItem item;
  final bool selected;
  final double cardElevation;
  final Animation<double> animation;
  const _PreviewCard({
    Key? key,
    this.selected = false,
    required this.blurSigmaX,
    required this.blurSigmaY,
    required this.cardElevation,
    required this.cardShrinkedColor,
    required this.cardExpandedColor,
    required this.cardShape,
    required this.selectedCardInnerPadding,
    required this.selectedCardMargin,
    required this.selectedShrinkedStyle,
    required this.selectedExpandedStyle,
    required this.animation,
    required this.item,
  }) : super(key: key);

  // Animation<double> get animation => super.listenable as Animation<double>;
  @override
  Widget build(BuildContext context) {
    try {
      if (selected) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    } catch (e) {}
    return Card(
      elevation: lerpDouble(
        0,
        cardElevation,
        animation.value,
      ),
      margin: EdgeInsets.lerp(
        EdgeInsets.zero,
        selectedCardMargin,
        animation.value,
      ),
      color: Color.lerp(
        cardShrinkedColor,
        cardExpandedColor,
        animation.value,
      ),
      shape: ShapeBorder.lerp(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        cardShape,
        animation.value,
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigmaX,
          sigmaY: blurSigmaY,
        ),
        child: Padding(
          padding: selectedCardInnerPadding,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.shrinkedLabel,
                  style: TextStyle.lerp(
                    selectedShrinkedStyle,
                    selectedExpandedStyle,
                    animation.value,
                  ),
                ),
                ClipRect(
                  child: Align(
                    widthFactor: animation.value,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 8.0),
                        item.shrinkedIcon,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
