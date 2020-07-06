import 'package:fhentai/apis/gallery.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/views/search/search.dart';
import 'package:fhentai/views/settings/settings.dart';
import 'package:fhentai/widget/bottom_navigation.dart';
import 'package:fhentai/widget/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum GalleryMode { FrontPage, Watched, Popular, Favorites, Histories }

class GalleryList extends StatefulWidget {
  final String fSearch;
  final GalleryMode mode;
  final bool isSearch;
  GalleryList({
    this.fSearch = '',
    this.mode = GalleryMode.FrontPage,
    this.isSearch = false,
  });
  @override
  _GalleryListState createState() => _GalleryListState();
}

class _GalleryListState extends State<GalleryList> {
  List<GalleryInfo> _dataSource;
  int _total = 0;
  int _page = 0;
  bool _isEnd = false;
  bool _isPerformingRequest = false;
  bool _showFloating = false;
  bool _error = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textfieldcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.light));
    _loadPage(_page);
    _textfieldcontroller.value = TextEditingValue(text: widget.fSearch);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 600) {
        _loadPage(_page);
      }
      if (_scrollController.position.pixels > 1000) {
        setState(() {
          _showFloating = true;
        });
      } else {
        setState(() {
          _showFloating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadPage(int page) async {
    try {
      if (_isPerformingRequest || (_isEnd && page != 0)) return;
      setState(() {
        _isPerformingRequest = true;
      });
      ResponseGalerry res;

      /// 从缓存中直接拿去第一页数据
      if (widget.mode != GalleryMode.Histories &&
          page == 0 &&
          _dataSource == null &&
          !widget.isSearch) {
        res = context.read<GalleryModel>().getGalleryList(widget.mode);
        if (res != null && mounted) {
          setState(() {
            _dataSource = res.list;
            _isPerformingRequest = false;
          });
        }
      }
      switch (widget.mode) {
        case GalleryMode.FrontPage:
          res = await galleryList(page: page, fSearch: widget.fSearch);
          break;
        case GalleryMode.Watched:
          res = await watchedGalleryList(page: page, fSearch: widget.fSearch);
          break;
        case GalleryMode.Popular:
          res = await popularGalleryList(page: page, fSearch: widget.fSearch);
          break;
        case GalleryMode.Histories:
          res = ResponseGalerry.getFromHistories();
          break;
        default:
      }

      if (mounted) {
        setState(() {
          _page = page + 1;
          if (widget.mode == GalleryMode.Popular ||
              widget.mode == GalleryMode.Histories) {
            _isEnd = true;
          } else {
            if (_page * 25 >= res.total) _isEnd = true;
          }
          _dataSource ??= [];
          if (page == 0) {
            _dataSource = res.list;
            if (!widget.isSearch)
              context.read<GalleryModel>().setGalleryList(widget.mode, res);
          } else {
            _dataSource.addAll(res.list);
          }
          _total = res.total;
          _isPerformingRequest = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isPerformingRequest = false;

        _error = true;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadPage(0);
  }

  Widget _buildProgressIndicator() {
    return SizedBox(
      height: 80,
      child: Align(
        alignment: Alignment.topCenter,
        child: _isEnd
            ? Text(I18n.of(context).Reach_End)
            : Opacity(
                opacity: _isPerformingRequest ? 1.0 : 0.0,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget _buildFirstLoading(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 1,
      children: <Widget>[
        Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 1,
      children: <Widget>[
        Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
                SizedBox(height: 8),
                Text(
                  I18n.of(context).Error,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 8),
                FlatButton(
                    textColor: Theme.of(context).colorScheme.onPrimary,
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      setState(() {
                        _dataSource = null;
                        _total = 0;
                        _page = 0;
                        _isEnd = false;
                        _isPerformingRequest = false;
                        _showFloating = false;
                        _error = false;
                        _loadPage(_page);
                      });
                    },
                    child: Text(
                      MaterialLocalizations.of(context)
                          .refreshIndicatorSemanticLabel,
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(I18n.of(context).SearchNot_found)),
    );
  }

  String _buildHintText(BuildContext context) {
    switch (widget.mode) {
      case GalleryMode.FrontPage:
        return I18n.of(context).Front_Page;
        break;
      case GalleryMode.Watched:
        return I18n.of(context).Watched;
        break;
      case GalleryMode.Popular:
        return I18n.of(context).Popular;
        break;
      case GalleryMode.Histories:
        return I18n.of(context).Histories;
        break;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              title: Text(widget.fSearch != ''
                  ? widget.fSearch
                  : _buildHintText(context)),
              floating: true,
              snap: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(widget.isSearch ? Icons.close : Icons.search),
                  tooltip: MaterialLocalizations.of(context).searchFieldLabel,
                  onPressed: () {
                    showSearch(context: context, delegate: SearchPage());
                  },
                ),
                widget.isSearch
                    ? IconButton(
                        icon: Icon(Icons.tune),
                        onPressed: () {},
                      )
                    : IconButton(
                        icon: Global.isSignin
                            ? ClipOval(child: Image.asset('images/panda.png'))
                            : Icon(Icons.account_circle),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Settings(),
                              ));
                        },
                      )
              ],
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 4,
              ),
            ),
            _error
                ? _buildError(context)
                : _dataSource == null
                    ? _buildFirstLoading(context)
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == _dataSource.length) {
                            if (index == 0) {
                              return _buildEmpty();
                            }
                            return _buildProgressIndicator();
                          }
                          return GalleryCard(_dataSource[index]);
                        },
                        childCount: _dataSource.length + 1,
                      ))
          ],
        ),
      ),
      floatingActionButton: _showFloating
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              },
              child: Icon(Icons.vertical_align_top),
            )
          : null,
    );
  }
}

class ZeroSizeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        child: null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}

class Gallery extends StatefulWidget {
  final String fSearch;
  final GalleryMode mode;
  Gallery({this.fSearch = '', this.mode = GalleryMode.FrontPage});
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  GalleryMode _mode;
  PageController _pageController;

  List<Widget> widgetList = [];
  @override
  void initState() {
    super.initState();
    widgetList.addAll([
      GalleryList(),
      GalleryList(mode: GalleryMode.Watched),
      GalleryList(mode: GalleryMode.Popular),
      GalleryList(),
      GalleryList(mode: GalleryMode.Histories)
    ]);
    _pageController =
        PageController(initialPage: widget.mode.index, keepPage: true);
    setState(() {
      _mode = widget.mode;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ZeroSizeAppBar(),
      body: Container(
        child: PageView.builder(
          controller: _pageController,
          itemCount: 5,
          itemBuilder: (context, index) {
            return widgetList[index];
          },
          onPageChanged: (index) {
            setState(() {
              _mode = GalleryMode.values[index];
            });
          },
        ),
      ),
      bottomNavigationBar: BNavigation(
        _mode,
        onChange: (index, mode) {
          setState(() {
            _mode = mode;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}
