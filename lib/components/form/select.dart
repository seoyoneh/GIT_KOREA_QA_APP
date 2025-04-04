import 'package:flutter/cupertino.dart';
import 'package:product_manager/components/image/svg_image.dart';
import 'package:product_manager/constants/assets.dart';
import 'package:product_manager/constants/colors.dart';
import 'package:product_manager/constants/font_style.dart';
import 'package:product_manager/models/form/select_type.dart';

class RollUpSelect extends StatefulWidget {
  const RollUpSelect({
    super.key,
    required this.title,
    required this.items,
    required this.controller,
  });

  final String title;
  final List<SelectType> items;
  final RollUpSelectController controller;

  @override
  State<RollUpSelect> createState() => _RollUpSelectState();
}

class _RollUpSelectState extends State<RollUpSelect>
  with TickerProviderStateMixin {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  OverlayEntry? _overlayEntry;

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final AnimationController _rollUpController;
  late final Animation<Offset> _rollUpAnimation;
  late final ScrollController _scrollController;
  //-------------------------------------
  // OVERRIDE
  //-------------------------------------
  @override
  void initState() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 250),
      reverseDuration: Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _rollUpController = AnimationController(
      duration: Duration(milliseconds: 250),
      reverseDuration: Duration(milliseconds: 200),
      vsync: this,
    );

    _rollUpAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero
    ).animate(
      CurvedAnimation(
        parent: _rollUpController,
        curve: Curves.easeInOut
      )
    );

    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _rollUpController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SelectType? item = _findSelectedItem();

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: QisColors.gray400.color
            )
          )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              null != item ? item.label : "",
              style: PretendardStyle.semibold.copyWith(
                fontSize: 18,
                color: QisColors.black.color
              )
            ),
            SizedBox(
              width: 24,
              height: 12,
              child: SvgImage.asset(SvgImageAsset.icoSelectArrow)
            )
          ],
        )
      )
    );
  }

  //-------------------------------------
  // PRIVATE METHOD
  //-------------------------------------
  SelectType? _findSelectedItem() {
    if(widget.items.isEmpty) {
      return null;
    }

    return widget.items.firstWhere((element) => element.isSelected);
  }

  void _showSelectList() {
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        double height = MediaQuery.of(context).size.height * 0.43;
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Stack(
            children: [
              GestureDetector(
                onTap: _hideSelectList,
                child: Container(
                  color: QisColors.barrier.color
                )
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _rollUpAnimation,
                  child: Container(
                    height: height,
                    padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                    decoration: BoxDecoration(
                      color: QisColors.white.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12)
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Text(
                            widget.title,
                            style: PretendardStyle.semibold.copyWith(
                              fontSize: 16,
                              color: QisColors.black.color
                            )
                          ),
                        ),
                        const SizedBox(height: 6),
                        Flexible(
                          flex: 1,
                          child: CupertinoScrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                SliverList.builder(
                                  itemCount: widget.items.length,
                                  itemBuilder: _selectItemBuilder
                                )
                              ]
                            )
                          )
                        ),
                        const SizedBox(height: 20),
                      ]
                    ),
                  ),
                )
              )
            ]
          )
        );
      }
    );

    Overlay.of(context).insert(_overlayEntry!);
    _fadeController.forward();
    _rollUpController.forward();
  }

  void _hideSelectList() async {
    if(null != _overlayEntry) {
      await _rollUpController.reverse();
      await _fadeController.reverse();

      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  Widget _selectItemBuilder(BuildContext context, int index) {
    SelectType item = widget.items[index];

    return GestureDetector(
      onTap: () => _onSelectItemTap(item),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
        color: CupertinoColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  style: PretendardStyle.medium.copyWith(
                    fontSize: 16,
                    color: QisColors.black.color
                  )
                ),
                item.isSelected
                ? SvgImage.asset(SvgImageAsset.icoRadioOn)
                : SvgImage.asset(SvgImageAsset.icoRadioOff),
              ],
            ),
            widget.items.length - 1 > index
            ? SizedBox(height: 7)
            : Container()
          ]
        )
      )
    );
  }
  //-------------------------------------
  // EVENT HANDLERS
  //-------------------------------------
  void _onTap() {
    _showSelectList();
  }

  void _onSelectItemTap(SelectType item) {
    widget.controller.select(item);
    _hideSelectList();
  }
}

class RollUpSelectController extends ChangeNotifier {
  //-------------------------------------
  // VARIABLE
  //-------------------------------------
  SelectType? _selectedItem;

  //-------------------------------------
  // GETTER
  //-------------------------------------
  SelectType? get selectedItem => _selectedItem;

  //-------------------------------------
  // PUBLIC METHOD
  //-------------------------------------
  void select(SelectType item) {
    _selectedItem = item;
    notifyListeners();
  }
}