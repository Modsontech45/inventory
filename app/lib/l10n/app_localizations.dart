import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'ENVentory'**
  String get appTitle;

  /// No description provided for @sell.
  ///
  /// In fr, this message translates to:
  /// **'Vendre'**
  String get sell;

  /// No description provided for @stock.
  ///
  /// In fr, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @receiveGoods.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir marchandise'**
  String get receiveGoods;

  /// No description provided for @clientsDebts.
  ///
  /// In fr, this message translates to:
  /// **'Clients / Dettes'**
  String get clientsDebts;

  /// No description provided for @reports.
  ///
  /// In fr, this message translates to:
  /// **'Rapports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @dashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboard;

  /// No description provided for @today.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In fr, this message translates to:
  /// **'Cette semaine'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get thisMonth;

  /// No description provided for @custom.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisé'**
  String get custom;

  /// No description provided for @totalSales.
  ///
  /// In fr, this message translates to:
  /// **'Ventes totales'**
  String get totalSales;

  /// No description provided for @grossProfit.
  ///
  /// In fr, this message translates to:
  /// **'Bénéfice brut'**
  String get grossProfit;

  /// No description provided for @stockValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur du stock'**
  String get stockValue;

  /// No description provided for @customerDebts.
  ///
  /// In fr, this message translates to:
  /// **'Dettes clients'**
  String get customerDebts;

  /// No description provided for @expenses.
  ///
  /// In fr, this message translates to:
  /// **'Dépenses'**
  String get expenses;

  /// No description provided for @salesCount.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de ventes'**
  String get salesCount;

  /// No description provided for @lowStock.
  ///
  /// In fr, this message translates to:
  /// **'Stock faible'**
  String get lowStock;

  /// No description provided for @outOfStock.
  ///
  /// In fr, this message translates to:
  /// **'Rupture de stock'**
  String get outOfStock;

  /// No description provided for @employees.
  ///
  /// In fr, this message translates to:
  /// **'Employés'**
  String get employees;

  /// No description provided for @recentSales.
  ///
  /// In fr, this message translates to:
  /// **'Ventes récentes'**
  String get recentSales;

  /// No description provided for @cash.
  ///
  /// In fr, this message translates to:
  /// **'Espèces'**
  String get cash;

  /// No description provided for @flooz.
  ///
  /// In fr, this message translates to:
  /// **'Flooz'**
  String get flooz;

  /// No description provided for @mixx.
  ///
  /// In fr, this message translates to:
  /// **'Mixx by Yas'**
  String get mixx;

  /// No description provided for @bank.
  ///
  /// In fr, this message translates to:
  /// **'Virement bancaire'**
  String get bank;

  /// No description provided for @credit.
  ///
  /// In fr, this message translates to:
  /// **'Crédit'**
  String get credit;

  /// No description provided for @mixed.
  ///
  /// In fr, this message translates to:
  /// **'Mixte'**
  String get mixed;

  /// No description provided for @pay.
  ///
  /// In fr, this message translates to:
  /// **'Payer'**
  String get pay;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get add;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @product.
  ///
  /// In fr, this message translates to:
  /// **'Produit'**
  String get product;

  /// No description provided for @products.
  ///
  /// In fr, this message translates to:
  /// **'Produits'**
  String get products;

  /// No description provided for @quantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get price;

  /// No description provided for @total.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @customer.
  ///
  /// In fr, this message translates to:
  /// **'Client'**
  String get customer;

  /// No description provided for @customers.
  ///
  /// In fr, this message translates to:
  /// **'Clients'**
  String get customers;

  /// No description provided for @supplier.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseur'**
  String get supplier;

  /// No description provided for @suppliers.
  ///
  /// In fr, this message translates to:
  /// **'Fournisseurs'**
  String get suppliers;

  /// No description provided for @user.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get user;

  /// No description provided for @users.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateurs'**
  String get users;

  /// No description provided for @depot.
  ///
  /// In fr, this message translates to:
  /// **'Dépôt'**
  String get depot;

  /// No description provided for @depots.
  ///
  /// In fr, this message translates to:
  /// **'Dépôts'**
  String get depots;

  /// No description provided for @name.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse'**
  String get address;

  /// No description provided for @notes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @date.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @amount.
  ///
  /// In fr, this message translates to:
  /// **'Montant'**
  String get amount;

  /// No description provided for @balance.
  ///
  /// In fr, this message translates to:
  /// **'Solde'**
  String get balance;

  /// No description provided for @debt.
  ///
  /// In fr, this message translates to:
  /// **'Dette'**
  String get debt;

  /// No description provided for @payment.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get payment;

  /// No description provided for @payments.
  ///
  /// In fr, this message translates to:
  /// **'Paiements'**
  String get payments;

  /// No description provided for @sale.
  ///
  /// In fr, this message translates to:
  /// **'Vente'**
  String get sale;

  /// No description provided for @sales.
  ///
  /// In fr, this message translates to:
  /// **'Ventes'**
  String get sales;

  /// No description provided for @receipt.
  ///
  /// In fr, this message translates to:
  /// **'Reçu'**
  String get receipt;

  /// No description provided for @invoice.
  ///
  /// In fr, this message translates to:
  /// **'Facture'**
  String get invoice;

  /// No description provided for @quote.
  ///
  /// In fr, this message translates to:
  /// **'Devis'**
  String get quote;

  /// No description provided for @delivery.
  ///
  /// In fr, this message translates to:
  /// **'Livraison'**
  String get delivery;

  /// No description provided for @category.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categories;

  /// No description provided for @unit.
  ///
  /// In fr, this message translates to:
  /// **'Unité'**
  String get unit;

  /// No description provided for @units.
  ///
  /// In fr, this message translates to:
  /// **'Unités'**
  String get units;

  /// No description provided for @brand.
  ///
  /// In fr, this message translates to:
  /// **'Marque'**
  String get brand;

  /// No description provided for @barcode.
  ///
  /// In fr, this message translates to:
  /// **'Code-barres'**
  String get barcode;

  /// No description provided for @retailPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix de détail'**
  String get retailPrice;

  /// No description provided for @wholesalePrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix de gros'**
  String get wholesalePrice;

  /// No description provided for @purchasePrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix d\'achat'**
  String get purchasePrice;

  /// No description provided for @minStock.
  ///
  /// In fr, this message translates to:
  /// **'Stock minimum'**
  String get minStock;

  /// No description provided for @inStock.
  ///
  /// In fr, this message translates to:
  /// **'En stock'**
  String get inStock;

  /// No description provided for @all.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get all;

  /// No description provided for @filter.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer'**
  String get filter;

  /// No description provided for @export.
  ///
  /// In fr, this message translates to:
  /// **'Exporter'**
  String get export;

  /// No description provided for @print.
  ///
  /// In fr, this message translates to:
  /// **'Imprimer'**
  String get print;

  /// No description provided for @share.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get share;

  /// No description provided for @syncNow.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer maintenant'**
  String get syncNow;

  /// No description provided for @syncOk.
  ///
  /// In fr, this message translates to:
  /// **'Tout est enregistré'**
  String get syncOk;

  /// No description provided for @syncWaiting.
  ///
  /// In fr, this message translates to:
  /// **'En attente d\'internet — vos données sont sauvées sur l\'appareil'**
  String get syncWaiting;

  /// No description provided for @login.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get logout;

  /// No description provided for @pin.
  ///
  /// In fr, this message translates to:
  /// **'Code PIN'**
  String get pin;

  /// No description provided for @enterPin.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre PIN'**
  String get enterPin;

  /// No description provided for @wrongPin.
  ///
  /// In fr, this message translates to:
  /// **'PIN incorrect'**
  String get wrongPin;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get error;

  /// No description provided for @success.
  ///
  /// In fr, this message translates to:
  /// **'Succès'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In fr, this message translates to:
  /// **'Attention'**
  String get warning;

  /// No description provided for @noData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @cancelSale.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la vente'**
  String get cancelSale;

  /// No description provided for @cancelReason.
  ///
  /// In fr, this message translates to:
  /// **'Raison de l\'annulation'**
  String get cancelReason;

  /// No description provided for @saleNumber.
  ///
  /// In fr, this message translates to:
  /// **'N° Vente'**
  String get saleNumber;

  /// No description provided for @change.
  ///
  /// In fr, this message translates to:
  /// **'Monnaie à rendre'**
  String get change;

  /// No description provided for @discount.
  ///
  /// In fr, this message translates to:
  /// **'Remise'**
  String get discount;

  /// No description provided for @tax.
  ///
  /// In fr, this message translates to:
  /// **'TVA'**
  String get tax;

  /// No description provided for @subtotal.
  ///
  /// In fr, this message translates to:
  /// **'Sous-total'**
  String get subtotal;

  /// No description provided for @fcfa.
  ///
  /// In fr, this message translates to:
  /// **'FCFA'**
  String get fcfa;

  /// No description provided for @seller.
  ///
  /// In fr, this message translates to:
  /// **'Vendeur'**
  String get seller;

  /// No description provided for @soldBy.
  ///
  /// In fr, this message translates to:
  /// **'Vendu par'**
  String get soldBy;

  /// No description provided for @margin.
  ///
  /// In fr, this message translates to:
  /// **'Marge'**
  String get margin;

  /// No description provided for @profit.
  ///
  /// In fr, this message translates to:
  /// **'Bénéfice'**
  String get profit;

  /// No description provided for @netProfit.
  ///
  /// In fr, this message translates to:
  /// **'Bénéfice net'**
  String get netProfit;

  /// No description provided for @period.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get period;

  /// No description provided for @from.
  ///
  /// In fr, this message translates to:
  /// **'Du'**
  String get from;

  /// No description provided for @to.
  ///
  /// In fr, this message translates to:
  /// **'Au'**
  String get to;

  /// No description provided for @depot_all.
  ///
  /// In fr, this message translates to:
  /// **'Tous les dépôts'**
  String get depot_all;

  /// No description provided for @topProducts.
  ///
  /// In fr, this message translates to:
  /// **'Meilleurs produits'**
  String get topProducts;

  /// No description provided for @salesByMethod.
  ///
  /// In fr, this message translates to:
  /// **'Ventes par mode de paiement'**
  String get salesByMethod;

  /// No description provided for @salesByEmployee.
  ///
  /// In fr, this message translates to:
  /// **'Ventes par employé'**
  String get salesByEmployee;

  /// No description provided for @salesTrend.
  ///
  /// In fr, this message translates to:
  /// **'Évolution des ventes'**
  String get salesTrend;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
