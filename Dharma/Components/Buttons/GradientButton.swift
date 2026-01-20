// GradientButton.swift
// Dharma Components - Gradient Button
// 严格按照 ui_design_spec.md 3.2 章节实现

import SwiftUI

/// 渐变按钮组件
/// 设计规范:
/// - 橙红到粉紫渐变: #FF6B4A → #D64EAF
/// - 胶囊形状 (Capsule)
/// - 阴影: radius 12, y 4, opacity 0.4
/// - 字体: Headline (17pt semibold)
struct GradientButton: View {
  let title: String
  let icon: String?
  let style: ButtonStyle
  let isLoading: Bool
  let action: () -> Void

  enum ButtonStyle {
    case primary  // 橙粉渐变 - 主要 CTA
    case secondary  // 紫蓝渐变 - 次要操作
    case orient  // 金色渐变 - 定向层
    case execute  // 蓝色渐变 - 执行层
    case feedback  // 绿色渐变 - 反馈层
    case outline  // 轮廓样式
  }

  init(
    _ title: String,
    icon: String? = nil,
    style: ButtonStyle = .primary,
    isLoading: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.icon = icon
    self.style = style
    self.isLoading = isLoading
    self.action = action
  }

  var body: some View {
    Button(action: {
      HapticManager.shared.impact(.light)
      action()
    }) {
      HStack(spacing: 8) {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(0.8)
        } else {
          if let icon = icon {
            Image(systemName: icon)
              .font(.system(size: 14, weight: .semibold))
          }
          Text(title)
            .font(.system(size: 17, weight: .semibold))
        }
      }
      .foregroundColor(foregroundColor)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(background)
      .clipShape(Capsule())
      .overlay(
        Capsule()
          .stroke(borderColor, lineWidth: style == .outline ? 1.5 : 0)
      )
      .shadow(color: shadowColor, radius: 12, x: 0, y: 4)
    }
    .disabled(isLoading)
  }

  // MARK: - Style Properties

  private var background: some View {
    Group {
      switch style {
      case .primary:
        LinearGradient(
          colors: [Color(hex: "#FF6B4A"), Color(hex: "#D64EAF")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .secondary:
        LinearGradient(
          colors: [Color(hex: "#7B5EA7"), Color(hex: "#5B8DEF")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .orient:
        LinearGradient(
          colors: [Color(hex: "#E6A817"), Color(hex: "#D4A017")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .execute:
        LinearGradient(
          colors: [Color(hex: "#4A90D9"), Color(hex: "#64B5F6")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .feedback:
        LinearGradient(
          colors: [Color(hex: "#4CAF7C"), Color(hex: "#81C784")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .outline:
        Color.clear
      }
    }
  }

  private var foregroundColor: Color {
    style == .outline ? .brand : .white
  }

  private var borderColor: Color {
    style == .outline ? .brand : .clear
  }

  private var shadowColor: Color {
    switch style {
    case .primary:
      return Color(hex: "#FF6B4A").opacity(0.4)
    case .secondary:
      return Color(hex: "#7B5EA7").opacity(0.3)
    case .orient:
      return Color(hex: "#E6A817").opacity(0.3)
    case .execute:
      return Color(hex: "#4A90D9").opacity(0.3)
    case .feedback:
      return Color(hex: "#4CAF7C").opacity(0.3)
    case .outline:
      return Color.clear
    }
  }
}

// MARK: - Icon Button
/// 圆形图标按钮
struct IconButton: View {
  let icon: String
  let color: Color
  let size: CGFloat
  let action: () -> Void

  init(
    icon: String,
    color: Color = .brand,
    size: CGFloat = 44,
    action: @escaping () -> Void
  ) {
    self.icon = icon
    self.color = color
    self.size = size
    self.action = action
  }

  var body: some View {
    Button(action: {
      HapticManager.shared.impact(.light)
      action()
    }) {
      Image(systemName: icon)
        .font(.system(size: size * 0.4, weight: .semibold))
        .foregroundColor(.white)
        .frame(width: size, height: size)
        .background(color)
        .clipShape(Circle())
        .shadow(color: color.opacity(0.4), radius: 8, y: 4)
    }
  }
}

// MARK: - Skip Link
/// 跳过链接（原型图中的 "Skip for now"）
struct SkipLink: View {
  let text: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(text)
        .font(.system(size: 15))
        .foregroundColor(.textSecondary)
        .underline()
    }
  }
}

// MARK: - Preview
#Preview("Gradient Buttons") {
  ZStack {
    Color.backgroundPrimary
      .ignoresSafeArea()

    VStack(spacing: Spacing.lg) {
      GradientButton("Begin Excavation", icon: "pickaxe") {
        print("Excavate!")
      }

      GradientButton("Continue", icon: "arrow.right", style: .secondary) {
        print("Continue")
      }

      GradientButton("Set Goals", icon: "target", style: .orient) {
        print("Orient")
      }

      GradientButton("Start Session", icon: "play.fill", style: .execute) {
        print("Execute")
      }

      GradientButton("Cancel", style: .outline) {
        print("Cancel")
      }

      SkipLink(text: "Skip for now") {
        print("Skip")
      }
    }
    .padding()
  }
}
