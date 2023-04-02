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

  // PGN standard 8.1.1: Seven Tag Roster
  // For these tags there are certain validations happening when the object is
  // constructed
  final String? event;
  final String? site;
  final DateTime? date;
  final String? round;
  final List<String> white;
  final List<String> black;
  final String result;

  // PGN standard 9: Supplemental tag names
  // For the remaining tags there is no validation
  // PGN standard 9.1: Player related information
  String? get whiteElo => rawTags['WhiteElo'];
  String? get blackElo => rawTags['BlackElo'];
  String? get whiteUSCF => rawTags['WhiteUSCF'];
  String? get blackUSCF => rawTags['BlackUSCF'];
  String? get whiteNA => rawTags['WhiteNA'];
  String? get blackNA => rawTags['BlackNA'];
  String? get whiteType => rawTags['WhiteType'];
  String? get blackType => rawTags['BlackType'];

  // PGN standard 9.2: Event related information
  String? get eventDate => rawTags['EventDate'];
  String? get eventSponsor => rawTags['EventSponsor'];
  String? get section => rawTags['Section'];
  String? get stage => rawTags['Stage'];
  String? get board => rawTags['Board'];

  // PGN standard 9.3: Opening information (locale specific)
  String? get opening => rawTags['Opening'];
  String? get variation => rawTags['Variation'];
  String? get subVariation => rawTags['SubVariation'];

  // PGN standard 9.4: Opening information (third party vendors)
  String? get eco => rawTags['ECO'];
  String? get nic => rawTags['NIC'];

  // PGN standard 9.5: Time and date related information
  String? get time => rawTags['Time'];
  String? get utcTime => rawTags['UTCTime'];
  String? get utcDate => rawTags['UTCDate'];

  // PGN standard 9.6: Time control
  String? get timeControl => rawTags['TimeControl'];

  // PGN standard 9.7: Alternative starting positions
  String? get setUp => rawTags['SetUp'];
  String? get fen => rawTags['FEN'];

  const ChessGameTags._({
    required this.rawTags,

    // PGN standard 8.1.1: Seven Tag Roster
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
