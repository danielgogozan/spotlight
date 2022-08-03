// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIFont
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "FontConvertible.Font", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias Font = FontConvertible.Font

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Fonts

// swiftlint:disable identifier_name line_length type_body_length
internal enum FontFamily {
  internal enum NewYorkSmall {
    internal static let heavy = FontConvertible(name: "NewYorkSmall-Heavy", family: "New York Small", path: "FontsFree-Net-NewYorkSmallHeavy.ttf")
    internal static let regular = FontConvertible(name: "NewYorkSmall-Regular", family: "New York Small", path: "FontsFree-Net-NewYorkSmallRegular.ttf")
    internal static let semibold = FontConvertible(name: "NewYorkSmall-Semibold", family: "New York Small", path: "FontsFree-Net-NewYorkSmallSemibold.ttf")
    internal static let all: [FontConvertible] = [heavy, regular, semibold]
  }
  internal enum Nunito {
    internal static let black = FontConvertible(name: "Nunito-Black", family: "Nunito", path: "Nunito-Black.ttf")
    internal static let bold = FontConvertible(name: "Nunito-Bold", family: "Nunito", path: "Nunito-Bold.ttf")
    internal static let extraBold = FontConvertible(name: "Nunito-ExtraBold", family: "Nunito", path: "Nunito-ExtraBold.ttf")
    internal static let light = FontConvertible(name: "Nunito-Light", family: "Nunito", path: "Nunito-Light.ttf")
    internal static let regular = FontConvertible(name: "Nunito-Regular", family: "Nunito", path: "Nunito-Regular.ttf")
    internal static let semiBold = FontConvertible(name: "Nunito-SemiBold", family: "Nunito", path: "Nunito-SemiBold.ttf")
    internal static let semiBoldItalic = FontConvertible(name: "Nunito-SemiBoldItalic", family: "Nunito", path: "Nunito-SemiBoldItalic.ttf")
    internal static let all: [FontConvertible] = [black, bold, extraBold, light, regular, semiBold, semiBoldItalic]
  }
  internal static let allCustomFonts: [FontConvertible] = [NewYorkSmall.all, Nunito.all].flatMap { $0 }
  internal static func registerAllCustomFonts() {
    allCustomFonts.forEach { $0.register() }
  }
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

internal struct FontConvertible {
  internal let name: String
  internal let family: String
  internal let path: String

  #if os(macOS)
  internal typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Font = UIFont
  #endif

  internal func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  internal func register() {
    // swiftlint:disable:next conditional_returns_on_newline
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    // swiftlint:disable:next implicit_return
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

internal extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
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
