// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Favorites
  internal static let favoritesScreenTitle = L10n.tr("Localizable", "favorites_screen_title")
  /// Filter
  internal static let filter = L10n.tr("Localizable", "filter")
  /// Hot Updates
  internal static let hotUpdates = L10n.tr("Localizable", "hot_updates")
  /// Language
  internal static let language = L10n.tr("Localizable", "language")
  /// Latest News
  internal static let latestNews = L10n.tr("Localizable", "latest_news")
  /// Login
  internal static let loginButton = L10n.tr("Localizable", "login_button")
  /// or connect with
  internal static let loginConnectWith = L10n.tr("Localizable", "login_connect_with")
  /// Email Address
  internal static let loginEmail = L10n.tr("Localizable", "login_email")
  /// Wrong email address or password
  internal static let loginError = L10n.tr("Localizable", "login_error")
  /// facebook
  internal static let loginFacebook = L10n.tr("Localizable", "login_facebook")
  /// Forget password
  internal static let loginForgetPassword = L10n.tr("Localizable", "login_forget_password")
  /// By signing in you are agreeing our Term and privacy policy
  internal static let loginInfo = L10n.tr("Localizable", "login_info")
  /// Term and privacy policy
  internal static let loginInfoLink = L10n.tr("Localizable", "login_info_link")
  /// Instagram
  internal static let loginInstagram = L10n.tr("Localizable", "login_instagram")
  /// LinkedIn
  internal static let loginLinkedin = L10n.tr("Localizable", "login_linkedin")
  /// Password
  internal static let loginPassword = L10n.tr("Localizable", "login_password")
  /// Register
  internal static let loginRegisterButton = L10n.tr("Localizable", "login_register_button")
  /// Remember password
  internal static let loginRememberPassword = L10n.tr("Localizable", "login_remember_password")
  /// Login
  internal static let loginTitle = L10n.tr("Localizable", "login_title")
  /// Login with %@
  internal static func loginWith(_ p1: Any) -> String {
    return L10n.tr("Localizable", "login_with", String(describing: p1))
  }
  /// Login with Face ID
  internal static let loginWithFaceId = L10n.tr("Localizable", "login_with_face_id")
  /// Published by %@
  internal static func publishedBy(_ p1: Any) -> String {
    return L10n.tr("Localizable", "published_by", String(describing: p1))
  }
  ///  Read Less
  internal static let readLess = L10n.tr("Localizable", "read_less")
  /// ...Read More
  internal static let readMore = L10n.tr("Localizable", "read_more")
  /// Reset
  internal static let resetBtn = L10n.tr("Localizable", "reset_btn")
  /// SAVE
  internal static let saveBtn = L10n.tr("Localizable", "save_btn")
  /// About %@ results for %@
  internal static func searchSummary(_ p1: Any, _ p2: Any) -> String {
    return L10n.tr("Localizable", "search_summary", String(describing: p1), String(describing: p2))
  }
  /// See All
  internal static let seeAll = L10n.tr("Localizable", "see_all")
  /// Sort
  internal static let sort = L10n.tr("Localizable", "sort")
  /// Favorite
  internal static let tabFavorite = L10n.tr("Localizable", "tab_favorite")
  /// Home
  internal static let tabHome = L10n.tr("Localizable", "tab_home")
  /// Profile
  internal static let tabProfile = L10n.tr("Localizable", "tab_profile")
  /// Today at %@
  internal static func today(_ p1: Any) -> String {
    return L10n.tr("Localizable", "today", String(describing: p1))
  }
  /// Yesterday at %@
  internal static func yesterday(_ p1: Any) -> String {
    return L10n.tr("Localizable", "yesterday", String(describing: p1))
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
