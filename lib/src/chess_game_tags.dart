T _onlyElement<T>(List<T> list) {
  assert(list.length == 1);
  return list.first;
}

List<String> _emptyStrings = const ['', '-', '?'];
String? _nullIfEmpty(String string) =>
    _emptyStrings.contains(string) ? null : string;

class ChessGameTags {
  final Map<String, List<String>> rawTags;

  final String? event;
  final String? site;
  final DateTime date;
  final String? round;
  final List<String> white;
  final List<String> black;
  final String result;

  const ChessGameTags._({
    required this.rawTags,
    required this.event,
    required this.site,
    required this.date,
    required this.round,
    required this.white,
    required this.black,
    required this.result,
  });

  factory ChessGameTags.fromRawTags(Map<String, List<String>> rawTags) =>
      ChessGameTags._(
        rawTags: rawTags,
        event: _parseTag(
            rawTags, 'Event', (values) => _nullIfEmpty(_onlyElement(values!))),
        site: _parseTag(
            rawTags, 'Site', (values) => _nullIfEmpty(_onlyElement(values!))),
        date: _parseTag(
            rawTags,
            'Date',
            (values) =>
                DateTime.parse(_onlyElement(values!).replaceAll('.', '-'))),
        round: _parseTag(
            rawTags, 'Round', (values) => _nullIfEmpty(_onlyElement(values!))),
        white: _parseTag(rawTags, 'White', (values) => values!),
        black: _parseTag(rawTags, 'Black', (values) => values!),
        result: _parseTag(rawTags, 'Result', (values) => _onlyElement(values!)),
      );

  static _parseTag<T>(Map<String, List<String>> rawTags, String tagName,
      T Function(List<String>?) parse) {
    final tagValues = rawTags[tagName];
    try {
      return parse(tagValues);
    } catch (error) {
      throw ChessGameTagsParsingException(
          tagName: tagName, tagValues: tagValues, error: error);
    }
  }
}

class ChessGameTagsParsingException implements Exception {
  final String tagName;
  final List<String>? tagValues;
  final dynamic error;

  ChessGameTagsParsingException({
    required this.tagName,
    required this.tagValues,
    required this.error,
  });

  @override
  String toString() =>
      'Cannot parse tag \'$tagName\', invalid value: \'${tagValues?.join(', ')}\'';
}
