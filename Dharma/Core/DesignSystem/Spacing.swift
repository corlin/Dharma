// Spacing.swift
// Dharma Design System - Spacing System (8pt Grid)

import SwiftUI

// MARK: - Spacing Tokens
enum Spacing {
  /// 4pt - 微小间距
  static let xxs: CGFloat = 4

  /// 8pt - 超小间距
  static let xs: CGFloat = 8

  /// 12pt - 小间距
  static let sm: CGFloat = 12

  /// 16pt - 中等间距
  static let md: CGFloat = 16

  /// 24pt - 大间距
  static let lg: CGFloat = 24

  /// 32pt - 超大间距
  static let xl: CGFloat = 32

  /// 48pt - 巨大间距
  static let xxl: CGFloat = 48

  /// 64pt - 特大间距
  static let xxxl: CGFloat = 64
}

// MARK: - Corner Radius Tokens
enum CornerRadius {
  /// 8pt - 小圆角（按钮、输入框）
  static let small: CGFloat = 8

  /// 12pt - 中圆角（标签芯片）
  static let medium: CGFloat = 12

  /// 16pt - 大圆角（卡片）
  static let large: CGFloat = 16

  /// 24pt - 超大圆角（模态框）
  static let extraLarge: CGFloat = 24

  /// 32pt - 浮动元素（导航栏）
  static let floating: CGFloat = 32

  /// 完全圆形
  static let full: CGFloat = 999
}

// MARK: - Shadow Tokens
struct DharmaShadow {
  let color: Color
  let radius: CGFloat
  let x: CGFloat
  let y: CGFloat

  /// 轻微阴影 - 用于卡片
  static let light = DharmaShadow(
    color: Color.black.opacity(0.08),
    radius: 8,
    x: 0,
    y: 4
  )

  /// 中等阴影 - 用于浮动元素
  static let medium = DharmaShadow(
    color: Color.black.opacity(0.12),
    radius: 16,
    x: 0,
    y: 8
  )

  /// 强烈阴影 - 用于模态框
  static let heavy = DharmaShadow(
    color: Color.black.opacity(0.16),
    radius: 24,
    x: 0,
    y: 12
  )

  /// 光晕效果 - 用于品牌元素
  static let glow = DharmaShadow(
    color: Color.excavate.opacity(0.4),
    radius: 20,
    x: 0,
    y: 0
  )
}

// MARK: - Shadow View Modifier
extension View {
  func dharmaShadow(_ shadow: DharmaShadow) -> some View {
    self.shadow(
      color: shadow.color,
      radius: shadow.radius,
      x: shadow.x,
      y: shadow.y
    )
  }
}

// MARK: - Padding Helpers
extension View {
  func horizontalPadding(_ spacing: CGFloat = Spacing.md) -> some View {
    self.padding(.horizontal, spacing)
  }

  func verticalPadding(_ spacing: CGFloat = Spacing.md) -> some View {
    self.padding(.vertical, spacing)
  }

  func cardPadding() -> some View {
    self.padding(Spacing.md)
  }
}
