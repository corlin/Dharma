// SettingsView.swift
// Dharma Features - Settings - AI Engine Configuration

import SwiftUI

/// 设置页面
/// 配置 AI 引擎参数
struct SettingsView: View {
  @Environment(\.dismiss) private var dismiss

  // 持久化存储配置
  @AppStorage("aiProvider") private var selectedProvider = "OpenAI"
  @AppStorage("aiApiKey") private var apiKey = ""
  @AppStorage("aiModel") private var modelName = "gpt-4o"
  @AppStorage("aiBaseURL") private var baseURL = "https://api.openai.com/v1"

  @State private var isTesting = false
  @State private var connectionResult: Bool?
  @State private var resultMessage = ""

  let providers = ["OpenAI", "Deepseek", "Ollama", "Groq"]

  var body: some View {
    NavigationStack {
      ZStack {
        Color.backgroundPrimary.ignoresSafeArea()

        Form {
          // AI 引擎配置
          Section {
            Picker("Provider", selection: $selectedProvider) {
              ForEach(providers, id: \.self) { provider in
                Text(provider).tag(provider)
              }
            }
            .onChange(of: selectedProvider) { _, newValue in
              updateDefaults(for: newValue)
            }

            if selectedProvider != "Ollama" {
              SecureField("API Key", text: $apiKey)
                .textContentType(.password)
                .autocorrectionDisabled()
            }

            TextField("Model Name", text: $modelName)
              .autocorrectionDisabled()

            if selectedProvider == "Ollama" || selectedProvider == "Deepseek" {
              TextField("Base URL", text: $baseURL)
                .keyboardType(.URL)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            }
          } header: {
            Text("AI Engine Configuration")
          } footer: {
            Text("Choose your preferred AI provider to power Dharma's reflective capabilities.")
          }

          // 连接测试
          Section {
            Button {
              testConnection()
            } label: {
              HStack {
                Text(isTesting ? "Testing..." : "Test Connection")

                if isTesting {
                  Spacer()
                  ProgressView()
                } else if let result = connectionResult {
                  Spacer()
                  Image(
                    systemName: result ? "checkmark.circle.fill" : "exclamationmark.circle.fill"
                  )
                  .foregroundColor(result ? .success : .error)
                }
              }
            }
            .disabled(isTesting || (selectedProvider != "Ollama" && apiKey.isEmpty))

            if !resultMessage.isEmpty {
              Text(resultMessage)
                .font(.caption)
                .foregroundColor(connectionResult == true ? .success : .error)
            }
          }

          // 调试信息
          Section("About") {
            HStack {
              Text("Version")
              Spacer()
              Text("0.1.0 Alpha")
                .foregroundColor(.textSecondary)
            }
          }
        }
        .scrollContentBackground(.hidden)
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            applyConfiguration()
            dismiss()
          }
        }
      }
      .onAppear {
        // 如果是首次进入，设置默认值
        if apiKey.isEmpty && selectedProvider == "Deepseek" {
          baseURL = "https://api.deepseek.com/v1"
          modelName = "deepseek-chat"
        }
      }
    }
  }

  // MARK: - Logic

  private func updateDefaults(for provider: String) {
    switch provider {
    case "OpenAI":
      baseURL = "https://api.openai.com/v1"
      modelName = "gpt-4o"
    case "Deepseek":
      baseURL = "https://api.deepseek.com/v1"
      modelName = "deepseek-chat"
    case "Ollama":
      baseURL = "http://localhost:11434"
      modelName = "llama3.2"
    case "Groq":
      baseURL = "https://api.groq.com/openai/v1"
      modelName = "llama-3.3-70b-versatile"
    default:
      break
    }
  }

  private func applyConfiguration() {
    let manager = AIEngineManager.shared
    switch selectedProvider {
    case "OpenAI":
      manager.setupOpenAI(apiKey: apiKey)
    case "Deepseek":
      manager.setupDeepseek(apiKey: apiKey)
    case "Ollama":
      manager.setupOllama(baseURL: baseURL, model: modelName)
    case "Groq":
      manager.setupGroq(apiKey: apiKey, model: modelName)
    default:
      break
    }

    // 如果使用了自定义配置(OpenAI Compatible)，也可以用通用方法配置
    // 为了简单，我们这里假设 setupXXX 方法会处理细节
  }

  private func testConnection() {
    isTesting = true
    connectionResult = nil
    resultMessage = ""

    // 先应用配置
    applyConfiguration()

    Task {
      let manager = AIEngineManager.shared
      guard let provider = manager.getActiveProvider() else {
        await MainActor.run {
          isTesting = false
          connectionResult = false
          resultMessage = "Provider not configured"
        }
        return
      }

      let isAvailable = await provider.checkAvailability()

      await MainActor.run {
        isTesting = false
        connectionResult = isAvailable
        resultMessage =
          isAvailable ? "Connection Successful" : "Connection Failed. Check API Key or Network."
      }
    }
  }
}

#Preview {
  SettingsView()
}
