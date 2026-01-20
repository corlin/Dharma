// Typography.swift
// Dharma Design System - Typography System

import SwiftUI

// MARK: - Font Tokens
extension Font {

  // MARK: - Display
  static let displayLarge = Font.system(size: 57, weight: .bold, design: .rounded)
  static let displayMedium = Font.system(size: 45, weight: .bold, design: .rounded)
  static let displaySmall = Font.system(size: 36, weight: .bold, design: .rounded)

  // MARK: - Headline
  static let headlineLarge = Font.system(size: 32, weight: .semibold, design: .rounded)
  static let headlineMedium = Font.system(size: 28, weight: .semibold, design: .rounded)
  static let headlineSmall = Font.system(size: 24, weight: .semibold, design: .rounded)

  // MARK: - Title
  static let titleLarge = Font.system(size: 22, weight: .semibold, design: .rounded)
  static let titleMedium = Font.system(size: 16, weight: .medium, design: .rounded)
  static let titleSmall = Font.system(size: 14, weight: .medium, design: .rounded)

  // MARK: - Body
  static let bodyLarge = Font.system(size: 16, weight: .regular, design: .rounded)
  static let bodyMedium = Font.system(size: 14, weight: .regular, design: .rounded)
  static let bodySmall = Font.system(size: 12, weight: .regular, design: .rounded)

  // MARK: - Label
  static let labelLarge = Font.system(size: 14, weight: .medium, design: .rounded)
  static let labelMedium = Font.system(size: 12, weight: .medium, design: .rounded)
  static let labelSmall = Font.system(size: 11, weight: .medium, design: .rounded)

  // MARK: - Timer (特殊用途)
  static let timer = Font.system(size: 64, weight: .bold, design: .monospaced)
  static let timerSmall = Font.system(size: 32, weight: .semibold, design: .monospaced)
}

// MARK: - Text Styles
struct DharmaTextStyle: ViewModifier {
  enum Style {
    case displayLarge, displayMedium, displaySmall
    case headlineLarge, headlineMedium, headlineSmall
    case titleLarge, titleMedium, titleSmall
    case bodyLarge, bodyMedium, bodySmall
    case labelLarge, labelMedium, labelSmall
  }

  let style: Style

  func body(content: Content) -> some View {
    content
      .font(font)
      .lineSpacing(lineSpacing)
  }

  private var font: Font {
    switch style {
    case .displayLarge: return .displayLarge
    case .displayMedium: return .displayMedium
    case .displaySmall: return .displaySmall
    case .headlineLarge: return .headlineLarge
    case .headlineMedium: return .headlineMedium
    case .headlineSmall: return .headlineSmall
    case .titleLarge: return .titleLarge
    case .titleMedium: return .titleMedium
    case .titleSmall: return .titleSmall
    case .bodyLarge: return .bodyLarge
    case .bodyMedium: return .bodyMedium
    case .bodySmall: return .bodySmall
    case .labelLarge: return .labelLarge
    case .labelMedium: return .labelMedium
    case .labelSmall: return .labelSmall
    }
  }

  private var lineSpacing: CGFloat {
    switch style {
    case .displayLarge, .displayMedium, .displaySmall: return 8
    case .headlineLarge, .headlineMedium, .headlineSmall: return 6
    case .titleLarge, .titleMedium, .titleSmall: return 4
    case .bodyLarge, .bodyMedium, .bodySmall: return 4
    case .labelLarge, .labelMedium, .labelSmall: return 2
    }
  }
}

extension View {
  func dharmaTextStyle(_ style: DharmaTextStyle.Style) -> some View {
    modifier(DharmaTextStyle(style: style))
  }
}
