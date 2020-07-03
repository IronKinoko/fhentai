import 'package:fhentai/apis/gallery.dart';
import 'package:fhentai/common/global.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_model.dart';
// import 'package:fhentai/widget/floating_appbar.dart';
import 'package:fhentai/widget/index.dart';
import 'package:floating_search_bar/ui/sliver_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum GalleryMode { FrontPage, Watched, Popular, Histories }

class Gallery extends StatefulWidget {
  final String fSearch;
  final GalleryMode mode;
  Gallery({this.fSearch = '', this.mode = GalleryMode.FrontPage});
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
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

      if (mounted)
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
          } else {
            _dataSource.addAll(res.list);
          }
          _total = res.total;
          _isPerformingRequest = false;
        });
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverFloatingBar(
              elevation: 16,
              title: TextField(
                  onSubmitted: (value) => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Gallery(fSearch: value)))
                      },
                  controller: _textfieldcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: _buildHintText(context))),
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 16),
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
      drawer: MenuDraw(
        current: _buildHintText(context),
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
