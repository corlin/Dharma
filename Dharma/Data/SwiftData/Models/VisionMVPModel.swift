// VisionMVPModel.swift
// Dharma Data - Orient Layer - Vision MVP

import Foundation
import SwiftData

@Model
final class VisionMVPModel {
  @Attribute(.unique) var id: UUID
  var statement: String
  var coreValues: [String]
  var createdAt: Date

  @Relationship(deleteRule: .nullify)
  var originAntiVision: AntiVisionModel?

  init(
    id: UUID = UUID(),
    statement: String,
    coreValues: [String] = []
  ) {
    self.id = id
    self.statement = statement
    self.coreValues = coreValues
    self.createdAt = Date()
  }
}
