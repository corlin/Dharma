// AIProvider.swift
// Dharma Services - AI Provider Protocol & OpenAI Compatible Client

import Foundation

// MARK: - AI Provider Protocol
/// AI 提供商协议 - 所有引擎必须实现
protocol AIProvider: Sendable {
  var name: String { get }

  func checkAvailability() async -> Bool

  func chat(
    messages: [ChatMessage],
    model: String?,
    temperature: Double?,
    maxTokens: Int?
  ) async throws -> String
}

// MARK: - Chat Message
struct ChatMessage: Codable, Sendable {
  enum Role: String, Codable, Sendable {
    case system, user, assistant
  }

  let role: Role
  let content: String
}

// MARK: - AI Provider Error
enum AIProviderError: Error, LocalizedError, Sendable {
  case invalidResponse
  case emptyResponse
  case apiError(statusCode: Int, message: String)
  case providerUnavailable(name: String)
  case configurationMissing

  var errorDescription: String? {
    switch self {
    case .invalidResponse:
      return "Invalid response from AI provider"
    case .emptyResponse:
      return "Empty response from AI provider"
    case .apiError(let code, let message):
      return "API Error (\(code)): \(message)"
    case .providerUnavailable(let name):
      return "\(name) is currently unavailable"
    case .configurationMissing:
      return "AI provider configuration is missing"
    }
  }
}

// MARK: - OpenAI Compatible Client
/// 通用 OpenAI 兼容客户端
/// 支持 OpenAI、Ollama、Deepseek、Groq、Together AI 等
final actor OpenAICompatibleClient: AIProvider {

  struct Configuration: Codable, Sendable {
    let name: String
    let baseURL: URL
    let apiKey: String
    let defaultModel: String
    let headers: [String: String]?
    let timeout: TimeInterval

    // 预设配置
    static func openAI(apiKey: String) -> Configuration {
      Configuration(
        name: "OpenAI",
        baseURL: URL(string: "https://api.openai.com/v1")!,
        apiKey: apiKey,
        defaultModel: "gpt-4o",
        headers: nil,
        timeout: 60
      )
    }

    static func ollama(baseURL: String = "http://localhost:11434", model: String = "llama3.2")
      -> Configuration
    {
      Configuration(
        name: "Ollama",
        baseURL: URL(string: "\(baseURL)/v1")!,
        apiKey: "ollama",
        defaultModel: model,
        headers: nil,
        timeout: 120
      )
    }

    static func deepseek(apiKey: String) -> Configuration {
      Configuration(
        name: "Deepseek",
        baseURL: URL(string: "https://api.deepseek.com/v1")!,
        apiKey: apiKey,
        defaultModel: "deepseek-chat",
        headers: nil,
        timeout: 60
      )
    }

    static func groq(apiKey: String, model: String = "llama-3.3-70b-versatile") -> Configuration {
      Configuration(
        name: "Groq",
        baseURL: URL(string: "https://api.groq.com/openai/v1")!,
        apiKey: apiKey,
        defaultModel: model,
        headers: nil,
        timeout: 30
      )
    }

    static func custom(name: String, baseURL: String, apiKey: String, model: String)
      -> Configuration
    {
      Configuration(
        name: name,
        baseURL: URL(string: baseURL)!,
        apiKey: apiKey,
        defaultModel: model,
        headers: nil,
        timeout: 60
      )
    }
  }

  private let configuration: Configuration
  private var _session: URLSession?

  // Non-isolated property access thanks to immutable configuration
  nonisolated var name: String { configuration.name }

  init(configuration: Configuration) {
    self.configuration = configuration
  }

  private func getSession() -> URLSession {
    if let existing = _session {
      return existing
    }
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = configuration.timeout
    let newSession = URLSession(configuration: sessionConfig)
    _session = newSession
    return newSession
  }

  func checkAvailability() async -> Bool {
    if configuration.baseURL.host == "localhost" || configuration.baseURL.host == "127.0.0.1" {
      return await checkLocalAvailability()
    }
    return true
  }

  private func checkLocalAvailability() async -> Bool {
    let baseURLString = configuration.baseURL.absoluteString.replacingOccurrences(
      of: "/v1", with: "")
    guard let url = URL(string: "\(baseURLString)/api/tags") else {
      return false
    }

    do {
      let (_, response) = try await getSession().data(from: url)
      return (response as? HTTPURLResponse)?.statusCode == 200
    } catch {
      return false
    }
  }

  func chat(
    messages: [ChatMessage],
    model: String? = nil,
    temperature: Double? = nil,
    maxTokens: Int? = nil
  ) async throws -> String {
    let url = configuration.baseURL.appendingPathComponent("chat/completions")

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(configuration.apiKey)", forHTTPHeaderField: "Authorization")

    configuration.headers?.forEach { key, value in
      request.setValue(value, forHTTPHeaderField: key)
    }

    let body: [String: Any] = [
      "model": model ?? configuration.defaultModel,
      "messages": messages.map { ["role": $0.role.rawValue, "content": $0.content] },
      "temperature": temperature ?? 0.7,
      "max_tokens": maxTokens ?? 1024,
    ]

    request.httpBody = try JSONSerialization.data(withJSONObject: body)

    let (data, response) = try await getSession().data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
      throw AIProviderError.invalidResponse
    }

    guard httpResponse.statusCode == 200 else {
      let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
      throw AIProviderError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
    }

    struct ChatResponse: Codable {
      struct Choice: Codable {
        struct Message: Codable {
          let content: String
        }
        let message: Message
      }
      let choices: [Choice]
    }

    let result = try JSONDecoder().decode(ChatResponse.self, from: data)

    guard let content = result.choices.first?.message.content else {
      throw AIProviderError.emptyResponse
    }

    return content
  }
}
