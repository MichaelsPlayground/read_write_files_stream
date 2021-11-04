import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

const SPLIT_SENTINEL = const [42];

class Splitter extends Converter<List<int>, List<List<int>>> {

  Splitter(this._splitOnByte);

  final int _splitOnByte;

  SplitterSink startChunkedConversion(ChunkedConversionSink sink) {
    return new SplitterSink(sink, _splitOnByte);
  }

  List<List<int>> convert(input) {
    var out = new ListSink();
    var sink = new SplitterSink(out, _splitOnByte);
    sink.add(input);
    sink.close();
    return out.list;
  }
}


class SplitterSink extends ByteConversionSinkBase {

  SplitterSink(this._sink, this._splitOnByte);

  final int _splitOnByte;
  final ChunkedConversionSink<List<int>> _sink;

  void add(List<int> chunk) {
    assert(chunk is Uint8List);
    int a = 0;
    while (a < chunk.length) {
      int b = chunk.indexOf(_splitOnByte, a);
      if (b < 0) {
        _sink.add(new Uint8List.view(chunk.buffer, a));
        return;
      } else if (b == 0) {
        _sink.add(SPLIT_SENTINEL);
      } else {
        _sink.add(new Uint8List.view(chunk.buffer, a, b - a));
        _sink.add(SPLIT_SENTINEL);
      }
      a = b + 1;
    }
  }

  void close() {
    _sink.close();
  }
}

class ListSink extends ChunkedConversionSink<List<int>> {
  final List<List<int>> list = new List<List<int>>();
  add(List<int> chunk) => list.add(chunk);
  close() {}
}

main() {
  var path = '/home/greg/Desktop/big-buck-bunny_trailer.webm';

  new File(path)
      .openRead()
      .transform(new Splitter(143)) // Just chose a random byte.
      .listen((List<int> chunk) {
    if (chunk == SPLIT_SENTINEL)
      print('Split');
    else
      print('Chunk: ${chunk.length}');
  });
}