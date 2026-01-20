// GlassCard.swift
// Dharma Components - Glass Card
// 严格按照 ui_design_spec.md 3.1 章节实现

import SwiftUI

/// 毛玻璃卡片组件
/// 参考设计中的核心元素：
/// - 半透明白色背景 + 模糊效果
/// - 紫蓝渐变头部
/// - 圆角 16pt
/// - 阴影 radius: 12, y: 4
struct GlassCard<Content: View, Header: View>: View {
  let content: Content
  let header: Header?
  let cornerRadius: CGFloat
  let padding: CGFloat

  init(
    cornerRadius: CGFloat = CornerRadius.large,
    padding: CGFloat = Spacing.md,
    @ViewBuilder content: () -> Content,
    @ViewBuilder header: () -> Header
  ) {
    self.content = content()
    self.header = header()
    self.cornerRadius = cornerRadius
    self.padding = padding
  }

  var body: some View {
    VStack(spacing: 0) {
      // 渐变头部（如有）
      if let header = header {
        header
          .padding(.horizontal, Spacing.md)
          .padding(.vertical, Spacing.sm)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color.gradientPurpleBlue)
          .clipShape(
            UnevenRoundedRectangle(
              topLeadingRadius: cornerRadius,
              bottomLeadingRadius: 0,
              bottomTrailingRadius: 0,
              topTrailingRadius: cornerRadius
            )
          )
      }

      // 内容区域 - 纯白背景
      content
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .background(
      RoundedRectangle(cornerRadius: cornerRadius)
        .fill(Color.backgroundTertiary)  // 纯白卡片
    )
    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    // 设计规范阴影: radius 12, y 4, opacity 0.08
    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
  }
}

// 无头部版本
extension GlassCard where Header == EmptyView {
  init(
    cornerRadius: CGFloat = CornerRadius.large,
    padding: CGFloat = Spacing.md,
    @ViewBuilder content: () -> Content
  ) {
    self.content = content()
    self.header = nil
    self.cornerRadius = cornerRadius
    self.padding = padding
  }
}

// MARK: - Themed Glass Card
/// 带主题色渐变头部的卡片变体
struct ThemedCard<Content: View>: View {
  let title: String
  let icon: String
  let theme: CardTheme
  let content: Content

  enum CardTheme {
    case excavate  // 紫蓝渐变
    case orient  // 金色渐变
    case execute  // 蓝色渐变
    case feedback  // 绿色渐变
    case evolve  // 紫粉渐变

    var gradient: LinearGradient {
      switch self {
      case .excavate:
        return LinearGradient(
          colors: [Color(hex: "#7B5EA7"), Color(hex: "#5B8DEF")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .orient:
        return LinearGradient(
          colors: [Color(hex: "#D4A017"), Color(hex: "#E6A817")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .execute:
        return LinearGradient(
          colors: [Color(hex: "#4A90D9"), Color(hex: "#64B5F6")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .feedback:
        return LinearGradient(
          colors: [Color(hex: "#4CAF7C"), Color(hex: "#81C784")],
          startPoint: .leading,
          endPoint: .trailing
        )
      case .evolve:
        return LinearGradient(
          colors: [Color(hex: "#9B59B6"), Color(hex: "#E91E9B")],
          startPoint: .leading,
          endPoint: .trailing
        )
      }
    }
  }

  init(
    _ title: String,
    icon: String,
    theme: CardTheme = .excavate,
    @ViewBuilder content: () -> Content
  ) {
    self.title = title
    self.icon = icon
    self.theme = theme
    self.content = content()
  }

  var body: some View {
    VStack(spacing: 0) {
      // 渐变头部
      HStack(spacing: Spacing.sm) {
        Image(systemName: icon)
          .font(.system(size: 16, weight: .semibold))
        Text(title)
          .font(.system(size: 16, weight: .semibold, design: .rounded))
      }
      .foregroundColor(.white)
      .padding(.horizontal, Spacing.md)
      .padding(.vertical, Spacing.sm + 2)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(theme.gradient)

      // 内容区域
      content
        .padding(Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .background(Color.backgroundTertiary)
    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
  }
}

// MARK: - Preview
#Preview("Glass Cards") {
  ZStack {
    Color.backgroundPrimary
      .ignoresSafeArea()

    VStack(spacing: Spacing.lg) {
      ThemedCard("Anti-Vision", icon: "cloud.bolt.fill", theme: .excavate) {
        VStack(alignment: .leading, spacing: Spacing.sm) {
          Text("Anti-Vision Workshop")
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundColor(.textPrimary)

          Text("Discover what you're escaping from.")
            .font(.system(size: 15))
            .foregroundColor(.textSecondary)
        }
      }

      ThemedCard("Goal Hierarchy", icon: "target", theme: .orient) {
        Text("Build your pyramid from vision to action")
          .font(.system(size: 15))
          .foregroundColor(.textSecondary)
      }

      GlassCard {
        VStack(alignment: .leading, spacing: Spacing.sm) {
          Text("Simple Card")
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.textPrimary)
          Text("Card without header")
            .font(.system(size: 15))
            .foregroundColor(.textSecondary)
        }
      }
    }
    .padding()
  }
}
