// PainLogModel.swift
// Dharma Data - Excavate Layer - Pain Log

import Foundation
import SwiftData

@Model
final class PainLogModel {
  @Attribute(.unique) var id: UUID
  var logDescription: String
  var intensity: Int  // 1-10
  var frequency: Int  // How often this happens (heuristic)
  var createdAt: Date

  // Relationship to Disappear List (Orient Layer)
  @Relationship(deleteRule: .nullify)
  var relatedDisappearItem: DisappearItemModel?

  init(
    id: UUID = UUID(),
    logDescription: String,
    intensity: Int = 5,
    frequency: Int = 1
  ) {
    self.id = id
    self.logDescription = logDescription
    self.intensity = intensity
    self.frequency = frequency
    self.createdAt = Date()
  }
}
