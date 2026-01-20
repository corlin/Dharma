// AIEngineManager.swift
// Dharma Services - AI Engine Manager

import Foundation

/// AI 引擎管理器
/// 统一管理多个 AI 提供商
final class AIEngineManager: @unchecked Sendable {
  static let shared = AIEngineManager()

  private var providers: [String: any AIProvider] = [:]
  private var activeProviderName: String?
  private let lock = NSLock()

  private init() {}

  // MARK: - Provider Management

  func registerProvider(_ provider: any AIProvider, name: String) {
    lock.lock()
    defer { lock.unlock() }
    providers[name] = provider
  }

  func setActiveProvider(_ name: String) throws {
    lock.lock()
    defer { lock.unlock() }
    guard providers[name] != nil else {
      throw AIProviderError.providerUnavailable(name: name)
    }
    activeProviderName = name
  }

  func getActiveProvider() -> (any AIProvider)? {
    lock.lock()
    defer { lock.unlock() }
    guard let name = activeProviderName else { return nil }
    return providers[name]
  }

  func listProviders() -> [String] {
    lock.lock()
    defer { lock.unlock() }
    return Array(providers.keys)
  }

  // MARK: - Quick Setup Helpers

  func setupOpenAI(apiKey: String) {
    let config = OpenAICompatibleClient.Configuration.openAI(apiKey: apiKey)
    let client = OpenAICompatibleClient(configuration: config)
    lock.lock()
    providers["OpenAI"] = client
    if activeProviderName == nil {
      activeProviderName = "OpenAI"
    }
    lock.unlock()
  }

  func setupOllama(baseURL: String = "http://localhost:11434", model: String = "llama3.2") {
    let config = OpenAICompatibleClient.Configuration.ollama(baseURL: baseURL, model: model)
    let client = OpenAICompatibleClient(configuration: config)
    lock.lock()
    providers["Ollama"] = client
    lock.unlock()
  }

  func setupDeepseek(apiKey: String, model: String = "deepseek-chat") {
    let config = OpenAICompatibleClient.Configuration.deepseek(apiKey: apiKey)
    // 覆盖默认 model 如果提供了新的
    let finalConfig = OpenAICompatibleClient.Configuration(
      name: config.name,
      baseURL: config.baseURL,
      apiKey: config.apiKey,
      defaultModel: model,
      headers: config.headers,
      timeout: config.timeout
    )
    let client = OpenAICompatibleClient(configuration: finalConfig)
    lock.lock()
    providers["Deepseek"] = client
    // 如果没有活跃的，设置为 Deepseek
    if activeProviderName == nil {
      activeProviderName = "Deepseek"
    }
    lock.unlock()
  }

  func setupGroq(apiKey: String, model: String = "llama-3.3-70b-versatile") {
    let config = OpenAICompatibleClient.Configuration.groq(apiKey: apiKey, model: model)
    let client = OpenAICompatibleClient(configuration: config)
    lock.lock()
    providers["Groq"] = client
    lock.unlock()
  }

  func setupCustomProvider(name: String, baseURL: String, apiKey: String, model: String) {
    let config = OpenAICompatibleClient.Configuration.custom(
      name: name,
      baseURL: baseURL,
      apiKey: apiKey,
      model: model
    )
    let client = OpenAICompatibleClient(configuration: config)
    lock.lock()
    providers[name] = client
    lock.unlock()
  }
}

// MARK: - Socratic Question Generator
final class SocraticQuestionGenerator: Sendable {
  private let aiManager = AIEngineManager.shared

  private let systemPrompt = """
    You are "Orb", the AI Coach for the Dharma App. Your role is:
    1. Silently observe user behavior and reflections.
    2. Guide users to self-discovery via Socratic questioning at key moments.
    3. NEVER give direct answers or advice.
    4. Use a gentle, curious tone.
    5. Ask only ONE question at a time.

    Types of Socratic Questions:
    - Clarification: Help user express thoughts clearly.
    - Assumption Probing: Challenge implicit assumptions.
    - Evidence Seeking: Guide user to support views with facts.
    - Alternative Consideration: Help user see other possibilities.
    - Impact Exploration: Guide user to consider consequences.

    IMPORTANT: Return ONLY the question itself, no prefix or explanation.
    """

  struct Context: Codable, Sendable {
    let saidGoals: [String]
    let actualBehaviors: [String]
    let recentReflections: [String]
    let currentChallenge: String?
  }

  func generateQuestion(context: Context) async throws -> String {
    guard let provider = aiManager.getActiveProvider() else {
      throw AIProviderError.configurationMissing
    }

    let userMessage = """
      User Context:
      - Stated Goals: \(context.saidGoals.joined(separator: ", "))
      - Actual Behavior: \(context.actualBehaviors.joined(separator: ", "))
      - Recent Reflections: \(context.recentReflections.joined(separator: "; "))
      - Current Challenge: \(context.currentChallenge ?? "None")

      Generate a Socratic question based on this gap.
      """

    let messages = [
      ChatMessage(role: .system, content: systemPrompt),
      ChatMessage(role: .user, content: userMessage),
    ]

    return try await provider.chat(
      messages: messages,
      model: nil,
      temperature: 0.8,
      maxTokens: 200
    )
  }

  func generateWelcomeMessage() async -> String {
    guard let provider = aiManager.getActiveProvider() else {
      return "欢迎回来。今天你想探索什么？"
    }

    let messages = [
      ChatMessage(
        role: .system,
        content: "You are the gentle AI guide Orb. Generate a short welcome message. Max 15 words."),
      ChatMessage(role: .user, content: "Generate welcome message"),
    ]

    do {
      return try await provider.chat(
        messages: messages, model: nil, temperature: 0.9, maxTokens: 50)
    } catch {
      return "Welcome back. What would you like to explore today?"
    }
  }
}
