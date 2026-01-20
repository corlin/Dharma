// User.swift
// Dharma Domain - User Entity

import Foundation

/// 用户实体
struct User: Identifiable, Codable, Equatable {
  let id: UUID
  var currentMindStage: MindStage
  var activeIdentityStatement: String
  var totalXP: Int
  var currentLevel: Level
  var createdAt: Date
  var updatedAt: Date

  init(
    id: UUID = UUID(),
    currentMindStage: MindStage = .fourthStage,
    activeIdentityStatement: String = "",
    totalXP: Int = 0,
    currentLevel: Level = .beginner,
    createdAt: Date = Date(),
    updatedAt: Date = Date()
  ) {
    self.id = id
    self.currentMindStage = currentMindStage
    self.activeIdentityStatement = activeIdentityStatement
    self.totalXP = totalXP
    self.currentLevel = currentLevel
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

// MARK: - Mind Stage (思维阶段)
enum MindStage: Int, Codable, CaseIterable {
  case firstStage = 1  // 我不知道我不知道
  case secondStage = 2  // 我知道我不知道
  case thirdStage = 3  // 我知道我知道
  case fourthStage = 4  // 我不知道我知道

  var description: String {
    switch self {
    case .firstStage: return "无意识无能"
    case .secondStage: return "有意识无能"
    case .thirdStage: return "有意识有能"
    case .fourthStage: return "无意识有能"
    }
  }

  var englishName: String {
    switch self {
    case .firstStage: return "Unconscious Incompetence"
    case .secondStage: return "Conscious Incompetence"
    case .thirdStage: return "Conscious competence"
    case .fourthStage: return "Unconscious Competence"
    }
  }
}

// MARK: - Level (等级系统)
enum Level: String, Codable, CaseIterable {
  case beginner = "新手"
  case explorer = "探索者"
  case practitioner = "修行者"
  case awakener = "觉醒者"
  case master = "大师"

  var levelNumber: Int {
    switch self {
    case .beginner: return 1
    case .explorer: return 2
    case .practitioner: return 3
    case .awakener: return 4
    case .master: return 5
    }
  }

  var displayName: String {
    "Lv.\(levelNumber) \(rawValue)"
  }

  var requiredXP: Int {
    switch self {
    case .beginner: return 100
    case .explorer: return 500
    case .practitioner: return 1500
    case .awakener: return 5000
    case .master: return 15000
    }
  }

  static func fromXP(_ xp: Int) -> Level {
    switch xp {
    case 0..<100: return .beginner
    case 100..<500: return .explorer
    case 500..<1500: return .practitioner
    case 1500..<5000: return .awakener
    default: return .master
    }
  }
}
