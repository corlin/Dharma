// UserModel.swift
// Dharma Data - SwiftData User Model

import Foundation
import SwiftData

@Model
final class UserModel {
  @Attribute(.unique) var id: UUID
  var currentMindStage: Int
  var activeIdentityStatement: String
  var totalXP: Int
  var currentLevel: String
  var createdAt: Date
  var updatedAt: Date

  @Relationship(deleteRule: .cascade)
  var antiVision: AntiVisionModel?

  @Relationship(deleteRule: .cascade)
  var goalHierarchy: GoalHierarchyModel?

  @Relationship(deleteRule: .cascade)
  var failures: [FailureModel]

  @Relationship(deleteRule: .cascade)
  var reflections: [ReflectionModel]

  init(
    id: UUID = UUID(),
    currentMindStage: Int = 4,
    activeIdentityStatement: String = "",
    totalXP: Int = 0,
    currentLevel: String = "新手"
  ) {
    self.id = id
    self.currentMindStage = currentMindStage
    self.activeIdentityStatement = activeIdentityStatement
    self.totalXP = totalXP
    self.currentLevel = currentLevel
    self.createdAt = Date()
    self.updatedAt = Date()
    self.failures = []
    self.reflections = []
  }
}

// MARK: - Anti Vision Model
@Model
final class AntiVisionModel {
  var fiveYearTuesday: String
  var tenYearTuesday: String
  var lifetimeCost: String
  var compressedStatement: String
  var roleModel: String
  var createdAt: Date

  @Relationship(inverse: \VisionMVPModel.originAntiVision)
  var visionMVP: VisionMVPModel?

  init(
    fiveYearTuesday: String = "",
    tenYearTuesday: String = "",
    lifetimeCost: String = "",
    compressedStatement: String = "",
    roleModel: String = ""
  ) {
    self.fiveYearTuesday = fiveYearTuesday
    self.tenYearTuesday = tenYearTuesday
    self.lifetimeCost = lifetimeCost
    self.compressedStatement = compressedStatement
    self.roleModel = roleModel
    self.createdAt = Date()
  }
}

// MARK: - Goal Hierarchy Model
@Model
final class GoalHierarchyModel {
  @Attribute(.unique) var id: UUID
  var decadeVisionDescription: String
  var decadeVisionIdentity: String
  var yearGoalDescription: String
  var quarterProjectTitle: String
  var quarterProjectDescription: String
  var weekMilestoneDescription: String
  var updatedAt: Date

  @Relationship(deleteRule: .cascade)
  var dailyLevers: [DailyLeverModel]

  init() {
    self.id = UUID()
    self.decadeVisionDescription = ""
    self.decadeVisionIdentity = ""
    self.yearGoalDescription = ""
    self.quarterProjectTitle = ""
    self.quarterProjectDescription = ""
    self.weekMilestoneDescription = ""
    self.updatedAt = Date()
    self.dailyLevers = []
  }
}

// MARK: - Daily Lever Model
@Model
final class DailyLeverModel {
  @Attribute(.unique) var id: UUID
  var title: String
  var estimatedDuration: Double
  var actualDuration: Double?
  var isCompleted: Bool
  var workType: String
  var priority: Int
  var date: Date
  var notes: String?

  init(
    id: UUID = UUID(),
    title: String,
    estimatedDuration: Double,
    workType: String = "BUILD",
    priority: Int = 2,
    date: Date = Date()
  ) {
    self.id = id
    self.title = title
    self.estimatedDuration = estimatedDuration
    self.isCompleted = false
    self.workType = workType
    self.priority = priority
    self.date = date
  }

  var estimatedDurationFormatted: String {
    let hours = Int(estimatedDuration) / 3600
    let minutes = Int(estimatedDuration) % 3600 / 60
    if hours > 0 {
      return "\(hours)h \(minutes)min"
    }
    return "\(minutes)min"
  }
}

// MARK: - Failure Model
@Model
final class FailureModel {
  @Attribute(.unique) var id: UUID
  var failureDescription: String
  var learningExtracted: String?
  var appliedToNextAttempt: Bool
  var xpEarned: Int
  var category: String
  var createdAt: Date

  init(
    id: UUID = UUID(),
    description: String,
    category: String = ""
  ) {
    self.id = id
    self.failureDescription = description
    self.learningExtracted = nil
    self.appliedToNextAttempt = false
    self.category = category
    self.createdAt = Date()
    self.xpEarned = 10  // 基础失败 XP
  }

  func updateLearning(_ learning: String) {
    self.learningExtracted = learning
    recalculateXP()
  }

  func markAsApplied() {
    self.appliedToNextAttempt = true
    recalculateXP()
  }

  private func recalculateXP() {
    var xp = 10
    if learningExtracted != nil { xp += 20 }
    if appliedToNextAttempt { xp += 30 }
    self.xpEarned = xp
  }
}

// MARK: - Reflection Model
@Model
final class ReflectionModel {
  @Attribute(.unique) var id: UUID
  var content: String
  var weekNumber: Int
  var year: Int
  var saidGoals: [String]
  var actualBehaviors: [String]
  var gapAnalysis: String?
  var xpEarned: Int
  var createdAt: Date

  init(
    id: UUID = UUID(),
    content: String,
    weekNumber: Int,
    year: Int
  ) {
    self.id = id
    self.content = content
    self.weekNumber = weekNumber
    self.year = year
    self.saidGoals = []
    self.actualBehaviors = []
    self.xpEarned = 0
    self.createdAt = Date()
  }
}
