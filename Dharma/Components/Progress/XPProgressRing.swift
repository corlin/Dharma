// XPProgressRing.swift
// Dharma Components - XP Progress Ring

import SwiftUI

/// XP 进度环组件
/// 显示用户等级和经验值进度
struct XPProgressRing: View {
  let currentXP: Int
  let requiredXP: Int
  let level: String
  let levelName: String
  let size: CGFloat

  private var progress: Double {
    Double(currentXP) / Double(requiredXP)
  }

  init(
    currentXP: Int,
    requiredXP: Int,
    level: String,
    levelName: String,
    size: CGFloat = 120
  ) {
    self.currentXP = currentXP
    self.requiredXP = requiredXP
    self.level = level
    self.levelName = levelName
    self.size = size
  }

  var body: some View {
    ZStack {
      // 背景环
      Circle()
        .stroke(Color.excavate.opacity(0.2), lineWidth: size * 0.08)

      // 进度环
      Circle()
        .trim(from: 0, to: progress)
        .stroke(
          AngularGradient(
            colors: [Color(hex: "#7B5EA7"), Color(hex: "#E91E63"), Color(hex: "#7B5EA7")],
            center: .center
          ),
          style: StrokeStyle(
            lineWidth: size * 0.08,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .animation(.spring(response: 0.8), value: progress)

      // 中心内容
      VStack(spacing: Spacing.xxs) {
        Text(level)
          .font(.system(size: size * 0.18, weight: .bold, design: .rounded))

        Text(levelName)
          .font(.system(size: size * 0.12, weight: .medium, design: .rounded))
          .foregroundColor(.textSecondary)

        Text("\(currentXP)/\(requiredXP) XP")
          .font(.system(size: size * 0.1, weight: .regular, design: .rounded))
          .foregroundColor(.textTertiary)
      }
    }
    .frame(width: size, height: size)
    .dharmaShadow(.glow)
  }
}

// MARK: - Mini XP Progress
struct MiniXPProgress: View {
  let currentXP: Int
  let requiredXP: Int
  let level: String

  private var progress: Double {
    Double(currentXP) / Double(requiredXP)
  }

  var body: some View {
    HStack(spacing: Spacing.sm) {
      // 等级徽章
      Text(level)
        .font(.labelMedium)
        .foregroundColor(.white)
        .padding(.horizontal, Spacing.xs)
        .padding(.vertical, Spacing.xxs)
        .background(Color.excavate)
        .clipShape(Capsule())

      // 进度条
      GeometryReader { geometry in
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: 4)
            .fill(Color.excavate.opacity(0.2))

          RoundedRectangle(cornerRadius: 4)
            .fill(Color.gradientPurpleBlue)
            .frame(width: geometry.size.width * progress)
            .animation(.spring(response: 0.5), value: progress)
        }
      }
      .frame(height: 8)

      // XP 数值
      Text("\(currentXP) XP")
        .font(.labelSmall)
        .foregroundColor(.textSecondary)
    }
  }
}

// MARK: - Preview
#Preview("XP Progress Ring") {
  ZStack {
    Color.backgroundPrimary
      .ignoresSafeArea()

    VStack(spacing: Spacing.xl) {
      XPProgressRing(
        currentXP: 320,
        requiredXP: 500,
        level: "Lv.2",
        levelName: "探索者",
        size: 160
      )

      MiniXPProgress(
        currentXP: 320,
        requiredXP: 500,
        level: "Lv.2"
      )
      .frame(width: 200)
    }
    .padding()
  }
}
