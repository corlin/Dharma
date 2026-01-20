// AntiVision.swift
// Dharma Domain - Anti Vision Entity

import Foundation

/// 反愿景实体
/// 用于挖掘层的反愿景工坊
struct AntiVision: Identifiable, Codable, Equatable {
  let id: UUID
  var fiveYearTuesday: String  // 5年后的普通星期二
  var tenYearTuesday: String  // 10年后的普通星期二
  var lifetimeCost: String  // 一生的代价
  var compressedStatement: String  // 压缩后的反愿景陈述
  var roleModel: String  // 已经走上这条路的人
  var painPoints: [PainPoint]  // 痛点列表
  var createdAt: Date
  var updatedAt: Date

  init(
    id: UUID = UUID(),
    fiveYearTuesday: String = "",
    tenYearTuesday: String = "",
    lifetimeCost: String = "",
    compressedStatement: String = "",
    roleModel: String = "",
    painPoints: [PainPoint] = [],
    createdAt: Date = Date(),
    updatedAt: Date = Date()
  ) {
    self.id = id
    self.fiveYearTuesday = fiveYearTuesday
    self.tenYearTuesday = tenYearTuesday
    self.lifetimeCost = lifetimeCost
    self.compressedStatement = compressedStatement
    self.roleModel = roleModel
    self.painPoints = painPoints
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

// MARK: - Pain Point (痛点)
struct PainPoint: Identifiable, Codable, Equatable {
  let id: UUID
  var description: String
  var category: PainPointCategory
  var intensity: Int  // 1-10
  var frequency: PainPointFrequency
  var createdAt: Date

  init(
    id: UUID = UUID(),
    description: String,
    category: PainPointCategory,
    intensity: Int = 5,
    frequency: PainPointFrequency = .sometimes,
    createdAt: Date = Date()
  ) {
    self.id = id
    self.description = description
    self.category = category
    self.intensity = min(10, max(1, intensity))
    self.frequency = frequency
    self.createdAt = createdAt
  }
}

enum PainPointCategory: String, Codable, CaseIterable {
  case procrastination = "Procrastination"
  case doubt = "Doubt"
  case burnout = "Burnout"
  case stagnation = "Stagnation"
  case fear = "Fear"
  case anxiety = "Anxiety"
  case distraction = "Distraction"
  case perfectionism = "Perfectionism"

  var localizedName: String {
    switch self {
    case .procrastination: return "Procrastination"
    case .doubt: return "Doubt"
    case .burnout: return "Burnout"
    case .stagnation: return "Stagnation"
    case .fear: return "Fear"
    case .anxiety: return "Anxiety"
    case .distraction: return "Distraction"
    case .perfectionism: return "Perfectionism"
    }
  }
}

enum PainPointFrequency: String, Codable, CaseIterable {
  case rarely = "Rarely"
  case sometimes = "Sometimes"
  case often = "Often"
  case always = "Always"

  var localizedName: String {
    switch self {
    case .rarely: return "Rarely"
    case .sometimes: return "Sometimes"
    case .often: return "Often"
    case .always: return "Always"
    }
  }
}
