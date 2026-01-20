// HapticManager.swift
// Dharma Core - Design System - Haptic Feedback

import UIKit

/// 触觉反馈管理器 (Singleton)
/// 集中管理 App 的震动反馈，确保体验一致性
final class HapticManager {
  static let shared = HapticManager()

  private init() {}

  /// 触发轻微撞击反馈 (如：点击小按钮，切换 Tab)
  func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let generator = UIImpactFeedbackGenerator(style: style)
    generator.prepare()
    generator.impactOccurred()
  }

  /// 触发选择反馈 (如：滚动 Picker，滑动刻度)
  func selection() {
    let generator = UISelectionFeedbackGenerator()
    generator.prepare()
    generator.selectionChanged()
  }

  /// 触发通知反馈 (如：任务完成，错误提示)
  /// - Parameter type: .success (成功), .warning (警告), .error (错误)
  func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
    let generator = UINotificationFeedbackGenerator()
    generator.prepare()
    generator.notificationOccurred(type)
  }
}
