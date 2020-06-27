import 'package:fhentai/apis/gallery.dart';
import 'package:fhentai/generated/i18n.dart';
import 'package:fhentai/model/gallery_model.dart';
import 'package:fhentai/widget/index.dart';
import 'package:flutter/material.dart';

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
  ScrollController _scrollController = ScrollController();
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
    var res = await galleryList(page: 0);
    setState(() {
      _dataSource = res.list;
      _total = res.total;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).Front_Page),
      ),
      body: Container(
        child: _dataSource == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _dataSource.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _dataSource.length) {
                        return _buildProgressIndicator();
                      }
                      return GalleryCard(_dataSource[index]);
                    }),
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
