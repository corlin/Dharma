// Colors.swift
// Dharma Design System - Color Tokens
// 严格按照 ui_design_spec.md 规范实现

import SwiftUI

// MARK: - Semantic Colors
extension Color {

  // MARK: - Brand Colors (设计规范 2.1)
  static let brand = Color(hex: "#7B5EA7")  // 智慧紫
  static let brandLight = Color(hex: "#9B7FD1")
  static let brandDark = Color(hex: "#5A3D7A")

  // MARK: - Background Colors (设计规范: 背景层级)
  // 遵循原型图的温暖米白色调
  static let backgroundPrimary = Color(hex: "#FBF9F7")  // 温暖米白 - 页面底色
  static let backgroundSecondary = Color(hex: "#F5F2EE")  // 浅米色 - 次级区域
  static let backgroundTertiary = Color(hex: "#FFFFFF")  // 纯白 - 卡片背景

  // MARK: - Functional Colors (各层级主题色)
  static let excavate = Color(hex: "#7B5EA7")  // 挖掘层 - 智慧紫
  static let orient = Color(hex: "#E6A817")  // 定向层 - 目标金 (原型图金色)
  static let execute = Color(hex: "#4A90D9")  // 执行层 - 专注蓝
  static let feedback = Color(hex: "#4CAF7C")  // 反馈层 - 成长绿 (原型图绿)
  static let evolve = Color(hex: "#9B59B6")  // 进化层 - 突破紫

  // MARK: - Status Colors (设计规范表格)
  static let success = Color(hex: "#34C759")  // 成功/进步
  static let warning = Color(hex: "#FF9500")  // 警告/觉察
  static let error = Color(hex: "#FF3B30")  // 错误/失败
  static let info = Color(hex: "#007AFF")  // 信息/引导

  // MARK: - Text Colors (设计规范: 文字层级)
  // 严格按照规范的十六进制值
  static let textPrimary = Color(hex: "#1C1C1E")  // 主要文字 - 几乎黑
  static let textSecondary = Color(hex: "#6E6E73")  // 次要文字 - 深灰
  static let textTertiary = Color(hex: "#AEAEB2")  // 占位符 - 浅灰
  static let sectionTitle = Color(hex: "#3C3C43")  // 章节标题 - 深灰（比 textSecondary 稍深）
  static let divider = Color(hex: "#E5E5EA")  // 分割线

  // MARK: - Gradient Definitions (设计规范)
  // 紫蓝渐变 - 挖掘层卡片头部
  static let gradientPurpleBlue = LinearGradient(
    colors: [Color(hex: "#7B5EA7"), Color(hex: "#5B8DEF")],
    startPoint: .leading,
    endPoint: .trailing
  )

  // 橙粉渐变 - CTA 按钮
  static let gradientOrangePink = LinearGradient(
    colors: [Color(hex: "#FF8C42"), Color(hex: "#E667AF")],
    startPoint: .leading,
    endPoint: .trailing
  )

  // 定向层金色渐变
  static let gradientOrientGold = LinearGradient(
    colors: [Color(hex: "#D4A017"), Color(hex: "#E6A817"), Color(hex: "#C9932E")],
    startPoint: .top,
    endPoint: .bottom
  )

  // 执行层蓝色渐变
  static let gradientExecuteBlue = LinearGradient(
    colors: [Color(hex: "#4A90D9"), Color(hex: "#64B5F6")],
    startPoint: .leading,
    endPoint: .trailing
  )

  // 反馈层绿色渐变
  static let gradientFeedbackGreen = LinearGradient(
    colors: [Color(hex: "#4CAF7C"), Color(hex: "#81C784")],
    startPoint: .leading,
    endPoint: .trailing
  )

  // 进化层紫粉渐变
  static let gradientEvolvePink = LinearGradient(
    colors: [Color(hex: "#9B59B6"), Color(hex: "#E91E9B")],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
}

// MARK: - Hex Color Extension
extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 3:
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6:
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

// MARK: - Dark Mode Support
extension Color {
  static func adaptive(light: Color, dark: Color) -> Color {
    Color(
      UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
          ? UIColor(dark)
          : UIColor(light)
      })
  }
}
