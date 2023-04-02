List<String> _parseNameList(String string) =>
    string.split(':').map((e) => e.trim()).toList();

List<String> _emptyStrings = const ['', '-', '?'];
String? _nullIfEmpty(String string) =>
    _emptyStrings.contains(string) ? null : string;

/// Parse a PGN date.
///
/// Allowed formats:
/// - "1992.08.31" -> parsed
/// - "1993.??.??" -> `null` is returned
DateTime? _parseDate(String dateString) {
  if (dateString.contains('?')) return null;
  final dateRegExp = RegExp(r'^(\d{4})\.(\d{2})\.(\d{2})$');
  final match = dateRegExp.firstMatch(dateString);
  return DateTime(int.parse(match!.group(1)!), int.parse(match.group(2)!),
      int.parse(match.group(3)!));
}

class ChessGameTags {
  final Map<String, String> rawTags;

  final String? event;
  final String? site;
  final DateTime? date;
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

  factory ChessGameTags.fromRawTags(Map<String, String> rawTags) =>
      ChessGameTags._(
        rawTags: rawTags,
        event: _parseTag(rawTags, 'Event', (values) => _nullIfEmpty(values!)),
        site: _parseTag(rawTags, 'Site', (values) => _nullIfEmpty(values!)),
        date: _parseTag(rawTags, 'Date', (values) => _parseDate(values!)),
        round: _parseTag(rawTags, 'Round', (values) => _nullIfEmpty(values!)),
        white: _parseTag(rawTags, 'White', (values) => _parseNameList(values!)),
        black: _parseTag(rawTags, 'Black', (values) => _parseNameList(values!)),
        result: _parseTag(rawTags, 'Result', (values) => values!),
      );

  static _parseTag<T>(
      Map<String, String> rawTags, String tagName, T Function(String?) parse) {
    final tagValue = rawTags[tagName];
    try {
      return parse(tagValue);
    } catch (error) {
      throw ChessGameTagsParsingException(
          tagName: tagName, tagValue: tagValue, error: error);
    }
  }
}

class ChessGameTagsParsingException implements Exception {
  final String tagName;
  final String? tagValue;
  final dynamic error;

  ChessGameTagsParsingException({
    required this.tagName,
    required this.tagValue,
    required this.error,
  });

  @override
  String toString() =>
      'Cannot parse tag \'$tagName\', invalid value: \'$tagValue\'';
}
