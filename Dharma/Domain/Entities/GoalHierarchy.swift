// GoalHierarchy.swift
// Dharma Domain - Goal Hierarchy Entity

import Foundation

/// 目标层级实体
/// 用于定向层的目标金字塔
struct GoalHierarchy: Identifiable, Codable, Equatable {
  let id: UUID
  var decadeVision: VisionItem  // 10年愿景
  var yearGoal: GoalItem  // 年度目标
  var quarterProject: ProjectItem  // 季度项目
  var weekMilestone: MilestoneItem  // 周里程碑
  var dailyLevers: [DailyLever]  // 每日杠杆任务
  var updatedAt: Date

  init(
    id: UUID = UUID(),
    decadeVision: VisionItem = VisionItem(),
    yearGoal: GoalItem = GoalItem(),
    quarterProject: ProjectItem = ProjectItem(),
    weekMilestone: MilestoneItem = MilestoneItem(),
    dailyLevers: [DailyLever] = [],
    updatedAt: Date = Date()
  ) {
    self.id = id
    self.decadeVision = decadeVision
    self.yearGoal = yearGoal
    self.quarterProject = quarterProject
    self.weekMilestone = weekMilestone
    self.dailyLevers = dailyLevers
    self.updatedAt = updatedAt
  }
}

// MARK: - Vision Item (10年愿景)
struct VisionItem: Codable, Equatable {
  var description: String
  var identityStatement: String  // "我是那种...的人"

  init(description: String = "", identityStatement: String = "") {
    self.description = description
    self.identityStatement = identityStatement
  }
}

// MARK: - Goal Item (年度目标)
struct GoalItem: Codable, Equatable {
  var description: String
  var keyResults: [String]
  var progress: Double  // 0.0 - 1.0

  init(description: String = "", keyResults: [String] = [], progress: Double = 0) {
    self.description = description
    self.keyResults = keyResults
    self.progress = progress
  }
}

// MARK: - Project Item (季度项目)
struct ProjectItem: Codable, Equatable {
  var title: String
  var description: String
  var milestones: [String]
  var currentMilestoneIndex: Int
  var startDate: Date?
  var endDate: Date?

  init(
    title: String = "",
    description: String = "",
    milestones: [String] = [],
    currentMilestoneIndex: Int = 0,
    startDate: Date? = nil,
    endDate: Date? = nil
  ) {
    self.title = title
    self.description = description
    self.milestones = milestones
    self.currentMilestoneIndex = currentMilestoneIndex
    self.startDate = startDate
    self.endDate = endDate
  }
}

// MARK: - Milestone Item (周里程碑)
struct MilestoneItem: Codable, Equatable {
  var description: String
  var isCompleted: Bool
  var weekNumber: Int

  init(description: String = "", isCompleted: Bool = false, weekNumber: Int = 1) {
    self.description = description
    self.isCompleted = isCompleted
    self.weekNumber = weekNumber
  }
}

// MARK: - Daily Lever (每日杠杆任务)
struct DailyLever: Identifiable, Codable, Equatable {
  let id: UUID
  var title: String
  var estimatedDuration: TimeInterval  // 秒
  var actualDuration: TimeInterval?
  var isCompleted: Bool
  var workType: WorkType
  var priority: Int  // 1-3，1最高
  var date: Date
  var notes: String?

  init(
    id: UUID = UUID(),
    title: String,
    estimatedDuration: TimeInterval,
    actualDuration: TimeInterval? = nil,
    isCompleted: Bool = false,
    workType: WorkType = .build,
    priority: Int = 2,
    date: Date = Date(),
    notes: String? = nil
  ) {
    self.id = id
    self.title = title
    self.estimatedDuration = estimatedDuration
    self.actualDuration = actualDuration
    self.isCompleted = isCompleted
    self.workType = workType
    self.priority = priority
    self.date = date
    self.notes = notes
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

// MARK: - Work Type (工作类型)
enum WorkType: String, Codable, CaseIterable {
  case build = "BUILD"
  case maintain = "MAINTAIN"
  case recover = "RECOVER"

  var localizedName: String {
    switch self {
    case .build: return "Build"
    case .maintain: return "Maintain"
    case .recover: return "Recover"
    }
  }

  var description: String {
    switch self {
    case .build: return "High leverage output work"
    case .maintain: return "Maintenance of systems and relationships"
    case .recover: return "Rest, study, and recharge"
    }
  }
}
