// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cards_database.dart';

// ignore_for_file: type=lint
class $CardsTable extends Cards with TableInfo<$CardsTable, CardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _scryfallIdMeta =
      const VerificationMeta('scryfallId');
  @override
  late final GeneratedColumn<String> scryfallId = GeneratedColumn<String>(
      'scryfall_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mtgjsonUuidMeta =
      const VerificationMeta('mtgjsonUuid');
  @override
  late final GeneratedColumn<String> mtgjsonUuid = GeneratedColumn<String>(
      'mtgjson_uuid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _oracleIdMeta =
      const VerificationMeta('oracleId');
  @override
  late final GeneratedColumn<String> oracleId = GeneratedColumn<String>(
      'oracle_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _flavorNameMeta =
      const VerificationMeta('flavorName');
  @override
  late final GeneratedColumn<String> flavorName = GeneratedColumn<String>(
      'flavor_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
      'lang', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _releasedAtMeta =
      const VerificationMeta('releasedAt');
  @override
  late final GeneratedColumn<String> releasedAt = GeneratedColumn<String>(
      'released_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
      'uri', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _scryfallUriMeta =
      const VerificationMeta('scryfallUri');
  @override
  late final GeneratedColumn<String> scryfallUri = GeneratedColumn<String>(
      'scryfall_uri', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _layoutMeta = const VerificationMeta('layout');
  @override
  late final GeneratedColumn<String> layout = GeneratedColumn<String>(
      'layout', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _manaCostMeta =
      const VerificationMeta('manaCost');
  @override
  late final GeneratedColumn<String> manaCost = GeneratedColumn<String>(
      'mana_cost', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cmcMeta = const VerificationMeta('cmc');
  @override
  late final GeneratedColumn<double> cmc = GeneratedColumn<double>(
      'cmc', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeLineMeta =
      const VerificationMeta('typeLine');
  @override
  late final GeneratedColumn<String> typeLine = GeneratedColumn<String>(
      'type_line', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _oracleTextMeta =
      const VerificationMeta('oracleText');
  @override
  late final GeneratedColumn<String> oracleText = GeneratedColumn<String>(
      'oracle_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _flavorTextMeta =
      const VerificationMeta('flavorText');
  @override
  late final GeneratedColumn<String> flavorText = GeneratedColumn<String>(
      'flavor_text', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _powerMeta = const VerificationMeta('power');
  @override
  late final GeneratedColumn<String> power = GeneratedColumn<String>(
      'power', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _toughnessMeta =
      const VerificationMeta('toughness');
  @override
  late final GeneratedColumn<String> toughness = GeneratedColumn<String>(
      'toughness', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorsJsonMeta =
      const VerificationMeta('colorsJson');
  @override
  late final GeneratedColumn<String> colorsJson = GeneratedColumn<String>(
      'colors_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _colorIdentityJsonMeta =
      const VerificationMeta('colorIdentityJson');
  @override
  late final GeneratedColumn<String> colorIdentityJson =
      GeneratedColumn<String>('color_identity_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _keywordsJsonMeta =
      const VerificationMeta('keywordsJson');
  @override
  late final GeneratedColumn<String> keywordsJson = GeneratedColumn<String>(
      'keywords_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorsStringMeta =
      const VerificationMeta('colorsString');
  @override
  late final GeneratedColumn<String> colorsString = GeneratedColumn<String>(
      'colors_string', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _colorIdentityStringMeta =
      const VerificationMeta('colorIdentityString');
  @override
  late final GeneratedColumn<String> colorIdentityString =
      GeneratedColumn<String>('color_identity_string', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  static const VerificationMeta _legalInAnyFormatMeta =
      const VerificationMeta('legalInAnyFormat');
  @override
  late final GeneratedColumn<bool> legalInAnyFormat = GeneratedColumn<bool>(
      'legal_in_any_format', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("legal_in_any_format" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCanonicalPrintingMeta =
      const VerificationMeta('isCanonicalPrinting');
  @override
  late final GeneratedColumn<bool> isCanonicalPrinting = GeneratedColumn<bool>(
      'is_canonical_printing', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_canonical_printing" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _setCodeMeta =
      const VerificationMeta('setCode');
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
      'set_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setNameMeta =
      const VerificationMeta('setName');
  @override
  late final GeneratedColumn<String> setName = GeneratedColumn<String>(
      'set_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setTypeMeta =
      const VerificationMeta('setType');
  @override
  late final GeneratedColumn<String> setType = GeneratedColumn<String>(
      'set_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _collectorNumberMeta =
      const VerificationMeta('collectorNumber');
  @override
  late final GeneratedColumn<String> collectorNumber = GeneratedColumn<String>(
      'collector_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _digitalMeta =
      const VerificationMeta('digital');
  @override
  late final GeneratedColumn<bool> digital = GeneratedColumn<bool>(
      'digital', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("digital" IN (0, 1))'));
  static const VerificationMeta _rarityMeta = const VerificationMeta('rarity');
  @override
  late final GeneratedColumn<String> rarity = GeneratedColumn<String>(
      'rarity', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _rarityOrderMeta =
      const VerificationMeta('rarityOrder');
  @override
  late final GeneratedColumn<int> rarityOrder = GeneratedColumn<int>(
      'rarity_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _powerNumericMeta =
      const VerificationMeta('powerNumeric');
  @override
  late final GeneratedColumn<double> powerNumeric = GeneratedColumn<double>(
      'power_numeric', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _toughnessNumericMeta =
      const VerificationMeta('toughnessNumeric');
  @override
  late final GeneratedColumn<double> toughnessNumeric = GeneratedColumn<double>(
      'toughness_numeric', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _borderColorMeta =
      const VerificationMeta('borderColor');
  @override
  late final GeneratedColumn<String> borderColor = GeneratedColumn<String>(
      'border_color', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _frameMeta = const VerificationMeta('frame');
  @override
  late final GeneratedColumn<String> frame = GeneratedColumn<String>(
      'frame', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullArtMeta =
      const VerificationMeta('fullArt');
  @override
  late final GeneratedColumn<bool> fullArt = GeneratedColumn<bool>(
      'full_art', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("full_art" IN (0, 1))'));
  static const VerificationMeta _textlessMeta =
      const VerificationMeta('textless');
  @override
  late final GeneratedColumn<bool> textless = GeneratedColumn<bool>(
      'textless', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("textless" IN (0, 1))'));
  static const VerificationMeta _boosterMeta =
      const VerificationMeta('booster');
  @override
  late final GeneratedColumn<bool> booster = GeneratedColumn<bool>(
      'booster', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("booster" IN (0, 1))'));
  static const VerificationMeta _storySpotlightMeta =
      const VerificationMeta('storySpotlight');
  @override
  late final GeneratedColumn<bool> storySpotlight = GeneratedColumn<bool>(
      'story_spotlight', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("story_spotlight" IN (0, 1))'));
  static const VerificationMeta _imageStatusMeta =
      const VerificationMeta('imageStatus');
  @override
  late final GeneratedColumn<String> imageStatus = GeneratedColumn<String>(
      'image_status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageSmallMeta =
      const VerificationMeta('imageSmall');
  @override
  late final GeneratedColumn<String> imageSmall = GeneratedColumn<String>(
      'image_small', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageNormalMeta =
      const VerificationMeta('imageNormal');
  @override
  late final GeneratedColumn<String> imageNormal = GeneratedColumn<String>(
      'image_normal', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageLargeMeta =
      const VerificationMeta('imageLarge');
  @override
  late final GeneratedColumn<String> imageLarge = GeneratedColumn<String>(
      'image_large', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagePngMeta =
      const VerificationMeta('imagePng');
  @override
  late final GeneratedColumn<String> imagePng = GeneratedColumn<String>(
      'image_png', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageArtCropMeta =
      const VerificationMeta('imageArtCrop');
  @override
  late final GeneratedColumn<String> imageArtCrop = GeneratedColumn<String>(
      'image_art_crop', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imageBorderCropMeta =
      const VerificationMeta('imageBorderCrop');
  @override
  late final GeneratedColumn<String> imageBorderCrop = GeneratedColumn<String>(
      'image_border_crop', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _legalStandardMeta =
      const VerificationMeta('legalStandard');
  @override
  late final GeneratedColumn<String> legalStandard = GeneratedColumn<String>(
      'legal_standard', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalFutureMeta =
      const VerificationMeta('legalFuture');
  @override
  late final GeneratedColumn<String> legalFuture = GeneratedColumn<String>(
      'legal_future', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalHistoricMeta =
      const VerificationMeta('legalHistoric');
  @override
  late final GeneratedColumn<String> legalHistoric = GeneratedColumn<String>(
      'legal_historic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalGladiatorMeta =
      const VerificationMeta('legalGladiator');
  @override
  late final GeneratedColumn<String> legalGladiator = GeneratedColumn<String>(
      'legal_gladiator', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalPioneerMeta =
      const VerificationMeta('legalPioneer');
  @override
  late final GeneratedColumn<String> legalPioneer = GeneratedColumn<String>(
      'legal_pioneer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalExplorerMeta =
      const VerificationMeta('legalExplorer');
  @override
  late final GeneratedColumn<String> legalExplorer = GeneratedColumn<String>(
      'legal_explorer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _legalModernMeta =
      const VerificationMeta('legalModern');
  @override
  late final GeneratedColumn<String> legalModern = GeneratedColumn<String>(
      'legal_modern', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalLegacyMeta =
      const VerificationMeta('legalLegacy');
  @override
  late final GeneratedColumn<String> legalLegacy = GeneratedColumn<String>(
      'legal_legacy', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalPauperMeta =
      const VerificationMeta('legalPauper');
  @override
  late final GeneratedColumn<String> legalPauper = GeneratedColumn<String>(
      'legal_pauper', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalVintageMeta =
      const VerificationMeta('legalVintage');
  @override
  late final GeneratedColumn<String> legalVintage = GeneratedColumn<String>(
      'legal_vintage', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalPennyMeta =
      const VerificationMeta('legalPenny');
  @override
  late final GeneratedColumn<String> legalPenny = GeneratedColumn<String>(
      'legal_penny', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalCommanderMeta =
      const VerificationMeta('legalCommander');
  @override
  late final GeneratedColumn<String> legalCommander = GeneratedColumn<String>(
      'legal_commander', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalOathbreakerMeta =
      const VerificationMeta('legalOathbreaker');
  @override
  late final GeneratedColumn<String> legalOathbreaker = GeneratedColumn<String>(
      'legal_oathbreaker', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalBrawlMeta =
      const VerificationMeta('legalBrawl');
  @override
  late final GeneratedColumn<String> legalBrawl = GeneratedColumn<String>(
      'legal_brawl', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalHistoricbrawlMeta =
      const VerificationMeta('legalHistoricbrawl');
  @override
  late final GeneratedColumn<String> legalHistoricbrawl =
      GeneratedColumn<String>('legal_historicbrawl', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _legalAlchemyMeta =
      const VerificationMeta('legalAlchemy');
  @override
  late final GeneratedColumn<String> legalAlchemy = GeneratedColumn<String>(
      'legal_alchemy', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalPaupercommanderMeta =
      const VerificationMeta('legalPaupercommander');
  @override
  late final GeneratedColumn<String> legalPaupercommander =
      GeneratedColumn<String>('legal_paupercommander', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalDuelMeta =
      const VerificationMeta('legalDuel');
  @override
  late final GeneratedColumn<String> legalDuel = GeneratedColumn<String>(
      'legal_duel', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalOldschoolMeta =
      const VerificationMeta('legalOldschool');
  @override
  late final GeneratedColumn<String> legalOldschool = GeneratedColumn<String>(
      'legal_oldschool', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalPremodernMeta =
      const VerificationMeta('legalPremodern');
  @override
  late final GeneratedColumn<String> legalPremodern = GeneratedColumn<String>(
      'legal_premodern', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _legalPredhMeta =
      const VerificationMeta('legalPredh');
  @override
  late final GeneratedColumn<String> legalPredh = GeneratedColumn<String>(
      'legal_predh', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceUsdMeta =
      const VerificationMeta('priceUsd');
  @override
  late final GeneratedColumn<String> priceUsd = GeneratedColumn<String>(
      'price_usd', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceUsdFoilMeta =
      const VerificationMeta('priceUsdFoil');
  @override
  late final GeneratedColumn<String> priceUsdFoil = GeneratedColumn<String>(
      'price_usd_foil', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceUsdEtchedMeta =
      const VerificationMeta('priceUsdEtched');
  @override
  late final GeneratedColumn<String> priceUsdEtched = GeneratedColumn<String>(
      'price_usd_etched', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceEurMeta =
      const VerificationMeta('priceEur');
  @override
  late final GeneratedColumn<String> priceEur = GeneratedColumn<String>(
      'price_eur', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceEurFoilMeta =
      const VerificationMeta('priceEurFoil');
  @override
  late final GeneratedColumn<String> priceEurFoil = GeneratedColumn<String>(
      'price_eur_foil', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceTixMeta =
      const VerificationMeta('priceTix');
  @override
  late final GeneratedColumn<String> priceTix = GeneratedColumn<String>(
      'price_tix', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceNumericMeta =
      const VerificationMeta('priceNumeric');
  @override
  late final GeneratedColumn<double> priceNumeric = GeneratedColumn<double>(
      'price_numeric', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cardFacesJsonMeta =
      const VerificationMeta('cardFacesJson');
  @override
  late final GeneratedColumn<String> cardFacesJson = GeneratedColumn<String>(
      'card_faces_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _rulingsJsonMeta =
      const VerificationMeta('rulingsJson');
  @override
  late final GeneratedColumn<String> rulingsJson = GeneratedColumn<String>(
      'rulings_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _objectMeta = const VerificationMeta('object');
  @override
  late final GeneratedColumn<String> object = GeneratedColumn<String>(
      'object', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _oversizedMeta =
      const VerificationMeta('oversized');
  @override
  late final GeneratedColumn<bool> oversized = GeneratedColumn<bool>(
      'oversized', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("oversized" IN (0, 1))'));
  static const VerificationMeta _promoMeta = const VerificationMeta('promo');
  @override
  late final GeneratedColumn<bool> promo = GeneratedColumn<bool>(
      'promo', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("promo" IN (0, 1))'));
  static const VerificationMeta _reprintMeta =
      const VerificationMeta('reprint');
  @override
  late final GeneratedColumn<bool> reprint = GeneratedColumn<bool>(
      'reprint', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("reprint" IN (0, 1))'));
  static const VerificationMeta _variationMeta =
      const VerificationMeta('variation');
  @override
  late final GeneratedColumn<bool> variation = GeneratedColumn<bool>(
      'variation', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("variation" IN (0, 1))'));
  static const VerificationMeta _gamesJsonMeta =
      const VerificationMeta('gamesJson');
  @override
  late final GeneratedColumn<String> gamesJson = GeneratedColumn<String>(
      'games_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _reservedMeta =
      const VerificationMeta('reserved');
  @override
  late final GeneratedColumn<bool> reserved = GeneratedColumn<bool>(
      'reserved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("reserved" IN (0, 1))'));
  static const VerificationMeta _foilMeta = const VerificationMeta('foil');
  @override
  late final GeneratedColumn<bool> foil = GeneratedColumn<bool>(
      'foil', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("foil" IN (0, 1))'));
  static const VerificationMeta _nonfoilMeta =
      const VerificationMeta('nonfoil');
  @override
  late final GeneratedColumn<bool> nonfoil = GeneratedColumn<bool>(
      'nonfoil', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("nonfoil" IN (0, 1))'));
  static const VerificationMeta _finishesJsonMeta =
      const VerificationMeta('finishesJson');
  @override
  late final GeneratedColumn<String> finishesJson = GeneratedColumn<String>(
      'finishes_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _producedManaJsonMeta =
      const VerificationMeta('producedManaJson');
  @override
  late final GeneratedColumn<String> producedManaJson = GeneratedColumn<String>(
      'produced_mana_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _edhrecRankMeta =
      const VerificationMeta('edhrecRank');
  @override
  late final GeneratedColumn<int> edhrecRank = GeneratedColumn<int>(
      'edhrec_rank', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isGameChangerMeta =
      const VerificationMeta('isGameChanger');
  @override
  late final GeneratedColumn<bool> isGameChanger = GeneratedColumn<bool>(
      'is_game_changer', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_game_changer" IN (0, 1))'));
  static const VerificationMeta _relatedTokenIdsJsonMeta =
      const VerificationMeta('relatedTokenIdsJson');
  @override
  late final GeneratedColumn<String> relatedTokenIdsJson =
      GeneratedColumn<String>('related_token_ids_json', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _mtgoIdMeta = const VerificationMeta('mtgoId');
  @override
  late final GeneratedColumn<int> mtgoId = GeneratedColumn<int>(
      'mtgo_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _arenaIdMeta =
      const VerificationMeta('arenaId');
  @override
  late final GeneratedColumn<int> arenaId = GeneratedColumn<int>(
      'arena_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _tcgplayerIdMeta =
      const VerificationMeta('tcgplayerId');
  @override
  late final GeneratedColumn<int> tcgplayerId = GeneratedColumn<int>(
      'tcgplayer_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cardmarketIdMeta =
      const VerificationMeta('cardmarketId');
  @override
  late final GeneratedColumn<int> cardmarketId = GeneratedColumn<int>(
      'cardmarket_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        scryfallId,
        mtgjsonUuid,
        oracleId,
        name,
        flavorName,
        lang,
        releasedAt,
        uri,
        scryfallUri,
        layout,
        manaCost,
        cmc,
        typeLine,
        oracleText,
        flavorText,
        power,
        toughness,
        colorsJson,
        colorIdentityJson,
        keywordsJson,
        colorsString,
        colorIdentityString,
        legalInAnyFormat,
        isCanonicalPrinting,
        setCode,
        setName,
        setType,
        collectorNumber,
        digital,
        rarity,
        rarityOrder,
        powerNumeric,
        toughnessNumeric,
        artist,
        borderColor,
        frame,
        fullArt,
        textless,
        booster,
        storySpotlight,
        imageStatus,
        imageSmall,
        imageNormal,
        imageLarge,
        imagePng,
        imageArtCrop,
        imageBorderCrop,
        legalStandard,
        legalFuture,
        legalHistoric,
        legalGladiator,
        legalPioneer,
        legalExplorer,
        legalModern,
        legalLegacy,
        legalPauper,
        legalVintage,
        legalPenny,
        legalCommander,
        legalOathbreaker,
        legalBrawl,
        legalHistoricbrawl,
        legalAlchemy,
        legalPaupercommander,
        legalDuel,
        legalOldschool,
        legalPremodern,
        legalPredh,
        priceUsd,
        priceUsdFoil,
        priceUsdEtched,
        priceEur,
        priceEurFoil,
        priceTix,
        priceNumeric,
        cardFacesJson,
        rulingsJson,
        object,
        oversized,
        promo,
        reprint,
        variation,
        gamesJson,
        reserved,
        foil,
        nonfoil,
        finishesJson,
        producedManaJson,
        edhrecRank,
        isGameChanger,
        relatedTokenIdsJson,
        mtgoId,
        arenaId,
        tcgplayerId,
        cardmarketId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cards';
  @override
  VerificationContext validateIntegrity(Insertable<CardRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scryfall_id')) {
      context.handle(
          _scryfallIdMeta,
          scryfallId.isAcceptableOrUnknown(
              data['scryfall_id']!, _scryfallIdMeta));
    } else if (isInserting) {
      context.missing(_scryfallIdMeta);
    }
    if (data.containsKey('mtgjson_uuid')) {
      context.handle(
          _mtgjsonUuidMeta,
          mtgjsonUuid.isAcceptableOrUnknown(
              data['mtgjson_uuid']!, _mtgjsonUuidMeta));
    }
    if (data.containsKey('oracle_id')) {
      context.handle(_oracleIdMeta,
          oracleId.isAcceptableOrUnknown(data['oracle_id']!, _oracleIdMeta));
    } else if (isInserting) {
      context.missing(_oracleIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('flavor_name')) {
      context.handle(
          _flavorNameMeta,
          flavorName.isAcceptableOrUnknown(
              data['flavor_name']!, _flavorNameMeta));
    }
    if (data.containsKey('lang')) {
      context.handle(
          _langMeta, lang.isAcceptableOrUnknown(data['lang']!, _langMeta));
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('released_at')) {
      context.handle(
          _releasedAtMeta,
          releasedAt.isAcceptableOrUnknown(
              data['released_at']!, _releasedAtMeta));
    } else if (isInserting) {
      context.missing(_releasedAtMeta);
    }
    if (data.containsKey('uri')) {
      context.handle(
          _uriMeta, uri.isAcceptableOrUnknown(data['uri']!, _uriMeta));
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('scryfall_uri')) {
      context.handle(
          _scryfallUriMeta,
          scryfallUri.isAcceptableOrUnknown(
              data['scryfall_uri']!, _scryfallUriMeta));
    } else if (isInserting) {
      context.missing(_scryfallUriMeta);
    }
    if (data.containsKey('layout')) {
      context.handle(_layoutMeta,
          layout.isAcceptableOrUnknown(data['layout']!, _layoutMeta));
    } else if (isInserting) {
      context.missing(_layoutMeta);
    }
    if (data.containsKey('mana_cost')) {
      context.handle(_manaCostMeta,
          manaCost.isAcceptableOrUnknown(data['mana_cost']!, _manaCostMeta));
    }
    if (data.containsKey('cmc')) {
      context.handle(
          _cmcMeta, cmc.isAcceptableOrUnknown(data['cmc']!, _cmcMeta));
    } else if (isInserting) {
      context.missing(_cmcMeta);
    }
    if (data.containsKey('type_line')) {
      context.handle(_typeLineMeta,
          typeLine.isAcceptableOrUnknown(data['type_line']!, _typeLineMeta));
    } else if (isInserting) {
      context.missing(_typeLineMeta);
    }
    if (data.containsKey('oracle_text')) {
      context.handle(
          _oracleTextMeta,
          oracleText.isAcceptableOrUnknown(
              data['oracle_text']!, _oracleTextMeta));
    }
    if (data.containsKey('flavor_text')) {
      context.handle(
          _flavorTextMeta,
          flavorText.isAcceptableOrUnknown(
              data['flavor_text']!, _flavorTextMeta));
    }
    if (data.containsKey('power')) {
      context.handle(
          _powerMeta, power.isAcceptableOrUnknown(data['power']!, _powerMeta));
    }
    if (data.containsKey('toughness')) {
      context.handle(_toughnessMeta,
          toughness.isAcceptableOrUnknown(data['toughness']!, _toughnessMeta));
    }
    if (data.containsKey('colors_json')) {
      context.handle(
          _colorsJsonMeta,
          colorsJson.isAcceptableOrUnknown(
              data['colors_json']!, _colorsJsonMeta));
    }
    if (data.containsKey('color_identity_json')) {
      context.handle(
          _colorIdentityJsonMeta,
          colorIdentityJson.isAcceptableOrUnknown(
              data['color_identity_json']!, _colorIdentityJsonMeta));
    }
    if (data.containsKey('keywords_json')) {
      context.handle(
          _keywordsJsonMeta,
          keywordsJson.isAcceptableOrUnknown(
              data['keywords_json']!, _keywordsJsonMeta));
    }
    if (data.containsKey('colors_string')) {
      context.handle(
          _colorsStringMeta,
          colorsString.isAcceptableOrUnknown(
              data['colors_string']!, _colorsStringMeta));
    }
    if (data.containsKey('color_identity_string')) {
      context.handle(
          _colorIdentityStringMeta,
          colorIdentityString.isAcceptableOrUnknown(
              data['color_identity_string']!, _colorIdentityStringMeta));
    }
    if (data.containsKey('legal_in_any_format')) {
      context.handle(
          _legalInAnyFormatMeta,
          legalInAnyFormat.isAcceptableOrUnknown(
              data['legal_in_any_format']!, _legalInAnyFormatMeta));
    }
    if (data.containsKey('is_canonical_printing')) {
      context.handle(
          _isCanonicalPrintingMeta,
          isCanonicalPrinting.isAcceptableOrUnknown(
              data['is_canonical_printing']!, _isCanonicalPrintingMeta));
    }
    if (data.containsKey('set_code')) {
      context.handle(_setCodeMeta,
          setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta));
    } else if (isInserting) {
      context.missing(_setCodeMeta);
    }
    if (data.containsKey('set_name')) {
      context.handle(_setNameMeta,
          setName.isAcceptableOrUnknown(data['set_name']!, _setNameMeta));
    } else if (isInserting) {
      context.missing(_setNameMeta);
    }
    if (data.containsKey('set_type')) {
      context.handle(_setTypeMeta,
          setType.isAcceptableOrUnknown(data['set_type']!, _setTypeMeta));
    } else if (isInserting) {
      context.missing(_setTypeMeta);
    }
    if (data.containsKey('collector_number')) {
      context.handle(
          _collectorNumberMeta,
          collectorNumber.isAcceptableOrUnknown(
              data['collector_number']!, _collectorNumberMeta));
    } else if (isInserting) {
      context.missing(_collectorNumberMeta);
    }
    if (data.containsKey('digital')) {
      context.handle(_digitalMeta,
          digital.isAcceptableOrUnknown(data['digital']!, _digitalMeta));
    } else if (isInserting) {
      context.missing(_digitalMeta);
    }
    if (data.containsKey('rarity')) {
      context.handle(_rarityMeta,
          rarity.isAcceptableOrUnknown(data['rarity']!, _rarityMeta));
    } else if (isInserting) {
      context.missing(_rarityMeta);
    }
    if (data.containsKey('rarity_order')) {
      context.handle(
          _rarityOrderMeta,
          rarityOrder.isAcceptableOrUnknown(
              data['rarity_order']!, _rarityOrderMeta));
    }
    if (data.containsKey('power_numeric')) {
      context.handle(
          _powerNumericMeta,
          powerNumeric.isAcceptableOrUnknown(
              data['power_numeric']!, _powerNumericMeta));
    }
    if (data.containsKey('toughness_numeric')) {
      context.handle(
          _toughnessNumericMeta,
          toughnessNumeric.isAcceptableOrUnknown(
              data['toughness_numeric']!, _toughnessNumericMeta));
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('border_color')) {
      context.handle(
          _borderColorMeta,
          borderColor.isAcceptableOrUnknown(
              data['border_color']!, _borderColorMeta));
    } else if (isInserting) {
      context.missing(_borderColorMeta);
    }
    if (data.containsKey('frame')) {
      context.handle(
          _frameMeta, frame.isAcceptableOrUnknown(data['frame']!, _frameMeta));
    } else if (isInserting) {
      context.missing(_frameMeta);
    }
    if (data.containsKey('full_art')) {
      context.handle(_fullArtMeta,
          fullArt.isAcceptableOrUnknown(data['full_art']!, _fullArtMeta));
    } else if (isInserting) {
      context.missing(_fullArtMeta);
    }
    if (data.containsKey('textless')) {
      context.handle(_textlessMeta,
          textless.isAcceptableOrUnknown(data['textless']!, _textlessMeta));
    } else if (isInserting) {
      context.missing(_textlessMeta);
    }
    if (data.containsKey('booster')) {
      context.handle(_boosterMeta,
          booster.isAcceptableOrUnknown(data['booster']!, _boosterMeta));
    } else if (isInserting) {
      context.missing(_boosterMeta);
    }
    if (data.containsKey('story_spotlight')) {
      context.handle(
          _storySpotlightMeta,
          storySpotlight.isAcceptableOrUnknown(
              data['story_spotlight']!, _storySpotlightMeta));
    } else if (isInserting) {
      context.missing(_storySpotlightMeta);
    }
    if (data.containsKey('image_status')) {
      context.handle(
          _imageStatusMeta,
          imageStatus.isAcceptableOrUnknown(
              data['image_status']!, _imageStatusMeta));
    } else if (isInserting) {
      context.missing(_imageStatusMeta);
    }
    if (data.containsKey('image_small')) {
      context.handle(
          _imageSmallMeta,
          imageSmall.isAcceptableOrUnknown(
              data['image_small']!, _imageSmallMeta));
    }
    if (data.containsKey('image_normal')) {
      context.handle(
          _imageNormalMeta,
          imageNormal.isAcceptableOrUnknown(
              data['image_normal']!, _imageNormalMeta));
    }
    if (data.containsKey('image_large')) {
      context.handle(
          _imageLargeMeta,
          imageLarge.isAcceptableOrUnknown(
              data['image_large']!, _imageLargeMeta));
    }
    if (data.containsKey('image_png')) {
      context.handle(_imagePngMeta,
          imagePng.isAcceptableOrUnknown(data['image_png']!, _imagePngMeta));
    }
    if (data.containsKey('image_art_crop')) {
      context.handle(
          _imageArtCropMeta,
          imageArtCrop.isAcceptableOrUnknown(
              data['image_art_crop']!, _imageArtCropMeta));
    }
    if (data.containsKey('image_border_crop')) {
      context.handle(
          _imageBorderCropMeta,
          imageBorderCrop.isAcceptableOrUnknown(
              data['image_border_crop']!, _imageBorderCropMeta));
    }
    if (data.containsKey('legal_standard')) {
      context.handle(
          _legalStandardMeta,
          legalStandard.isAcceptableOrUnknown(
              data['legal_standard']!, _legalStandardMeta));
    } else if (isInserting) {
      context.missing(_legalStandardMeta);
    }
    if (data.containsKey('legal_future')) {
      context.handle(
          _legalFutureMeta,
          legalFuture.isAcceptableOrUnknown(
              data['legal_future']!, _legalFutureMeta));
    } else if (isInserting) {
      context.missing(_legalFutureMeta);
    }
    if (data.containsKey('legal_historic')) {
      context.handle(
          _legalHistoricMeta,
          legalHistoric.isAcceptableOrUnknown(
              data['legal_historic']!, _legalHistoricMeta));
    } else if (isInserting) {
      context.missing(_legalHistoricMeta);
    }
    if (data.containsKey('legal_gladiator')) {
      context.handle(
          _legalGladiatorMeta,
          legalGladiator.isAcceptableOrUnknown(
              data['legal_gladiator']!, _legalGladiatorMeta));
    } else if (isInserting) {
      context.missing(_legalGladiatorMeta);
    }
    if (data.containsKey('legal_pioneer')) {
      context.handle(
          _legalPioneerMeta,
          legalPioneer.isAcceptableOrUnknown(
              data['legal_pioneer']!, _legalPioneerMeta));
    } else if (isInserting) {
      context.missing(_legalPioneerMeta);
    }
    if (data.containsKey('legal_explorer')) {
      context.handle(
          _legalExplorerMeta,
          legalExplorer.isAcceptableOrUnknown(
              data['legal_explorer']!, _legalExplorerMeta));
    }
    if (data.containsKey('legal_modern')) {
      context.handle(
          _legalModernMeta,
          legalModern.isAcceptableOrUnknown(
              data['legal_modern']!, _legalModernMeta));
    } else if (isInserting) {
      context.missing(_legalModernMeta);
    }
    if (data.containsKey('legal_legacy')) {
      context.handle(
          _legalLegacyMeta,
          legalLegacy.isAcceptableOrUnknown(
              data['legal_legacy']!, _legalLegacyMeta));
    } else if (isInserting) {
      context.missing(_legalLegacyMeta);
    }
    if (data.containsKey('legal_pauper')) {
      context.handle(
          _legalPauperMeta,
          legalPauper.isAcceptableOrUnknown(
              data['legal_pauper']!, _legalPauperMeta));
    } else if (isInserting) {
      context.missing(_legalPauperMeta);
    }
    if (data.containsKey('legal_vintage')) {
      context.handle(
          _legalVintageMeta,
          legalVintage.isAcceptableOrUnknown(
              data['legal_vintage']!, _legalVintageMeta));
    } else if (isInserting) {
      context.missing(_legalVintageMeta);
    }
    if (data.containsKey('legal_penny')) {
      context.handle(
          _legalPennyMeta,
          legalPenny.isAcceptableOrUnknown(
              data['legal_penny']!, _legalPennyMeta));
    } else if (isInserting) {
      context.missing(_legalPennyMeta);
    }
    if (data.containsKey('legal_commander')) {
      context.handle(
          _legalCommanderMeta,
          legalCommander.isAcceptableOrUnknown(
              data['legal_commander']!, _legalCommanderMeta));
    } else if (isInserting) {
      context.missing(_legalCommanderMeta);
    }
    if (data.containsKey('legal_oathbreaker')) {
      context.handle(
          _legalOathbreakerMeta,
          legalOathbreaker.isAcceptableOrUnknown(
              data['legal_oathbreaker']!, _legalOathbreakerMeta));
    } else if (isInserting) {
      context.missing(_legalOathbreakerMeta);
    }
    if (data.containsKey('legal_brawl')) {
      context.handle(
          _legalBrawlMeta,
          legalBrawl.isAcceptableOrUnknown(
              data['legal_brawl']!, _legalBrawlMeta));
    } else if (isInserting) {
      context.missing(_legalBrawlMeta);
    }
    if (data.containsKey('legal_historicbrawl')) {
      context.handle(
          _legalHistoricbrawlMeta,
          legalHistoricbrawl.isAcceptableOrUnknown(
              data['legal_historicbrawl']!, _legalHistoricbrawlMeta));
    }
    if (data.containsKey('legal_alchemy')) {
      context.handle(
          _legalAlchemyMeta,
          legalAlchemy.isAcceptableOrUnknown(
              data['legal_alchemy']!, _legalAlchemyMeta));
    } else if (isInserting) {
      context.missing(_legalAlchemyMeta);
    }
    if (data.containsKey('legal_paupercommander')) {
      context.handle(
          _legalPaupercommanderMeta,
          legalPaupercommander.isAcceptableOrUnknown(
              data['legal_paupercommander']!, _legalPaupercommanderMeta));
    } else if (isInserting) {
      context.missing(_legalPaupercommanderMeta);
    }
    if (data.containsKey('legal_duel')) {
      context.handle(_legalDuelMeta,
          legalDuel.isAcceptableOrUnknown(data['legal_duel']!, _legalDuelMeta));
    } else if (isInserting) {
      context.missing(_legalDuelMeta);
    }
    if (data.containsKey('legal_oldschool')) {
      context.handle(
          _legalOldschoolMeta,
          legalOldschool.isAcceptableOrUnknown(
              data['legal_oldschool']!, _legalOldschoolMeta));
    } else if (isInserting) {
      context.missing(_legalOldschoolMeta);
    }
    if (data.containsKey('legal_premodern')) {
      context.handle(
          _legalPremodernMeta,
          legalPremodern.isAcceptableOrUnknown(
              data['legal_premodern']!, _legalPremodernMeta));
    } else if (isInserting) {
      context.missing(_legalPremodernMeta);
    }
    if (data.containsKey('legal_predh')) {
      context.handle(
          _legalPredhMeta,
          legalPredh.isAcceptableOrUnknown(
              data['legal_predh']!, _legalPredhMeta));
    } else if (isInserting) {
      context.missing(_legalPredhMeta);
    }
    if (data.containsKey('price_usd')) {
      context.handle(_priceUsdMeta,
          priceUsd.isAcceptableOrUnknown(data['price_usd']!, _priceUsdMeta));
    }
    if (data.containsKey('price_usd_foil')) {
      context.handle(
          _priceUsdFoilMeta,
          priceUsdFoil.isAcceptableOrUnknown(
              data['price_usd_foil']!, _priceUsdFoilMeta));
    }
    if (data.containsKey('price_usd_etched')) {
      context.handle(
          _priceUsdEtchedMeta,
          priceUsdEtched.isAcceptableOrUnknown(
              data['price_usd_etched']!, _priceUsdEtchedMeta));
    }
    if (data.containsKey('price_eur')) {
      context.handle(_priceEurMeta,
          priceEur.isAcceptableOrUnknown(data['price_eur']!, _priceEurMeta));
    }
    if (data.containsKey('price_eur_foil')) {
      context.handle(
          _priceEurFoilMeta,
          priceEurFoil.isAcceptableOrUnknown(
              data['price_eur_foil']!, _priceEurFoilMeta));
    }
    if (data.containsKey('price_tix')) {
      context.handle(_priceTixMeta,
          priceTix.isAcceptableOrUnknown(data['price_tix']!, _priceTixMeta));
    }
    if (data.containsKey('price_numeric')) {
      context.handle(
          _priceNumericMeta,
          priceNumeric.isAcceptableOrUnknown(
              data['price_numeric']!, _priceNumericMeta));
    }
    if (data.containsKey('card_faces_json')) {
      context.handle(
          _cardFacesJsonMeta,
          cardFacesJson.isAcceptableOrUnknown(
              data['card_faces_json']!, _cardFacesJsonMeta));
    }
    if (data.containsKey('rulings_json')) {
      context.handle(
          _rulingsJsonMeta,
          rulingsJson.isAcceptableOrUnknown(
              data['rulings_json']!, _rulingsJsonMeta));
    }
    if (data.containsKey('object')) {
      context.handle(_objectMeta,
          object.isAcceptableOrUnknown(data['object']!, _objectMeta));
    } else if (isInserting) {
      context.missing(_objectMeta);
    }
    if (data.containsKey('oversized')) {
      context.handle(_oversizedMeta,
          oversized.isAcceptableOrUnknown(data['oversized']!, _oversizedMeta));
    } else if (isInserting) {
      context.missing(_oversizedMeta);
    }
    if (data.containsKey('promo')) {
      context.handle(
          _promoMeta, promo.isAcceptableOrUnknown(data['promo']!, _promoMeta));
    } else if (isInserting) {
      context.missing(_promoMeta);
    }
    if (data.containsKey('reprint')) {
      context.handle(_reprintMeta,
          reprint.isAcceptableOrUnknown(data['reprint']!, _reprintMeta));
    } else if (isInserting) {
      context.missing(_reprintMeta);
    }
    if (data.containsKey('variation')) {
      context.handle(_variationMeta,
          variation.isAcceptableOrUnknown(data['variation']!, _variationMeta));
    } else if (isInserting) {
      context.missing(_variationMeta);
    }
    if (data.containsKey('games_json')) {
      context.handle(_gamesJsonMeta,
          gamesJson.isAcceptableOrUnknown(data['games_json']!, _gamesJsonMeta));
    }
    if (data.containsKey('reserved')) {
      context.handle(_reservedMeta,
          reserved.isAcceptableOrUnknown(data['reserved']!, _reservedMeta));
    } else if (isInserting) {
      context.missing(_reservedMeta);
    }
    if (data.containsKey('foil')) {
      context.handle(
          _foilMeta, foil.isAcceptableOrUnknown(data['foil']!, _foilMeta));
    } else if (isInserting) {
      context.missing(_foilMeta);
    }
    if (data.containsKey('nonfoil')) {
      context.handle(_nonfoilMeta,
          nonfoil.isAcceptableOrUnknown(data['nonfoil']!, _nonfoilMeta));
    } else if (isInserting) {
      context.missing(_nonfoilMeta);
    }
    if (data.containsKey('finishes_json')) {
      context.handle(
          _finishesJsonMeta,
          finishesJson.isAcceptableOrUnknown(
              data['finishes_json']!, _finishesJsonMeta));
    }
    if (data.containsKey('produced_mana_json')) {
      context.handle(
          _producedManaJsonMeta,
          producedManaJson.isAcceptableOrUnknown(
              data['produced_mana_json']!, _producedManaJsonMeta));
    }
    if (data.containsKey('edhrec_rank')) {
      context.handle(
          _edhrecRankMeta,
          edhrecRank.isAcceptableOrUnknown(
              data['edhrec_rank']!, _edhrecRankMeta));
    }
    if (data.containsKey('is_game_changer')) {
      context.handle(
          _isGameChangerMeta,
          isGameChanger.isAcceptableOrUnknown(
              data['is_game_changer']!, _isGameChangerMeta));
    }
    if (data.containsKey('related_token_ids_json')) {
      context.handle(
          _relatedTokenIdsJsonMeta,
          relatedTokenIdsJson.isAcceptableOrUnknown(
              data['related_token_ids_json']!, _relatedTokenIdsJsonMeta));
    }
    if (data.containsKey('mtgo_id')) {
      context.handle(_mtgoIdMeta,
          mtgoId.isAcceptableOrUnknown(data['mtgo_id']!, _mtgoIdMeta));
    }
    if (data.containsKey('arena_id')) {
      context.handle(_arenaIdMeta,
          arenaId.isAcceptableOrUnknown(data['arena_id']!, _arenaIdMeta));
    }
    if (data.containsKey('tcgplayer_id')) {
      context.handle(
          _tcgplayerIdMeta,
          tcgplayerId.isAcceptableOrUnknown(
              data['tcgplayer_id']!, _tcgplayerIdMeta));
    }
    if (data.containsKey('cardmarket_id')) {
      context.handle(
          _cardmarketIdMeta,
          cardmarketId.isAcceptableOrUnknown(
              data['cardmarket_id']!, _cardmarketIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      scryfallId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scryfall_id'])!,
      mtgjsonUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mtgjson_uuid']),
      oracleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}oracle_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      flavorName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flavor_name']),
      lang: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lang'])!,
      releasedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}released_at'])!,
      uri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uri'])!,
      scryfallUri: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scryfall_uri'])!,
      layout: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}layout'])!,
      manaCost: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mana_cost']),
      cmc: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cmc'])!,
      typeLine: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_line'])!,
      oracleText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}oracle_text']),
      flavorText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}flavor_text']),
      power: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}power']),
      toughness: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}toughness']),
      colorsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}colors_json'])!,
      colorIdentityJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}color_identity_json'])!,
      keywordsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keywords_json']),
      colorsString: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}colors_string'])!,
      colorIdentityString: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}color_identity_string'])!,
      legalInAnyFormat: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}legal_in_any_format'])!,
      isCanonicalPrinting: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}is_canonical_printing'])!,
      setCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_code'])!,
      setName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_name'])!,
      setType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_type'])!,
      collectorNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}collector_number'])!,
      digital: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}digital'])!,
      rarity: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarity'])!,
      rarityOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rarity_order'])!,
      powerNumeric: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}power_numeric']),
      toughnessNumeric: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}toughness_numeric']),
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist']),
      borderColor: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}border_color'])!,
      frame: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}frame'])!,
      fullArt: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}full_art'])!,
      textless: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}textless'])!,
      booster: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}booster'])!,
      storySpotlight: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}story_spotlight'])!,
      imageStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_status'])!,
      imageSmall: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_small']),
      imageNormal: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_normal']),
      imageLarge: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_large']),
      imagePng: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_png']),
      imageArtCrop: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_art_crop']),
      imageBorderCrop: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}image_border_crop']),
      legalStandard: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_standard'])!,
      legalFuture: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_future'])!,
      legalHistoric: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_historic'])!,
      legalGladiator: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}legal_gladiator'])!,
      legalPioneer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_pioneer'])!,
      legalExplorer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_explorer']),
      legalModern: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_modern'])!,
      legalLegacy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_legacy'])!,
      legalPauper: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_pauper'])!,
      legalVintage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_vintage'])!,
      legalPenny: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_penny'])!,
      legalCommander: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}legal_commander'])!,
      legalOathbreaker: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}legal_oathbreaker'])!,
      legalBrawl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_brawl'])!,
      legalHistoricbrawl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}legal_historicbrawl']),
      legalAlchemy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_alchemy'])!,
      legalPaupercommander: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}legal_paupercommander'])!,
      legalDuel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_duel'])!,
      legalOldschool: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}legal_oldschool'])!,
      legalPremodern: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}legal_premodern'])!,
      legalPredh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}legal_predh'])!,
      priceUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_usd']),
      priceUsdFoil: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_usd_foil']),
      priceUsdEtched: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}price_usd_etched']),
      priceEur: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_eur']),
      priceEurFoil: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_eur_foil']),
      priceTix: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}price_tix']),
      priceNumeric: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price_numeric']),
      cardFacesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}card_faces_json']),
      rulingsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rulings_json']),
      object: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}object'])!,
      oversized: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}oversized'])!,
      promo: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}promo'])!,
      reprint: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reprint'])!,
      variation: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}variation'])!,
      gamesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}games_json'])!,
      reserved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}reserved'])!,
      foil: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}foil'])!,
      nonfoil: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}nonfoil'])!,
      finishesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}finishes_json'])!,
      producedManaJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}produced_mana_json'])!,
      edhrecRank: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}edhrec_rank']),
      isGameChanger: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_game_changer']),
      relatedTokenIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}related_token_ids_json'])!,
      mtgoId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}mtgo_id']),
      arenaId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}arena_id']),
      tcgplayerId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tcgplayer_id']),
      cardmarketId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}cardmarket_id']),
    );
  }

  @override
  $CardsTable createAlias(String alias) {
    return $CardsTable(attachedDatabase, alias);
  }
}

class CardRow extends DataClass implements Insertable<CardRow> {
  final int id;
  final String scryfallId;
  final String? mtgjsonUuid;
  final String oracleId;
  final String name;
  final String? flavorName;
  final String lang;
  final String releasedAt;
  final String uri;
  final String scryfallUri;
  final String layout;
  final String? manaCost;
  final double cmc;
  final String typeLine;
  final String? oracleText;
  final String? flavorText;
  final String? power;
  final String? toughness;

  /// JSON-encoded `List<String>` — unsorted color letters, e.g. `["R","G"]`.
  final String colorsJson;

  /// JSON-encoded `List<String>` — sorted color identity letters.
  final String colorIdentityJson;

  /// JSON-encoded `List<String>?` — Scryfall keyword list.
  final String? keywordsJson;

  /// Precomputed: sorted colors as a WUBRG-ordered string (e.g. "WU").
  final String colorsString;

  /// Precomputed: sorted color identity as a WUBRG-ordered string.
  final String colorIdentityString;
  final bool legalInAnyFormat;
  final bool isCanonicalPrinting;
  final String setCode;
  final String setName;
  final String setType;
  final String collectorNumber;
  final bool digital;
  final String rarity;
  final int rarityOrder;
  final double? powerNumeric;
  final double? toughnessNumeric;
  final String? artist;
  final String borderColor;
  final String frame;
  final bool fullArt;
  final bool textless;
  final bool booster;
  final bool storySpotlight;
  final String imageStatus;
  final String? imageSmall;
  final String? imageNormal;
  final String? imageLarge;
  final String? imagePng;
  final String? imageArtCrop;
  final String? imageBorderCrop;
  final String legalStandard;
  final String legalFuture;
  final String legalHistoric;
  final String legalGladiator;
  final String legalPioneer;
  final String? legalExplorer;
  final String legalModern;
  final String legalLegacy;
  final String legalPauper;
  final String legalVintage;
  final String legalPenny;
  final String legalCommander;
  final String legalOathbreaker;
  final String legalBrawl;
  final String? legalHistoricbrawl;
  final String legalAlchemy;
  final String legalPaupercommander;
  final String legalDuel;
  final String legalOldschool;
  final String legalPremodern;
  final String legalPredh;
  final String? priceUsd;
  final String? priceUsdFoil;
  final String? priceUsdEtched;
  final String? priceEur;
  final String? priceEurFoil;
  final String? priceTix;
  final double? priceNumeric;
  final String? cardFacesJson;
  final String? rulingsJson;
  final String object;
  final bool oversized;
  final bool promo;
  final bool reprint;
  final bool variation;

  /// JSON-encoded `List<String>`.
  final String gamesJson;
  final bool reserved;
  final bool foil;
  final bool nonfoil;

  /// JSON-encoded `List<String>`.
  final String finishesJson;

  /// JSON-encoded `List<String>`.
  final String producedManaJson;
  final int? edhrecRank;
  final bool? isGameChanger;

  /// JSON-encoded `List<String>` — MTGJSON UUIDs of related tokens.
  final String relatedTokenIdsJson;
  final int? mtgoId;
  final int? arenaId;
  final int? tcgplayerId;
  final int? cardmarketId;
  const CardRow(
      {required this.id,
      required this.scryfallId,
      this.mtgjsonUuid,
      required this.oracleId,
      required this.name,
      this.flavorName,
      required this.lang,
      required this.releasedAt,
      required this.uri,
      required this.scryfallUri,
      required this.layout,
      this.manaCost,
      required this.cmc,
      required this.typeLine,
      this.oracleText,
      this.flavorText,
      this.power,
      this.toughness,
      required this.colorsJson,
      required this.colorIdentityJson,
      this.keywordsJson,
      required this.colorsString,
      required this.colorIdentityString,
      required this.legalInAnyFormat,
      required this.isCanonicalPrinting,
      required this.setCode,
      required this.setName,
      required this.setType,
      required this.collectorNumber,
      required this.digital,
      required this.rarity,
      required this.rarityOrder,
      this.powerNumeric,
      this.toughnessNumeric,
      this.artist,
      required this.borderColor,
      required this.frame,
      required this.fullArt,
      required this.textless,
      required this.booster,
      required this.storySpotlight,
      required this.imageStatus,
      this.imageSmall,
      this.imageNormal,
      this.imageLarge,
      this.imagePng,
      this.imageArtCrop,
      this.imageBorderCrop,
      required this.legalStandard,
      required this.legalFuture,
      required this.legalHistoric,
      required this.legalGladiator,
      required this.legalPioneer,
      this.legalExplorer,
      required this.legalModern,
      required this.legalLegacy,
      required this.legalPauper,
      required this.legalVintage,
      required this.legalPenny,
      required this.legalCommander,
      required this.legalOathbreaker,
      required this.legalBrawl,
      this.legalHistoricbrawl,
      required this.legalAlchemy,
      required this.legalPaupercommander,
      required this.legalDuel,
      required this.legalOldschool,
      required this.legalPremodern,
      required this.legalPredh,
      this.priceUsd,
      this.priceUsdFoil,
      this.priceUsdEtched,
      this.priceEur,
      this.priceEurFoil,
      this.priceTix,
      this.priceNumeric,
      this.cardFacesJson,
      this.rulingsJson,
      required this.object,
      required this.oversized,
      required this.promo,
      required this.reprint,
      required this.variation,
      required this.gamesJson,
      required this.reserved,
      required this.foil,
      required this.nonfoil,
      required this.finishesJson,
      required this.producedManaJson,
      this.edhrecRank,
      this.isGameChanger,
      required this.relatedTokenIdsJson,
      this.mtgoId,
      this.arenaId,
      this.tcgplayerId,
      this.cardmarketId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scryfall_id'] = Variable<String>(scryfallId);
    if (!nullToAbsent || mtgjsonUuid != null) {
      map['mtgjson_uuid'] = Variable<String>(mtgjsonUuid);
    }
    map['oracle_id'] = Variable<String>(oracleId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || flavorName != null) {
      map['flavor_name'] = Variable<String>(flavorName);
    }
    map['lang'] = Variable<String>(lang);
    map['released_at'] = Variable<String>(releasedAt);
    map['uri'] = Variable<String>(uri);
    map['scryfall_uri'] = Variable<String>(scryfallUri);
    map['layout'] = Variable<String>(layout);
    if (!nullToAbsent || manaCost != null) {
      map['mana_cost'] = Variable<String>(manaCost);
    }
    map['cmc'] = Variable<double>(cmc);
    map['type_line'] = Variable<String>(typeLine);
    if (!nullToAbsent || oracleText != null) {
      map['oracle_text'] = Variable<String>(oracleText);
    }
    if (!nullToAbsent || flavorText != null) {
      map['flavor_text'] = Variable<String>(flavorText);
    }
    if (!nullToAbsent || power != null) {
      map['power'] = Variable<String>(power);
    }
    if (!nullToAbsent || toughness != null) {
      map['toughness'] = Variable<String>(toughness);
    }
    map['colors_json'] = Variable<String>(colorsJson);
    map['color_identity_json'] = Variable<String>(colorIdentityJson);
    if (!nullToAbsent || keywordsJson != null) {
      map['keywords_json'] = Variable<String>(keywordsJson);
    }
    map['colors_string'] = Variable<String>(colorsString);
    map['color_identity_string'] = Variable<String>(colorIdentityString);
    map['legal_in_any_format'] = Variable<bool>(legalInAnyFormat);
    map['is_canonical_printing'] = Variable<bool>(isCanonicalPrinting);
    map['set_code'] = Variable<String>(setCode);
    map['set_name'] = Variable<String>(setName);
    map['set_type'] = Variable<String>(setType);
    map['collector_number'] = Variable<String>(collectorNumber);
    map['digital'] = Variable<bool>(digital);
    map['rarity'] = Variable<String>(rarity);
    map['rarity_order'] = Variable<int>(rarityOrder);
    if (!nullToAbsent || powerNumeric != null) {
      map['power_numeric'] = Variable<double>(powerNumeric);
    }
    if (!nullToAbsent || toughnessNumeric != null) {
      map['toughness_numeric'] = Variable<double>(toughnessNumeric);
    }
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    map['border_color'] = Variable<String>(borderColor);
    map['frame'] = Variable<String>(frame);
    map['full_art'] = Variable<bool>(fullArt);
    map['textless'] = Variable<bool>(textless);
    map['booster'] = Variable<bool>(booster);
    map['story_spotlight'] = Variable<bool>(storySpotlight);
    map['image_status'] = Variable<String>(imageStatus);
    if (!nullToAbsent || imageSmall != null) {
      map['image_small'] = Variable<String>(imageSmall);
    }
    if (!nullToAbsent || imageNormal != null) {
      map['image_normal'] = Variable<String>(imageNormal);
    }
    if (!nullToAbsent || imageLarge != null) {
      map['image_large'] = Variable<String>(imageLarge);
    }
    if (!nullToAbsent || imagePng != null) {
      map['image_png'] = Variable<String>(imagePng);
    }
    if (!nullToAbsent || imageArtCrop != null) {
      map['image_art_crop'] = Variable<String>(imageArtCrop);
    }
    if (!nullToAbsent || imageBorderCrop != null) {
      map['image_border_crop'] = Variable<String>(imageBorderCrop);
    }
    map['legal_standard'] = Variable<String>(legalStandard);
    map['legal_future'] = Variable<String>(legalFuture);
    map['legal_historic'] = Variable<String>(legalHistoric);
    map['legal_gladiator'] = Variable<String>(legalGladiator);
    map['legal_pioneer'] = Variable<String>(legalPioneer);
    if (!nullToAbsent || legalExplorer != null) {
      map['legal_explorer'] = Variable<String>(legalExplorer);
    }
    map['legal_modern'] = Variable<String>(legalModern);
    map['legal_legacy'] = Variable<String>(legalLegacy);
    map['legal_pauper'] = Variable<String>(legalPauper);
    map['legal_vintage'] = Variable<String>(legalVintage);
    map['legal_penny'] = Variable<String>(legalPenny);
    map['legal_commander'] = Variable<String>(legalCommander);
    map['legal_oathbreaker'] = Variable<String>(legalOathbreaker);
    map['legal_brawl'] = Variable<String>(legalBrawl);
    if (!nullToAbsent || legalHistoricbrawl != null) {
      map['legal_historicbrawl'] = Variable<String>(legalHistoricbrawl);
    }
    map['legal_alchemy'] = Variable<String>(legalAlchemy);
    map['legal_paupercommander'] = Variable<String>(legalPaupercommander);
    map['legal_duel'] = Variable<String>(legalDuel);
    map['legal_oldschool'] = Variable<String>(legalOldschool);
    map['legal_premodern'] = Variable<String>(legalPremodern);
    map['legal_predh'] = Variable<String>(legalPredh);
    if (!nullToAbsent || priceUsd != null) {
      map['price_usd'] = Variable<String>(priceUsd);
    }
    if (!nullToAbsent || priceUsdFoil != null) {
      map['price_usd_foil'] = Variable<String>(priceUsdFoil);
    }
    if (!nullToAbsent || priceUsdEtched != null) {
      map['price_usd_etched'] = Variable<String>(priceUsdEtched);
    }
    if (!nullToAbsent || priceEur != null) {
      map['price_eur'] = Variable<String>(priceEur);
    }
    if (!nullToAbsent || priceEurFoil != null) {
      map['price_eur_foil'] = Variable<String>(priceEurFoil);
    }
    if (!nullToAbsent || priceTix != null) {
      map['price_tix'] = Variable<String>(priceTix);
    }
    if (!nullToAbsent || priceNumeric != null) {
      map['price_numeric'] = Variable<double>(priceNumeric);
    }
    if (!nullToAbsent || cardFacesJson != null) {
      map['card_faces_json'] = Variable<String>(cardFacesJson);
    }
    if (!nullToAbsent || rulingsJson != null) {
      map['rulings_json'] = Variable<String>(rulingsJson);
    }
    map['object'] = Variable<String>(object);
    map['oversized'] = Variable<bool>(oversized);
    map['promo'] = Variable<bool>(promo);
    map['reprint'] = Variable<bool>(reprint);
    map['variation'] = Variable<bool>(variation);
    map['games_json'] = Variable<String>(gamesJson);
    map['reserved'] = Variable<bool>(reserved);
    map['foil'] = Variable<bool>(foil);
    map['nonfoil'] = Variable<bool>(nonfoil);
    map['finishes_json'] = Variable<String>(finishesJson);
    map['produced_mana_json'] = Variable<String>(producedManaJson);
    if (!nullToAbsent || edhrecRank != null) {
      map['edhrec_rank'] = Variable<int>(edhrecRank);
    }
    if (!nullToAbsent || isGameChanger != null) {
      map['is_game_changer'] = Variable<bool>(isGameChanger);
    }
    map['related_token_ids_json'] = Variable<String>(relatedTokenIdsJson);
    if (!nullToAbsent || mtgoId != null) {
      map['mtgo_id'] = Variable<int>(mtgoId);
    }
    if (!nullToAbsent || arenaId != null) {
      map['arena_id'] = Variable<int>(arenaId);
    }
    if (!nullToAbsent || tcgplayerId != null) {
      map['tcgplayer_id'] = Variable<int>(tcgplayerId);
    }
    if (!nullToAbsent || cardmarketId != null) {
      map['cardmarket_id'] = Variable<int>(cardmarketId);
    }
    return map;
  }

  CardsCompanion toCompanion(bool nullToAbsent) {
    return CardsCompanion(
      id: Value(id),
      scryfallId: Value(scryfallId),
      mtgjsonUuid: mtgjsonUuid == null && nullToAbsent
          ? const Value.absent()
          : Value(mtgjsonUuid),
      oracleId: Value(oracleId),
      name: Value(name),
      flavorName: flavorName == null && nullToAbsent
          ? const Value.absent()
          : Value(flavorName),
      lang: Value(lang),
      releasedAt: Value(releasedAt),
      uri: Value(uri),
      scryfallUri: Value(scryfallUri),
      layout: Value(layout),
      manaCost: manaCost == null && nullToAbsent
          ? const Value.absent()
          : Value(manaCost),
      cmc: Value(cmc),
      typeLine: Value(typeLine),
      oracleText: oracleText == null && nullToAbsent
          ? const Value.absent()
          : Value(oracleText),
      flavorText: flavorText == null && nullToAbsent
          ? const Value.absent()
          : Value(flavorText),
      power:
          power == null && nullToAbsent ? const Value.absent() : Value(power),
      toughness: toughness == null && nullToAbsent
          ? const Value.absent()
          : Value(toughness),
      colorsJson: Value(colorsJson),
      colorIdentityJson: Value(colorIdentityJson),
      keywordsJson: keywordsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(keywordsJson),
      colorsString: Value(colorsString),
      colorIdentityString: Value(colorIdentityString),
      legalInAnyFormat: Value(legalInAnyFormat),
      isCanonicalPrinting: Value(isCanonicalPrinting),
      setCode: Value(setCode),
      setName: Value(setName),
      setType: Value(setType),
      collectorNumber: Value(collectorNumber),
      digital: Value(digital),
      rarity: Value(rarity),
      rarityOrder: Value(rarityOrder),
      powerNumeric: powerNumeric == null && nullToAbsent
          ? const Value.absent()
          : Value(powerNumeric),
      toughnessNumeric: toughnessNumeric == null && nullToAbsent
          ? const Value.absent()
          : Value(toughnessNumeric),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      borderColor: Value(borderColor),
      frame: Value(frame),
      fullArt: Value(fullArt),
      textless: Value(textless),
      booster: Value(booster),
      storySpotlight: Value(storySpotlight),
      imageStatus: Value(imageStatus),
      imageSmall: imageSmall == null && nullToAbsent
          ? const Value.absent()
          : Value(imageSmall),
      imageNormal: imageNormal == null && nullToAbsent
          ? const Value.absent()
          : Value(imageNormal),
      imageLarge: imageLarge == null && nullToAbsent
          ? const Value.absent()
          : Value(imageLarge),
      imagePng: imagePng == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePng),
      imageArtCrop: imageArtCrop == null && nullToAbsent
          ? const Value.absent()
          : Value(imageArtCrop),
      imageBorderCrop: imageBorderCrop == null && nullToAbsent
          ? const Value.absent()
          : Value(imageBorderCrop),
      legalStandard: Value(legalStandard),
      legalFuture: Value(legalFuture),
      legalHistoric: Value(legalHistoric),
      legalGladiator: Value(legalGladiator),
      legalPioneer: Value(legalPioneer),
      legalExplorer: legalExplorer == null && nullToAbsent
          ? const Value.absent()
          : Value(legalExplorer),
      legalModern: Value(legalModern),
      legalLegacy: Value(legalLegacy),
      legalPauper: Value(legalPauper),
      legalVintage: Value(legalVintage),
      legalPenny: Value(legalPenny),
      legalCommander: Value(legalCommander),
      legalOathbreaker: Value(legalOathbreaker),
      legalBrawl: Value(legalBrawl),
      legalHistoricbrawl: legalHistoricbrawl == null && nullToAbsent
          ? const Value.absent()
          : Value(legalHistoricbrawl),
      legalAlchemy: Value(legalAlchemy),
      legalPaupercommander: Value(legalPaupercommander),
      legalDuel: Value(legalDuel),
      legalOldschool: Value(legalOldschool),
      legalPremodern: Value(legalPremodern),
      legalPredh: Value(legalPredh),
      priceUsd: priceUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(priceUsd),
      priceUsdFoil: priceUsdFoil == null && nullToAbsent
          ? const Value.absent()
          : Value(priceUsdFoil),
      priceUsdEtched: priceUsdEtched == null && nullToAbsent
          ? const Value.absent()
          : Value(priceUsdEtched),
      priceEur: priceEur == null && nullToAbsent
          ? const Value.absent()
          : Value(priceEur),
      priceEurFoil: priceEurFoil == null && nullToAbsent
          ? const Value.absent()
          : Value(priceEurFoil),
      priceTix: priceTix == null && nullToAbsent
          ? const Value.absent()
          : Value(priceTix),
      priceNumeric: priceNumeric == null && nullToAbsent
          ? const Value.absent()
          : Value(priceNumeric),
      cardFacesJson: cardFacesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(cardFacesJson),
      rulingsJson: rulingsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(rulingsJson),
      object: Value(object),
      oversized: Value(oversized),
      promo: Value(promo),
      reprint: Value(reprint),
      variation: Value(variation),
      gamesJson: Value(gamesJson),
      reserved: Value(reserved),
      foil: Value(foil),
      nonfoil: Value(nonfoil),
      finishesJson: Value(finishesJson),
      producedManaJson: Value(producedManaJson),
      edhrecRank: edhrecRank == null && nullToAbsent
          ? const Value.absent()
          : Value(edhrecRank),
      isGameChanger: isGameChanger == null && nullToAbsent
          ? const Value.absent()
          : Value(isGameChanger),
      relatedTokenIdsJson: Value(relatedTokenIdsJson),
      mtgoId:
          mtgoId == null && nullToAbsent ? const Value.absent() : Value(mtgoId),
      arenaId: arenaId == null && nullToAbsent
          ? const Value.absent()
          : Value(arenaId),
      tcgplayerId: tcgplayerId == null && nullToAbsent
          ? const Value.absent()
          : Value(tcgplayerId),
      cardmarketId: cardmarketId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardmarketId),
    );
  }

  factory CardRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardRow(
      id: serializer.fromJson<int>(json['id']),
      scryfallId: serializer.fromJson<String>(json['scryfallId']),
      mtgjsonUuid: serializer.fromJson<String?>(json['mtgjsonUuid']),
      oracleId: serializer.fromJson<String>(json['oracleId']),
      name: serializer.fromJson<String>(json['name']),
      flavorName: serializer.fromJson<String?>(json['flavorName']),
      lang: serializer.fromJson<String>(json['lang']),
      releasedAt: serializer.fromJson<String>(json['releasedAt']),
      uri: serializer.fromJson<String>(json['uri']),
      scryfallUri: serializer.fromJson<String>(json['scryfallUri']),
      layout: serializer.fromJson<String>(json['layout']),
      manaCost: serializer.fromJson<String?>(json['manaCost']),
      cmc: serializer.fromJson<double>(json['cmc']),
      typeLine: serializer.fromJson<String>(json['typeLine']),
      oracleText: serializer.fromJson<String?>(json['oracleText']),
      flavorText: serializer.fromJson<String?>(json['flavorText']),
      power: serializer.fromJson<String?>(json['power']),
      toughness: serializer.fromJson<String?>(json['toughness']),
      colorsJson: serializer.fromJson<String>(json['colorsJson']),
      colorIdentityJson: serializer.fromJson<String>(json['colorIdentityJson']),
      keywordsJson: serializer.fromJson<String?>(json['keywordsJson']),
      colorsString: serializer.fromJson<String>(json['colorsString']),
      colorIdentityString:
          serializer.fromJson<String>(json['colorIdentityString']),
      legalInAnyFormat: serializer.fromJson<bool>(json['legalInAnyFormat']),
      isCanonicalPrinting:
          serializer.fromJson<bool>(json['isCanonicalPrinting']),
      setCode: serializer.fromJson<String>(json['setCode']),
      setName: serializer.fromJson<String>(json['setName']),
      setType: serializer.fromJson<String>(json['setType']),
      collectorNumber: serializer.fromJson<String>(json['collectorNumber']),
      digital: serializer.fromJson<bool>(json['digital']),
      rarity: serializer.fromJson<String>(json['rarity']),
      rarityOrder: serializer.fromJson<int>(json['rarityOrder']),
      powerNumeric: serializer.fromJson<double?>(json['powerNumeric']),
      toughnessNumeric: serializer.fromJson<double?>(json['toughnessNumeric']),
      artist: serializer.fromJson<String?>(json['artist']),
      borderColor: serializer.fromJson<String>(json['borderColor']),
      frame: serializer.fromJson<String>(json['frame']),
      fullArt: serializer.fromJson<bool>(json['fullArt']),
      textless: serializer.fromJson<bool>(json['textless']),
      booster: serializer.fromJson<bool>(json['booster']),
      storySpotlight: serializer.fromJson<bool>(json['storySpotlight']),
      imageStatus: serializer.fromJson<String>(json['imageStatus']),
      imageSmall: serializer.fromJson<String?>(json['imageSmall']),
      imageNormal: serializer.fromJson<String?>(json['imageNormal']),
      imageLarge: serializer.fromJson<String?>(json['imageLarge']),
      imagePng: serializer.fromJson<String?>(json['imagePng']),
      imageArtCrop: serializer.fromJson<String?>(json['imageArtCrop']),
      imageBorderCrop: serializer.fromJson<String?>(json['imageBorderCrop']),
      legalStandard: serializer.fromJson<String>(json['legalStandard']),
      legalFuture: serializer.fromJson<String>(json['legalFuture']),
      legalHistoric: serializer.fromJson<String>(json['legalHistoric']),
      legalGladiator: serializer.fromJson<String>(json['legalGladiator']),
      legalPioneer: serializer.fromJson<String>(json['legalPioneer']),
      legalExplorer: serializer.fromJson<String?>(json['legalExplorer']),
      legalModern: serializer.fromJson<String>(json['legalModern']),
      legalLegacy: serializer.fromJson<String>(json['legalLegacy']),
      legalPauper: serializer.fromJson<String>(json['legalPauper']),
      legalVintage: serializer.fromJson<String>(json['legalVintage']),
      legalPenny: serializer.fromJson<String>(json['legalPenny']),
      legalCommander: serializer.fromJson<String>(json['legalCommander']),
      legalOathbreaker: serializer.fromJson<String>(json['legalOathbreaker']),
      legalBrawl: serializer.fromJson<String>(json['legalBrawl']),
      legalHistoricbrawl:
          serializer.fromJson<String?>(json['legalHistoricbrawl']),
      legalAlchemy: serializer.fromJson<String>(json['legalAlchemy']),
      legalPaupercommander:
          serializer.fromJson<String>(json['legalPaupercommander']),
      legalDuel: serializer.fromJson<String>(json['legalDuel']),
      legalOldschool: serializer.fromJson<String>(json['legalOldschool']),
      legalPremodern: serializer.fromJson<String>(json['legalPremodern']),
      legalPredh: serializer.fromJson<String>(json['legalPredh']),
      priceUsd: serializer.fromJson<String?>(json['priceUsd']),
      priceUsdFoil: serializer.fromJson<String?>(json['priceUsdFoil']),
      priceUsdEtched: serializer.fromJson<String?>(json['priceUsdEtched']),
      priceEur: serializer.fromJson<String?>(json['priceEur']),
      priceEurFoil: serializer.fromJson<String?>(json['priceEurFoil']),
      priceTix: serializer.fromJson<String?>(json['priceTix']),
      priceNumeric: serializer.fromJson<double?>(json['priceNumeric']),
      cardFacesJson: serializer.fromJson<String?>(json['cardFacesJson']),
      rulingsJson: serializer.fromJson<String?>(json['rulingsJson']),
      object: serializer.fromJson<String>(json['object']),
      oversized: serializer.fromJson<bool>(json['oversized']),
      promo: serializer.fromJson<bool>(json['promo']),
      reprint: serializer.fromJson<bool>(json['reprint']),
      variation: serializer.fromJson<bool>(json['variation']),
      gamesJson: serializer.fromJson<String>(json['gamesJson']),
      reserved: serializer.fromJson<bool>(json['reserved']),
      foil: serializer.fromJson<bool>(json['foil']),
      nonfoil: serializer.fromJson<bool>(json['nonfoil']),
      finishesJson: serializer.fromJson<String>(json['finishesJson']),
      producedManaJson: serializer.fromJson<String>(json['producedManaJson']),
      edhrecRank: serializer.fromJson<int?>(json['edhrecRank']),
      isGameChanger: serializer.fromJson<bool?>(json['isGameChanger']),
      relatedTokenIdsJson:
          serializer.fromJson<String>(json['relatedTokenIdsJson']),
      mtgoId: serializer.fromJson<int?>(json['mtgoId']),
      arenaId: serializer.fromJson<int?>(json['arenaId']),
      tcgplayerId: serializer.fromJson<int?>(json['tcgplayerId']),
      cardmarketId: serializer.fromJson<int?>(json['cardmarketId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scryfallId': serializer.toJson<String>(scryfallId),
      'mtgjsonUuid': serializer.toJson<String?>(mtgjsonUuid),
      'oracleId': serializer.toJson<String>(oracleId),
      'name': serializer.toJson<String>(name),
      'flavorName': serializer.toJson<String?>(flavorName),
      'lang': serializer.toJson<String>(lang),
      'releasedAt': serializer.toJson<String>(releasedAt),
      'uri': serializer.toJson<String>(uri),
      'scryfallUri': serializer.toJson<String>(scryfallUri),
      'layout': serializer.toJson<String>(layout),
      'manaCost': serializer.toJson<String?>(manaCost),
      'cmc': serializer.toJson<double>(cmc),
      'typeLine': serializer.toJson<String>(typeLine),
      'oracleText': serializer.toJson<String?>(oracleText),
      'flavorText': serializer.toJson<String?>(flavorText),
      'power': serializer.toJson<String?>(power),
      'toughness': serializer.toJson<String?>(toughness),
      'colorsJson': serializer.toJson<String>(colorsJson),
      'colorIdentityJson': serializer.toJson<String>(colorIdentityJson),
      'keywordsJson': serializer.toJson<String?>(keywordsJson),
      'colorsString': serializer.toJson<String>(colorsString),
      'colorIdentityString': serializer.toJson<String>(colorIdentityString),
      'legalInAnyFormat': serializer.toJson<bool>(legalInAnyFormat),
      'isCanonicalPrinting': serializer.toJson<bool>(isCanonicalPrinting),
      'setCode': serializer.toJson<String>(setCode),
      'setName': serializer.toJson<String>(setName),
      'setType': serializer.toJson<String>(setType),
      'collectorNumber': serializer.toJson<String>(collectorNumber),
      'digital': serializer.toJson<bool>(digital),
      'rarity': serializer.toJson<String>(rarity),
      'rarityOrder': serializer.toJson<int>(rarityOrder),
      'powerNumeric': serializer.toJson<double?>(powerNumeric),
      'toughnessNumeric': serializer.toJson<double?>(toughnessNumeric),
      'artist': serializer.toJson<String?>(artist),
      'borderColor': serializer.toJson<String>(borderColor),
      'frame': serializer.toJson<String>(frame),
      'fullArt': serializer.toJson<bool>(fullArt),
      'textless': serializer.toJson<bool>(textless),
      'booster': serializer.toJson<bool>(booster),
      'storySpotlight': serializer.toJson<bool>(storySpotlight),
      'imageStatus': serializer.toJson<String>(imageStatus),
      'imageSmall': serializer.toJson<String?>(imageSmall),
      'imageNormal': serializer.toJson<String?>(imageNormal),
      'imageLarge': serializer.toJson<String?>(imageLarge),
      'imagePng': serializer.toJson<String?>(imagePng),
      'imageArtCrop': serializer.toJson<String?>(imageArtCrop),
      'imageBorderCrop': serializer.toJson<String?>(imageBorderCrop),
      'legalStandard': serializer.toJson<String>(legalStandard),
      'legalFuture': serializer.toJson<String>(legalFuture),
      'legalHistoric': serializer.toJson<String>(legalHistoric),
      'legalGladiator': serializer.toJson<String>(legalGladiator),
      'legalPioneer': serializer.toJson<String>(legalPioneer),
      'legalExplorer': serializer.toJson<String?>(legalExplorer),
      'legalModern': serializer.toJson<String>(legalModern),
      'legalLegacy': serializer.toJson<String>(legalLegacy),
      'legalPauper': serializer.toJson<String>(legalPauper),
      'legalVintage': serializer.toJson<String>(legalVintage),
      'legalPenny': serializer.toJson<String>(legalPenny),
      'legalCommander': serializer.toJson<String>(legalCommander),
      'legalOathbreaker': serializer.toJson<String>(legalOathbreaker),
      'legalBrawl': serializer.toJson<String>(legalBrawl),
      'legalHistoricbrawl': serializer.toJson<String?>(legalHistoricbrawl),
      'legalAlchemy': serializer.toJson<String>(legalAlchemy),
      'legalPaupercommander': serializer.toJson<String>(legalPaupercommander),
      'legalDuel': serializer.toJson<String>(legalDuel),
      'legalOldschool': serializer.toJson<String>(legalOldschool),
      'legalPremodern': serializer.toJson<String>(legalPremodern),
      'legalPredh': serializer.toJson<String>(legalPredh),
      'priceUsd': serializer.toJson<String?>(priceUsd),
      'priceUsdFoil': serializer.toJson<String?>(priceUsdFoil),
      'priceUsdEtched': serializer.toJson<String?>(priceUsdEtched),
      'priceEur': serializer.toJson<String?>(priceEur),
      'priceEurFoil': serializer.toJson<String?>(priceEurFoil),
      'priceTix': serializer.toJson<String?>(priceTix),
      'priceNumeric': serializer.toJson<double?>(priceNumeric),
      'cardFacesJson': serializer.toJson<String?>(cardFacesJson),
      'rulingsJson': serializer.toJson<String?>(rulingsJson),
      'object': serializer.toJson<String>(object),
      'oversized': serializer.toJson<bool>(oversized),
      'promo': serializer.toJson<bool>(promo),
      'reprint': serializer.toJson<bool>(reprint),
      'variation': serializer.toJson<bool>(variation),
      'gamesJson': serializer.toJson<String>(gamesJson),
      'reserved': serializer.toJson<bool>(reserved),
      'foil': serializer.toJson<bool>(foil),
      'nonfoil': serializer.toJson<bool>(nonfoil),
      'finishesJson': serializer.toJson<String>(finishesJson),
      'producedManaJson': serializer.toJson<String>(producedManaJson),
      'edhrecRank': serializer.toJson<int?>(edhrecRank),
      'isGameChanger': serializer.toJson<bool?>(isGameChanger),
      'relatedTokenIdsJson': serializer.toJson<String>(relatedTokenIdsJson),
      'mtgoId': serializer.toJson<int?>(mtgoId),
      'arenaId': serializer.toJson<int?>(arenaId),
      'tcgplayerId': serializer.toJson<int?>(tcgplayerId),
      'cardmarketId': serializer.toJson<int?>(cardmarketId),
    };
  }

  CardRow copyWith(
          {int? id,
          String? scryfallId,
          Value<String?> mtgjsonUuid = const Value.absent(),
          String? oracleId,
          String? name,
          Value<String?> flavorName = const Value.absent(),
          String? lang,
          String? releasedAt,
          String? uri,
          String? scryfallUri,
          String? layout,
          Value<String?> manaCost = const Value.absent(),
          double? cmc,
          String? typeLine,
          Value<String?> oracleText = const Value.absent(),
          Value<String?> flavorText = const Value.absent(),
          Value<String?> power = const Value.absent(),
          Value<String?> toughness = const Value.absent(),
          String? colorsJson,
          String? colorIdentityJson,
          Value<String?> keywordsJson = const Value.absent(),
          String? colorsString,
          String? colorIdentityString,
          bool? legalInAnyFormat,
          bool? isCanonicalPrinting,
          String? setCode,
          String? setName,
          String? setType,
          String? collectorNumber,
          bool? digital,
          String? rarity,
          int? rarityOrder,
          Value<double?> powerNumeric = const Value.absent(),
          Value<double?> toughnessNumeric = const Value.absent(),
          Value<String?> artist = const Value.absent(),
          String? borderColor,
          String? frame,
          bool? fullArt,
          bool? textless,
          bool? booster,
          bool? storySpotlight,
          String? imageStatus,
          Value<String?> imageSmall = const Value.absent(),
          Value<String?> imageNormal = const Value.absent(),
          Value<String?> imageLarge = const Value.absent(),
          Value<String?> imagePng = const Value.absent(),
          Value<String?> imageArtCrop = const Value.absent(),
          Value<String?> imageBorderCrop = const Value.absent(),
          String? legalStandard,
          String? legalFuture,
          String? legalHistoric,
          String? legalGladiator,
          String? legalPioneer,
          Value<String?> legalExplorer = const Value.absent(),
          String? legalModern,
          String? legalLegacy,
          String? legalPauper,
          String? legalVintage,
          String? legalPenny,
          String? legalCommander,
          String? legalOathbreaker,
          String? legalBrawl,
          Value<String?> legalHistoricbrawl = const Value.absent(),
          String? legalAlchemy,
          String? legalPaupercommander,
          String? legalDuel,
          String? legalOldschool,
          String? legalPremodern,
          String? legalPredh,
          Value<String?> priceUsd = const Value.absent(),
          Value<String?> priceUsdFoil = const Value.absent(),
          Value<String?> priceUsdEtched = const Value.absent(),
          Value<String?> priceEur = const Value.absent(),
          Value<String?> priceEurFoil = const Value.absent(),
          Value<String?> priceTix = const Value.absent(),
          Value<double?> priceNumeric = const Value.absent(),
          Value<String?> cardFacesJson = const Value.absent(),
          Value<String?> rulingsJson = const Value.absent(),
          String? object,
          bool? oversized,
          bool? promo,
          bool? reprint,
          bool? variation,
          String? gamesJson,
          bool? reserved,
          bool? foil,
          bool? nonfoil,
          String? finishesJson,
          String? producedManaJson,
          Value<int?> edhrecRank = const Value.absent(),
          Value<bool?> isGameChanger = const Value.absent(),
          String? relatedTokenIdsJson,
          Value<int?> mtgoId = const Value.absent(),
          Value<int?> arenaId = const Value.absent(),
          Value<int?> tcgplayerId = const Value.absent(),
          Value<int?> cardmarketId = const Value.absent()}) =>
      CardRow(
        id: id ?? this.id,
        scryfallId: scryfallId ?? this.scryfallId,
        mtgjsonUuid: mtgjsonUuid.present ? mtgjsonUuid.value : this.mtgjsonUuid,
        oracleId: oracleId ?? this.oracleId,
        name: name ?? this.name,
        flavorName: flavorName.present ? flavorName.value : this.flavorName,
        lang: lang ?? this.lang,
        releasedAt: releasedAt ?? this.releasedAt,
        uri: uri ?? this.uri,
        scryfallUri: scryfallUri ?? this.scryfallUri,
        layout: layout ?? this.layout,
        manaCost: manaCost.present ? manaCost.value : this.manaCost,
        cmc: cmc ?? this.cmc,
        typeLine: typeLine ?? this.typeLine,
        oracleText: oracleText.present ? oracleText.value : this.oracleText,
        flavorText: flavorText.present ? flavorText.value : this.flavorText,
        power: power.present ? power.value : this.power,
        toughness: toughness.present ? toughness.value : this.toughness,
        colorsJson: colorsJson ?? this.colorsJson,
        colorIdentityJson: colorIdentityJson ?? this.colorIdentityJson,
        keywordsJson:
            keywordsJson.present ? keywordsJson.value : this.keywordsJson,
        colorsString: colorsString ?? this.colorsString,
        colorIdentityString: colorIdentityString ?? this.colorIdentityString,
        legalInAnyFormat: legalInAnyFormat ?? this.legalInAnyFormat,
        isCanonicalPrinting: isCanonicalPrinting ?? this.isCanonicalPrinting,
        setCode: setCode ?? this.setCode,
        setName: setName ?? this.setName,
        setType: setType ?? this.setType,
        collectorNumber: collectorNumber ?? this.collectorNumber,
        digital: digital ?? this.digital,
        rarity: rarity ?? this.rarity,
        rarityOrder: rarityOrder ?? this.rarityOrder,
        powerNumeric:
            powerNumeric.present ? powerNumeric.value : this.powerNumeric,
        toughnessNumeric: toughnessNumeric.present
            ? toughnessNumeric.value
            : this.toughnessNumeric,
        artist: artist.present ? artist.value : this.artist,
        borderColor: borderColor ?? this.borderColor,
        frame: frame ?? this.frame,
        fullArt: fullArt ?? this.fullArt,
        textless: textless ?? this.textless,
        booster: booster ?? this.booster,
        storySpotlight: storySpotlight ?? this.storySpotlight,
        imageStatus: imageStatus ?? this.imageStatus,
        imageSmall: imageSmall.present ? imageSmall.value : this.imageSmall,
        imageNormal: imageNormal.present ? imageNormal.value : this.imageNormal,
        imageLarge: imageLarge.present ? imageLarge.value : this.imageLarge,
        imagePng: imagePng.present ? imagePng.value : this.imagePng,
        imageArtCrop:
            imageArtCrop.present ? imageArtCrop.value : this.imageArtCrop,
        imageBorderCrop: imageBorderCrop.present
            ? imageBorderCrop.value
            : this.imageBorderCrop,
        legalStandard: legalStandard ?? this.legalStandard,
        legalFuture: legalFuture ?? this.legalFuture,
        legalHistoric: legalHistoric ?? this.legalHistoric,
        legalGladiator: legalGladiator ?? this.legalGladiator,
        legalPioneer: legalPioneer ?? this.legalPioneer,
        legalExplorer:
            legalExplorer.present ? legalExplorer.value : this.legalExplorer,
        legalModern: legalModern ?? this.legalModern,
        legalLegacy: legalLegacy ?? this.legalLegacy,
        legalPauper: legalPauper ?? this.legalPauper,
        legalVintage: legalVintage ?? this.legalVintage,
        legalPenny: legalPenny ?? this.legalPenny,
        legalCommander: legalCommander ?? this.legalCommander,
        legalOathbreaker: legalOathbreaker ?? this.legalOathbreaker,
        legalBrawl: legalBrawl ?? this.legalBrawl,
        legalHistoricbrawl: legalHistoricbrawl.present
            ? legalHistoricbrawl.value
            : this.legalHistoricbrawl,
        legalAlchemy: legalAlchemy ?? this.legalAlchemy,
        legalPaupercommander: legalPaupercommander ?? this.legalPaupercommander,
        legalDuel: legalDuel ?? this.legalDuel,
        legalOldschool: legalOldschool ?? this.legalOldschool,
        legalPremodern: legalPremodern ?? this.legalPremodern,
        legalPredh: legalPredh ?? this.legalPredh,
        priceUsd: priceUsd.present ? priceUsd.value : this.priceUsd,
        priceUsdFoil:
            priceUsdFoil.present ? priceUsdFoil.value : this.priceUsdFoil,
        priceUsdEtched:
            priceUsdEtched.present ? priceUsdEtched.value : this.priceUsdEtched,
        priceEur: priceEur.present ? priceEur.value : this.priceEur,
        priceEurFoil:
            priceEurFoil.present ? priceEurFoil.value : this.priceEurFoil,
        priceTix: priceTix.present ? priceTix.value : this.priceTix,
        priceNumeric:
            priceNumeric.present ? priceNumeric.value : this.priceNumeric,
        cardFacesJson:
            cardFacesJson.present ? cardFacesJson.value : this.cardFacesJson,
        rulingsJson: rulingsJson.present ? rulingsJson.value : this.rulingsJson,
        object: object ?? this.object,
        oversized: oversized ?? this.oversized,
        promo: promo ?? this.promo,
        reprint: reprint ?? this.reprint,
        variation: variation ?? this.variation,
        gamesJson: gamesJson ?? this.gamesJson,
        reserved: reserved ?? this.reserved,
        foil: foil ?? this.foil,
        nonfoil: nonfoil ?? this.nonfoil,
        finishesJson: finishesJson ?? this.finishesJson,
        producedManaJson: producedManaJson ?? this.producedManaJson,
        edhrecRank: edhrecRank.present ? edhrecRank.value : this.edhrecRank,
        isGameChanger:
            isGameChanger.present ? isGameChanger.value : this.isGameChanger,
        relatedTokenIdsJson: relatedTokenIdsJson ?? this.relatedTokenIdsJson,
        mtgoId: mtgoId.present ? mtgoId.value : this.mtgoId,
        arenaId: arenaId.present ? arenaId.value : this.arenaId,
        tcgplayerId: tcgplayerId.present ? tcgplayerId.value : this.tcgplayerId,
        cardmarketId:
            cardmarketId.present ? cardmarketId.value : this.cardmarketId,
      );
  CardRow copyWithCompanion(CardsCompanion data) {
    return CardRow(
      id: data.id.present ? data.id.value : this.id,
      scryfallId:
          data.scryfallId.present ? data.scryfallId.value : this.scryfallId,
      mtgjsonUuid:
          data.mtgjsonUuid.present ? data.mtgjsonUuid.value : this.mtgjsonUuid,
      oracleId: data.oracleId.present ? data.oracleId.value : this.oracleId,
      name: data.name.present ? data.name.value : this.name,
      flavorName:
          data.flavorName.present ? data.flavorName.value : this.flavorName,
      lang: data.lang.present ? data.lang.value : this.lang,
      releasedAt:
          data.releasedAt.present ? data.releasedAt.value : this.releasedAt,
      uri: data.uri.present ? data.uri.value : this.uri,
      scryfallUri:
          data.scryfallUri.present ? data.scryfallUri.value : this.scryfallUri,
      layout: data.layout.present ? data.layout.value : this.layout,
      manaCost: data.manaCost.present ? data.manaCost.value : this.manaCost,
      cmc: data.cmc.present ? data.cmc.value : this.cmc,
      typeLine: data.typeLine.present ? data.typeLine.value : this.typeLine,
      oracleText:
          data.oracleText.present ? data.oracleText.value : this.oracleText,
      flavorText:
          data.flavorText.present ? data.flavorText.value : this.flavorText,
      power: data.power.present ? data.power.value : this.power,
      toughness: data.toughness.present ? data.toughness.value : this.toughness,
      colorsJson:
          data.colorsJson.present ? data.colorsJson.value : this.colorsJson,
      colorIdentityJson: data.colorIdentityJson.present
          ? data.colorIdentityJson.value
          : this.colorIdentityJson,
      keywordsJson: data.keywordsJson.present
          ? data.keywordsJson.value
          : this.keywordsJson,
      colorsString: data.colorsString.present
          ? data.colorsString.value
          : this.colorsString,
      colorIdentityString: data.colorIdentityString.present
          ? data.colorIdentityString.value
          : this.colorIdentityString,
      legalInAnyFormat: data.legalInAnyFormat.present
          ? data.legalInAnyFormat.value
          : this.legalInAnyFormat,
      isCanonicalPrinting: data.isCanonicalPrinting.present
          ? data.isCanonicalPrinting.value
          : this.isCanonicalPrinting,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      setName: data.setName.present ? data.setName.value : this.setName,
      setType: data.setType.present ? data.setType.value : this.setType,
      collectorNumber: data.collectorNumber.present
          ? data.collectorNumber.value
          : this.collectorNumber,
      digital: data.digital.present ? data.digital.value : this.digital,
      rarity: data.rarity.present ? data.rarity.value : this.rarity,
      rarityOrder:
          data.rarityOrder.present ? data.rarityOrder.value : this.rarityOrder,
      powerNumeric: data.powerNumeric.present
          ? data.powerNumeric.value
          : this.powerNumeric,
      toughnessNumeric: data.toughnessNumeric.present
          ? data.toughnessNumeric.value
          : this.toughnessNumeric,
      artist: data.artist.present ? data.artist.value : this.artist,
      borderColor:
          data.borderColor.present ? data.borderColor.value : this.borderColor,
      frame: data.frame.present ? data.frame.value : this.frame,
      fullArt: data.fullArt.present ? data.fullArt.value : this.fullArt,
      textless: data.textless.present ? data.textless.value : this.textless,
      booster: data.booster.present ? data.booster.value : this.booster,
      storySpotlight: data.storySpotlight.present
          ? data.storySpotlight.value
          : this.storySpotlight,
      imageStatus:
          data.imageStatus.present ? data.imageStatus.value : this.imageStatus,
      imageSmall:
          data.imageSmall.present ? data.imageSmall.value : this.imageSmall,
      imageNormal:
          data.imageNormal.present ? data.imageNormal.value : this.imageNormal,
      imageLarge:
          data.imageLarge.present ? data.imageLarge.value : this.imageLarge,
      imagePng: data.imagePng.present ? data.imagePng.value : this.imagePng,
      imageArtCrop: data.imageArtCrop.present
          ? data.imageArtCrop.value
          : this.imageArtCrop,
      imageBorderCrop: data.imageBorderCrop.present
          ? data.imageBorderCrop.value
          : this.imageBorderCrop,
      legalStandard: data.legalStandard.present
          ? data.legalStandard.value
          : this.legalStandard,
      legalFuture:
          data.legalFuture.present ? data.legalFuture.value : this.legalFuture,
      legalHistoric: data.legalHistoric.present
          ? data.legalHistoric.value
          : this.legalHistoric,
      legalGladiator: data.legalGladiator.present
          ? data.legalGladiator.value
          : this.legalGladiator,
      legalPioneer: data.legalPioneer.present
          ? data.legalPioneer.value
          : this.legalPioneer,
      legalExplorer: data.legalExplorer.present
          ? data.legalExplorer.value
          : this.legalExplorer,
      legalModern:
          data.legalModern.present ? data.legalModern.value : this.legalModern,
      legalLegacy:
          data.legalLegacy.present ? data.legalLegacy.value : this.legalLegacy,
      legalPauper:
          data.legalPauper.present ? data.legalPauper.value : this.legalPauper,
      legalVintage: data.legalVintage.present
          ? data.legalVintage.value
          : this.legalVintage,
      legalPenny:
          data.legalPenny.present ? data.legalPenny.value : this.legalPenny,
      legalCommander: data.legalCommander.present
          ? data.legalCommander.value
          : this.legalCommander,
      legalOathbreaker: data.legalOathbreaker.present
          ? data.legalOathbreaker.value
          : this.legalOathbreaker,
      legalBrawl:
          data.legalBrawl.present ? data.legalBrawl.value : this.legalBrawl,
      legalHistoricbrawl: data.legalHistoricbrawl.present
          ? data.legalHistoricbrawl.value
          : this.legalHistoricbrawl,
      legalAlchemy: data.legalAlchemy.present
          ? data.legalAlchemy.value
          : this.legalAlchemy,
      legalPaupercommander: data.legalPaupercommander.present
          ? data.legalPaupercommander.value
          : this.legalPaupercommander,
      legalDuel: data.legalDuel.present ? data.legalDuel.value : this.legalDuel,
      legalOldschool: data.legalOldschool.present
          ? data.legalOldschool.value
          : this.legalOldschool,
      legalPremodern: data.legalPremodern.present
          ? data.legalPremodern.value
          : this.legalPremodern,
      legalPredh:
          data.legalPredh.present ? data.legalPredh.value : this.legalPredh,
      priceUsd: data.priceUsd.present ? data.priceUsd.value : this.priceUsd,
      priceUsdFoil: data.priceUsdFoil.present
          ? data.priceUsdFoil.value
          : this.priceUsdFoil,
      priceUsdEtched: data.priceUsdEtched.present
          ? data.priceUsdEtched.value
          : this.priceUsdEtched,
      priceEur: data.priceEur.present ? data.priceEur.value : this.priceEur,
      priceEurFoil: data.priceEurFoil.present
          ? data.priceEurFoil.value
          : this.priceEurFoil,
      priceTix: data.priceTix.present ? data.priceTix.value : this.priceTix,
      priceNumeric: data.priceNumeric.present
          ? data.priceNumeric.value
          : this.priceNumeric,
      cardFacesJson: data.cardFacesJson.present
          ? data.cardFacesJson.value
          : this.cardFacesJson,
      rulingsJson:
          data.rulingsJson.present ? data.rulingsJson.value : this.rulingsJson,
      object: data.object.present ? data.object.value : this.object,
      oversized: data.oversized.present ? data.oversized.value : this.oversized,
      promo: data.promo.present ? data.promo.value : this.promo,
      reprint: data.reprint.present ? data.reprint.value : this.reprint,
      variation: data.variation.present ? data.variation.value : this.variation,
      gamesJson: data.gamesJson.present ? data.gamesJson.value : this.gamesJson,
      reserved: data.reserved.present ? data.reserved.value : this.reserved,
      foil: data.foil.present ? data.foil.value : this.foil,
      nonfoil: data.nonfoil.present ? data.nonfoil.value : this.nonfoil,
      finishesJson: data.finishesJson.present
          ? data.finishesJson.value
          : this.finishesJson,
      producedManaJson: data.producedManaJson.present
          ? data.producedManaJson.value
          : this.producedManaJson,
      edhrecRank:
          data.edhrecRank.present ? data.edhrecRank.value : this.edhrecRank,
      isGameChanger: data.isGameChanger.present
          ? data.isGameChanger.value
          : this.isGameChanger,
      relatedTokenIdsJson: data.relatedTokenIdsJson.present
          ? data.relatedTokenIdsJson.value
          : this.relatedTokenIdsJson,
      mtgoId: data.mtgoId.present ? data.mtgoId.value : this.mtgoId,
      arenaId: data.arenaId.present ? data.arenaId.value : this.arenaId,
      tcgplayerId:
          data.tcgplayerId.present ? data.tcgplayerId.value : this.tcgplayerId,
      cardmarketId: data.cardmarketId.present
          ? data.cardmarketId.value
          : this.cardmarketId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardRow(')
          ..write('id: $id, ')
          ..write('scryfallId: $scryfallId, ')
          ..write('mtgjsonUuid: $mtgjsonUuid, ')
          ..write('oracleId: $oracleId, ')
          ..write('name: $name, ')
          ..write('flavorName: $flavorName, ')
          ..write('lang: $lang, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('uri: $uri, ')
          ..write('scryfallUri: $scryfallUri, ')
          ..write('layout: $layout, ')
          ..write('manaCost: $manaCost, ')
          ..write('cmc: $cmc, ')
          ..write('typeLine: $typeLine, ')
          ..write('oracleText: $oracleText, ')
          ..write('flavorText: $flavorText, ')
          ..write('power: $power, ')
          ..write('toughness: $toughness, ')
          ..write('colorsJson: $colorsJson, ')
          ..write('colorIdentityJson: $colorIdentityJson, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('colorsString: $colorsString, ')
          ..write('colorIdentityString: $colorIdentityString, ')
          ..write('legalInAnyFormat: $legalInAnyFormat, ')
          ..write('isCanonicalPrinting: $isCanonicalPrinting, ')
          ..write('setCode: $setCode, ')
          ..write('setName: $setName, ')
          ..write('setType: $setType, ')
          ..write('collectorNumber: $collectorNumber, ')
          ..write('digital: $digital, ')
          ..write('rarity: $rarity, ')
          ..write('rarityOrder: $rarityOrder, ')
          ..write('powerNumeric: $powerNumeric, ')
          ..write('toughnessNumeric: $toughnessNumeric, ')
          ..write('artist: $artist, ')
          ..write('borderColor: $borderColor, ')
          ..write('frame: $frame, ')
          ..write('fullArt: $fullArt, ')
          ..write('textless: $textless, ')
          ..write('booster: $booster, ')
          ..write('storySpotlight: $storySpotlight, ')
          ..write('imageStatus: $imageStatus, ')
          ..write('imageSmall: $imageSmall, ')
          ..write('imageNormal: $imageNormal, ')
          ..write('imageLarge: $imageLarge, ')
          ..write('imagePng: $imagePng, ')
          ..write('imageArtCrop: $imageArtCrop, ')
          ..write('imageBorderCrop: $imageBorderCrop, ')
          ..write('legalStandard: $legalStandard, ')
          ..write('legalFuture: $legalFuture, ')
          ..write('legalHistoric: $legalHistoric, ')
          ..write('legalGladiator: $legalGladiator, ')
          ..write('legalPioneer: $legalPioneer, ')
          ..write('legalExplorer: $legalExplorer, ')
          ..write('legalModern: $legalModern, ')
          ..write('legalLegacy: $legalLegacy, ')
          ..write('legalPauper: $legalPauper, ')
          ..write('legalVintage: $legalVintage, ')
          ..write('legalPenny: $legalPenny, ')
          ..write('legalCommander: $legalCommander, ')
          ..write('legalOathbreaker: $legalOathbreaker, ')
          ..write('legalBrawl: $legalBrawl, ')
          ..write('legalHistoricbrawl: $legalHistoricbrawl, ')
          ..write('legalAlchemy: $legalAlchemy, ')
          ..write('legalPaupercommander: $legalPaupercommander, ')
          ..write('legalDuel: $legalDuel, ')
          ..write('legalOldschool: $legalOldschool, ')
          ..write('legalPremodern: $legalPremodern, ')
          ..write('legalPredh: $legalPredh, ')
          ..write('priceUsd: $priceUsd, ')
          ..write('priceUsdFoil: $priceUsdFoil, ')
          ..write('priceUsdEtched: $priceUsdEtched, ')
          ..write('priceEur: $priceEur, ')
          ..write('priceEurFoil: $priceEurFoil, ')
          ..write('priceTix: $priceTix, ')
          ..write('priceNumeric: $priceNumeric, ')
          ..write('cardFacesJson: $cardFacesJson, ')
          ..write('rulingsJson: $rulingsJson, ')
          ..write('object: $object, ')
          ..write('oversized: $oversized, ')
          ..write('promo: $promo, ')
          ..write('reprint: $reprint, ')
          ..write('variation: $variation, ')
          ..write('gamesJson: $gamesJson, ')
          ..write('reserved: $reserved, ')
          ..write('foil: $foil, ')
          ..write('nonfoil: $nonfoil, ')
          ..write('finishesJson: $finishesJson, ')
          ..write('producedManaJson: $producedManaJson, ')
          ..write('edhrecRank: $edhrecRank, ')
          ..write('isGameChanger: $isGameChanger, ')
          ..write('relatedTokenIdsJson: $relatedTokenIdsJson, ')
          ..write('mtgoId: $mtgoId, ')
          ..write('arenaId: $arenaId, ')
          ..write('tcgplayerId: $tcgplayerId, ')
          ..write('cardmarketId: $cardmarketId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        scryfallId,
        mtgjsonUuid,
        oracleId,
        name,
        flavorName,
        lang,
        releasedAt,
        uri,
        scryfallUri,
        layout,
        manaCost,
        cmc,
        typeLine,
        oracleText,
        flavorText,
        power,
        toughness,
        colorsJson,
        colorIdentityJson,
        keywordsJson,
        colorsString,
        colorIdentityString,
        legalInAnyFormat,
        isCanonicalPrinting,
        setCode,
        setName,
        setType,
        collectorNumber,
        digital,
        rarity,
        rarityOrder,
        powerNumeric,
        toughnessNumeric,
        artist,
        borderColor,
        frame,
        fullArt,
        textless,
        booster,
        storySpotlight,
        imageStatus,
        imageSmall,
        imageNormal,
        imageLarge,
        imagePng,
        imageArtCrop,
        imageBorderCrop,
        legalStandard,
        legalFuture,
        legalHistoric,
        legalGladiator,
        legalPioneer,
        legalExplorer,
        legalModern,
        legalLegacy,
        legalPauper,
        legalVintage,
        legalPenny,
        legalCommander,
        legalOathbreaker,
        legalBrawl,
        legalHistoricbrawl,
        legalAlchemy,
        legalPaupercommander,
        legalDuel,
        legalOldschool,
        legalPremodern,
        legalPredh,
        priceUsd,
        priceUsdFoil,
        priceUsdEtched,
        priceEur,
        priceEurFoil,
        priceTix,
        priceNumeric,
        cardFacesJson,
        rulingsJson,
        object,
        oversized,
        promo,
        reprint,
        variation,
        gamesJson,
        reserved,
        foil,
        nonfoil,
        finishesJson,
        producedManaJson,
        edhrecRank,
        isGameChanger,
        relatedTokenIdsJson,
        mtgoId,
        arenaId,
        tcgplayerId,
        cardmarketId
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardRow &&
          other.id == this.id &&
          other.scryfallId == this.scryfallId &&
          other.mtgjsonUuid == this.mtgjsonUuid &&
          other.oracleId == this.oracleId &&
          other.name == this.name &&
          other.flavorName == this.flavorName &&
          other.lang == this.lang &&
          other.releasedAt == this.releasedAt &&
          other.uri == this.uri &&
          other.scryfallUri == this.scryfallUri &&
          other.layout == this.layout &&
          other.manaCost == this.manaCost &&
          other.cmc == this.cmc &&
          other.typeLine == this.typeLine &&
          other.oracleText == this.oracleText &&
          other.flavorText == this.flavorText &&
          other.power == this.power &&
          other.toughness == this.toughness &&
          other.colorsJson == this.colorsJson &&
          other.colorIdentityJson == this.colorIdentityJson &&
          other.keywordsJson == this.keywordsJson &&
          other.colorsString == this.colorsString &&
          other.colorIdentityString == this.colorIdentityString &&
          other.legalInAnyFormat == this.legalInAnyFormat &&
          other.isCanonicalPrinting == this.isCanonicalPrinting &&
          other.setCode == this.setCode &&
          other.setName == this.setName &&
          other.setType == this.setType &&
          other.collectorNumber == this.collectorNumber &&
          other.digital == this.digital &&
          other.rarity == this.rarity &&
          other.rarityOrder == this.rarityOrder &&
          other.powerNumeric == this.powerNumeric &&
          other.toughnessNumeric == this.toughnessNumeric &&
          other.artist == this.artist &&
          other.borderColor == this.borderColor &&
          other.frame == this.frame &&
          other.fullArt == this.fullArt &&
          other.textless == this.textless &&
          other.booster == this.booster &&
          other.storySpotlight == this.storySpotlight &&
          other.imageStatus == this.imageStatus &&
          other.imageSmall == this.imageSmall &&
          other.imageNormal == this.imageNormal &&
          other.imageLarge == this.imageLarge &&
          other.imagePng == this.imagePng &&
          other.imageArtCrop == this.imageArtCrop &&
          other.imageBorderCrop == this.imageBorderCrop &&
          other.legalStandard == this.legalStandard &&
          other.legalFuture == this.legalFuture &&
          other.legalHistoric == this.legalHistoric &&
          other.legalGladiator == this.legalGladiator &&
          other.legalPioneer == this.legalPioneer &&
          other.legalExplorer == this.legalExplorer &&
          other.legalModern == this.legalModern &&
          other.legalLegacy == this.legalLegacy &&
          other.legalPauper == this.legalPauper &&
          other.legalVintage == this.legalVintage &&
          other.legalPenny == this.legalPenny &&
          other.legalCommander == this.legalCommander &&
          other.legalOathbreaker == this.legalOathbreaker &&
          other.legalBrawl == this.legalBrawl &&
          other.legalHistoricbrawl == this.legalHistoricbrawl &&
          other.legalAlchemy == this.legalAlchemy &&
          other.legalPaupercommander == this.legalPaupercommander &&
          other.legalDuel == this.legalDuel &&
          other.legalOldschool == this.legalOldschool &&
          other.legalPremodern == this.legalPremodern &&
          other.legalPredh == this.legalPredh &&
          other.priceUsd == this.priceUsd &&
          other.priceUsdFoil == this.priceUsdFoil &&
          other.priceUsdEtched == this.priceUsdEtched &&
          other.priceEur == this.priceEur &&
          other.priceEurFoil == this.priceEurFoil &&
          other.priceTix == this.priceTix &&
          other.priceNumeric == this.priceNumeric &&
          other.cardFacesJson == this.cardFacesJson &&
          other.rulingsJson == this.rulingsJson &&
          other.object == this.object &&
          other.oversized == this.oversized &&
          other.promo == this.promo &&
          other.reprint == this.reprint &&
          other.variation == this.variation &&
          other.gamesJson == this.gamesJson &&
          other.reserved == this.reserved &&
          other.foil == this.foil &&
          other.nonfoil == this.nonfoil &&
          other.finishesJson == this.finishesJson &&
          other.producedManaJson == this.producedManaJson &&
          other.edhrecRank == this.edhrecRank &&
          other.isGameChanger == this.isGameChanger &&
          other.relatedTokenIdsJson == this.relatedTokenIdsJson &&
          other.mtgoId == this.mtgoId &&
          other.arenaId == this.arenaId &&
          other.tcgplayerId == this.tcgplayerId &&
          other.cardmarketId == this.cardmarketId);
}

class CardsCompanion extends UpdateCompanion<CardRow> {
  final Value<int> id;
  final Value<String> scryfallId;
  final Value<String?> mtgjsonUuid;
  final Value<String> oracleId;
  final Value<String> name;
  final Value<String?> flavorName;
  final Value<String> lang;
  final Value<String> releasedAt;
  final Value<String> uri;
  final Value<String> scryfallUri;
  final Value<String> layout;
  final Value<String?> manaCost;
  final Value<double> cmc;
  final Value<String> typeLine;
  final Value<String?> oracleText;
  final Value<String?> flavorText;
  final Value<String?> power;
  final Value<String?> toughness;
  final Value<String> colorsJson;
  final Value<String> colorIdentityJson;
  final Value<String?> keywordsJson;
  final Value<String> colorsString;
  final Value<String> colorIdentityString;
  final Value<bool> legalInAnyFormat;
  final Value<bool> isCanonicalPrinting;
  final Value<String> setCode;
  final Value<String> setName;
  final Value<String> setType;
  final Value<String> collectorNumber;
  final Value<bool> digital;
  final Value<String> rarity;
  final Value<int> rarityOrder;
  final Value<double?> powerNumeric;
  final Value<double?> toughnessNumeric;
  final Value<String?> artist;
  final Value<String> borderColor;
  final Value<String> frame;
  final Value<bool> fullArt;
  final Value<bool> textless;
  final Value<bool> booster;
  final Value<bool> storySpotlight;
  final Value<String> imageStatus;
  final Value<String?> imageSmall;
  final Value<String?> imageNormal;
  final Value<String?> imageLarge;
  final Value<String?> imagePng;
  final Value<String?> imageArtCrop;
  final Value<String?> imageBorderCrop;
  final Value<String> legalStandard;
  final Value<String> legalFuture;
  final Value<String> legalHistoric;
  final Value<String> legalGladiator;
  final Value<String> legalPioneer;
  final Value<String?> legalExplorer;
  final Value<String> legalModern;
  final Value<String> legalLegacy;
  final Value<String> legalPauper;
  final Value<String> legalVintage;
  final Value<String> legalPenny;
  final Value<String> legalCommander;
  final Value<String> legalOathbreaker;
  final Value<String> legalBrawl;
  final Value<String?> legalHistoricbrawl;
  final Value<String> legalAlchemy;
  final Value<String> legalPaupercommander;
  final Value<String> legalDuel;
  final Value<String> legalOldschool;
  final Value<String> legalPremodern;
  final Value<String> legalPredh;
  final Value<String?> priceUsd;
  final Value<String?> priceUsdFoil;
  final Value<String?> priceUsdEtched;
  final Value<String?> priceEur;
  final Value<String?> priceEurFoil;
  final Value<String?> priceTix;
  final Value<double?> priceNumeric;
  final Value<String?> cardFacesJson;
  final Value<String?> rulingsJson;
  final Value<String> object;
  final Value<bool> oversized;
  final Value<bool> promo;
  final Value<bool> reprint;
  final Value<bool> variation;
  final Value<String> gamesJson;
  final Value<bool> reserved;
  final Value<bool> foil;
  final Value<bool> nonfoil;
  final Value<String> finishesJson;
  final Value<String> producedManaJson;
  final Value<int?> edhrecRank;
  final Value<bool?> isGameChanger;
  final Value<String> relatedTokenIdsJson;
  final Value<int?> mtgoId;
  final Value<int?> arenaId;
  final Value<int?> tcgplayerId;
  final Value<int?> cardmarketId;
  const CardsCompanion({
    this.id = const Value.absent(),
    this.scryfallId = const Value.absent(),
    this.mtgjsonUuid = const Value.absent(),
    this.oracleId = const Value.absent(),
    this.name = const Value.absent(),
    this.flavorName = const Value.absent(),
    this.lang = const Value.absent(),
    this.releasedAt = const Value.absent(),
    this.uri = const Value.absent(),
    this.scryfallUri = const Value.absent(),
    this.layout = const Value.absent(),
    this.manaCost = const Value.absent(),
    this.cmc = const Value.absent(),
    this.typeLine = const Value.absent(),
    this.oracleText = const Value.absent(),
    this.flavorText = const Value.absent(),
    this.power = const Value.absent(),
    this.toughness = const Value.absent(),
    this.colorsJson = const Value.absent(),
    this.colorIdentityJson = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.colorsString = const Value.absent(),
    this.colorIdentityString = const Value.absent(),
    this.legalInAnyFormat = const Value.absent(),
    this.isCanonicalPrinting = const Value.absent(),
    this.setCode = const Value.absent(),
    this.setName = const Value.absent(),
    this.setType = const Value.absent(),
    this.collectorNumber = const Value.absent(),
    this.digital = const Value.absent(),
    this.rarity = const Value.absent(),
    this.rarityOrder = const Value.absent(),
    this.powerNumeric = const Value.absent(),
    this.toughnessNumeric = const Value.absent(),
    this.artist = const Value.absent(),
    this.borderColor = const Value.absent(),
    this.frame = const Value.absent(),
    this.fullArt = const Value.absent(),
    this.textless = const Value.absent(),
    this.booster = const Value.absent(),
    this.storySpotlight = const Value.absent(),
    this.imageStatus = const Value.absent(),
    this.imageSmall = const Value.absent(),
    this.imageNormal = const Value.absent(),
    this.imageLarge = const Value.absent(),
    this.imagePng = const Value.absent(),
    this.imageArtCrop = const Value.absent(),
    this.imageBorderCrop = const Value.absent(),
    this.legalStandard = const Value.absent(),
    this.legalFuture = const Value.absent(),
    this.legalHistoric = const Value.absent(),
    this.legalGladiator = const Value.absent(),
    this.legalPioneer = const Value.absent(),
    this.legalExplorer = const Value.absent(),
    this.legalModern = const Value.absent(),
    this.legalLegacy = const Value.absent(),
    this.legalPauper = const Value.absent(),
    this.legalVintage = const Value.absent(),
    this.legalPenny = const Value.absent(),
    this.legalCommander = const Value.absent(),
    this.legalOathbreaker = const Value.absent(),
    this.legalBrawl = const Value.absent(),
    this.legalHistoricbrawl = const Value.absent(),
    this.legalAlchemy = const Value.absent(),
    this.legalPaupercommander = const Value.absent(),
    this.legalDuel = const Value.absent(),
    this.legalOldschool = const Value.absent(),
    this.legalPremodern = const Value.absent(),
    this.legalPredh = const Value.absent(),
    this.priceUsd = const Value.absent(),
    this.priceUsdFoil = const Value.absent(),
    this.priceUsdEtched = const Value.absent(),
    this.priceEur = const Value.absent(),
    this.priceEurFoil = const Value.absent(),
    this.priceTix = const Value.absent(),
    this.priceNumeric = const Value.absent(),
    this.cardFacesJson = const Value.absent(),
    this.rulingsJson = const Value.absent(),
    this.object = const Value.absent(),
    this.oversized = const Value.absent(),
    this.promo = const Value.absent(),
    this.reprint = const Value.absent(),
    this.variation = const Value.absent(),
    this.gamesJson = const Value.absent(),
    this.reserved = const Value.absent(),
    this.foil = const Value.absent(),
    this.nonfoil = const Value.absent(),
    this.finishesJson = const Value.absent(),
    this.producedManaJson = const Value.absent(),
    this.edhrecRank = const Value.absent(),
    this.isGameChanger = const Value.absent(),
    this.relatedTokenIdsJson = const Value.absent(),
    this.mtgoId = const Value.absent(),
    this.arenaId = const Value.absent(),
    this.tcgplayerId = const Value.absent(),
    this.cardmarketId = const Value.absent(),
  });
  CardsCompanion.insert({
    this.id = const Value.absent(),
    required String scryfallId,
    this.mtgjsonUuid = const Value.absent(),
    required String oracleId,
    required String name,
    this.flavorName = const Value.absent(),
    required String lang,
    required String releasedAt,
    required String uri,
    required String scryfallUri,
    required String layout,
    this.manaCost = const Value.absent(),
    required double cmc,
    required String typeLine,
    this.oracleText = const Value.absent(),
    this.flavorText = const Value.absent(),
    this.power = const Value.absent(),
    this.toughness = const Value.absent(),
    this.colorsJson = const Value.absent(),
    this.colorIdentityJson = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.colorsString = const Value.absent(),
    this.colorIdentityString = const Value.absent(),
    this.legalInAnyFormat = const Value.absent(),
    this.isCanonicalPrinting = const Value.absent(),
    required String setCode,
    required String setName,
    required String setType,
    required String collectorNumber,
    required bool digital,
    required String rarity,
    this.rarityOrder = const Value.absent(),
    this.powerNumeric = const Value.absent(),
    this.toughnessNumeric = const Value.absent(),
    this.artist = const Value.absent(),
    required String borderColor,
    required String frame,
    required bool fullArt,
    required bool textless,
    required bool booster,
    required bool storySpotlight,
    required String imageStatus,
    this.imageSmall = const Value.absent(),
    this.imageNormal = const Value.absent(),
    this.imageLarge = const Value.absent(),
    this.imagePng = const Value.absent(),
    this.imageArtCrop = const Value.absent(),
    this.imageBorderCrop = const Value.absent(),
    required String legalStandard,
    required String legalFuture,
    required String legalHistoric,
    required String legalGladiator,
    required String legalPioneer,
    this.legalExplorer = const Value.absent(),
    required String legalModern,
    required String legalLegacy,
    required String legalPauper,
    required String legalVintage,
    required String legalPenny,
    required String legalCommander,
    required String legalOathbreaker,
    required String legalBrawl,
    this.legalHistoricbrawl = const Value.absent(),
    required String legalAlchemy,
    required String legalPaupercommander,
    required String legalDuel,
    required String legalOldschool,
    required String legalPremodern,
    required String legalPredh,
    this.priceUsd = const Value.absent(),
    this.priceUsdFoil = const Value.absent(),
    this.priceUsdEtched = const Value.absent(),
    this.priceEur = const Value.absent(),
    this.priceEurFoil = const Value.absent(),
    this.priceTix = const Value.absent(),
    this.priceNumeric = const Value.absent(),
    this.cardFacesJson = const Value.absent(),
    this.rulingsJson = const Value.absent(),
    required String object,
    required bool oversized,
    required bool promo,
    required bool reprint,
    required bool variation,
    this.gamesJson = const Value.absent(),
    required bool reserved,
    required bool foil,
    required bool nonfoil,
    this.finishesJson = const Value.absent(),
    this.producedManaJson = const Value.absent(),
    this.edhrecRank = const Value.absent(),
    this.isGameChanger = const Value.absent(),
    this.relatedTokenIdsJson = const Value.absent(),
    this.mtgoId = const Value.absent(),
    this.arenaId = const Value.absent(),
    this.tcgplayerId = const Value.absent(),
    this.cardmarketId = const Value.absent(),
  })  : scryfallId = Value(scryfallId),
        oracleId = Value(oracleId),
        name = Value(name),
        lang = Value(lang),
        releasedAt = Value(releasedAt),
        uri = Value(uri),
        scryfallUri = Value(scryfallUri),
        layout = Value(layout),
        cmc = Value(cmc),
        typeLine = Value(typeLine),
        setCode = Value(setCode),
        setName = Value(setName),
        setType = Value(setType),
        collectorNumber = Value(collectorNumber),
        digital = Value(digital),
        rarity = Value(rarity),
        borderColor = Value(borderColor),
        frame = Value(frame),
        fullArt = Value(fullArt),
        textless = Value(textless),
        booster = Value(booster),
        storySpotlight = Value(storySpotlight),
        imageStatus = Value(imageStatus),
        legalStandard = Value(legalStandard),
        legalFuture = Value(legalFuture),
        legalHistoric = Value(legalHistoric),
        legalGladiator = Value(legalGladiator),
        legalPioneer = Value(legalPioneer),
        legalModern = Value(legalModern),
        legalLegacy = Value(legalLegacy),
        legalPauper = Value(legalPauper),
        legalVintage = Value(legalVintage),
        legalPenny = Value(legalPenny),
        legalCommander = Value(legalCommander),
        legalOathbreaker = Value(legalOathbreaker),
        legalBrawl = Value(legalBrawl),
        legalAlchemy = Value(legalAlchemy),
        legalPaupercommander = Value(legalPaupercommander),
        legalDuel = Value(legalDuel),
        legalOldschool = Value(legalOldschool),
        legalPremodern = Value(legalPremodern),
        legalPredh = Value(legalPredh),
        object = Value(object),
        oversized = Value(oversized),
        promo = Value(promo),
        reprint = Value(reprint),
        variation = Value(variation),
        reserved = Value(reserved),
        foil = Value(foil),
        nonfoil = Value(nonfoil);
  static Insertable<CardRow> custom({
    Expression<int>? id,
    Expression<String>? scryfallId,
    Expression<String>? mtgjsonUuid,
    Expression<String>? oracleId,
    Expression<String>? name,
    Expression<String>? flavorName,
    Expression<String>? lang,
    Expression<String>? releasedAt,
    Expression<String>? uri,
    Expression<String>? scryfallUri,
    Expression<String>? layout,
    Expression<String>? manaCost,
    Expression<double>? cmc,
    Expression<String>? typeLine,
    Expression<String>? oracleText,
    Expression<String>? flavorText,
    Expression<String>? power,
    Expression<String>? toughness,
    Expression<String>? colorsJson,
    Expression<String>? colorIdentityJson,
    Expression<String>? keywordsJson,
    Expression<String>? colorsString,
    Expression<String>? colorIdentityString,
    Expression<bool>? legalInAnyFormat,
    Expression<bool>? isCanonicalPrinting,
    Expression<String>? setCode,
    Expression<String>? setName,
    Expression<String>? setType,
    Expression<String>? collectorNumber,
    Expression<bool>? digital,
    Expression<String>? rarity,
    Expression<int>? rarityOrder,
    Expression<double>? powerNumeric,
    Expression<double>? toughnessNumeric,
    Expression<String>? artist,
    Expression<String>? borderColor,
    Expression<String>? frame,
    Expression<bool>? fullArt,
    Expression<bool>? textless,
    Expression<bool>? booster,
    Expression<bool>? storySpotlight,
    Expression<String>? imageStatus,
    Expression<String>? imageSmall,
    Expression<String>? imageNormal,
    Expression<String>? imageLarge,
    Expression<String>? imagePng,
    Expression<String>? imageArtCrop,
    Expression<String>? imageBorderCrop,
    Expression<String>? legalStandard,
    Expression<String>? legalFuture,
    Expression<String>? legalHistoric,
    Expression<String>? legalGladiator,
    Expression<String>? legalPioneer,
    Expression<String>? legalExplorer,
    Expression<String>? legalModern,
    Expression<String>? legalLegacy,
    Expression<String>? legalPauper,
    Expression<String>? legalVintage,
    Expression<String>? legalPenny,
    Expression<String>? legalCommander,
    Expression<String>? legalOathbreaker,
    Expression<String>? legalBrawl,
    Expression<String>? legalHistoricbrawl,
    Expression<String>? legalAlchemy,
    Expression<String>? legalPaupercommander,
    Expression<String>? legalDuel,
    Expression<String>? legalOldschool,
    Expression<String>? legalPremodern,
    Expression<String>? legalPredh,
    Expression<String>? priceUsd,
    Expression<String>? priceUsdFoil,
    Expression<String>? priceUsdEtched,
    Expression<String>? priceEur,
    Expression<String>? priceEurFoil,
    Expression<String>? priceTix,
    Expression<double>? priceNumeric,
    Expression<String>? cardFacesJson,
    Expression<String>? rulingsJson,
    Expression<String>? object,
    Expression<bool>? oversized,
    Expression<bool>? promo,
    Expression<bool>? reprint,
    Expression<bool>? variation,
    Expression<String>? gamesJson,
    Expression<bool>? reserved,
    Expression<bool>? foil,
    Expression<bool>? nonfoil,
    Expression<String>? finishesJson,
    Expression<String>? producedManaJson,
    Expression<int>? edhrecRank,
    Expression<bool>? isGameChanger,
    Expression<String>? relatedTokenIdsJson,
    Expression<int>? mtgoId,
    Expression<int>? arenaId,
    Expression<int>? tcgplayerId,
    Expression<int>? cardmarketId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scryfallId != null) 'scryfall_id': scryfallId,
      if (mtgjsonUuid != null) 'mtgjson_uuid': mtgjsonUuid,
      if (oracleId != null) 'oracle_id': oracleId,
      if (name != null) 'name': name,
      if (flavorName != null) 'flavor_name': flavorName,
      if (lang != null) 'lang': lang,
      if (releasedAt != null) 'released_at': releasedAt,
      if (uri != null) 'uri': uri,
      if (scryfallUri != null) 'scryfall_uri': scryfallUri,
      if (layout != null) 'layout': layout,
      if (manaCost != null) 'mana_cost': manaCost,
      if (cmc != null) 'cmc': cmc,
      if (typeLine != null) 'type_line': typeLine,
      if (oracleText != null) 'oracle_text': oracleText,
      if (flavorText != null) 'flavor_text': flavorText,
      if (power != null) 'power': power,
      if (toughness != null) 'toughness': toughness,
      if (colorsJson != null) 'colors_json': colorsJson,
      if (colorIdentityJson != null) 'color_identity_json': colorIdentityJson,
      if (keywordsJson != null) 'keywords_json': keywordsJson,
      if (colorsString != null) 'colors_string': colorsString,
      if (colorIdentityString != null)
        'color_identity_string': colorIdentityString,
      if (legalInAnyFormat != null) 'legal_in_any_format': legalInAnyFormat,
      if (isCanonicalPrinting != null)
        'is_canonical_printing': isCanonicalPrinting,
      if (setCode != null) 'set_code': setCode,
      if (setName != null) 'set_name': setName,
      if (setType != null) 'set_type': setType,
      if (collectorNumber != null) 'collector_number': collectorNumber,
      if (digital != null) 'digital': digital,
      if (rarity != null) 'rarity': rarity,
      if (rarityOrder != null) 'rarity_order': rarityOrder,
      if (powerNumeric != null) 'power_numeric': powerNumeric,
      if (toughnessNumeric != null) 'toughness_numeric': toughnessNumeric,
      if (artist != null) 'artist': artist,
      if (borderColor != null) 'border_color': borderColor,
      if (frame != null) 'frame': frame,
      if (fullArt != null) 'full_art': fullArt,
      if (textless != null) 'textless': textless,
      if (booster != null) 'booster': booster,
      if (storySpotlight != null) 'story_spotlight': storySpotlight,
      if (imageStatus != null) 'image_status': imageStatus,
      if (imageSmall != null) 'image_small': imageSmall,
      if (imageNormal != null) 'image_normal': imageNormal,
      if (imageLarge != null) 'image_large': imageLarge,
      if (imagePng != null) 'image_png': imagePng,
      if (imageArtCrop != null) 'image_art_crop': imageArtCrop,
      if (imageBorderCrop != null) 'image_border_crop': imageBorderCrop,
      if (legalStandard != null) 'legal_standard': legalStandard,
      if (legalFuture != null) 'legal_future': legalFuture,
      if (legalHistoric != null) 'legal_historic': legalHistoric,
      if (legalGladiator != null) 'legal_gladiator': legalGladiator,
      if (legalPioneer != null) 'legal_pioneer': legalPioneer,
      if (legalExplorer != null) 'legal_explorer': legalExplorer,
      if (legalModern != null) 'legal_modern': legalModern,
      if (legalLegacy != null) 'legal_legacy': legalLegacy,
      if (legalPauper != null) 'legal_pauper': legalPauper,
      if (legalVintage != null) 'legal_vintage': legalVintage,
      if (legalPenny != null) 'legal_penny': legalPenny,
      if (legalCommander != null) 'legal_commander': legalCommander,
      if (legalOathbreaker != null) 'legal_oathbreaker': legalOathbreaker,
      if (legalBrawl != null) 'legal_brawl': legalBrawl,
      if (legalHistoricbrawl != null) 'legal_historicbrawl': legalHistoricbrawl,
      if (legalAlchemy != null) 'legal_alchemy': legalAlchemy,
      if (legalPaupercommander != null)
        'legal_paupercommander': legalPaupercommander,
      if (legalDuel != null) 'legal_duel': legalDuel,
      if (legalOldschool != null) 'legal_oldschool': legalOldschool,
      if (legalPremodern != null) 'legal_premodern': legalPremodern,
      if (legalPredh != null) 'legal_predh': legalPredh,
      if (priceUsd != null) 'price_usd': priceUsd,
      if (priceUsdFoil != null) 'price_usd_foil': priceUsdFoil,
      if (priceUsdEtched != null) 'price_usd_etched': priceUsdEtched,
      if (priceEur != null) 'price_eur': priceEur,
      if (priceEurFoil != null) 'price_eur_foil': priceEurFoil,
      if (priceTix != null) 'price_tix': priceTix,
      if (priceNumeric != null) 'price_numeric': priceNumeric,
      if (cardFacesJson != null) 'card_faces_json': cardFacesJson,
      if (rulingsJson != null) 'rulings_json': rulingsJson,
      if (object != null) 'object': object,
      if (oversized != null) 'oversized': oversized,
      if (promo != null) 'promo': promo,
      if (reprint != null) 'reprint': reprint,
      if (variation != null) 'variation': variation,
      if (gamesJson != null) 'games_json': gamesJson,
      if (reserved != null) 'reserved': reserved,
      if (foil != null) 'foil': foil,
      if (nonfoil != null) 'nonfoil': nonfoil,
      if (finishesJson != null) 'finishes_json': finishesJson,
      if (producedManaJson != null) 'produced_mana_json': producedManaJson,
      if (edhrecRank != null) 'edhrec_rank': edhrecRank,
      if (isGameChanger != null) 'is_game_changer': isGameChanger,
      if (relatedTokenIdsJson != null)
        'related_token_ids_json': relatedTokenIdsJson,
      if (mtgoId != null) 'mtgo_id': mtgoId,
      if (arenaId != null) 'arena_id': arenaId,
      if (tcgplayerId != null) 'tcgplayer_id': tcgplayerId,
      if (cardmarketId != null) 'cardmarket_id': cardmarketId,
    });
  }

  CardsCompanion copyWith(
      {Value<int>? id,
      Value<String>? scryfallId,
      Value<String?>? mtgjsonUuid,
      Value<String>? oracleId,
      Value<String>? name,
      Value<String?>? flavorName,
      Value<String>? lang,
      Value<String>? releasedAt,
      Value<String>? uri,
      Value<String>? scryfallUri,
      Value<String>? layout,
      Value<String?>? manaCost,
      Value<double>? cmc,
      Value<String>? typeLine,
      Value<String?>? oracleText,
      Value<String?>? flavorText,
      Value<String?>? power,
      Value<String?>? toughness,
      Value<String>? colorsJson,
      Value<String>? colorIdentityJson,
      Value<String?>? keywordsJson,
      Value<String>? colorsString,
      Value<String>? colorIdentityString,
      Value<bool>? legalInAnyFormat,
      Value<bool>? isCanonicalPrinting,
      Value<String>? setCode,
      Value<String>? setName,
      Value<String>? setType,
      Value<String>? collectorNumber,
      Value<bool>? digital,
      Value<String>? rarity,
      Value<int>? rarityOrder,
      Value<double?>? powerNumeric,
      Value<double?>? toughnessNumeric,
      Value<String?>? artist,
      Value<String>? borderColor,
      Value<String>? frame,
      Value<bool>? fullArt,
      Value<bool>? textless,
      Value<bool>? booster,
      Value<bool>? storySpotlight,
      Value<String>? imageStatus,
      Value<String?>? imageSmall,
      Value<String?>? imageNormal,
      Value<String?>? imageLarge,
      Value<String?>? imagePng,
      Value<String?>? imageArtCrop,
      Value<String?>? imageBorderCrop,
      Value<String>? legalStandard,
      Value<String>? legalFuture,
      Value<String>? legalHistoric,
      Value<String>? legalGladiator,
      Value<String>? legalPioneer,
      Value<String?>? legalExplorer,
      Value<String>? legalModern,
      Value<String>? legalLegacy,
      Value<String>? legalPauper,
      Value<String>? legalVintage,
      Value<String>? legalPenny,
      Value<String>? legalCommander,
      Value<String>? legalOathbreaker,
      Value<String>? legalBrawl,
      Value<String?>? legalHistoricbrawl,
      Value<String>? legalAlchemy,
      Value<String>? legalPaupercommander,
      Value<String>? legalDuel,
      Value<String>? legalOldschool,
      Value<String>? legalPremodern,
      Value<String>? legalPredh,
      Value<String?>? priceUsd,
      Value<String?>? priceUsdFoil,
      Value<String?>? priceUsdEtched,
      Value<String?>? priceEur,
      Value<String?>? priceEurFoil,
      Value<String?>? priceTix,
      Value<double?>? priceNumeric,
      Value<String?>? cardFacesJson,
      Value<String?>? rulingsJson,
      Value<String>? object,
      Value<bool>? oversized,
      Value<bool>? promo,
      Value<bool>? reprint,
      Value<bool>? variation,
      Value<String>? gamesJson,
      Value<bool>? reserved,
      Value<bool>? foil,
      Value<bool>? nonfoil,
      Value<String>? finishesJson,
      Value<String>? producedManaJson,
      Value<int?>? edhrecRank,
      Value<bool?>? isGameChanger,
      Value<String>? relatedTokenIdsJson,
      Value<int?>? mtgoId,
      Value<int?>? arenaId,
      Value<int?>? tcgplayerId,
      Value<int?>? cardmarketId}) {
    return CardsCompanion(
      id: id ?? this.id,
      scryfallId: scryfallId ?? this.scryfallId,
      mtgjsonUuid: mtgjsonUuid ?? this.mtgjsonUuid,
      oracleId: oracleId ?? this.oracleId,
      name: name ?? this.name,
      flavorName: flavorName ?? this.flavorName,
      lang: lang ?? this.lang,
      releasedAt: releasedAt ?? this.releasedAt,
      uri: uri ?? this.uri,
      scryfallUri: scryfallUri ?? this.scryfallUri,
      layout: layout ?? this.layout,
      manaCost: manaCost ?? this.manaCost,
      cmc: cmc ?? this.cmc,
      typeLine: typeLine ?? this.typeLine,
      oracleText: oracleText ?? this.oracleText,
      flavorText: flavorText ?? this.flavorText,
      power: power ?? this.power,
      toughness: toughness ?? this.toughness,
      colorsJson: colorsJson ?? this.colorsJson,
      colorIdentityJson: colorIdentityJson ?? this.colorIdentityJson,
      keywordsJson: keywordsJson ?? this.keywordsJson,
      colorsString: colorsString ?? this.colorsString,
      colorIdentityString: colorIdentityString ?? this.colorIdentityString,
      legalInAnyFormat: legalInAnyFormat ?? this.legalInAnyFormat,
      isCanonicalPrinting: isCanonicalPrinting ?? this.isCanonicalPrinting,
      setCode: setCode ?? this.setCode,
      setName: setName ?? this.setName,
      setType: setType ?? this.setType,
      collectorNumber: collectorNumber ?? this.collectorNumber,
      digital: digital ?? this.digital,
      rarity: rarity ?? this.rarity,
      rarityOrder: rarityOrder ?? this.rarityOrder,
      powerNumeric: powerNumeric ?? this.powerNumeric,
      toughnessNumeric: toughnessNumeric ?? this.toughnessNumeric,
      artist: artist ?? this.artist,
      borderColor: borderColor ?? this.borderColor,
      frame: frame ?? this.frame,
      fullArt: fullArt ?? this.fullArt,
      textless: textless ?? this.textless,
      booster: booster ?? this.booster,
      storySpotlight: storySpotlight ?? this.storySpotlight,
      imageStatus: imageStatus ?? this.imageStatus,
      imageSmall: imageSmall ?? this.imageSmall,
      imageNormal: imageNormal ?? this.imageNormal,
      imageLarge: imageLarge ?? this.imageLarge,
      imagePng: imagePng ?? this.imagePng,
      imageArtCrop: imageArtCrop ?? this.imageArtCrop,
      imageBorderCrop: imageBorderCrop ?? this.imageBorderCrop,
      legalStandard: legalStandard ?? this.legalStandard,
      legalFuture: legalFuture ?? this.legalFuture,
      legalHistoric: legalHistoric ?? this.legalHistoric,
      legalGladiator: legalGladiator ?? this.legalGladiator,
      legalPioneer: legalPioneer ?? this.legalPioneer,
      legalExplorer: legalExplorer ?? this.legalExplorer,
      legalModern: legalModern ?? this.legalModern,
      legalLegacy: legalLegacy ?? this.legalLegacy,
      legalPauper: legalPauper ?? this.legalPauper,
      legalVintage: legalVintage ?? this.legalVintage,
      legalPenny: legalPenny ?? this.legalPenny,
      legalCommander: legalCommander ?? this.legalCommander,
      legalOathbreaker: legalOathbreaker ?? this.legalOathbreaker,
      legalBrawl: legalBrawl ?? this.legalBrawl,
      legalHistoricbrawl: legalHistoricbrawl ?? this.legalHistoricbrawl,
      legalAlchemy: legalAlchemy ?? this.legalAlchemy,
      legalPaupercommander: legalPaupercommander ?? this.legalPaupercommander,
      legalDuel: legalDuel ?? this.legalDuel,
      legalOldschool: legalOldschool ?? this.legalOldschool,
      legalPremodern: legalPremodern ?? this.legalPremodern,
      legalPredh: legalPredh ?? this.legalPredh,
      priceUsd: priceUsd ?? this.priceUsd,
      priceUsdFoil: priceUsdFoil ?? this.priceUsdFoil,
      priceUsdEtched: priceUsdEtched ?? this.priceUsdEtched,
      priceEur: priceEur ?? this.priceEur,
      priceEurFoil: priceEurFoil ?? this.priceEurFoil,
      priceTix: priceTix ?? this.priceTix,
      priceNumeric: priceNumeric ?? this.priceNumeric,
      cardFacesJson: cardFacesJson ?? this.cardFacesJson,
      rulingsJson: rulingsJson ?? this.rulingsJson,
      object: object ?? this.object,
      oversized: oversized ?? this.oversized,
      promo: promo ?? this.promo,
      reprint: reprint ?? this.reprint,
      variation: variation ?? this.variation,
      gamesJson: gamesJson ?? this.gamesJson,
      reserved: reserved ?? this.reserved,
      foil: foil ?? this.foil,
      nonfoil: nonfoil ?? this.nonfoil,
      finishesJson: finishesJson ?? this.finishesJson,
      producedManaJson: producedManaJson ?? this.producedManaJson,
      edhrecRank: edhrecRank ?? this.edhrecRank,
      isGameChanger: isGameChanger ?? this.isGameChanger,
      relatedTokenIdsJson: relatedTokenIdsJson ?? this.relatedTokenIdsJson,
      mtgoId: mtgoId ?? this.mtgoId,
      arenaId: arenaId ?? this.arenaId,
      tcgplayerId: tcgplayerId ?? this.tcgplayerId,
      cardmarketId: cardmarketId ?? this.cardmarketId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scryfallId.present) {
      map['scryfall_id'] = Variable<String>(scryfallId.value);
    }
    if (mtgjsonUuid.present) {
      map['mtgjson_uuid'] = Variable<String>(mtgjsonUuid.value);
    }
    if (oracleId.present) {
      map['oracle_id'] = Variable<String>(oracleId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (flavorName.present) {
      map['flavor_name'] = Variable<String>(flavorName.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (releasedAt.present) {
      map['released_at'] = Variable<String>(releasedAt.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (scryfallUri.present) {
      map['scryfall_uri'] = Variable<String>(scryfallUri.value);
    }
    if (layout.present) {
      map['layout'] = Variable<String>(layout.value);
    }
    if (manaCost.present) {
      map['mana_cost'] = Variable<String>(manaCost.value);
    }
    if (cmc.present) {
      map['cmc'] = Variable<double>(cmc.value);
    }
    if (typeLine.present) {
      map['type_line'] = Variable<String>(typeLine.value);
    }
    if (oracleText.present) {
      map['oracle_text'] = Variable<String>(oracleText.value);
    }
    if (flavorText.present) {
      map['flavor_text'] = Variable<String>(flavorText.value);
    }
    if (power.present) {
      map['power'] = Variable<String>(power.value);
    }
    if (toughness.present) {
      map['toughness'] = Variable<String>(toughness.value);
    }
    if (colorsJson.present) {
      map['colors_json'] = Variable<String>(colorsJson.value);
    }
    if (colorIdentityJson.present) {
      map['color_identity_json'] = Variable<String>(colorIdentityJson.value);
    }
    if (keywordsJson.present) {
      map['keywords_json'] = Variable<String>(keywordsJson.value);
    }
    if (colorsString.present) {
      map['colors_string'] = Variable<String>(colorsString.value);
    }
    if (colorIdentityString.present) {
      map['color_identity_string'] =
          Variable<String>(colorIdentityString.value);
    }
    if (legalInAnyFormat.present) {
      map['legal_in_any_format'] = Variable<bool>(legalInAnyFormat.value);
    }
    if (isCanonicalPrinting.present) {
      map['is_canonical_printing'] = Variable<bool>(isCanonicalPrinting.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (setName.present) {
      map['set_name'] = Variable<String>(setName.value);
    }
    if (setType.present) {
      map['set_type'] = Variable<String>(setType.value);
    }
    if (collectorNumber.present) {
      map['collector_number'] = Variable<String>(collectorNumber.value);
    }
    if (digital.present) {
      map['digital'] = Variable<bool>(digital.value);
    }
    if (rarity.present) {
      map['rarity'] = Variable<String>(rarity.value);
    }
    if (rarityOrder.present) {
      map['rarity_order'] = Variable<int>(rarityOrder.value);
    }
    if (powerNumeric.present) {
      map['power_numeric'] = Variable<double>(powerNumeric.value);
    }
    if (toughnessNumeric.present) {
      map['toughness_numeric'] = Variable<double>(toughnessNumeric.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (borderColor.present) {
      map['border_color'] = Variable<String>(borderColor.value);
    }
    if (frame.present) {
      map['frame'] = Variable<String>(frame.value);
    }
    if (fullArt.present) {
      map['full_art'] = Variable<bool>(fullArt.value);
    }
    if (textless.present) {
      map['textless'] = Variable<bool>(textless.value);
    }
    if (booster.present) {
      map['booster'] = Variable<bool>(booster.value);
    }
    if (storySpotlight.present) {
      map['story_spotlight'] = Variable<bool>(storySpotlight.value);
    }
    if (imageStatus.present) {
      map['image_status'] = Variable<String>(imageStatus.value);
    }
    if (imageSmall.present) {
      map['image_small'] = Variable<String>(imageSmall.value);
    }
    if (imageNormal.present) {
      map['image_normal'] = Variable<String>(imageNormal.value);
    }
    if (imageLarge.present) {
      map['image_large'] = Variable<String>(imageLarge.value);
    }
    if (imagePng.present) {
      map['image_png'] = Variable<String>(imagePng.value);
    }
    if (imageArtCrop.present) {
      map['image_art_crop'] = Variable<String>(imageArtCrop.value);
    }
    if (imageBorderCrop.present) {
      map['image_border_crop'] = Variable<String>(imageBorderCrop.value);
    }
    if (legalStandard.present) {
      map['legal_standard'] = Variable<String>(legalStandard.value);
    }
    if (legalFuture.present) {
      map['legal_future'] = Variable<String>(legalFuture.value);
    }
    if (legalHistoric.present) {
      map['legal_historic'] = Variable<String>(legalHistoric.value);
    }
    if (legalGladiator.present) {
      map['legal_gladiator'] = Variable<String>(legalGladiator.value);
    }
    if (legalPioneer.present) {
      map['legal_pioneer'] = Variable<String>(legalPioneer.value);
    }
    if (legalExplorer.present) {
      map['legal_explorer'] = Variable<String>(legalExplorer.value);
    }
    if (legalModern.present) {
      map['legal_modern'] = Variable<String>(legalModern.value);
    }
    if (legalLegacy.present) {
      map['legal_legacy'] = Variable<String>(legalLegacy.value);
    }
    if (legalPauper.present) {
      map['legal_pauper'] = Variable<String>(legalPauper.value);
    }
    if (legalVintage.present) {
      map['legal_vintage'] = Variable<String>(legalVintage.value);
    }
    if (legalPenny.present) {
      map['legal_penny'] = Variable<String>(legalPenny.value);
    }
    if (legalCommander.present) {
      map['legal_commander'] = Variable<String>(legalCommander.value);
    }
    if (legalOathbreaker.present) {
      map['legal_oathbreaker'] = Variable<String>(legalOathbreaker.value);
    }
    if (legalBrawl.present) {
      map['legal_brawl'] = Variable<String>(legalBrawl.value);
    }
    if (legalHistoricbrawl.present) {
      map['legal_historicbrawl'] = Variable<String>(legalHistoricbrawl.value);
    }
    if (legalAlchemy.present) {
      map['legal_alchemy'] = Variable<String>(legalAlchemy.value);
    }
    if (legalPaupercommander.present) {
      map['legal_paupercommander'] =
          Variable<String>(legalPaupercommander.value);
    }
    if (legalDuel.present) {
      map['legal_duel'] = Variable<String>(legalDuel.value);
    }
    if (legalOldschool.present) {
      map['legal_oldschool'] = Variable<String>(legalOldschool.value);
    }
    if (legalPremodern.present) {
      map['legal_premodern'] = Variable<String>(legalPremodern.value);
    }
    if (legalPredh.present) {
      map['legal_predh'] = Variable<String>(legalPredh.value);
    }
    if (priceUsd.present) {
      map['price_usd'] = Variable<String>(priceUsd.value);
    }
    if (priceUsdFoil.present) {
      map['price_usd_foil'] = Variable<String>(priceUsdFoil.value);
    }
    if (priceUsdEtched.present) {
      map['price_usd_etched'] = Variable<String>(priceUsdEtched.value);
    }
    if (priceEur.present) {
      map['price_eur'] = Variable<String>(priceEur.value);
    }
    if (priceEurFoil.present) {
      map['price_eur_foil'] = Variable<String>(priceEurFoil.value);
    }
    if (priceTix.present) {
      map['price_tix'] = Variable<String>(priceTix.value);
    }
    if (priceNumeric.present) {
      map['price_numeric'] = Variable<double>(priceNumeric.value);
    }
    if (cardFacesJson.present) {
      map['card_faces_json'] = Variable<String>(cardFacesJson.value);
    }
    if (rulingsJson.present) {
      map['rulings_json'] = Variable<String>(rulingsJson.value);
    }
    if (object.present) {
      map['object'] = Variable<String>(object.value);
    }
    if (oversized.present) {
      map['oversized'] = Variable<bool>(oversized.value);
    }
    if (promo.present) {
      map['promo'] = Variable<bool>(promo.value);
    }
    if (reprint.present) {
      map['reprint'] = Variable<bool>(reprint.value);
    }
    if (variation.present) {
      map['variation'] = Variable<bool>(variation.value);
    }
    if (gamesJson.present) {
      map['games_json'] = Variable<String>(gamesJson.value);
    }
    if (reserved.present) {
      map['reserved'] = Variable<bool>(reserved.value);
    }
    if (foil.present) {
      map['foil'] = Variable<bool>(foil.value);
    }
    if (nonfoil.present) {
      map['nonfoil'] = Variable<bool>(nonfoil.value);
    }
    if (finishesJson.present) {
      map['finishes_json'] = Variable<String>(finishesJson.value);
    }
    if (producedManaJson.present) {
      map['produced_mana_json'] = Variable<String>(producedManaJson.value);
    }
    if (edhrecRank.present) {
      map['edhrec_rank'] = Variable<int>(edhrecRank.value);
    }
    if (isGameChanger.present) {
      map['is_game_changer'] = Variable<bool>(isGameChanger.value);
    }
    if (relatedTokenIdsJson.present) {
      map['related_token_ids_json'] =
          Variable<String>(relatedTokenIdsJson.value);
    }
    if (mtgoId.present) {
      map['mtgo_id'] = Variable<int>(mtgoId.value);
    }
    if (arenaId.present) {
      map['arena_id'] = Variable<int>(arenaId.value);
    }
    if (tcgplayerId.present) {
      map['tcgplayer_id'] = Variable<int>(tcgplayerId.value);
    }
    if (cardmarketId.present) {
      map['cardmarket_id'] = Variable<int>(cardmarketId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardsCompanion(')
          ..write('id: $id, ')
          ..write('scryfallId: $scryfallId, ')
          ..write('mtgjsonUuid: $mtgjsonUuid, ')
          ..write('oracleId: $oracleId, ')
          ..write('name: $name, ')
          ..write('flavorName: $flavorName, ')
          ..write('lang: $lang, ')
          ..write('releasedAt: $releasedAt, ')
          ..write('uri: $uri, ')
          ..write('scryfallUri: $scryfallUri, ')
          ..write('layout: $layout, ')
          ..write('manaCost: $manaCost, ')
          ..write('cmc: $cmc, ')
          ..write('typeLine: $typeLine, ')
          ..write('oracleText: $oracleText, ')
          ..write('flavorText: $flavorText, ')
          ..write('power: $power, ')
          ..write('toughness: $toughness, ')
          ..write('colorsJson: $colorsJson, ')
          ..write('colorIdentityJson: $colorIdentityJson, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('colorsString: $colorsString, ')
          ..write('colorIdentityString: $colorIdentityString, ')
          ..write('legalInAnyFormat: $legalInAnyFormat, ')
          ..write('isCanonicalPrinting: $isCanonicalPrinting, ')
          ..write('setCode: $setCode, ')
          ..write('setName: $setName, ')
          ..write('setType: $setType, ')
          ..write('collectorNumber: $collectorNumber, ')
          ..write('digital: $digital, ')
          ..write('rarity: $rarity, ')
          ..write('rarityOrder: $rarityOrder, ')
          ..write('powerNumeric: $powerNumeric, ')
          ..write('toughnessNumeric: $toughnessNumeric, ')
          ..write('artist: $artist, ')
          ..write('borderColor: $borderColor, ')
          ..write('frame: $frame, ')
          ..write('fullArt: $fullArt, ')
          ..write('textless: $textless, ')
          ..write('booster: $booster, ')
          ..write('storySpotlight: $storySpotlight, ')
          ..write('imageStatus: $imageStatus, ')
          ..write('imageSmall: $imageSmall, ')
          ..write('imageNormal: $imageNormal, ')
          ..write('imageLarge: $imageLarge, ')
          ..write('imagePng: $imagePng, ')
          ..write('imageArtCrop: $imageArtCrop, ')
          ..write('imageBorderCrop: $imageBorderCrop, ')
          ..write('legalStandard: $legalStandard, ')
          ..write('legalFuture: $legalFuture, ')
          ..write('legalHistoric: $legalHistoric, ')
          ..write('legalGladiator: $legalGladiator, ')
          ..write('legalPioneer: $legalPioneer, ')
          ..write('legalExplorer: $legalExplorer, ')
          ..write('legalModern: $legalModern, ')
          ..write('legalLegacy: $legalLegacy, ')
          ..write('legalPauper: $legalPauper, ')
          ..write('legalVintage: $legalVintage, ')
          ..write('legalPenny: $legalPenny, ')
          ..write('legalCommander: $legalCommander, ')
          ..write('legalOathbreaker: $legalOathbreaker, ')
          ..write('legalBrawl: $legalBrawl, ')
          ..write('legalHistoricbrawl: $legalHistoricbrawl, ')
          ..write('legalAlchemy: $legalAlchemy, ')
          ..write('legalPaupercommander: $legalPaupercommander, ')
          ..write('legalDuel: $legalDuel, ')
          ..write('legalOldschool: $legalOldschool, ')
          ..write('legalPremodern: $legalPremodern, ')
          ..write('legalPredh: $legalPredh, ')
          ..write('priceUsd: $priceUsd, ')
          ..write('priceUsdFoil: $priceUsdFoil, ')
          ..write('priceUsdEtched: $priceUsdEtched, ')
          ..write('priceEur: $priceEur, ')
          ..write('priceEurFoil: $priceEurFoil, ')
          ..write('priceTix: $priceTix, ')
          ..write('priceNumeric: $priceNumeric, ')
          ..write('cardFacesJson: $cardFacesJson, ')
          ..write('rulingsJson: $rulingsJson, ')
          ..write('object: $object, ')
          ..write('oversized: $oversized, ')
          ..write('promo: $promo, ')
          ..write('reprint: $reprint, ')
          ..write('variation: $variation, ')
          ..write('gamesJson: $gamesJson, ')
          ..write('reserved: $reserved, ')
          ..write('foil: $foil, ')
          ..write('nonfoil: $nonfoil, ')
          ..write('finishesJson: $finishesJson, ')
          ..write('producedManaJson: $producedManaJson, ')
          ..write('edhrecRank: $edhrecRank, ')
          ..write('isGameChanger: $isGameChanger, ')
          ..write('relatedTokenIdsJson: $relatedTokenIdsJson, ')
          ..write('mtgoId: $mtgoId, ')
          ..write('arenaId: $arenaId, ')
          ..write('tcgplayerId: $tcgplayerId, ')
          ..write('cardmarketId: $cardmarketId')
          ..write(')'))
        .toString();
  }
}

class $CardPricesTable extends CardPrices
    with TableInfo<$CardPricesTable, CardPriceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _scryfallIdMeta =
      const VerificationMeta('scryfallId');
  @override
  late final GeneratedColumn<String> scryfallId = GeneratedColumn<String>(
      'scryfall_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cardmarketEurMeta =
      const VerificationMeta('cardmarketEur');
  @override
  late final GeneratedColumn<double> cardmarketEur = GeneratedColumn<double>(
      'cardmarket_eur', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cardmarketEurFoilMeta =
      const VerificationMeta('cardmarketEurFoil');
  @override
  late final GeneratedColumn<double> cardmarketEurFoil =
      GeneratedColumn<double>('cardmarket_eur_foil', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tcgplayerUsdMeta =
      const VerificationMeta('tcgplayerUsd');
  @override
  late final GeneratedColumn<double> tcgplayerUsd = GeneratedColumn<double>(
      'tcgplayer_usd', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _tcgplayerUsdFoilMeta =
      const VerificationMeta('tcgplayerUsdFoil');
  @override
  late final GeneratedColumn<double> tcgplayerUsdFoil = GeneratedColumn<double>(
      'tcgplayer_usd_foil', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cardKingdomUsdMeta =
      const VerificationMeta('cardKingdomUsd');
  @override
  late final GeneratedColumn<double> cardKingdomUsd = GeneratedColumn<double>(
      'card_kingdom_usd', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cardKingdomUsdFoilMeta =
      const VerificationMeta('cardKingdomUsdFoil');
  @override
  late final GeneratedColumn<double> cardKingdomUsdFoil =
      GeneratedColumn<double>('card_kingdom_usd_foil', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cardKingdomBuylistUsdMeta =
      const VerificationMeta('cardKingdomBuylistUsd');
  @override
  late final GeneratedColumn<double> cardKingdomBuylistUsd =
      GeneratedColumn<double>('card_kingdom_buylist_usd', aliasedName, true,
          type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _fetchedDateMeta =
      const VerificationMeta('fetchedDate');
  @override
  late final GeneratedColumn<String> fetchedDate = GeneratedColumn<String>(
      'fetched_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        scryfallId,
        cardmarketEur,
        cardmarketEurFoil,
        tcgplayerUsd,
        tcgplayerUsdFoil,
        cardKingdomUsd,
        cardKingdomUsdFoil,
        cardKingdomBuylistUsd,
        fetchedDate
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_prices';
  @override
  VerificationContext validateIntegrity(Insertable<CardPriceRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('scryfall_id')) {
      context.handle(
          _scryfallIdMeta,
          scryfallId.isAcceptableOrUnknown(
              data['scryfall_id']!, _scryfallIdMeta));
    } else if (isInserting) {
      context.missing(_scryfallIdMeta);
    }
    if (data.containsKey('cardmarket_eur')) {
      context.handle(
          _cardmarketEurMeta,
          cardmarketEur.isAcceptableOrUnknown(
              data['cardmarket_eur']!, _cardmarketEurMeta));
    }
    if (data.containsKey('cardmarket_eur_foil')) {
      context.handle(
          _cardmarketEurFoilMeta,
          cardmarketEurFoil.isAcceptableOrUnknown(
              data['cardmarket_eur_foil']!, _cardmarketEurFoilMeta));
    }
    if (data.containsKey('tcgplayer_usd')) {
      context.handle(
          _tcgplayerUsdMeta,
          tcgplayerUsd.isAcceptableOrUnknown(
              data['tcgplayer_usd']!, _tcgplayerUsdMeta));
    }
    if (data.containsKey('tcgplayer_usd_foil')) {
      context.handle(
          _tcgplayerUsdFoilMeta,
          tcgplayerUsdFoil.isAcceptableOrUnknown(
              data['tcgplayer_usd_foil']!, _tcgplayerUsdFoilMeta));
    }
    if (data.containsKey('card_kingdom_usd')) {
      context.handle(
          _cardKingdomUsdMeta,
          cardKingdomUsd.isAcceptableOrUnknown(
              data['card_kingdom_usd']!, _cardKingdomUsdMeta));
    }
    if (data.containsKey('card_kingdom_usd_foil')) {
      context.handle(
          _cardKingdomUsdFoilMeta,
          cardKingdomUsdFoil.isAcceptableOrUnknown(
              data['card_kingdom_usd_foil']!, _cardKingdomUsdFoilMeta));
    }
    if (data.containsKey('card_kingdom_buylist_usd')) {
      context.handle(
          _cardKingdomBuylistUsdMeta,
          cardKingdomBuylistUsd.isAcceptableOrUnknown(
              data['card_kingdom_buylist_usd']!, _cardKingdomBuylistUsdMeta));
    }
    if (data.containsKey('fetched_date')) {
      context.handle(
          _fetchedDateMeta,
          fetchedDate.isAcceptableOrUnknown(
              data['fetched_date']!, _fetchedDateMeta));
    } else if (isInserting) {
      context.missing(_fetchedDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardPriceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardPriceRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      scryfallId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scryfall_id'])!,
      cardmarketEur: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cardmarket_eur']),
      cardmarketEurFoil: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}cardmarket_eur_foil']),
      tcgplayerUsd: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tcgplayer_usd']),
      tcgplayerUsdFoil: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}tcgplayer_usd_foil']),
      cardKingdomUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}card_kingdom_usd']),
      cardKingdomUsdFoil: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}card_kingdom_usd_foil']),
      cardKingdomBuylistUsd: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}card_kingdom_buylist_usd']),
      fetchedDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fetched_date'])!,
    );
  }

  @override
  $CardPricesTable createAlias(String alias) {
    return $CardPricesTable(attachedDatabase, alias);
  }
}

class CardPriceRow extends DataClass implements Insertable<CardPriceRow> {
  final int id;

  /// Bare Scryfall UUID (no language suffix). The bundle builder strips
  /// `_de` / `_fr` etc. before writing so lookups always hit.
  final String scryfallId;
  final double? cardmarketEur;
  final double? cardmarketEurFoil;
  final double? tcgplayerUsd;
  final double? tcgplayerUsdFoil;
  final double? cardKingdomUsd;
  final double? cardKingdomUsdFoil;
  final double? cardKingdomBuylistUsd;

  /// MTGJSON price feed date (e.g. `2026-04-30`). Useful for the UI to
  /// show "Prices as of …" without needing a separate manifest read.
  final String fetchedDate;
  const CardPriceRow(
      {required this.id,
      required this.scryfallId,
      this.cardmarketEur,
      this.cardmarketEurFoil,
      this.tcgplayerUsd,
      this.tcgplayerUsdFoil,
      this.cardKingdomUsd,
      this.cardKingdomUsdFoil,
      this.cardKingdomBuylistUsd,
      required this.fetchedDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['scryfall_id'] = Variable<String>(scryfallId);
    if (!nullToAbsent || cardmarketEur != null) {
      map['cardmarket_eur'] = Variable<double>(cardmarketEur);
    }
    if (!nullToAbsent || cardmarketEurFoil != null) {
      map['cardmarket_eur_foil'] = Variable<double>(cardmarketEurFoil);
    }
    if (!nullToAbsent || tcgplayerUsd != null) {
      map['tcgplayer_usd'] = Variable<double>(tcgplayerUsd);
    }
    if (!nullToAbsent || tcgplayerUsdFoil != null) {
      map['tcgplayer_usd_foil'] = Variable<double>(tcgplayerUsdFoil);
    }
    if (!nullToAbsent || cardKingdomUsd != null) {
      map['card_kingdom_usd'] = Variable<double>(cardKingdomUsd);
    }
    if (!nullToAbsent || cardKingdomUsdFoil != null) {
      map['card_kingdom_usd_foil'] = Variable<double>(cardKingdomUsdFoil);
    }
    if (!nullToAbsent || cardKingdomBuylistUsd != null) {
      map['card_kingdom_buylist_usd'] = Variable<double>(cardKingdomBuylistUsd);
    }
    map['fetched_date'] = Variable<String>(fetchedDate);
    return map;
  }

  CardPricesCompanion toCompanion(bool nullToAbsent) {
    return CardPricesCompanion(
      id: Value(id),
      scryfallId: Value(scryfallId),
      cardmarketEur: cardmarketEur == null && nullToAbsent
          ? const Value.absent()
          : Value(cardmarketEur),
      cardmarketEurFoil: cardmarketEurFoil == null && nullToAbsent
          ? const Value.absent()
          : Value(cardmarketEurFoil),
      tcgplayerUsd: tcgplayerUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(tcgplayerUsd),
      tcgplayerUsdFoil: tcgplayerUsdFoil == null && nullToAbsent
          ? const Value.absent()
          : Value(tcgplayerUsdFoil),
      cardKingdomUsd: cardKingdomUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(cardKingdomUsd),
      cardKingdomUsdFoil: cardKingdomUsdFoil == null && nullToAbsent
          ? const Value.absent()
          : Value(cardKingdomUsdFoil),
      cardKingdomBuylistUsd: cardKingdomBuylistUsd == null && nullToAbsent
          ? const Value.absent()
          : Value(cardKingdomBuylistUsd),
      fetchedDate: Value(fetchedDate),
    );
  }

  factory CardPriceRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardPriceRow(
      id: serializer.fromJson<int>(json['id']),
      scryfallId: serializer.fromJson<String>(json['scryfallId']),
      cardmarketEur: serializer.fromJson<double?>(json['cardmarketEur']),
      cardmarketEurFoil:
          serializer.fromJson<double?>(json['cardmarketEurFoil']),
      tcgplayerUsd: serializer.fromJson<double?>(json['tcgplayerUsd']),
      tcgplayerUsdFoil: serializer.fromJson<double?>(json['tcgplayerUsdFoil']),
      cardKingdomUsd: serializer.fromJson<double?>(json['cardKingdomUsd']),
      cardKingdomUsdFoil:
          serializer.fromJson<double?>(json['cardKingdomUsdFoil']),
      cardKingdomBuylistUsd:
          serializer.fromJson<double?>(json['cardKingdomBuylistUsd']),
      fetchedDate: serializer.fromJson<String>(json['fetchedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'scryfallId': serializer.toJson<String>(scryfallId),
      'cardmarketEur': serializer.toJson<double?>(cardmarketEur),
      'cardmarketEurFoil': serializer.toJson<double?>(cardmarketEurFoil),
      'tcgplayerUsd': serializer.toJson<double?>(tcgplayerUsd),
      'tcgplayerUsdFoil': serializer.toJson<double?>(tcgplayerUsdFoil),
      'cardKingdomUsd': serializer.toJson<double?>(cardKingdomUsd),
      'cardKingdomUsdFoil': serializer.toJson<double?>(cardKingdomUsdFoil),
      'cardKingdomBuylistUsd':
          serializer.toJson<double?>(cardKingdomBuylistUsd),
      'fetchedDate': serializer.toJson<String>(fetchedDate),
    };
  }

  CardPriceRow copyWith(
          {int? id,
          String? scryfallId,
          Value<double?> cardmarketEur = const Value.absent(),
          Value<double?> cardmarketEurFoil = const Value.absent(),
          Value<double?> tcgplayerUsd = const Value.absent(),
          Value<double?> tcgplayerUsdFoil = const Value.absent(),
          Value<double?> cardKingdomUsd = const Value.absent(),
          Value<double?> cardKingdomUsdFoil = const Value.absent(),
          Value<double?> cardKingdomBuylistUsd = const Value.absent(),
          String? fetchedDate}) =>
      CardPriceRow(
        id: id ?? this.id,
        scryfallId: scryfallId ?? this.scryfallId,
        cardmarketEur:
            cardmarketEur.present ? cardmarketEur.value : this.cardmarketEur,
        cardmarketEurFoil: cardmarketEurFoil.present
            ? cardmarketEurFoil.value
            : this.cardmarketEurFoil,
        tcgplayerUsd:
            tcgplayerUsd.present ? tcgplayerUsd.value : this.tcgplayerUsd,
        tcgplayerUsdFoil: tcgplayerUsdFoil.present
            ? tcgplayerUsdFoil.value
            : this.tcgplayerUsdFoil,
        cardKingdomUsd:
            cardKingdomUsd.present ? cardKingdomUsd.value : this.cardKingdomUsd,
        cardKingdomUsdFoil: cardKingdomUsdFoil.present
            ? cardKingdomUsdFoil.value
            : this.cardKingdomUsdFoil,
        cardKingdomBuylistUsd: cardKingdomBuylistUsd.present
            ? cardKingdomBuylistUsd.value
            : this.cardKingdomBuylistUsd,
        fetchedDate: fetchedDate ?? this.fetchedDate,
      );
  CardPriceRow copyWithCompanion(CardPricesCompanion data) {
    return CardPriceRow(
      id: data.id.present ? data.id.value : this.id,
      scryfallId:
          data.scryfallId.present ? data.scryfallId.value : this.scryfallId,
      cardmarketEur: data.cardmarketEur.present
          ? data.cardmarketEur.value
          : this.cardmarketEur,
      cardmarketEurFoil: data.cardmarketEurFoil.present
          ? data.cardmarketEurFoil.value
          : this.cardmarketEurFoil,
      tcgplayerUsd: data.tcgplayerUsd.present
          ? data.tcgplayerUsd.value
          : this.tcgplayerUsd,
      tcgplayerUsdFoil: data.tcgplayerUsdFoil.present
          ? data.tcgplayerUsdFoil.value
          : this.tcgplayerUsdFoil,
      cardKingdomUsd: data.cardKingdomUsd.present
          ? data.cardKingdomUsd.value
          : this.cardKingdomUsd,
      cardKingdomUsdFoil: data.cardKingdomUsdFoil.present
          ? data.cardKingdomUsdFoil.value
          : this.cardKingdomUsdFoil,
      cardKingdomBuylistUsd: data.cardKingdomBuylistUsd.present
          ? data.cardKingdomBuylistUsd.value
          : this.cardKingdomBuylistUsd,
      fetchedDate:
          data.fetchedDate.present ? data.fetchedDate.value : this.fetchedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardPriceRow(')
          ..write('id: $id, ')
          ..write('scryfallId: $scryfallId, ')
          ..write('cardmarketEur: $cardmarketEur, ')
          ..write('cardmarketEurFoil: $cardmarketEurFoil, ')
          ..write('tcgplayerUsd: $tcgplayerUsd, ')
          ..write('tcgplayerUsdFoil: $tcgplayerUsdFoil, ')
          ..write('cardKingdomUsd: $cardKingdomUsd, ')
          ..write('cardKingdomUsdFoil: $cardKingdomUsdFoil, ')
          ..write('cardKingdomBuylistUsd: $cardKingdomBuylistUsd, ')
          ..write('fetchedDate: $fetchedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      scryfallId,
      cardmarketEur,
      cardmarketEurFoil,
      tcgplayerUsd,
      tcgplayerUsdFoil,
      cardKingdomUsd,
      cardKingdomUsdFoil,
      cardKingdomBuylistUsd,
      fetchedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardPriceRow &&
          other.id == this.id &&
          other.scryfallId == this.scryfallId &&
          other.cardmarketEur == this.cardmarketEur &&
          other.cardmarketEurFoil == this.cardmarketEurFoil &&
          other.tcgplayerUsd == this.tcgplayerUsd &&
          other.tcgplayerUsdFoil == this.tcgplayerUsdFoil &&
          other.cardKingdomUsd == this.cardKingdomUsd &&
          other.cardKingdomUsdFoil == this.cardKingdomUsdFoil &&
          other.cardKingdomBuylistUsd == this.cardKingdomBuylistUsd &&
          other.fetchedDate == this.fetchedDate);
}

class CardPricesCompanion extends UpdateCompanion<CardPriceRow> {
  final Value<int> id;
  final Value<String> scryfallId;
  final Value<double?> cardmarketEur;
  final Value<double?> cardmarketEurFoil;
  final Value<double?> tcgplayerUsd;
  final Value<double?> tcgplayerUsdFoil;
  final Value<double?> cardKingdomUsd;
  final Value<double?> cardKingdomUsdFoil;
  final Value<double?> cardKingdomBuylistUsd;
  final Value<String> fetchedDate;
  const CardPricesCompanion({
    this.id = const Value.absent(),
    this.scryfallId = const Value.absent(),
    this.cardmarketEur = const Value.absent(),
    this.cardmarketEurFoil = const Value.absent(),
    this.tcgplayerUsd = const Value.absent(),
    this.tcgplayerUsdFoil = const Value.absent(),
    this.cardKingdomUsd = const Value.absent(),
    this.cardKingdomUsdFoil = const Value.absent(),
    this.cardKingdomBuylistUsd = const Value.absent(),
    this.fetchedDate = const Value.absent(),
  });
  CardPricesCompanion.insert({
    this.id = const Value.absent(),
    required String scryfallId,
    this.cardmarketEur = const Value.absent(),
    this.cardmarketEurFoil = const Value.absent(),
    this.tcgplayerUsd = const Value.absent(),
    this.tcgplayerUsdFoil = const Value.absent(),
    this.cardKingdomUsd = const Value.absent(),
    this.cardKingdomUsdFoil = const Value.absent(),
    this.cardKingdomBuylistUsd = const Value.absent(),
    required String fetchedDate,
  })  : scryfallId = Value(scryfallId),
        fetchedDate = Value(fetchedDate);
  static Insertable<CardPriceRow> custom({
    Expression<int>? id,
    Expression<String>? scryfallId,
    Expression<double>? cardmarketEur,
    Expression<double>? cardmarketEurFoil,
    Expression<double>? tcgplayerUsd,
    Expression<double>? tcgplayerUsdFoil,
    Expression<double>? cardKingdomUsd,
    Expression<double>? cardKingdomUsdFoil,
    Expression<double>? cardKingdomBuylistUsd,
    Expression<String>? fetchedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (scryfallId != null) 'scryfall_id': scryfallId,
      if (cardmarketEur != null) 'cardmarket_eur': cardmarketEur,
      if (cardmarketEurFoil != null) 'cardmarket_eur_foil': cardmarketEurFoil,
      if (tcgplayerUsd != null) 'tcgplayer_usd': tcgplayerUsd,
      if (tcgplayerUsdFoil != null) 'tcgplayer_usd_foil': tcgplayerUsdFoil,
      if (cardKingdomUsd != null) 'card_kingdom_usd': cardKingdomUsd,
      if (cardKingdomUsdFoil != null)
        'card_kingdom_usd_foil': cardKingdomUsdFoil,
      if (cardKingdomBuylistUsd != null)
        'card_kingdom_buylist_usd': cardKingdomBuylistUsd,
      if (fetchedDate != null) 'fetched_date': fetchedDate,
    });
  }

  CardPricesCompanion copyWith(
      {Value<int>? id,
      Value<String>? scryfallId,
      Value<double?>? cardmarketEur,
      Value<double?>? cardmarketEurFoil,
      Value<double?>? tcgplayerUsd,
      Value<double?>? tcgplayerUsdFoil,
      Value<double?>? cardKingdomUsd,
      Value<double?>? cardKingdomUsdFoil,
      Value<double?>? cardKingdomBuylistUsd,
      Value<String>? fetchedDate}) {
    return CardPricesCompanion(
      id: id ?? this.id,
      scryfallId: scryfallId ?? this.scryfallId,
      cardmarketEur: cardmarketEur ?? this.cardmarketEur,
      cardmarketEurFoil: cardmarketEurFoil ?? this.cardmarketEurFoil,
      tcgplayerUsd: tcgplayerUsd ?? this.tcgplayerUsd,
      tcgplayerUsdFoil: tcgplayerUsdFoil ?? this.tcgplayerUsdFoil,
      cardKingdomUsd: cardKingdomUsd ?? this.cardKingdomUsd,
      cardKingdomUsdFoil: cardKingdomUsdFoil ?? this.cardKingdomUsdFoil,
      cardKingdomBuylistUsd:
          cardKingdomBuylistUsd ?? this.cardKingdomBuylistUsd,
      fetchedDate: fetchedDate ?? this.fetchedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (scryfallId.present) {
      map['scryfall_id'] = Variable<String>(scryfallId.value);
    }
    if (cardmarketEur.present) {
      map['cardmarket_eur'] = Variable<double>(cardmarketEur.value);
    }
    if (cardmarketEurFoil.present) {
      map['cardmarket_eur_foil'] = Variable<double>(cardmarketEurFoil.value);
    }
    if (tcgplayerUsd.present) {
      map['tcgplayer_usd'] = Variable<double>(tcgplayerUsd.value);
    }
    if (tcgplayerUsdFoil.present) {
      map['tcgplayer_usd_foil'] = Variable<double>(tcgplayerUsdFoil.value);
    }
    if (cardKingdomUsd.present) {
      map['card_kingdom_usd'] = Variable<double>(cardKingdomUsd.value);
    }
    if (cardKingdomUsdFoil.present) {
      map['card_kingdom_usd_foil'] = Variable<double>(cardKingdomUsdFoil.value);
    }
    if (cardKingdomBuylistUsd.present) {
      map['card_kingdom_buylist_usd'] =
          Variable<double>(cardKingdomBuylistUsd.value);
    }
    if (fetchedDate.present) {
      map['fetched_date'] = Variable<String>(fetchedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardPricesCompanion(')
          ..write('id: $id, ')
          ..write('scryfallId: $scryfallId, ')
          ..write('cardmarketEur: $cardmarketEur, ')
          ..write('cardmarketEurFoil: $cardmarketEurFoil, ')
          ..write('tcgplayerUsd: $tcgplayerUsd, ')
          ..write('tcgplayerUsdFoil: $tcgplayerUsdFoil, ')
          ..write('cardKingdomUsd: $cardKingdomUsd, ')
          ..write('cardKingdomUsdFoil: $cardKingdomUsdFoil, ')
          ..write('cardKingdomBuylistUsd: $cardKingdomBuylistUsd, ')
          ..write('fetchedDate: $fetchedDate')
          ..write(')'))
        .toString();
  }
}

class $FilterMetadataTable extends FilterMetadata
    with TableInfo<$FilterMetadataTable, FilterMetadataRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FilterMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setsJsonMeta =
      const VerificationMeta('setsJson');
  @override
  late final GeneratedColumn<String> setsJson = GeneratedColumn<String>(
      'sets_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _setsMapJsonMeta =
      const VerificationMeta('setsMapJson');
  @override
  late final GeneratedColumn<String> setsMapJson = GeneratedColumn<String>(
      'sets_map_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('{}'));
  static const VerificationMeta _raritiesJsonMeta =
      const VerificationMeta('raritiesJson');
  @override
  late final GeneratedColumn<String> raritiesJson = GeneratedColumn<String>(
      'rarities_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _keywordsJsonMeta =
      const VerificationMeta('keywordsJson');
  @override
  late final GeneratedColumn<String> keywordsJson = GeneratedColumn<String>(
      'keywords_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _setMetadataJsonMeta =
      const VerificationMeta('setMetadataJson');
  @override
  late final GeneratedColumn<String> setMetadataJson = GeneratedColumn<String>(
      'set_metadata_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        key,
        setsJson,
        setsMapJson,
        raritiesJson,
        keywordsJson,
        setMetadataJson,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'filter_metadata';
  @override
  VerificationContext validateIntegrity(Insertable<FilterMetadataRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('sets_json')) {
      context.handle(_setsJsonMeta,
          setsJson.isAcceptableOrUnknown(data['sets_json']!, _setsJsonMeta));
    }
    if (data.containsKey('sets_map_json')) {
      context.handle(
          _setsMapJsonMeta,
          setsMapJson.isAcceptableOrUnknown(
              data['sets_map_json']!, _setsMapJsonMeta));
    }
    if (data.containsKey('rarities_json')) {
      context.handle(
          _raritiesJsonMeta,
          raritiesJson.isAcceptableOrUnknown(
              data['rarities_json']!, _raritiesJsonMeta));
    }
    if (data.containsKey('keywords_json')) {
      context.handle(
          _keywordsJsonMeta,
          keywordsJson.isAcceptableOrUnknown(
              data['keywords_json']!, _keywordsJsonMeta));
    }
    if (data.containsKey('set_metadata_json')) {
      context.handle(
          _setMetadataJsonMeta,
          setMetadataJson.isAcceptableOrUnknown(
              data['set_metadata_json']!, _setMetadataJsonMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FilterMetadataRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FilterMetadataRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      setsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sets_json'])!,
      setsMapJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sets_map_json'])!,
      raritiesJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}rarities_json'])!,
      keywordsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}keywords_json'])!,
      setMetadataJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}set_metadata_json'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FilterMetadataTable createAlias(String alias) {
    return $FilterMetadataTable(attachedDatabase, alias);
  }
}

class FilterMetadataRow extends DataClass
    implements Insertable<FilterMetadataRow> {
  final int id;
  final String key;
  final String setsJson;
  final String setsMapJson;
  final String raritiesJson;
  final String keywordsJson;
  final String setMetadataJson;
  final DateTime updatedAt;
  const FilterMetadataRow(
      {required this.id,
      required this.key,
      required this.setsJson,
      required this.setsMapJson,
      required this.raritiesJson,
      required this.keywordsJson,
      required this.setMetadataJson,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['sets_json'] = Variable<String>(setsJson);
    map['sets_map_json'] = Variable<String>(setsMapJson);
    map['rarities_json'] = Variable<String>(raritiesJson);
    map['keywords_json'] = Variable<String>(keywordsJson);
    map['set_metadata_json'] = Variable<String>(setMetadataJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FilterMetadataCompanion toCompanion(bool nullToAbsent) {
    return FilterMetadataCompanion(
      id: Value(id),
      key: Value(key),
      setsJson: Value(setsJson),
      setsMapJson: Value(setsMapJson),
      raritiesJson: Value(raritiesJson),
      keywordsJson: Value(keywordsJson),
      setMetadataJson: Value(setMetadataJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory FilterMetadataRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FilterMetadataRow(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      setsJson: serializer.fromJson<String>(json['setsJson']),
      setsMapJson: serializer.fromJson<String>(json['setsMapJson']),
      raritiesJson: serializer.fromJson<String>(json['raritiesJson']),
      keywordsJson: serializer.fromJson<String>(json['keywordsJson']),
      setMetadataJson: serializer.fromJson<String>(json['setMetadataJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'setsJson': serializer.toJson<String>(setsJson),
      'setsMapJson': serializer.toJson<String>(setsMapJson),
      'raritiesJson': serializer.toJson<String>(raritiesJson),
      'keywordsJson': serializer.toJson<String>(keywordsJson),
      'setMetadataJson': serializer.toJson<String>(setMetadataJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FilterMetadataRow copyWith(
          {int? id,
          String? key,
          String? setsJson,
          String? setsMapJson,
          String? raritiesJson,
          String? keywordsJson,
          String? setMetadataJson,
          DateTime? updatedAt}) =>
      FilterMetadataRow(
        id: id ?? this.id,
        key: key ?? this.key,
        setsJson: setsJson ?? this.setsJson,
        setsMapJson: setsMapJson ?? this.setsMapJson,
        raritiesJson: raritiesJson ?? this.raritiesJson,
        keywordsJson: keywordsJson ?? this.keywordsJson,
        setMetadataJson: setMetadataJson ?? this.setMetadataJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FilterMetadataRow copyWithCompanion(FilterMetadataCompanion data) {
    return FilterMetadataRow(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      setsJson: data.setsJson.present ? data.setsJson.value : this.setsJson,
      setsMapJson:
          data.setsMapJson.present ? data.setsMapJson.value : this.setsMapJson,
      raritiesJson: data.raritiesJson.present
          ? data.raritiesJson.value
          : this.raritiesJson,
      keywordsJson: data.keywordsJson.present
          ? data.keywordsJson.value
          : this.keywordsJson,
      setMetadataJson: data.setMetadataJson.present
          ? data.setMetadataJson.value
          : this.setMetadataJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FilterMetadataRow(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('setsJson: $setsJson, ')
          ..write('setsMapJson: $setsMapJson, ')
          ..write('raritiesJson: $raritiesJson, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('setMetadataJson: $setMetadataJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, setsJson, setsMapJson, raritiesJson,
      keywordsJson, setMetadataJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FilterMetadataRow &&
          other.id == this.id &&
          other.key == this.key &&
          other.setsJson == this.setsJson &&
          other.setsMapJson == this.setsMapJson &&
          other.raritiesJson == this.raritiesJson &&
          other.keywordsJson == this.keywordsJson &&
          other.setMetadataJson == this.setMetadataJson &&
          other.updatedAt == this.updatedAt);
}

class FilterMetadataCompanion extends UpdateCompanion<FilterMetadataRow> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> setsJson;
  final Value<String> setsMapJson;
  final Value<String> raritiesJson;
  final Value<String> keywordsJson;
  final Value<String> setMetadataJson;
  final Value<DateTime> updatedAt;
  const FilterMetadataCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.setsJson = const Value.absent(),
    this.setsMapJson = const Value.absent(),
    this.raritiesJson = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.setMetadataJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FilterMetadataCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    this.setsJson = const Value.absent(),
    this.setsMapJson = const Value.absent(),
    this.raritiesJson = const Value.absent(),
    this.keywordsJson = const Value.absent(),
    this.setMetadataJson = const Value.absent(),
    required DateTime updatedAt,
  })  : key = Value(key),
        updatedAt = Value(updatedAt);
  static Insertable<FilterMetadataRow> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? setsJson,
    Expression<String>? setsMapJson,
    Expression<String>? raritiesJson,
    Expression<String>? keywordsJson,
    Expression<String>? setMetadataJson,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (setsJson != null) 'sets_json': setsJson,
      if (setsMapJson != null) 'sets_map_json': setsMapJson,
      if (raritiesJson != null) 'rarities_json': raritiesJson,
      if (keywordsJson != null) 'keywords_json': keywordsJson,
      if (setMetadataJson != null) 'set_metadata_json': setMetadataJson,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FilterMetadataCompanion copyWith(
      {Value<int>? id,
      Value<String>? key,
      Value<String>? setsJson,
      Value<String>? setsMapJson,
      Value<String>? raritiesJson,
      Value<String>? keywordsJson,
      Value<String>? setMetadataJson,
      Value<DateTime>? updatedAt}) {
    return FilterMetadataCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      setsJson: setsJson ?? this.setsJson,
      setsMapJson: setsMapJson ?? this.setsMapJson,
      raritiesJson: raritiesJson ?? this.raritiesJson,
      keywordsJson: keywordsJson ?? this.keywordsJson,
      setMetadataJson: setMetadataJson ?? this.setMetadataJson,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (setsJson.present) {
      map['sets_json'] = Variable<String>(setsJson.value);
    }
    if (setsMapJson.present) {
      map['sets_map_json'] = Variable<String>(setsMapJson.value);
    }
    if (raritiesJson.present) {
      map['rarities_json'] = Variable<String>(raritiesJson.value);
    }
    if (keywordsJson.present) {
      map['keywords_json'] = Variable<String>(keywordsJson.value);
    }
    if (setMetadataJson.present) {
      map['set_metadata_json'] = Variable<String>(setMetadataJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FilterMetadataCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('setsJson: $setsJson, ')
          ..write('setsMapJson: $setsMapJson, ')
          ..write('raritiesJson: $raritiesJson, ')
          ..write('keywordsJson: $keywordsJson, ')
          ..write('setMetadataJson: $setMetadataJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PreconDecksTable extends PreconDecks
    with TableInfo<$PreconDecksTable, PreconDeckRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreconDecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setCodeMeta =
      const VerificationMeta('setCode');
  @override
  late final GeneratedColumn<String> setCode = GeneratedColumn<String>(
      'set_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setNameMeta =
      const VerificationMeta('setName');
  @override
  late final GeneratedColumn<String> setName = GeneratedColumn<String>(
      'set_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  @override
  late final GeneratedColumn<String> releaseDate = GeneratedColumn<String>(
      'release_date', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _mainBoardJsonMeta =
      const VerificationMeta('mainBoardJson');
  @override
  late final GeneratedColumn<String> mainBoardJson = GeneratedColumn<String>(
      'main_board_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _sideBoardJsonMeta =
      const VerificationMeta('sideBoardJson');
  @override
  late final GeneratedColumn<String> sideBoardJson = GeneratedColumn<String>(
      'side_board_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _commandersJsonMeta =
      const VerificationMeta('commandersJson');
  @override
  late final GeneratedColumn<String> commandersJson = GeneratedColumn<String>(
      'commanders_json', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _featuredCardScryfallIdMeta =
      const VerificationMeta('featuredCardScryfallId');
  @override
  late final GeneratedColumn<String> featuredCardScryfallId =
      GeneratedColumn<String>('featured_card_scryfall_id', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorIdentityStringMeta =
      const VerificationMeta('colorIdentityString');
  @override
  late final GeneratedColumn<String> colorIdentityString =
      GeneratedColumn<String>('color_identity_string', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        setCode,
        setName,
        type,
        releaseDate,
        mainBoardJson,
        sideBoardJson,
        commandersJson,
        featuredCardScryfallId,
        colorIdentityString
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'precon_decks';
  @override
  VerificationContext validateIntegrity(Insertable<PreconDeckRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('set_code')) {
      context.handle(_setCodeMeta,
          setCode.isAcceptableOrUnknown(data['set_code']!, _setCodeMeta));
    } else if (isInserting) {
      context.missing(_setCodeMeta);
    }
    if (data.containsKey('set_name')) {
      context.handle(_setNameMeta,
          setName.isAcceptableOrUnknown(data['set_name']!, _setNameMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('main_board_json')) {
      context.handle(
          _mainBoardJsonMeta,
          mainBoardJson.isAcceptableOrUnknown(
              data['main_board_json']!, _mainBoardJsonMeta));
    }
    if (data.containsKey('side_board_json')) {
      context.handle(
          _sideBoardJsonMeta,
          sideBoardJson.isAcceptableOrUnknown(
              data['side_board_json']!, _sideBoardJsonMeta));
    }
    if (data.containsKey('commanders_json')) {
      context.handle(
          _commandersJsonMeta,
          commandersJson.isAcceptableOrUnknown(
              data['commanders_json']!, _commandersJsonMeta));
    }
    if (data.containsKey('featured_card_scryfall_id')) {
      context.handle(
          _featuredCardScryfallIdMeta,
          featuredCardScryfallId.isAcceptableOrUnknown(
              data['featured_card_scryfall_id']!, _featuredCardScryfallIdMeta));
    }
    if (data.containsKey('color_identity_string')) {
      context.handle(
          _colorIdentityStringMeta,
          colorIdentityString.isAcceptableOrUnknown(
              data['color_identity_string']!, _colorIdentityStringMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PreconDeckRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PreconDeckRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      setCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_code'])!,
      setName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}set_name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}release_date'])!,
      mainBoardJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}main_board_json'])!,
      sideBoardJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}side_board_json'])!,
      commandersJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}commanders_json'])!,
      featuredCardScryfallId: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}featured_card_scryfall_id']),
      colorIdentityString: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}color_identity_string'])!,
    );
  }

  @override
  $PreconDecksTable createAlias(String alias) {
    return $PreconDecksTable(attachedDatabase, alias);
  }
}

class PreconDeckRow extends DataClass implements Insertable<PreconDeckRow> {
  final int id;
  final String name;
  final String setCode;
  final String setName;
  final String type;
  final String releaseDate;
  final String mainBoardJson;
  final String sideBoardJson;
  final String commandersJson;
  final String? featuredCardScryfallId;

  /// Precomputed sorted-WUBRG color identity (e.g. "WU", "BGR"). Built
  /// by the bundle pipeline by unioning the colorIdentity of each
  /// commander; for non-commander decks sampled from the main board.
  ///
  /// The browser screen reads this directly to color the deck-box tile
  /// — without it, the client used to scan the cards table per deck
  /// at load (~200 SQL lookups + JSON-decoding every main board) which
  /// blocked the UI for several seconds on a fresh install.
  final String colorIdentityString;
  const PreconDeckRow(
      {required this.id,
      required this.name,
      required this.setCode,
      required this.setName,
      required this.type,
      required this.releaseDate,
      required this.mainBoardJson,
      required this.sideBoardJson,
      required this.commandersJson,
      this.featuredCardScryfallId,
      required this.colorIdentityString});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['set_code'] = Variable<String>(setCode);
    map['set_name'] = Variable<String>(setName);
    map['type'] = Variable<String>(type);
    map['release_date'] = Variable<String>(releaseDate);
    map['main_board_json'] = Variable<String>(mainBoardJson);
    map['side_board_json'] = Variable<String>(sideBoardJson);
    map['commanders_json'] = Variable<String>(commandersJson);
    if (!nullToAbsent || featuredCardScryfallId != null) {
      map['featured_card_scryfall_id'] =
          Variable<String>(featuredCardScryfallId);
    }
    map['color_identity_string'] = Variable<String>(colorIdentityString);
    return map;
  }

  PreconDecksCompanion toCompanion(bool nullToAbsent) {
    return PreconDecksCompanion(
      id: Value(id),
      name: Value(name),
      setCode: Value(setCode),
      setName: Value(setName),
      type: Value(type),
      releaseDate: Value(releaseDate),
      mainBoardJson: Value(mainBoardJson),
      sideBoardJson: Value(sideBoardJson),
      commandersJson: Value(commandersJson),
      featuredCardScryfallId: featuredCardScryfallId == null && nullToAbsent
          ? const Value.absent()
          : Value(featuredCardScryfallId),
      colorIdentityString: Value(colorIdentityString),
    );
  }

  factory PreconDeckRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PreconDeckRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      setCode: serializer.fromJson<String>(json['setCode']),
      setName: serializer.fromJson<String>(json['setName']),
      type: serializer.fromJson<String>(json['type']),
      releaseDate: serializer.fromJson<String>(json['releaseDate']),
      mainBoardJson: serializer.fromJson<String>(json['mainBoardJson']),
      sideBoardJson: serializer.fromJson<String>(json['sideBoardJson']),
      commandersJson: serializer.fromJson<String>(json['commandersJson']),
      featuredCardScryfallId:
          serializer.fromJson<String?>(json['featuredCardScryfallId']),
      colorIdentityString:
          serializer.fromJson<String>(json['colorIdentityString']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'setCode': serializer.toJson<String>(setCode),
      'setName': serializer.toJson<String>(setName),
      'type': serializer.toJson<String>(type),
      'releaseDate': serializer.toJson<String>(releaseDate),
      'mainBoardJson': serializer.toJson<String>(mainBoardJson),
      'sideBoardJson': serializer.toJson<String>(sideBoardJson),
      'commandersJson': serializer.toJson<String>(commandersJson),
      'featuredCardScryfallId':
          serializer.toJson<String?>(featuredCardScryfallId),
      'colorIdentityString': serializer.toJson<String>(colorIdentityString),
    };
  }

  PreconDeckRow copyWith(
          {int? id,
          String? name,
          String? setCode,
          String? setName,
          String? type,
          String? releaseDate,
          String? mainBoardJson,
          String? sideBoardJson,
          String? commandersJson,
          Value<String?> featuredCardScryfallId = const Value.absent(),
          String? colorIdentityString}) =>
      PreconDeckRow(
        id: id ?? this.id,
        name: name ?? this.name,
        setCode: setCode ?? this.setCode,
        setName: setName ?? this.setName,
        type: type ?? this.type,
        releaseDate: releaseDate ?? this.releaseDate,
        mainBoardJson: mainBoardJson ?? this.mainBoardJson,
        sideBoardJson: sideBoardJson ?? this.sideBoardJson,
        commandersJson: commandersJson ?? this.commandersJson,
        featuredCardScryfallId: featuredCardScryfallId.present
            ? featuredCardScryfallId.value
            : this.featuredCardScryfallId,
        colorIdentityString: colorIdentityString ?? this.colorIdentityString,
      );
  PreconDeckRow copyWithCompanion(PreconDecksCompanion data) {
    return PreconDeckRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      setCode: data.setCode.present ? data.setCode.value : this.setCode,
      setName: data.setName.present ? data.setName.value : this.setName,
      type: data.type.present ? data.type.value : this.type,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      mainBoardJson: data.mainBoardJson.present
          ? data.mainBoardJson.value
          : this.mainBoardJson,
      sideBoardJson: data.sideBoardJson.present
          ? data.sideBoardJson.value
          : this.sideBoardJson,
      commandersJson: data.commandersJson.present
          ? data.commandersJson.value
          : this.commandersJson,
      featuredCardScryfallId: data.featuredCardScryfallId.present
          ? data.featuredCardScryfallId.value
          : this.featuredCardScryfallId,
      colorIdentityString: data.colorIdentityString.present
          ? data.colorIdentityString.value
          : this.colorIdentityString,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PreconDeckRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('setCode: $setCode, ')
          ..write('setName: $setName, ')
          ..write('type: $type, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('mainBoardJson: $mainBoardJson, ')
          ..write('sideBoardJson: $sideBoardJson, ')
          ..write('commandersJson: $commandersJson, ')
          ..write('featuredCardScryfallId: $featuredCardScryfallId, ')
          ..write('colorIdentityString: $colorIdentityString')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      setCode,
      setName,
      type,
      releaseDate,
      mainBoardJson,
      sideBoardJson,
      commandersJson,
      featuredCardScryfallId,
      colorIdentityString);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PreconDeckRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.setCode == this.setCode &&
          other.setName == this.setName &&
          other.type == this.type &&
          other.releaseDate == this.releaseDate &&
          other.mainBoardJson == this.mainBoardJson &&
          other.sideBoardJson == this.sideBoardJson &&
          other.commandersJson == this.commandersJson &&
          other.featuredCardScryfallId == this.featuredCardScryfallId &&
          other.colorIdentityString == this.colorIdentityString);
}

class PreconDecksCompanion extends UpdateCompanion<PreconDeckRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> setCode;
  final Value<String> setName;
  final Value<String> type;
  final Value<String> releaseDate;
  final Value<String> mainBoardJson;
  final Value<String> sideBoardJson;
  final Value<String> commandersJson;
  final Value<String?> featuredCardScryfallId;
  final Value<String> colorIdentityString;
  const PreconDecksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.setCode = const Value.absent(),
    this.setName = const Value.absent(),
    this.type = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.mainBoardJson = const Value.absent(),
    this.sideBoardJson = const Value.absent(),
    this.commandersJson = const Value.absent(),
    this.featuredCardScryfallId = const Value.absent(),
    this.colorIdentityString = const Value.absent(),
  });
  PreconDecksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String setCode,
    this.setName = const Value.absent(),
    required String type,
    this.releaseDate = const Value.absent(),
    this.mainBoardJson = const Value.absent(),
    this.sideBoardJson = const Value.absent(),
    this.commandersJson = const Value.absent(),
    this.featuredCardScryfallId = const Value.absent(),
    this.colorIdentityString = const Value.absent(),
  })  : name = Value(name),
        setCode = Value(setCode),
        type = Value(type);
  static Insertable<PreconDeckRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? setCode,
    Expression<String>? setName,
    Expression<String>? type,
    Expression<String>? releaseDate,
    Expression<String>? mainBoardJson,
    Expression<String>? sideBoardJson,
    Expression<String>? commandersJson,
    Expression<String>? featuredCardScryfallId,
    Expression<String>? colorIdentityString,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (setCode != null) 'set_code': setCode,
      if (setName != null) 'set_name': setName,
      if (type != null) 'type': type,
      if (releaseDate != null) 'release_date': releaseDate,
      if (mainBoardJson != null) 'main_board_json': mainBoardJson,
      if (sideBoardJson != null) 'side_board_json': sideBoardJson,
      if (commandersJson != null) 'commanders_json': commandersJson,
      if (featuredCardScryfallId != null)
        'featured_card_scryfall_id': featuredCardScryfallId,
      if (colorIdentityString != null)
        'color_identity_string': colorIdentityString,
    });
  }

  PreconDecksCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? setCode,
      Value<String>? setName,
      Value<String>? type,
      Value<String>? releaseDate,
      Value<String>? mainBoardJson,
      Value<String>? sideBoardJson,
      Value<String>? commandersJson,
      Value<String?>? featuredCardScryfallId,
      Value<String>? colorIdentityString}) {
    return PreconDecksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      setCode: setCode ?? this.setCode,
      setName: setName ?? this.setName,
      type: type ?? this.type,
      releaseDate: releaseDate ?? this.releaseDate,
      mainBoardJson: mainBoardJson ?? this.mainBoardJson,
      sideBoardJson: sideBoardJson ?? this.sideBoardJson,
      commandersJson: commandersJson ?? this.commandersJson,
      featuredCardScryfallId:
          featuredCardScryfallId ?? this.featuredCardScryfallId,
      colorIdentityString: colorIdentityString ?? this.colorIdentityString,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (setCode.present) {
      map['set_code'] = Variable<String>(setCode.value);
    }
    if (setName.present) {
      map['set_name'] = Variable<String>(setName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<String>(releaseDate.value);
    }
    if (mainBoardJson.present) {
      map['main_board_json'] = Variable<String>(mainBoardJson.value);
    }
    if (sideBoardJson.present) {
      map['side_board_json'] = Variable<String>(sideBoardJson.value);
    }
    if (commandersJson.present) {
      map['commanders_json'] = Variable<String>(commandersJson.value);
    }
    if (featuredCardScryfallId.present) {
      map['featured_card_scryfall_id'] =
          Variable<String>(featuredCardScryfallId.value);
    }
    if (colorIdentityString.present) {
      map['color_identity_string'] =
          Variable<String>(colorIdentityString.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreconDecksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('setCode: $setCode, ')
          ..write('setName: $setName, ')
          ..write('type: $type, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('mainBoardJson: $mainBoardJson, ')
          ..write('sideBoardJson: $sideBoardJson, ')
          ..write('commandersJson: $commandersJson, ')
          ..write('featuredCardScryfallId: $featuredCardScryfallId, ')
          ..write('colorIdentityString: $colorIdentityString')
          ..write(')'))
        .toString();
  }
}

abstract class _$CardsDatabase extends GeneratedDatabase {
  _$CardsDatabase(QueryExecutor e) : super(e);
  $CardsDatabaseManager get managers => $CardsDatabaseManager(this);
  late final $CardsTable cards = $CardsTable(this);
  late final $CardPricesTable cardPrices = $CardPricesTable(this);
  late final $FilterMetadataTable filterMetadata = $FilterMetadataTable(this);
  late final $PreconDecksTable preconDecks = $PreconDecksTable(this);
  late final Index idxCardScryfallId = Index('idx_card_scryfall_id',
      'CREATE UNIQUE INDEX idx_card_scryfall_id ON cards (scryfall_id)');
  late final Index idxCardMtgjsonUuid = Index('idx_card_mtgjson_uuid',
      'CREATE INDEX idx_card_mtgjson_uuid ON cards (mtgjson_uuid)');
  late final Index idxCardOracleId = Index('idx_card_oracle_id',
      'CREATE INDEX idx_card_oracle_id ON cards (oracle_id)');
  late final Index idxCardName =
      Index('idx_card_name', 'CREATE INDEX idx_card_name ON cards (name)');
  late final Index idxCardFlavorName = Index('idx_card_flavor_name',
      'CREATE INDEX idx_card_flavor_name ON cards (flavor_name)');
  late final Index idxCardLang =
      Index('idx_card_lang', 'CREATE INDEX idx_card_lang ON cards (lang)');
  late final Index idxCardTypeLine = Index('idx_card_type_line',
      'CREATE INDEX idx_card_type_line ON cards (type_line)');
  late final Index idxCardColorsString = Index('idx_card_colors_string',
      'CREATE INDEX idx_card_colors_string ON cards (colors_string)');
  late final Index idxCardColorIdentityString = Index(
      'idx_card_color_identity_string',
      'CREATE INDEX idx_card_color_identity_string ON cards (color_identity_string)');
  late final Index idxCardLegalInAnyFormat = Index(
      'idx_card_legal_in_any_format',
      'CREATE INDEX idx_card_legal_in_any_format ON cards (legal_in_any_format)');
  late final Index idxCardIsCanonicalPrinting = Index(
      'idx_card_is_canonical_printing',
      'CREATE INDEX idx_card_is_canonical_printing ON cards (is_canonical_printing)');
  late final Index idxCardSetCode = Index('idx_card_set_code',
      'CREATE INDEX idx_card_set_code ON cards (set_code)');
  late final Index idxCardRarity = Index(
      'idx_card_rarity', 'CREATE INDEX idx_card_rarity ON cards (rarity)');
  late final Index idxCardPriceNumeric = Index('idx_card_price_numeric',
      'CREATE INDEX idx_card_price_numeric ON cards (price_numeric)');
  late final Index idxCardPriceScryfallId = Index('idx_card_price_scryfall_id',
      'CREATE UNIQUE INDEX idx_card_price_scryfall_id ON card_prices (scryfall_id)');
  late final Index idxFilterMetadataKey = Index('idx_filter_metadata_key',
      'CREATE UNIQUE INDEX idx_filter_metadata_key ON filter_metadata ("key")');
  late final Index idxPreconName = Index(
      'idx_precon_name', 'CREATE INDEX idx_precon_name ON precon_decks (name)');
  late final Index idxPreconSetCode = Index('idx_precon_set_code',
      'CREATE INDEX idx_precon_set_code ON precon_decks (set_code)');
  late final Index idxPreconType = Index(
      'idx_precon_type', 'CREATE INDEX idx_precon_type ON precon_decks (type)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        cards,
        cardPrices,
        filterMetadata,
        preconDecks,
        idxCardScryfallId,
        idxCardMtgjsonUuid,
        idxCardOracleId,
        idxCardName,
        idxCardFlavorName,
        idxCardLang,
        idxCardTypeLine,
        idxCardColorsString,
        idxCardColorIdentityString,
        idxCardLegalInAnyFormat,
        idxCardIsCanonicalPrinting,
        idxCardSetCode,
        idxCardRarity,
        idxCardPriceNumeric,
        idxCardPriceScryfallId,
        idxFilterMetadataKey,
        idxPreconName,
        idxPreconSetCode,
        idxPreconType
      ];
}

typedef $$CardsTableCreateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  required String scryfallId,
  Value<String?> mtgjsonUuid,
  required String oracleId,
  required String name,
  Value<String?> flavorName,
  required String lang,
  required String releasedAt,
  required String uri,
  required String scryfallUri,
  required String layout,
  Value<String?> manaCost,
  required double cmc,
  required String typeLine,
  Value<String?> oracleText,
  Value<String?> flavorText,
  Value<String?> power,
  Value<String?> toughness,
  Value<String> colorsJson,
  Value<String> colorIdentityJson,
  Value<String?> keywordsJson,
  Value<String> colorsString,
  Value<String> colorIdentityString,
  Value<bool> legalInAnyFormat,
  Value<bool> isCanonicalPrinting,
  required String setCode,
  required String setName,
  required String setType,
  required String collectorNumber,
  required bool digital,
  required String rarity,
  Value<int> rarityOrder,
  Value<double?> powerNumeric,
  Value<double?> toughnessNumeric,
  Value<String?> artist,
  required String borderColor,
  required String frame,
  required bool fullArt,
  required bool textless,
  required bool booster,
  required bool storySpotlight,
  required String imageStatus,
  Value<String?> imageSmall,
  Value<String?> imageNormal,
  Value<String?> imageLarge,
  Value<String?> imagePng,
  Value<String?> imageArtCrop,
  Value<String?> imageBorderCrop,
  required String legalStandard,
  required String legalFuture,
  required String legalHistoric,
  required String legalGladiator,
  required String legalPioneer,
  Value<String?> legalExplorer,
  required String legalModern,
  required String legalLegacy,
  required String legalPauper,
  required String legalVintage,
  required String legalPenny,
  required String legalCommander,
  required String legalOathbreaker,
  required String legalBrawl,
  Value<String?> legalHistoricbrawl,
  required String legalAlchemy,
  required String legalPaupercommander,
  required String legalDuel,
  required String legalOldschool,
  required String legalPremodern,
  required String legalPredh,
  Value<String?> priceUsd,
  Value<String?> priceUsdFoil,
  Value<String?> priceUsdEtched,
  Value<String?> priceEur,
  Value<String?> priceEurFoil,
  Value<String?> priceTix,
  Value<double?> priceNumeric,
  Value<String?> cardFacesJson,
  Value<String?> rulingsJson,
  required String object,
  required bool oversized,
  required bool promo,
  required bool reprint,
  required bool variation,
  Value<String> gamesJson,
  required bool reserved,
  required bool foil,
  required bool nonfoil,
  Value<String> finishesJson,
  Value<String> producedManaJson,
  Value<int?> edhrecRank,
  Value<bool?> isGameChanger,
  Value<String> relatedTokenIdsJson,
  Value<int?> mtgoId,
  Value<int?> arenaId,
  Value<int?> tcgplayerId,
  Value<int?> cardmarketId,
});
typedef $$CardsTableUpdateCompanionBuilder = CardsCompanion Function({
  Value<int> id,
  Value<String> scryfallId,
  Value<String?> mtgjsonUuid,
  Value<String> oracleId,
  Value<String> name,
  Value<String?> flavorName,
  Value<String> lang,
  Value<String> releasedAt,
  Value<String> uri,
  Value<String> scryfallUri,
  Value<String> layout,
  Value<String?> manaCost,
  Value<double> cmc,
  Value<String> typeLine,
  Value<String?> oracleText,
  Value<String?> flavorText,
  Value<String?> power,
  Value<String?> toughness,
  Value<String> colorsJson,
  Value<String> colorIdentityJson,
  Value<String?> keywordsJson,
  Value<String> colorsString,
  Value<String> colorIdentityString,
  Value<bool> legalInAnyFormat,
  Value<bool> isCanonicalPrinting,
  Value<String> setCode,
  Value<String> setName,
  Value<String> setType,
  Value<String> collectorNumber,
  Value<bool> digital,
  Value<String> rarity,
  Value<int> rarityOrder,
  Value<double?> powerNumeric,
  Value<double?> toughnessNumeric,
  Value<String?> artist,
  Value<String> borderColor,
  Value<String> frame,
  Value<bool> fullArt,
  Value<bool> textless,
  Value<bool> booster,
  Value<bool> storySpotlight,
  Value<String> imageStatus,
  Value<String?> imageSmall,
  Value<String?> imageNormal,
  Value<String?> imageLarge,
  Value<String?> imagePng,
  Value<String?> imageArtCrop,
  Value<String?> imageBorderCrop,
  Value<String> legalStandard,
  Value<String> legalFuture,
  Value<String> legalHistoric,
  Value<String> legalGladiator,
  Value<String> legalPioneer,
  Value<String?> legalExplorer,
  Value<String> legalModern,
  Value<String> legalLegacy,
  Value<String> legalPauper,
  Value<String> legalVintage,
  Value<String> legalPenny,
  Value<String> legalCommander,
  Value<String> legalOathbreaker,
  Value<String> legalBrawl,
  Value<String?> legalHistoricbrawl,
  Value<String> legalAlchemy,
  Value<String> legalPaupercommander,
  Value<String> legalDuel,
  Value<String> legalOldschool,
  Value<String> legalPremodern,
  Value<String> legalPredh,
  Value<String?> priceUsd,
  Value<String?> priceUsdFoil,
  Value<String?> priceUsdEtched,
  Value<String?> priceEur,
  Value<String?> priceEurFoil,
  Value<String?> priceTix,
  Value<double?> priceNumeric,
  Value<String?> cardFacesJson,
  Value<String?> rulingsJson,
  Value<String> object,
  Value<bool> oversized,
  Value<bool> promo,
  Value<bool> reprint,
  Value<bool> variation,
  Value<String> gamesJson,
  Value<bool> reserved,
  Value<bool> foil,
  Value<bool> nonfoil,
  Value<String> finishesJson,
  Value<String> producedManaJson,
  Value<int?> edhrecRank,
  Value<bool?> isGameChanger,
  Value<String> relatedTokenIdsJson,
  Value<int?> mtgoId,
  Value<int?> arenaId,
  Value<int?> tcgplayerId,
  Value<int?> cardmarketId,
});

class $$CardsTableFilterComposer
    extends Composer<_$CardsDatabase, $CardsTable> {
  $$CardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scryfallId => $composableBuilder(
      column: $table.scryfallId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mtgjsonUuid => $composableBuilder(
      column: $table.mtgjsonUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oracleId => $composableBuilder(
      column: $table.oracleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flavorName => $composableBuilder(
      column: $table.flavorName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get releasedAt => $composableBuilder(
      column: $table.releasedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scryfallUri => $composableBuilder(
      column: $table.scryfallUri, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get layout => $composableBuilder(
      column: $table.layout, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manaCost => $composableBuilder(
      column: $table.manaCost, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cmc => $composableBuilder(
      column: $table.cmc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeLine => $composableBuilder(
      column: $table.typeLine, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get oracleText => $composableBuilder(
      column: $table.oracleText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get flavorText => $composableBuilder(
      column: $table.flavorText, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get power => $composableBuilder(
      column: $table.power, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toughness => $composableBuilder(
      column: $table.toughness, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorsJson => $composableBuilder(
      column: $table.colorsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorIdentityJson => $composableBuilder(
      column: $table.colorIdentityJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorsString => $composableBuilder(
      column: $table.colorsString, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorIdentityString => $composableBuilder(
      column: $table.colorIdentityString,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get legalInAnyFormat => $composableBuilder(
      column: $table.legalInAnyFormat,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCanonicalPrinting => $composableBuilder(
      column: $table.isCanonicalPrinting,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setCode => $composableBuilder(
      column: $table.setCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setName => $composableBuilder(
      column: $table.setName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setType => $composableBuilder(
      column: $table.setType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get collectorNumber => $composableBuilder(
      column: $table.collectorNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get digital => $composableBuilder(
      column: $table.digital, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rarityOrder => $composableBuilder(
      column: $table.rarityOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get powerNumeric => $composableBuilder(
      column: $table.powerNumeric, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get toughnessNumeric => $composableBuilder(
      column: $table.toughnessNumeric,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get borderColor => $composableBuilder(
      column: $table.borderColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frame => $composableBuilder(
      column: $table.frame, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get fullArt => $composableBuilder(
      column: $table.fullArt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get textless => $composableBuilder(
      column: $table.textless, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get booster => $composableBuilder(
      column: $table.booster, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get storySpotlight => $composableBuilder(
      column: $table.storySpotlight,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageStatus => $composableBuilder(
      column: $table.imageStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageSmall => $composableBuilder(
      column: $table.imageSmall, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageNormal => $composableBuilder(
      column: $table.imageNormal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageLarge => $composableBuilder(
      column: $table.imageLarge, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePng => $composableBuilder(
      column: $table.imagePng, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageArtCrop => $composableBuilder(
      column: $table.imageArtCrop, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageBorderCrop => $composableBuilder(
      column: $table.imageBorderCrop,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalStandard => $composableBuilder(
      column: $table.legalStandard, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalFuture => $composableBuilder(
      column: $table.legalFuture, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalHistoric => $composableBuilder(
      column: $table.legalHistoric, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalGladiator => $composableBuilder(
      column: $table.legalGladiator,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalPioneer => $composableBuilder(
      column: $table.legalPioneer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalExplorer => $composableBuilder(
      column: $table.legalExplorer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalModern => $composableBuilder(
      column: $table.legalModern, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalLegacy => $composableBuilder(
      column: $table.legalLegacy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalPauper => $composableBuilder(
      column: $table.legalPauper, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalVintage => $composableBuilder(
      column: $table.legalVintage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalPenny => $composableBuilder(
      column: $table.legalPenny, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalCommander => $composableBuilder(
      column: $table.legalCommander,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalOathbreaker => $composableBuilder(
      column: $table.legalOathbreaker,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalBrawl => $composableBuilder(
      column: $table.legalBrawl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalHistoricbrawl => $composableBuilder(
      column: $table.legalHistoricbrawl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalAlchemy => $composableBuilder(
      column: $table.legalAlchemy, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalPaupercommander => $composableBuilder(
      column: $table.legalPaupercommander,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalDuel => $composableBuilder(
      column: $table.legalDuel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalOldschool => $composableBuilder(
      column: $table.legalOldschool,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalPremodern => $composableBuilder(
      column: $table.legalPremodern,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get legalPredh => $composableBuilder(
      column: $table.legalPredh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceUsd => $composableBuilder(
      column: $table.priceUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceUsdFoil => $composableBuilder(
      column: $table.priceUsdFoil, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceUsdEtched => $composableBuilder(
      column: $table.priceUsdEtched,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceEur => $composableBuilder(
      column: $table.priceEur, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceEurFoil => $composableBuilder(
      column: $table.priceEurFoil, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get priceTix => $composableBuilder(
      column: $table.priceTix, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get priceNumeric => $composableBuilder(
      column: $table.priceNumeric, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardFacesJson => $composableBuilder(
      column: $table.cardFacesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get rulingsJson => $composableBuilder(
      column: $table.rulingsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get object => $composableBuilder(
      column: $table.object, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get oversized => $composableBuilder(
      column: $table.oversized, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get promo => $composableBuilder(
      column: $table.promo, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reprint => $composableBuilder(
      column: $table.reprint, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get variation => $composableBuilder(
      column: $table.variation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get gamesJson => $composableBuilder(
      column: $table.gamesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get reserved => $composableBuilder(
      column: $table.reserved, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get foil => $composableBuilder(
      column: $table.foil, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get nonfoil => $composableBuilder(
      column: $table.nonfoil, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get finishesJson => $composableBuilder(
      column: $table.finishesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get producedManaJson => $composableBuilder(
      column: $table.producedManaJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get edhrecRank => $composableBuilder(
      column: $table.edhrecRank, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isGameChanger => $composableBuilder(
      column: $table.isGameChanger, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedTokenIdsJson => $composableBuilder(
      column: $table.relatedTokenIdsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mtgoId => $composableBuilder(
      column: $table.mtgoId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get arenaId => $composableBuilder(
      column: $table.arenaId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get tcgplayerId => $composableBuilder(
      column: $table.tcgplayerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get cardmarketId => $composableBuilder(
      column: $table.cardmarketId, builder: (column) => ColumnFilters(column));
}

class $$CardsTableOrderingComposer
    extends Composer<_$CardsDatabase, $CardsTable> {
  $$CardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scryfallId => $composableBuilder(
      column: $table.scryfallId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mtgjsonUuid => $composableBuilder(
      column: $table.mtgjsonUuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oracleId => $composableBuilder(
      column: $table.oracleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flavorName => $composableBuilder(
      column: $table.flavorName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lang => $composableBuilder(
      column: $table.lang, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get releasedAt => $composableBuilder(
      column: $table.releasedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uri => $composableBuilder(
      column: $table.uri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scryfallUri => $composableBuilder(
      column: $table.scryfallUri, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get layout => $composableBuilder(
      column: $table.layout, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manaCost => $composableBuilder(
      column: $table.manaCost, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cmc => $composableBuilder(
      column: $table.cmc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeLine => $composableBuilder(
      column: $table.typeLine, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get oracleText => $composableBuilder(
      column: $table.oracleText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flavorText => $composableBuilder(
      column: $table.flavorText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get power => $composableBuilder(
      column: $table.power, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toughness => $composableBuilder(
      column: $table.toughness, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorsJson => $composableBuilder(
      column: $table.colorsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorIdentityJson => $composableBuilder(
      column: $table.colorIdentityJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorsString => $composableBuilder(
      column: $table.colorsString,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorIdentityString => $composableBuilder(
      column: $table.colorIdentityString,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get legalInAnyFormat => $composableBuilder(
      column: $table.legalInAnyFormat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCanonicalPrinting => $composableBuilder(
      column: $table.isCanonicalPrinting,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setCode => $composableBuilder(
      column: $table.setCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setName => $composableBuilder(
      column: $table.setName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setType => $composableBuilder(
      column: $table.setType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get collectorNumber => $composableBuilder(
      column: $table.collectorNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get digital => $composableBuilder(
      column: $table.digital, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rarity => $composableBuilder(
      column: $table.rarity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rarityOrder => $composableBuilder(
      column: $table.rarityOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get powerNumeric => $composableBuilder(
      column: $table.powerNumeric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get toughnessNumeric => $composableBuilder(
      column: $table.toughnessNumeric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get borderColor => $composableBuilder(
      column: $table.borderColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frame => $composableBuilder(
      column: $table.frame, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get fullArt => $composableBuilder(
      column: $table.fullArt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get textless => $composableBuilder(
      column: $table.textless, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get booster => $composableBuilder(
      column: $table.booster, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get storySpotlight => $composableBuilder(
      column: $table.storySpotlight,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageStatus => $composableBuilder(
      column: $table.imageStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageSmall => $composableBuilder(
      column: $table.imageSmall, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageNormal => $composableBuilder(
      column: $table.imageNormal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageLarge => $composableBuilder(
      column: $table.imageLarge, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePng => $composableBuilder(
      column: $table.imagePng, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageArtCrop => $composableBuilder(
      column: $table.imageArtCrop,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageBorderCrop => $composableBuilder(
      column: $table.imageBorderCrop,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalStandard => $composableBuilder(
      column: $table.legalStandard,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalFuture => $composableBuilder(
      column: $table.legalFuture, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalHistoric => $composableBuilder(
      column: $table.legalHistoric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalGladiator => $composableBuilder(
      column: $table.legalGladiator,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalPioneer => $composableBuilder(
      column: $table.legalPioneer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalExplorer => $composableBuilder(
      column: $table.legalExplorer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalModern => $composableBuilder(
      column: $table.legalModern, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalLegacy => $composableBuilder(
      column: $table.legalLegacy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalPauper => $composableBuilder(
      column: $table.legalPauper, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalVintage => $composableBuilder(
      column: $table.legalVintage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalPenny => $composableBuilder(
      column: $table.legalPenny, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalCommander => $composableBuilder(
      column: $table.legalCommander,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalOathbreaker => $composableBuilder(
      column: $table.legalOathbreaker,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalBrawl => $composableBuilder(
      column: $table.legalBrawl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalHistoricbrawl => $composableBuilder(
      column: $table.legalHistoricbrawl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalAlchemy => $composableBuilder(
      column: $table.legalAlchemy,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalPaupercommander => $composableBuilder(
      column: $table.legalPaupercommander,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalDuel => $composableBuilder(
      column: $table.legalDuel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalOldschool => $composableBuilder(
      column: $table.legalOldschool,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalPremodern => $composableBuilder(
      column: $table.legalPremodern,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get legalPredh => $composableBuilder(
      column: $table.legalPredh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceUsd => $composableBuilder(
      column: $table.priceUsd, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceUsdFoil => $composableBuilder(
      column: $table.priceUsdFoil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceUsdEtched => $composableBuilder(
      column: $table.priceUsdEtched,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceEur => $composableBuilder(
      column: $table.priceEur, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceEurFoil => $composableBuilder(
      column: $table.priceEurFoil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get priceTix => $composableBuilder(
      column: $table.priceTix, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get priceNumeric => $composableBuilder(
      column: $table.priceNumeric,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardFacesJson => $composableBuilder(
      column: $table.cardFacesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get rulingsJson => $composableBuilder(
      column: $table.rulingsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get object => $composableBuilder(
      column: $table.object, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get oversized => $composableBuilder(
      column: $table.oversized, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get promo => $composableBuilder(
      column: $table.promo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reprint => $composableBuilder(
      column: $table.reprint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get variation => $composableBuilder(
      column: $table.variation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get gamesJson => $composableBuilder(
      column: $table.gamesJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get reserved => $composableBuilder(
      column: $table.reserved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get foil => $composableBuilder(
      column: $table.foil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get nonfoil => $composableBuilder(
      column: $table.nonfoil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get finishesJson => $composableBuilder(
      column: $table.finishesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get producedManaJson => $composableBuilder(
      column: $table.producedManaJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get edhrecRank => $composableBuilder(
      column: $table.edhrecRank, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isGameChanger => $composableBuilder(
      column: $table.isGameChanger,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedTokenIdsJson => $composableBuilder(
      column: $table.relatedTokenIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mtgoId => $composableBuilder(
      column: $table.mtgoId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get arenaId => $composableBuilder(
      column: $table.arenaId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get tcgplayerId => $composableBuilder(
      column: $table.tcgplayerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get cardmarketId => $composableBuilder(
      column: $table.cardmarketId,
      builder: (column) => ColumnOrderings(column));
}

class $$CardsTableAnnotationComposer
    extends Composer<_$CardsDatabase, $CardsTable> {
  $$CardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scryfallId => $composableBuilder(
      column: $table.scryfallId, builder: (column) => column);

  GeneratedColumn<String> get mtgjsonUuid => $composableBuilder(
      column: $table.mtgjsonUuid, builder: (column) => column);

  GeneratedColumn<String> get oracleId =>
      $composableBuilder(column: $table.oracleId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get flavorName => $composableBuilder(
      column: $table.flavorName, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get releasedAt => $composableBuilder(
      column: $table.releasedAt, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get scryfallUri => $composableBuilder(
      column: $table.scryfallUri, builder: (column) => column);

  GeneratedColumn<String> get layout =>
      $composableBuilder(column: $table.layout, builder: (column) => column);

  GeneratedColumn<String> get manaCost =>
      $composableBuilder(column: $table.manaCost, builder: (column) => column);

  GeneratedColumn<double> get cmc =>
      $composableBuilder(column: $table.cmc, builder: (column) => column);

  GeneratedColumn<String> get typeLine =>
      $composableBuilder(column: $table.typeLine, builder: (column) => column);

  GeneratedColumn<String> get oracleText => $composableBuilder(
      column: $table.oracleText, builder: (column) => column);

  GeneratedColumn<String> get flavorText => $composableBuilder(
      column: $table.flavorText, builder: (column) => column);

  GeneratedColumn<String> get power =>
      $composableBuilder(column: $table.power, builder: (column) => column);

  GeneratedColumn<String> get toughness =>
      $composableBuilder(column: $table.toughness, builder: (column) => column);

  GeneratedColumn<String> get colorsJson => $composableBuilder(
      column: $table.colorsJson, builder: (column) => column);

  GeneratedColumn<String> get colorIdentityJson => $composableBuilder(
      column: $table.colorIdentityJson, builder: (column) => column);

  GeneratedColumn<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson, builder: (column) => column);

  GeneratedColumn<String> get colorsString => $composableBuilder(
      column: $table.colorsString, builder: (column) => column);

  GeneratedColumn<String> get colorIdentityString => $composableBuilder(
      column: $table.colorIdentityString, builder: (column) => column);

  GeneratedColumn<bool> get legalInAnyFormat => $composableBuilder(
      column: $table.legalInAnyFormat, builder: (column) => column);

  GeneratedColumn<bool> get isCanonicalPrinting => $composableBuilder(
      column: $table.isCanonicalPrinting, builder: (column) => column);

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<String> get setName =>
      $composableBuilder(column: $table.setName, builder: (column) => column);

  GeneratedColumn<String> get setType =>
      $composableBuilder(column: $table.setType, builder: (column) => column);

  GeneratedColumn<String> get collectorNumber => $composableBuilder(
      column: $table.collectorNumber, builder: (column) => column);

  GeneratedColumn<bool> get digital =>
      $composableBuilder(column: $table.digital, builder: (column) => column);

  GeneratedColumn<String> get rarity =>
      $composableBuilder(column: $table.rarity, builder: (column) => column);

  GeneratedColumn<int> get rarityOrder => $composableBuilder(
      column: $table.rarityOrder, builder: (column) => column);

  GeneratedColumn<double> get powerNumeric => $composableBuilder(
      column: $table.powerNumeric, builder: (column) => column);

  GeneratedColumn<double> get toughnessNumeric => $composableBuilder(
      column: $table.toughnessNumeric, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get borderColor => $composableBuilder(
      column: $table.borderColor, builder: (column) => column);

  GeneratedColumn<String> get frame =>
      $composableBuilder(column: $table.frame, builder: (column) => column);

  GeneratedColumn<bool> get fullArt =>
      $composableBuilder(column: $table.fullArt, builder: (column) => column);

  GeneratedColumn<bool> get textless =>
      $composableBuilder(column: $table.textless, builder: (column) => column);

  GeneratedColumn<bool> get booster =>
      $composableBuilder(column: $table.booster, builder: (column) => column);

  GeneratedColumn<bool> get storySpotlight => $composableBuilder(
      column: $table.storySpotlight, builder: (column) => column);

  GeneratedColumn<String> get imageStatus => $composableBuilder(
      column: $table.imageStatus, builder: (column) => column);

  GeneratedColumn<String> get imageSmall => $composableBuilder(
      column: $table.imageSmall, builder: (column) => column);

  GeneratedColumn<String> get imageNormal => $composableBuilder(
      column: $table.imageNormal, builder: (column) => column);

  GeneratedColumn<String> get imageLarge => $composableBuilder(
      column: $table.imageLarge, builder: (column) => column);

  GeneratedColumn<String> get imagePng =>
      $composableBuilder(column: $table.imagePng, builder: (column) => column);

  GeneratedColumn<String> get imageArtCrop => $composableBuilder(
      column: $table.imageArtCrop, builder: (column) => column);

  GeneratedColumn<String> get imageBorderCrop => $composableBuilder(
      column: $table.imageBorderCrop, builder: (column) => column);

  GeneratedColumn<String> get legalStandard => $composableBuilder(
      column: $table.legalStandard, builder: (column) => column);

  GeneratedColumn<String> get legalFuture => $composableBuilder(
      column: $table.legalFuture, builder: (column) => column);

  GeneratedColumn<String> get legalHistoric => $composableBuilder(
      column: $table.legalHistoric, builder: (column) => column);

  GeneratedColumn<String> get legalGladiator => $composableBuilder(
      column: $table.legalGladiator, builder: (column) => column);

  GeneratedColumn<String> get legalPioneer => $composableBuilder(
      column: $table.legalPioneer, builder: (column) => column);

  GeneratedColumn<String> get legalExplorer => $composableBuilder(
      column: $table.legalExplorer, builder: (column) => column);

  GeneratedColumn<String> get legalModern => $composableBuilder(
      column: $table.legalModern, builder: (column) => column);

  GeneratedColumn<String> get legalLegacy => $composableBuilder(
      column: $table.legalLegacy, builder: (column) => column);

  GeneratedColumn<String> get legalPauper => $composableBuilder(
      column: $table.legalPauper, builder: (column) => column);

  GeneratedColumn<String> get legalVintage => $composableBuilder(
      column: $table.legalVintage, builder: (column) => column);

  GeneratedColumn<String> get legalPenny => $composableBuilder(
      column: $table.legalPenny, builder: (column) => column);

  GeneratedColumn<String> get legalCommander => $composableBuilder(
      column: $table.legalCommander, builder: (column) => column);

  GeneratedColumn<String> get legalOathbreaker => $composableBuilder(
      column: $table.legalOathbreaker, builder: (column) => column);

  GeneratedColumn<String> get legalBrawl => $composableBuilder(
      column: $table.legalBrawl, builder: (column) => column);

  GeneratedColumn<String> get legalHistoricbrawl => $composableBuilder(
      column: $table.legalHistoricbrawl, builder: (column) => column);

  GeneratedColumn<String> get legalAlchemy => $composableBuilder(
      column: $table.legalAlchemy, builder: (column) => column);

  GeneratedColumn<String> get legalPaupercommander => $composableBuilder(
      column: $table.legalPaupercommander, builder: (column) => column);

  GeneratedColumn<String> get legalDuel =>
      $composableBuilder(column: $table.legalDuel, builder: (column) => column);

  GeneratedColumn<String> get legalOldschool => $composableBuilder(
      column: $table.legalOldschool, builder: (column) => column);

  GeneratedColumn<String> get legalPremodern => $composableBuilder(
      column: $table.legalPremodern, builder: (column) => column);

  GeneratedColumn<String> get legalPredh => $composableBuilder(
      column: $table.legalPredh, builder: (column) => column);

  GeneratedColumn<String> get priceUsd =>
      $composableBuilder(column: $table.priceUsd, builder: (column) => column);

  GeneratedColumn<String> get priceUsdFoil => $composableBuilder(
      column: $table.priceUsdFoil, builder: (column) => column);

  GeneratedColumn<String> get priceUsdEtched => $composableBuilder(
      column: $table.priceUsdEtched, builder: (column) => column);

  GeneratedColumn<String> get priceEur =>
      $composableBuilder(column: $table.priceEur, builder: (column) => column);

  GeneratedColumn<String> get priceEurFoil => $composableBuilder(
      column: $table.priceEurFoil, builder: (column) => column);

  GeneratedColumn<String> get priceTix =>
      $composableBuilder(column: $table.priceTix, builder: (column) => column);

  GeneratedColumn<double> get priceNumeric => $composableBuilder(
      column: $table.priceNumeric, builder: (column) => column);

  GeneratedColumn<String> get cardFacesJson => $composableBuilder(
      column: $table.cardFacesJson, builder: (column) => column);

  GeneratedColumn<String> get rulingsJson => $composableBuilder(
      column: $table.rulingsJson, builder: (column) => column);

  GeneratedColumn<String> get object =>
      $composableBuilder(column: $table.object, builder: (column) => column);

  GeneratedColumn<bool> get oversized =>
      $composableBuilder(column: $table.oversized, builder: (column) => column);

  GeneratedColumn<bool> get promo =>
      $composableBuilder(column: $table.promo, builder: (column) => column);

  GeneratedColumn<bool> get reprint =>
      $composableBuilder(column: $table.reprint, builder: (column) => column);

  GeneratedColumn<bool> get variation =>
      $composableBuilder(column: $table.variation, builder: (column) => column);

  GeneratedColumn<String> get gamesJson =>
      $composableBuilder(column: $table.gamesJson, builder: (column) => column);

  GeneratedColumn<bool> get reserved =>
      $composableBuilder(column: $table.reserved, builder: (column) => column);

  GeneratedColumn<bool> get foil =>
      $composableBuilder(column: $table.foil, builder: (column) => column);

  GeneratedColumn<bool> get nonfoil =>
      $composableBuilder(column: $table.nonfoil, builder: (column) => column);

  GeneratedColumn<String> get finishesJson => $composableBuilder(
      column: $table.finishesJson, builder: (column) => column);

  GeneratedColumn<String> get producedManaJson => $composableBuilder(
      column: $table.producedManaJson, builder: (column) => column);

  GeneratedColumn<int> get edhrecRank => $composableBuilder(
      column: $table.edhrecRank, builder: (column) => column);

  GeneratedColumn<bool> get isGameChanger => $composableBuilder(
      column: $table.isGameChanger, builder: (column) => column);

  GeneratedColumn<String> get relatedTokenIdsJson => $composableBuilder(
      column: $table.relatedTokenIdsJson, builder: (column) => column);

  GeneratedColumn<int> get mtgoId =>
      $composableBuilder(column: $table.mtgoId, builder: (column) => column);

  GeneratedColumn<int> get arenaId =>
      $composableBuilder(column: $table.arenaId, builder: (column) => column);

  GeneratedColumn<int> get tcgplayerId => $composableBuilder(
      column: $table.tcgplayerId, builder: (column) => column);

  GeneratedColumn<int> get cardmarketId => $composableBuilder(
      column: $table.cardmarketId, builder: (column) => column);
}

class $$CardsTableTableManager extends RootTableManager<
    _$CardsDatabase,
    $CardsTable,
    CardRow,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardRow, BaseReferences<_$CardsDatabase, $CardsTable, CardRow>),
    CardRow,
    PrefetchHooks Function()> {
  $$CardsTableTableManager(_$CardsDatabase db, $CardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> scryfallId = const Value.absent(),
            Value<String?> mtgjsonUuid = const Value.absent(),
            Value<String> oracleId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> flavorName = const Value.absent(),
            Value<String> lang = const Value.absent(),
            Value<String> releasedAt = const Value.absent(),
            Value<String> uri = const Value.absent(),
            Value<String> scryfallUri = const Value.absent(),
            Value<String> layout = const Value.absent(),
            Value<String?> manaCost = const Value.absent(),
            Value<double> cmc = const Value.absent(),
            Value<String> typeLine = const Value.absent(),
            Value<String?> oracleText = const Value.absent(),
            Value<String?> flavorText = const Value.absent(),
            Value<String?> power = const Value.absent(),
            Value<String?> toughness = const Value.absent(),
            Value<String> colorsJson = const Value.absent(),
            Value<String> colorIdentityJson = const Value.absent(),
            Value<String?> keywordsJson = const Value.absent(),
            Value<String> colorsString = const Value.absent(),
            Value<String> colorIdentityString = const Value.absent(),
            Value<bool> legalInAnyFormat = const Value.absent(),
            Value<bool> isCanonicalPrinting = const Value.absent(),
            Value<String> setCode = const Value.absent(),
            Value<String> setName = const Value.absent(),
            Value<String> setType = const Value.absent(),
            Value<String> collectorNumber = const Value.absent(),
            Value<bool> digital = const Value.absent(),
            Value<String> rarity = const Value.absent(),
            Value<int> rarityOrder = const Value.absent(),
            Value<double?> powerNumeric = const Value.absent(),
            Value<double?> toughnessNumeric = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            Value<String> borderColor = const Value.absent(),
            Value<String> frame = const Value.absent(),
            Value<bool> fullArt = const Value.absent(),
            Value<bool> textless = const Value.absent(),
            Value<bool> booster = const Value.absent(),
            Value<bool> storySpotlight = const Value.absent(),
            Value<String> imageStatus = const Value.absent(),
            Value<String?> imageSmall = const Value.absent(),
            Value<String?> imageNormal = const Value.absent(),
            Value<String?> imageLarge = const Value.absent(),
            Value<String?> imagePng = const Value.absent(),
            Value<String?> imageArtCrop = const Value.absent(),
            Value<String?> imageBorderCrop = const Value.absent(),
            Value<String> legalStandard = const Value.absent(),
            Value<String> legalFuture = const Value.absent(),
            Value<String> legalHistoric = const Value.absent(),
            Value<String> legalGladiator = const Value.absent(),
            Value<String> legalPioneer = const Value.absent(),
            Value<String?> legalExplorer = const Value.absent(),
            Value<String> legalModern = const Value.absent(),
            Value<String> legalLegacy = const Value.absent(),
            Value<String> legalPauper = const Value.absent(),
            Value<String> legalVintage = const Value.absent(),
            Value<String> legalPenny = const Value.absent(),
            Value<String> legalCommander = const Value.absent(),
            Value<String> legalOathbreaker = const Value.absent(),
            Value<String> legalBrawl = const Value.absent(),
            Value<String?> legalHistoricbrawl = const Value.absent(),
            Value<String> legalAlchemy = const Value.absent(),
            Value<String> legalPaupercommander = const Value.absent(),
            Value<String> legalDuel = const Value.absent(),
            Value<String> legalOldschool = const Value.absent(),
            Value<String> legalPremodern = const Value.absent(),
            Value<String> legalPredh = const Value.absent(),
            Value<String?> priceUsd = const Value.absent(),
            Value<String?> priceUsdFoil = const Value.absent(),
            Value<String?> priceUsdEtched = const Value.absent(),
            Value<String?> priceEur = const Value.absent(),
            Value<String?> priceEurFoil = const Value.absent(),
            Value<String?> priceTix = const Value.absent(),
            Value<double?> priceNumeric = const Value.absent(),
            Value<String?> cardFacesJson = const Value.absent(),
            Value<String?> rulingsJson = const Value.absent(),
            Value<String> object = const Value.absent(),
            Value<bool> oversized = const Value.absent(),
            Value<bool> promo = const Value.absent(),
            Value<bool> reprint = const Value.absent(),
            Value<bool> variation = const Value.absent(),
            Value<String> gamesJson = const Value.absent(),
            Value<bool> reserved = const Value.absent(),
            Value<bool> foil = const Value.absent(),
            Value<bool> nonfoil = const Value.absent(),
            Value<String> finishesJson = const Value.absent(),
            Value<String> producedManaJson = const Value.absent(),
            Value<int?> edhrecRank = const Value.absent(),
            Value<bool?> isGameChanger = const Value.absent(),
            Value<String> relatedTokenIdsJson = const Value.absent(),
            Value<int?> mtgoId = const Value.absent(),
            Value<int?> arenaId = const Value.absent(),
            Value<int?> tcgplayerId = const Value.absent(),
            Value<int?> cardmarketId = const Value.absent(),
          }) =>
              CardsCompanion(
            id: id,
            scryfallId: scryfallId,
            mtgjsonUuid: mtgjsonUuid,
            oracleId: oracleId,
            name: name,
            flavorName: flavorName,
            lang: lang,
            releasedAt: releasedAt,
            uri: uri,
            scryfallUri: scryfallUri,
            layout: layout,
            manaCost: manaCost,
            cmc: cmc,
            typeLine: typeLine,
            oracleText: oracleText,
            flavorText: flavorText,
            power: power,
            toughness: toughness,
            colorsJson: colorsJson,
            colorIdentityJson: colorIdentityJson,
            keywordsJson: keywordsJson,
            colorsString: colorsString,
            colorIdentityString: colorIdentityString,
            legalInAnyFormat: legalInAnyFormat,
            isCanonicalPrinting: isCanonicalPrinting,
            setCode: setCode,
            setName: setName,
            setType: setType,
            collectorNumber: collectorNumber,
            digital: digital,
            rarity: rarity,
            rarityOrder: rarityOrder,
            powerNumeric: powerNumeric,
            toughnessNumeric: toughnessNumeric,
            artist: artist,
            borderColor: borderColor,
            frame: frame,
            fullArt: fullArt,
            textless: textless,
            booster: booster,
            storySpotlight: storySpotlight,
            imageStatus: imageStatus,
            imageSmall: imageSmall,
            imageNormal: imageNormal,
            imageLarge: imageLarge,
            imagePng: imagePng,
            imageArtCrop: imageArtCrop,
            imageBorderCrop: imageBorderCrop,
            legalStandard: legalStandard,
            legalFuture: legalFuture,
            legalHistoric: legalHistoric,
            legalGladiator: legalGladiator,
            legalPioneer: legalPioneer,
            legalExplorer: legalExplorer,
            legalModern: legalModern,
            legalLegacy: legalLegacy,
            legalPauper: legalPauper,
            legalVintage: legalVintage,
            legalPenny: legalPenny,
            legalCommander: legalCommander,
            legalOathbreaker: legalOathbreaker,
            legalBrawl: legalBrawl,
            legalHistoricbrawl: legalHistoricbrawl,
            legalAlchemy: legalAlchemy,
            legalPaupercommander: legalPaupercommander,
            legalDuel: legalDuel,
            legalOldschool: legalOldschool,
            legalPremodern: legalPremodern,
            legalPredh: legalPredh,
            priceUsd: priceUsd,
            priceUsdFoil: priceUsdFoil,
            priceUsdEtched: priceUsdEtched,
            priceEur: priceEur,
            priceEurFoil: priceEurFoil,
            priceTix: priceTix,
            priceNumeric: priceNumeric,
            cardFacesJson: cardFacesJson,
            rulingsJson: rulingsJson,
            object: object,
            oversized: oversized,
            promo: promo,
            reprint: reprint,
            variation: variation,
            gamesJson: gamesJson,
            reserved: reserved,
            foil: foil,
            nonfoil: nonfoil,
            finishesJson: finishesJson,
            producedManaJson: producedManaJson,
            edhrecRank: edhrecRank,
            isGameChanger: isGameChanger,
            relatedTokenIdsJson: relatedTokenIdsJson,
            mtgoId: mtgoId,
            arenaId: arenaId,
            tcgplayerId: tcgplayerId,
            cardmarketId: cardmarketId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String scryfallId,
            Value<String?> mtgjsonUuid = const Value.absent(),
            required String oracleId,
            required String name,
            Value<String?> flavorName = const Value.absent(),
            required String lang,
            required String releasedAt,
            required String uri,
            required String scryfallUri,
            required String layout,
            Value<String?> manaCost = const Value.absent(),
            required double cmc,
            required String typeLine,
            Value<String?> oracleText = const Value.absent(),
            Value<String?> flavorText = const Value.absent(),
            Value<String?> power = const Value.absent(),
            Value<String?> toughness = const Value.absent(),
            Value<String> colorsJson = const Value.absent(),
            Value<String> colorIdentityJson = const Value.absent(),
            Value<String?> keywordsJson = const Value.absent(),
            Value<String> colorsString = const Value.absent(),
            Value<String> colorIdentityString = const Value.absent(),
            Value<bool> legalInAnyFormat = const Value.absent(),
            Value<bool> isCanonicalPrinting = const Value.absent(),
            required String setCode,
            required String setName,
            required String setType,
            required String collectorNumber,
            required bool digital,
            required String rarity,
            Value<int> rarityOrder = const Value.absent(),
            Value<double?> powerNumeric = const Value.absent(),
            Value<double?> toughnessNumeric = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            required String borderColor,
            required String frame,
            required bool fullArt,
            required bool textless,
            required bool booster,
            required bool storySpotlight,
            required String imageStatus,
            Value<String?> imageSmall = const Value.absent(),
            Value<String?> imageNormal = const Value.absent(),
            Value<String?> imageLarge = const Value.absent(),
            Value<String?> imagePng = const Value.absent(),
            Value<String?> imageArtCrop = const Value.absent(),
            Value<String?> imageBorderCrop = const Value.absent(),
            required String legalStandard,
            required String legalFuture,
            required String legalHistoric,
            required String legalGladiator,
            required String legalPioneer,
            Value<String?> legalExplorer = const Value.absent(),
            required String legalModern,
            required String legalLegacy,
            required String legalPauper,
            required String legalVintage,
            required String legalPenny,
            required String legalCommander,
            required String legalOathbreaker,
            required String legalBrawl,
            Value<String?> legalHistoricbrawl = const Value.absent(),
            required String legalAlchemy,
            required String legalPaupercommander,
            required String legalDuel,
            required String legalOldschool,
            required String legalPremodern,
            required String legalPredh,
            Value<String?> priceUsd = const Value.absent(),
            Value<String?> priceUsdFoil = const Value.absent(),
            Value<String?> priceUsdEtched = const Value.absent(),
            Value<String?> priceEur = const Value.absent(),
            Value<String?> priceEurFoil = const Value.absent(),
            Value<String?> priceTix = const Value.absent(),
            Value<double?> priceNumeric = const Value.absent(),
            Value<String?> cardFacesJson = const Value.absent(),
            Value<String?> rulingsJson = const Value.absent(),
            required String object,
            required bool oversized,
            required bool promo,
            required bool reprint,
            required bool variation,
            Value<String> gamesJson = const Value.absent(),
            required bool reserved,
            required bool foil,
            required bool nonfoil,
            Value<String> finishesJson = const Value.absent(),
            Value<String> producedManaJson = const Value.absent(),
            Value<int?> edhrecRank = const Value.absent(),
            Value<bool?> isGameChanger = const Value.absent(),
            Value<String> relatedTokenIdsJson = const Value.absent(),
            Value<int?> mtgoId = const Value.absent(),
            Value<int?> arenaId = const Value.absent(),
            Value<int?> tcgplayerId = const Value.absent(),
            Value<int?> cardmarketId = const Value.absent(),
          }) =>
              CardsCompanion.insert(
            id: id,
            scryfallId: scryfallId,
            mtgjsonUuid: mtgjsonUuid,
            oracleId: oracleId,
            name: name,
            flavorName: flavorName,
            lang: lang,
            releasedAt: releasedAt,
            uri: uri,
            scryfallUri: scryfallUri,
            layout: layout,
            manaCost: manaCost,
            cmc: cmc,
            typeLine: typeLine,
            oracleText: oracleText,
            flavorText: flavorText,
            power: power,
            toughness: toughness,
            colorsJson: colorsJson,
            colorIdentityJson: colorIdentityJson,
            keywordsJson: keywordsJson,
            colorsString: colorsString,
            colorIdentityString: colorIdentityString,
            legalInAnyFormat: legalInAnyFormat,
            isCanonicalPrinting: isCanonicalPrinting,
            setCode: setCode,
            setName: setName,
            setType: setType,
            collectorNumber: collectorNumber,
            digital: digital,
            rarity: rarity,
            rarityOrder: rarityOrder,
            powerNumeric: powerNumeric,
            toughnessNumeric: toughnessNumeric,
            artist: artist,
            borderColor: borderColor,
            frame: frame,
            fullArt: fullArt,
            textless: textless,
            booster: booster,
            storySpotlight: storySpotlight,
            imageStatus: imageStatus,
            imageSmall: imageSmall,
            imageNormal: imageNormal,
            imageLarge: imageLarge,
            imagePng: imagePng,
            imageArtCrop: imageArtCrop,
            imageBorderCrop: imageBorderCrop,
            legalStandard: legalStandard,
            legalFuture: legalFuture,
            legalHistoric: legalHistoric,
            legalGladiator: legalGladiator,
            legalPioneer: legalPioneer,
            legalExplorer: legalExplorer,
            legalModern: legalModern,
            legalLegacy: legalLegacy,
            legalPauper: legalPauper,
            legalVintage: legalVintage,
            legalPenny: legalPenny,
            legalCommander: legalCommander,
            legalOathbreaker: legalOathbreaker,
            legalBrawl: legalBrawl,
            legalHistoricbrawl: legalHistoricbrawl,
            legalAlchemy: legalAlchemy,
            legalPaupercommander: legalPaupercommander,
            legalDuel: legalDuel,
            legalOldschool: legalOldschool,
            legalPremodern: legalPremodern,
            legalPredh: legalPredh,
            priceUsd: priceUsd,
            priceUsdFoil: priceUsdFoil,
            priceUsdEtched: priceUsdEtched,
            priceEur: priceEur,
            priceEurFoil: priceEurFoil,
            priceTix: priceTix,
            priceNumeric: priceNumeric,
            cardFacesJson: cardFacesJson,
            rulingsJson: rulingsJson,
            object: object,
            oversized: oversized,
            promo: promo,
            reprint: reprint,
            variation: variation,
            gamesJson: gamesJson,
            reserved: reserved,
            foil: foil,
            nonfoil: nonfoil,
            finishesJson: finishesJson,
            producedManaJson: producedManaJson,
            edhrecRank: edhrecRank,
            isGameChanger: isGameChanger,
            relatedTokenIdsJson: relatedTokenIdsJson,
            mtgoId: mtgoId,
            arenaId: arenaId,
            tcgplayerId: tcgplayerId,
            cardmarketId: cardmarketId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardsTableProcessedTableManager = ProcessedTableManager<
    _$CardsDatabase,
    $CardsTable,
    CardRow,
    $$CardsTableFilterComposer,
    $$CardsTableOrderingComposer,
    $$CardsTableAnnotationComposer,
    $$CardsTableCreateCompanionBuilder,
    $$CardsTableUpdateCompanionBuilder,
    (CardRow, BaseReferences<_$CardsDatabase, $CardsTable, CardRow>),
    CardRow,
    PrefetchHooks Function()>;
typedef $$CardPricesTableCreateCompanionBuilder = CardPricesCompanion Function({
  Value<int> id,
  required String scryfallId,
  Value<double?> cardmarketEur,
  Value<double?> cardmarketEurFoil,
  Value<double?> tcgplayerUsd,
  Value<double?> tcgplayerUsdFoil,
  Value<double?> cardKingdomUsd,
  Value<double?> cardKingdomUsdFoil,
  Value<double?> cardKingdomBuylistUsd,
  required String fetchedDate,
});
typedef $$CardPricesTableUpdateCompanionBuilder = CardPricesCompanion Function({
  Value<int> id,
  Value<String> scryfallId,
  Value<double?> cardmarketEur,
  Value<double?> cardmarketEurFoil,
  Value<double?> tcgplayerUsd,
  Value<double?> tcgplayerUsdFoil,
  Value<double?> cardKingdomUsd,
  Value<double?> cardKingdomUsdFoil,
  Value<double?> cardKingdomBuylistUsd,
  Value<String> fetchedDate,
});

class $$CardPricesTableFilterComposer
    extends Composer<_$CardsDatabase, $CardPricesTable> {
  $$CardPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scryfallId => $composableBuilder(
      column: $table.scryfallId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cardmarketEur => $composableBuilder(
      column: $table.cardmarketEur, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cardmarketEurFoil => $composableBuilder(
      column: $table.cardmarketEurFoil,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tcgplayerUsd => $composableBuilder(
      column: $table.tcgplayerUsd, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tcgplayerUsdFoil => $composableBuilder(
      column: $table.tcgplayerUsdFoil,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cardKingdomUsd => $composableBuilder(
      column: $table.cardKingdomUsd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cardKingdomUsdFoil => $composableBuilder(
      column: $table.cardKingdomUsdFoil,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cardKingdomBuylistUsd => $composableBuilder(
      column: $table.cardKingdomBuylistUsd,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fetchedDate => $composableBuilder(
      column: $table.fetchedDate, builder: (column) => ColumnFilters(column));
}

class $$CardPricesTableOrderingComposer
    extends Composer<_$CardsDatabase, $CardPricesTable> {
  $$CardPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scryfallId => $composableBuilder(
      column: $table.scryfallId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cardmarketEur => $composableBuilder(
      column: $table.cardmarketEur,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cardmarketEurFoil => $composableBuilder(
      column: $table.cardmarketEurFoil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tcgplayerUsd => $composableBuilder(
      column: $table.tcgplayerUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tcgplayerUsdFoil => $composableBuilder(
      column: $table.tcgplayerUsdFoil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cardKingdomUsd => $composableBuilder(
      column: $table.cardKingdomUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cardKingdomUsdFoil => $composableBuilder(
      column: $table.cardKingdomUsdFoil,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cardKingdomBuylistUsd => $composableBuilder(
      column: $table.cardKingdomBuylistUsd,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fetchedDate => $composableBuilder(
      column: $table.fetchedDate, builder: (column) => ColumnOrderings(column));
}

class $$CardPricesTableAnnotationComposer
    extends Composer<_$CardsDatabase, $CardPricesTable> {
  $$CardPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get scryfallId => $composableBuilder(
      column: $table.scryfallId, builder: (column) => column);

  GeneratedColumn<double> get cardmarketEur => $composableBuilder(
      column: $table.cardmarketEur, builder: (column) => column);

  GeneratedColumn<double> get cardmarketEurFoil => $composableBuilder(
      column: $table.cardmarketEurFoil, builder: (column) => column);

  GeneratedColumn<double> get tcgplayerUsd => $composableBuilder(
      column: $table.tcgplayerUsd, builder: (column) => column);

  GeneratedColumn<double> get tcgplayerUsdFoil => $composableBuilder(
      column: $table.tcgplayerUsdFoil, builder: (column) => column);

  GeneratedColumn<double> get cardKingdomUsd => $composableBuilder(
      column: $table.cardKingdomUsd, builder: (column) => column);

  GeneratedColumn<double> get cardKingdomUsdFoil => $composableBuilder(
      column: $table.cardKingdomUsdFoil, builder: (column) => column);

  GeneratedColumn<double> get cardKingdomBuylistUsd => $composableBuilder(
      column: $table.cardKingdomBuylistUsd, builder: (column) => column);

  GeneratedColumn<String> get fetchedDate => $composableBuilder(
      column: $table.fetchedDate, builder: (column) => column);
}

class $$CardPricesTableTableManager extends RootTableManager<
    _$CardsDatabase,
    $CardPricesTable,
    CardPriceRow,
    $$CardPricesTableFilterComposer,
    $$CardPricesTableOrderingComposer,
    $$CardPricesTableAnnotationComposer,
    $$CardPricesTableCreateCompanionBuilder,
    $$CardPricesTableUpdateCompanionBuilder,
    (
      CardPriceRow,
      BaseReferences<_$CardsDatabase, $CardPricesTable, CardPriceRow>
    ),
    CardPriceRow,
    PrefetchHooks Function()> {
  $$CardPricesTableTableManager(_$CardsDatabase db, $CardPricesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> scryfallId = const Value.absent(),
            Value<double?> cardmarketEur = const Value.absent(),
            Value<double?> cardmarketEurFoil = const Value.absent(),
            Value<double?> tcgplayerUsd = const Value.absent(),
            Value<double?> tcgplayerUsdFoil = const Value.absent(),
            Value<double?> cardKingdomUsd = const Value.absent(),
            Value<double?> cardKingdomUsdFoil = const Value.absent(),
            Value<double?> cardKingdomBuylistUsd = const Value.absent(),
            Value<String> fetchedDate = const Value.absent(),
          }) =>
              CardPricesCompanion(
            id: id,
            scryfallId: scryfallId,
            cardmarketEur: cardmarketEur,
            cardmarketEurFoil: cardmarketEurFoil,
            tcgplayerUsd: tcgplayerUsd,
            tcgplayerUsdFoil: tcgplayerUsdFoil,
            cardKingdomUsd: cardKingdomUsd,
            cardKingdomUsdFoil: cardKingdomUsdFoil,
            cardKingdomBuylistUsd: cardKingdomBuylistUsd,
            fetchedDate: fetchedDate,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String scryfallId,
            Value<double?> cardmarketEur = const Value.absent(),
            Value<double?> cardmarketEurFoil = const Value.absent(),
            Value<double?> tcgplayerUsd = const Value.absent(),
            Value<double?> tcgplayerUsdFoil = const Value.absent(),
            Value<double?> cardKingdomUsd = const Value.absent(),
            Value<double?> cardKingdomUsdFoil = const Value.absent(),
            Value<double?> cardKingdomBuylistUsd = const Value.absent(),
            required String fetchedDate,
          }) =>
              CardPricesCompanion.insert(
            id: id,
            scryfallId: scryfallId,
            cardmarketEur: cardmarketEur,
            cardmarketEurFoil: cardmarketEurFoil,
            tcgplayerUsd: tcgplayerUsd,
            tcgplayerUsdFoil: tcgplayerUsdFoil,
            cardKingdomUsd: cardKingdomUsd,
            cardKingdomUsdFoil: cardKingdomUsdFoil,
            cardKingdomBuylistUsd: cardKingdomBuylistUsd,
            fetchedDate: fetchedDate,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CardPricesTableProcessedTableManager = ProcessedTableManager<
    _$CardsDatabase,
    $CardPricesTable,
    CardPriceRow,
    $$CardPricesTableFilterComposer,
    $$CardPricesTableOrderingComposer,
    $$CardPricesTableAnnotationComposer,
    $$CardPricesTableCreateCompanionBuilder,
    $$CardPricesTableUpdateCompanionBuilder,
    (
      CardPriceRow,
      BaseReferences<_$CardsDatabase, $CardPricesTable, CardPriceRow>
    ),
    CardPriceRow,
    PrefetchHooks Function()>;
typedef $$FilterMetadataTableCreateCompanionBuilder = FilterMetadataCompanion
    Function({
  Value<int> id,
  required String key,
  Value<String> setsJson,
  Value<String> setsMapJson,
  Value<String> raritiesJson,
  Value<String> keywordsJson,
  Value<String> setMetadataJson,
  required DateTime updatedAt,
});
typedef $$FilterMetadataTableUpdateCompanionBuilder = FilterMetadataCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<String> setsJson,
  Value<String> setsMapJson,
  Value<String> raritiesJson,
  Value<String> keywordsJson,
  Value<String> setMetadataJson,
  Value<DateTime> updatedAt,
});

class $$FilterMetadataTableFilterComposer
    extends Composer<_$CardsDatabase, $FilterMetadataTable> {
  $$FilterMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setsJson => $composableBuilder(
      column: $table.setsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setsMapJson => $composableBuilder(
      column: $table.setsMapJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get raritiesJson => $composableBuilder(
      column: $table.raritiesJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setMetadataJson => $composableBuilder(
      column: $table.setMetadataJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FilterMetadataTableOrderingComposer
    extends Composer<_$CardsDatabase, $FilterMetadataTable> {
  $$FilterMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setsJson => $composableBuilder(
      column: $table.setsJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setsMapJson => $composableBuilder(
      column: $table.setsMapJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get raritiesJson => $composableBuilder(
      column: $table.raritiesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setMetadataJson => $composableBuilder(
      column: $table.setMetadataJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FilterMetadataTableAnnotationComposer
    extends Composer<_$CardsDatabase, $FilterMetadataTable> {
  $$FilterMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get setsJson =>
      $composableBuilder(column: $table.setsJson, builder: (column) => column);

  GeneratedColumn<String> get setsMapJson => $composableBuilder(
      column: $table.setsMapJson, builder: (column) => column);

  GeneratedColumn<String> get raritiesJson => $composableBuilder(
      column: $table.raritiesJson, builder: (column) => column);

  GeneratedColumn<String> get keywordsJson => $composableBuilder(
      column: $table.keywordsJson, builder: (column) => column);

  GeneratedColumn<String> get setMetadataJson => $composableBuilder(
      column: $table.setMetadataJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FilterMetadataTableTableManager extends RootTableManager<
    _$CardsDatabase,
    $FilterMetadataTable,
    FilterMetadataRow,
    $$FilterMetadataTableFilterComposer,
    $$FilterMetadataTableOrderingComposer,
    $$FilterMetadataTableAnnotationComposer,
    $$FilterMetadataTableCreateCompanionBuilder,
    $$FilterMetadataTableUpdateCompanionBuilder,
    (
      FilterMetadataRow,
      BaseReferences<_$CardsDatabase, $FilterMetadataTable, FilterMetadataRow>
    ),
    FilterMetadataRow,
    PrefetchHooks Function()> {
  $$FilterMetadataTableTableManager(
      _$CardsDatabase db, $FilterMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FilterMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FilterMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FilterMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> setsJson = const Value.absent(),
            Value<String> setsMapJson = const Value.absent(),
            Value<String> raritiesJson = const Value.absent(),
            Value<String> keywordsJson = const Value.absent(),
            Value<String> setMetadataJson = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              FilterMetadataCompanion(
            id: id,
            key: key,
            setsJson: setsJson,
            setsMapJson: setsMapJson,
            raritiesJson: raritiesJson,
            keywordsJson: keywordsJson,
            setMetadataJson: setMetadataJson,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            Value<String> setsJson = const Value.absent(),
            Value<String> setsMapJson = const Value.absent(),
            Value<String> raritiesJson = const Value.absent(),
            Value<String> keywordsJson = const Value.absent(),
            Value<String> setMetadataJson = const Value.absent(),
            required DateTime updatedAt,
          }) =>
              FilterMetadataCompanion.insert(
            id: id,
            key: key,
            setsJson: setsJson,
            setsMapJson: setsMapJson,
            raritiesJson: raritiesJson,
            keywordsJson: keywordsJson,
            setMetadataJson: setMetadataJson,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FilterMetadataTableProcessedTableManager = ProcessedTableManager<
    _$CardsDatabase,
    $FilterMetadataTable,
    FilterMetadataRow,
    $$FilterMetadataTableFilterComposer,
    $$FilterMetadataTableOrderingComposer,
    $$FilterMetadataTableAnnotationComposer,
    $$FilterMetadataTableCreateCompanionBuilder,
    $$FilterMetadataTableUpdateCompanionBuilder,
    (
      FilterMetadataRow,
      BaseReferences<_$CardsDatabase, $FilterMetadataTable, FilterMetadataRow>
    ),
    FilterMetadataRow,
    PrefetchHooks Function()>;
typedef $$PreconDecksTableCreateCompanionBuilder = PreconDecksCompanion
    Function({
  Value<int> id,
  required String name,
  required String setCode,
  Value<String> setName,
  required String type,
  Value<String> releaseDate,
  Value<String> mainBoardJson,
  Value<String> sideBoardJson,
  Value<String> commandersJson,
  Value<String?> featuredCardScryfallId,
  Value<String> colorIdentityString,
});
typedef $$PreconDecksTableUpdateCompanionBuilder = PreconDecksCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String> setCode,
  Value<String> setName,
  Value<String> type,
  Value<String> releaseDate,
  Value<String> mainBoardJson,
  Value<String> sideBoardJson,
  Value<String> commandersJson,
  Value<String?> featuredCardScryfallId,
  Value<String> colorIdentityString,
});

class $$PreconDecksTableFilterComposer
    extends Composer<_$CardsDatabase, $PreconDecksTable> {
  $$PreconDecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setCode => $composableBuilder(
      column: $table.setCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setName => $composableBuilder(
      column: $table.setName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mainBoardJson => $composableBuilder(
      column: $table.mainBoardJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sideBoardJson => $composableBuilder(
      column: $table.sideBoardJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commandersJson => $composableBuilder(
      column: $table.commandersJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get featuredCardScryfallId => $composableBuilder(
      column: $table.featuredCardScryfallId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorIdentityString => $composableBuilder(
      column: $table.colorIdentityString,
      builder: (column) => ColumnFilters(column));
}

class $$PreconDecksTableOrderingComposer
    extends Composer<_$CardsDatabase, $PreconDecksTable> {
  $$PreconDecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setCode => $composableBuilder(
      column: $table.setCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setName => $composableBuilder(
      column: $table.setName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mainBoardJson => $composableBuilder(
      column: $table.mainBoardJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sideBoardJson => $composableBuilder(
      column: $table.sideBoardJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commandersJson => $composableBuilder(
      column: $table.commandersJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get featuredCardScryfallId => $composableBuilder(
      column: $table.featuredCardScryfallId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorIdentityString => $composableBuilder(
      column: $table.colorIdentityString,
      builder: (column) => ColumnOrderings(column));
}

class $$PreconDecksTableAnnotationComposer
    extends Composer<_$CardsDatabase, $PreconDecksTable> {
  $$PreconDecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get setCode =>
      $composableBuilder(column: $table.setCode, builder: (column) => column);

  GeneratedColumn<String> get setName =>
      $composableBuilder(column: $table.setName, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => column);

  GeneratedColumn<String> get mainBoardJson => $composableBuilder(
      column: $table.mainBoardJson, builder: (column) => column);

  GeneratedColumn<String> get sideBoardJson => $composableBuilder(
      column: $table.sideBoardJson, builder: (column) => column);

  GeneratedColumn<String> get commandersJson => $composableBuilder(
      column: $table.commandersJson, builder: (column) => column);

  GeneratedColumn<String> get featuredCardScryfallId => $composableBuilder(
      column: $table.featuredCardScryfallId, builder: (column) => column);

  GeneratedColumn<String> get colorIdentityString => $composableBuilder(
      column: $table.colorIdentityString, builder: (column) => column);
}

class $$PreconDecksTableTableManager extends RootTableManager<
    _$CardsDatabase,
    $PreconDecksTable,
    PreconDeckRow,
    $$PreconDecksTableFilterComposer,
    $$PreconDecksTableOrderingComposer,
    $$PreconDecksTableAnnotationComposer,
    $$PreconDecksTableCreateCompanionBuilder,
    $$PreconDecksTableUpdateCompanionBuilder,
    (
      PreconDeckRow,
      BaseReferences<_$CardsDatabase, $PreconDecksTable, PreconDeckRow>
    ),
    PreconDeckRow,
    PrefetchHooks Function()> {
  $$PreconDecksTableTableManager(_$CardsDatabase db, $PreconDecksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreconDecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreconDecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreconDecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> setCode = const Value.absent(),
            Value<String> setName = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> releaseDate = const Value.absent(),
            Value<String> mainBoardJson = const Value.absent(),
            Value<String> sideBoardJson = const Value.absent(),
            Value<String> commandersJson = const Value.absent(),
            Value<String?> featuredCardScryfallId = const Value.absent(),
            Value<String> colorIdentityString = const Value.absent(),
          }) =>
              PreconDecksCompanion(
            id: id,
            name: name,
            setCode: setCode,
            setName: setName,
            type: type,
            releaseDate: releaseDate,
            mainBoardJson: mainBoardJson,
            sideBoardJson: sideBoardJson,
            commandersJson: commandersJson,
            featuredCardScryfallId: featuredCardScryfallId,
            colorIdentityString: colorIdentityString,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String setCode,
            Value<String> setName = const Value.absent(),
            required String type,
            Value<String> releaseDate = const Value.absent(),
            Value<String> mainBoardJson = const Value.absent(),
            Value<String> sideBoardJson = const Value.absent(),
            Value<String> commandersJson = const Value.absent(),
            Value<String?> featuredCardScryfallId = const Value.absent(),
            Value<String> colorIdentityString = const Value.absent(),
          }) =>
              PreconDecksCompanion.insert(
            id: id,
            name: name,
            setCode: setCode,
            setName: setName,
            type: type,
            releaseDate: releaseDate,
            mainBoardJson: mainBoardJson,
            sideBoardJson: sideBoardJson,
            commandersJson: commandersJson,
            featuredCardScryfallId: featuredCardScryfallId,
            colorIdentityString: colorIdentityString,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PreconDecksTableProcessedTableManager = ProcessedTableManager<
    _$CardsDatabase,
    $PreconDecksTable,
    PreconDeckRow,
    $$PreconDecksTableFilterComposer,
    $$PreconDecksTableOrderingComposer,
    $$PreconDecksTableAnnotationComposer,
    $$PreconDecksTableCreateCompanionBuilder,
    $$PreconDecksTableUpdateCompanionBuilder,
    (
      PreconDeckRow,
      BaseReferences<_$CardsDatabase, $PreconDecksTable, PreconDeckRow>
    ),
    PreconDeckRow,
    PrefetchHooks Function()>;

class $CardsDatabaseManager {
  final _$CardsDatabase _db;
  $CardsDatabaseManager(this._db);
  $$CardsTableTableManager get cards =>
      $$CardsTableTableManager(_db, _db.cards);
  $$CardPricesTableTableManager get cardPrices =>
      $$CardPricesTableTableManager(_db, _db.cardPrices);
  $$FilterMetadataTableTableManager get filterMetadata =>
      $$FilterMetadataTableTableManager(_db, _db.filterMetadata);
  $$PreconDecksTableTableManager get preconDecks =>
      $$PreconDecksTableTableManager(_db, _db.preconDecks);
}
