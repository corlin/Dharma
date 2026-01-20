// LogicController.swift
// Dharma Services - Logic Layer
// Handles the "Hooks" logic between different layers

import Foundation
import SwiftData

class LogicController {

  /// Hook: Anti-Vision -> Vision MVP
  /// Reverse engineers the Anti-Vision to create an initial Vision MVP

  /// Hook: Anti-Vision -> Vision MVP (AI Powered)
  /// Uses the active AI provider to analyze the Anti-Vision and generate a compelling Vision MVP
  static func generateVisionFromAntiVisionAI(_ antiVision: AntiVisionModel) async throws
    -> VisionMVPModel
  {
    guard let provider = AIEngineManager.shared.getActiveProvider() else {
      // Fallback to heuristic if no AI is available
      return generateVisionFromAntiVision(antiVision)
    }

    let systemPrompt = """
      You are an expert psychological coach specializing in "Identity Shifting".
      Your task is to analyze the user's "Anti-Vision" (their detailed fear of a failed future) and reverse-engineer it into a powerful, inspiring "Vision MVP" (North Star).

      The Vision MVP must be:
      1. Linguistically distinct (not just "not X").
      2. Emotionally resonant.
      3. Concise but punchy.

      Return ONLY a JSON object with this structure:
      {
        "statement": "A single sentence identity statement (e.g., 'I am the architect of a flourishing community')",
        "coreValues": ["Value1", "Value2", "Value3"]
      }
      """

    let userMessage = """
      My Anti-Vision (What I must avoid):
      - 5-Year Hell: \(antiVision.fiveYearTuesday)
      - The Cost: \(antiVision.lifetimeCost)
      - Compressed Fear: \(antiVision.compressedStatement)

      Generate my Vision MVP.
      """

    let messages = [
      ChatMessage(role: .system, content: systemPrompt),
      ChatMessage(role: .user, content: userMessage),
    ]

    do {
      let jsonString = try await provider.chat(
        messages: messages,
        model: nil,
        temperature: 0.7,
        maxTokens: 500
      )

      // Clean up potential markdown code blocks from AI response
      let cleanJson = jsonString.replacingOccurrences(of: "```json", with: "")
        .replacingOccurrences(of: "```", with: "")
        .trimmingCharacters(in: .whitespacesAndNewlines)

      guard let data = cleanJson.data(using: .utf8) else {
        throw AIProviderError.invalidResponse
      }

      struct VisionResponse: Codable {
        let statement: String
        let coreValues: [String]
      }

      let response = try JSONDecoder().decode(VisionResponse.self, from: data)

      let visionMVP = VisionMVPModel(
        statement: response.statement,
        coreValues: response.coreValues
      )
      visionMVP.originAntiVision = antiVision
      return visionMVP

    } catch {
      print("AI Generation failed: \(error). Falling back to heuristic.")
      return generateVisionFromAntiVision(antiVision)
    }
  }

  /// Original Heuristic Logic (Fallback)
  static func generateVisionFromAntiVision(_ antiVision: AntiVisionModel) -> VisionMVPModel {
    // Simple heuristic inversion logic
    let antiStatements = antiVision.compressedStatement
    let invertedStatement = invertText(antiStatements)

    let visionMVP = VisionMVPModel(
      statement: invertedStatement,
      coreValues: ["Freedom", "Clarity", "Growth"]  // Default values
    )
    visionMVP.originAntiVision = antiVision
    return visionMVP
  }

  private static func invertText(_ text: String) -> String {
    if text.isEmpty { return "A balanced and purposeful life." }
    return "The opposite of: \(text)"
  }
}
