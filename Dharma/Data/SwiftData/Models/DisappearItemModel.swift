// DisappearItemModel.swift
// Dharma Data - Orient Layer - Disappear List (Items to remove from life)

import Foundation
import SwiftData

@Model
final class DisappearItemModel {
  @Attribute(.unique) var id: UUID
  var name: String
  var category: String  // e.g., "Person", "Habit", "Environment"
  var status: DisappearStatus
  var createdAt: Date

  // Inverse relationship to Pain Log
  @Relationship(inverse: \PainLogModel.relatedDisappearItem)
  var sourcePainLogs: [PainLogModel] = []

  init(
    id: UUID = UUID(),
    name: String,
    category: String = "General",
    status: DisappearStatus = .identified
  ) {
    self.id = id
    self.name = name
    self.category = category
    self.status = status
    self.createdAt = Date()
    // self.sourcePainLogs is already initialized to []
  }
}

enum DisappearStatus: String, Codable, CaseIterable {
  case identified = "Identified"
  case inProgress = "In Progress"
  case gone = "Gone"
}
