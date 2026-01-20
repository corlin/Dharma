// Failure.swift
// Dharma Domain - Failure Entity (XP System)

import Foundation

/// 失败实体
/// 用于失败投资组合和 XP 系统
struct Failure: Identifiable, Codable, Equatable {
  let id: UUID
  var description: String
  var learningExtracted: String?
  var appliedToNextAttempt: Bool
  var xpEarned: Int
  var category: String
  var relatedGoalId: UUID?
  var createdAt: Date

  init(
    id: UUID = UUID(),
    description: String,
    learningExtracted: String? = nil,
    appliedToNextAttempt: Bool = false,
    category: String = "",
    relatedGoalId: UUID? = nil,
    createdAt: Date = Date()
  ) {
    self.id = id
    self.description = description
    self.learningExtracted = learningExtracted
    self.appliedToNextAttempt = appliedToNextAttempt
    self.category = category
    self.relatedGoalId = relatedGoalId
    self.createdAt = createdAt

    // 计算 XP
    self.xpEarned = Self.calculateXP(
      hasLearning: learningExtracted != nil,
      hasApplied: appliedToNextAttempt
    )
  }

  /// XP 计算公式
  /// 基础失败: 10 XP
  /// 记录学习: +20 XP
  /// 应用到下次: +30 XP
  static func calculateXP(hasLearning: Bool, hasApplied: Bool) -> Int {
    var xp = 10  // 基础失败 XP
    if hasLearning { xp += 20 }
    if hasApplied { xp += 30 }
    return xp
  }

  /// 更新学习记录
  mutating func updateLearning(_ learning: String) {
    self.learningExtracted = learning
    self.xpEarned = Self.calculateXP(
      hasLearning: true,
      hasApplied: appliedToNextAttempt
    )
  }

  /// 标记为已应用
  mutating func markAsApplied() {
    self.appliedToNextAttempt = true
    self.xpEarned = Self.calculateXP(
      hasLearning: learningExtracted != nil,
      hasApplied: true
    )
  }
}

// MARK: - Failure Portfolio (失败投资组合统计)
struct FailurePortfolio: Codable, Equatable {
  var totalFailures: Int
  var learningsExtracted: Int
  var appliedToNextAttempt: Int
  var totalXPFromFailures: Int
  var distanceToBreakthrough: Double  // 0.0 - 1.0

  init(failures: [Failure]) {
    self.totalFailures = failures.count
    self.learningsExtracted = failures.filter { $0.learningExtracted != nil }.count
    self.appliedToNextAttempt = failures.filter { $0.appliedToNextAttempt }.count
    self.totalXPFromFailures = failures.reduce(0) { $0 + $1.xpEarned }

    // 突破距离计算（基于失败转化率）
    if totalFailures > 0 {
      let conversionRate = Double(appliedToNextAttempt) / Double(totalFailures)
      self.distanceToBreakthrough = min(1.0, conversionRate * 1.2)
    } else {
      self.distanceToBreakthrough = 0
    }
  }

  static let empty = FailurePortfolio(failures: [])
}
