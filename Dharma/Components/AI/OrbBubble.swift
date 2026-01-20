// OrbBubble.swift
// Dharma Components - AI Guide Chat Bubble
// 严格按照 ui_design_spec.md 3.4 章节实现

import SwiftUI

/// Orb AI 向导的对话气泡组件
/// 设计规范:
/// - 字体: Callout (16pt)
/// - 气泡背景: 白色
/// - 圆角: 12pt
/// - 阴影: radius 8, y 2, opacity 0.06
struct OrbBubble: View {
  let message: String
  let isTyping: Bool

  init(_ message: String, isTyping: Bool = false) {
    self.message = message
    self.isTyping = isTyping
  }

  var body: some View {
    HStack(alignment: .top, spacing: Spacing.sm) {
      // Orb 头像 (左侧)
      OrbAvatar(size: 44)

      // 对话气泡
      VStack(alignment: .leading, spacing: Spacing.xxs) {
        if isTyping {
          TypingIndicator()
        } else {
          Text(message)
            .font(.system(size: 16))  // Callout
            .foregroundColor(.textPrimary)
            .lineSpacing(4)
        }
      }
      .padding(Spacing.sm + 2)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))  // 12pt
      .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)

      Spacer(minLength: Spacing.lg)
    }
  }
}

// MARK: - Orb Avatar
/// 3D Orb 角色头像
struct OrbAvatar: View {
  let size: CGFloat
  @State private var isAnimating = false

  var body: some View {
    ZStack {
      // 外层光晕
      Circle()
        .fill(
          RadialGradient(
            colors: [Color.brand.opacity(0.3), Color.clear],
            center: .center,
            startRadius: 0,
            endRadius: size * 0.8
          )
        )
        .frame(width: size * 1.5, height: size * 1.5)
        .scaleEffect(isAnimating ? 1.1 : 1.0)

      // Orb 主体 - 紫色渐变球体
      Circle()
        .fill(
          LinearGradient(
            colors: [Color(hex: "#A78BDA"), Color(hex: "#7B5EA7")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .frame(width: size, height: size)
        .overlay(
          // 高光效果
          Circle()
            .fill(
              LinearGradient(
                colors: [Color.white.opacity(0.5), Color.clear],
                startPoint: .topLeading,
                endPoint: .center
              )
            )
            .frame(width: size * 0.5, height: size * 0.5)
            .offset(x: -size * 0.1, y: -size * 0.1)
        )
        .shadow(color: Color.brand.opacity(0.4), radius: 8, y: 4)
    }
    .frame(width: size, height: size)
    .onAppear {
      withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
        isAnimating = true
      }
    }
  }
}

// MARK: - Typing Indicator
/// 打字中指示器
struct TypingIndicator: View {
  @State private var dotOffsets = [false, false, false]

  var body: some View {
    HStack(spacing: 4) {
      ForEach(0..<3, id: \.self) { index in
        Circle()
          .fill(Color.brand)
          .frame(width: 6, height: 6)
          .offset(y: dotOffsets[index] ? -4 : 4)
      }
    }
    .frame(height: 20)
    .padding(.horizontal, 4)
    .onAppear {
      for i in 0..<3 {
        withAnimation(
          .easeInOut(duration: 0.4)
            .repeatForever(autoreverses: true)
            .delay(Double(i) * 0.12)
        ) {
          dotOffsets[i].toggle()
        }
      }
    }
  }
}

// MARK: - Preview
#Preview("Orb Bubble") {
  ZStack {
    Color.backgroundPrimary
      .ignoresSafeArea()

    VStack(spacing: Spacing.lg) {
      OrbBubble("Hey there! Let's uncover your path. Tap on 'Anti-vision' to start.")

      OrbBubble(
        "You said you wanted to complete 3 videos, but data shows you spent 40% of your time on 'research'. What does this tell you?"
      )

      OrbBubble("", isTyping: true)
    }
    .padding()
  }
}
