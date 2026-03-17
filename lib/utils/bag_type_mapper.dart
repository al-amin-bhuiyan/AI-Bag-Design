/// BagTypeMapper - Maps UI selection (bag type + product row) to API bag_type string
/// Follows OOP: single responsibility, encapsulation, no instantiation needed
///
/// API bag_type values:
///   gusset_fullwrap  → Gusset Bag     + Full Graphic
///   gusset_label     → Gusset Bag     + Label
///   foil_fullwrap    → Stand Up Pouch + Full Graphic
///   foil_label       → Stand Up Pouch + Label
///   quad_fullwrap    → Quad Seal Bag  + Full Graphic
///   quad_label       → Quad Seal Bag  + Label
class BagTypeMapper {
  // Private constructor — utility class, no instantiation
  BagTypeMapper._();

  // ─── Row index constants (matches ProductSelectionDialog rows) ────────────
  static const int rowQuadSeal = 0;
  static const int rowGusset = 1;
  static const int rowStandUpPouch = 2;

  // ─── API bag_type constants ───────────────────────────────────────────────
  static const String gussetFullwrap = 'gusset_fullwrap';
  static const String gussetLabel    = 'gusset_label';
  static const String foilFullwrap   = 'foil_fullwrap';
  static const String foilLabel      = 'foil_label';
  static const String quadFullwrap   = 'quad_fullwrap';
  static const String quadLabel      = 'quad_label';

  // ─── Default fallback ─────────────────────────────────────────────────────
  static const String defaultBagType = gussetFullwrap;

  /// Resolves the API `bag_type` string from UI selections.
  ///
  /// [isFullGraphic] — true if "Create Full Graphics Bag" was selected,
  ///                   false if "Create Label Bag" was selected.
  /// [productRow]    — 0 = Quad Seal Bag, 1 = Gusset Bag, 2 = Stand Up Pouch
  ///
  /// Returns the matching API bag_type string, or [defaultBagType] as fallback.
  static String resolve({
    required bool isFullGraphic,
    required int productRow,
  }) {
    if (isFullGraphic) {
      switch (productRow) {
        case rowQuadSeal:
          return quadFullwrap;   // Quad Seal Bag   + Full Graphic
        case rowGusset:
          return gussetFullwrap; // Gusset Bag       + Full Graphic
        case rowStandUpPouch:
          return foilFullwrap;   // Stand Up Pouch   + Full Graphic
        default:
          return defaultBagType;
      }
    } else {
      // Label bag
      switch (productRow) {
        case rowQuadSeal:
          return quadLabel;      // Quad Seal Bag   + Label
        case rowGusset:
          return gussetLabel;    // Gusset Bag       + Label
        case rowStandUpPouch:
          return foilLabel;      // Stand Up Pouch   + Label
        default:
          return defaultBagType;
      }
    }
  }

  /// Human-readable description of a bag_type (for debugging / logging)
  static String describe(String bagType) {
    switch (bagType) {
      case gussetFullwrap: return 'Gusset Bag – Full Body Design';
      case gussetLabel:    return 'Gusset Bag – Label Design';
      case foilFullwrap:   return 'Stand Up Pouch – Full Body Design';
      case foilLabel:      return 'Stand Up Pouch – Label Design';
      case quadFullwrap:   return 'Quad Seal Bag – Full Body Design';
      case quadLabel:      return 'Quad Seal Bag – Label Design';
      default:             return 'Unknown bag type: $bagType';
    }
  }
}
