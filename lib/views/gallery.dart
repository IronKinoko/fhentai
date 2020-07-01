import 'package:fhentai/apis/gallery.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_model.dart';
// import 'package:fhentai/widget/floating_appbar.dart';
import 'package:fhentai/widget/index.dart';
import 'package:floating_search_bar/ui/sliver_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Gallery extends StatefulWidget {
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
  @override
  void initState() {
    super.initState();
    _loadPage(_page);
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

  Future<void> _loadPage(int page, {String fSearch = ''}) async {
    if (_isPerformingRequest || _isEnd) return;
    setState(() {
      _isPerformingRequest = true;
    });
    var res = await galleryList(page: page, fSearch: fSearch);
    if (res.list.isEmpty) {
      double edge = 50.0;
      double offsetFromBottom = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (offsetFromBottom < edge) {
        _scrollController.animateTo(
            _scrollController.offset - (edge - offsetFromBottom),
            duration: new Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
    }
    if (mounted)
      setState(() {
        if (_dataSource != null && ++_page * 25 >= res.total) _isEnd = true;
        _dataSource ??= [];
        _dataSource.addAll(res.list);
        _total = res.total;
        _isPerformingRequest = false;
      });
  }

  Future<void> _onRefresh() async {
    try {
      var res = await galleryList(page: 0);
      setState(() {
        _dataSource = res.list;
        _total = res.total;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
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
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintText: I18n.of(context).Front_Page)),
              floating: true,
              snap: true,
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 16),
            ),
            _dataSource == null
                ? _buildFirstLoading(context)
                : _error
                    ? _buildError(context)
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == _dataSource.length) {
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
        current: I18n.of(context).Front_Page,
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
