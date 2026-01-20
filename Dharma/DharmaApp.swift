// DharmaApp.swift
// Dharma - Main App Entry

import SwiftData
import SwiftUI

@main
struct DharmaApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([
      UserModel.self,
      AntiVisionModel.self,
      GoalHierarchyModel.self,
      DailyLeverModel.self,
      FailureModel.self,
      ReflectionModel.self,
      PainLogModel.self,
      DisappearItemModel.self,
      VisionMVPModel.self,
    ])
    let modelConfiguration = ModelConfiguration(
      schema: schema,
      isStoredInMemoryOnly: false,
      cloudKitDatabase: .none
    )

    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()

  init() {
    // 初始化 AI 引擎（使用 UserDefaults 中保存的配置）
    setupAIEngine()

    // 设置导航栏外观 - 深色标题确保可读性
    setupNavigationBarAppearance()
  }

  var body: some Scene {
    WindowGroup {
      MainTabView()
        .tint(.brand)  // 设置全局强调色
    }
    .modelContainer(sharedModelContainer)
  }

  private func setupNavigationBarAppearance() {
    // iOS 26 导航栏样式 - 按设计规范 2.2 字体系统
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()

    // Large Title: Bold 34pt - 设计规范表格
    appearance.largeTitleTextAttributes = [
      .foregroundColor: UIColor(Color(hex: "#1C1C1E")),  // textPrimary
      .font: UIFont.systemFont(ofSize: 34, weight: .bold),
    ]

    // Title 3: Semibold 20pt
    appearance.titleTextAttributes = [
      .foregroundColor: UIColor(Color(hex: "#1C1C1E")),  // textPrimary
      .font: UIFont.systemFont(ofSize: 20, weight: .semibold),
    ]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().tintColor = UIColor(Color(hex: "#7B5EA7"))  // brand
  }

  private func setupAIEngine() {
    let manager = AIEngineManager.shared

    // 默认设置 Ollama（本地优先）
    manager.setupOllama()

    // 如果用户配置了 OpenAI
    if let openAIKey = UserDefaults.standard.string(forKey: "openai_api_key"), !openAIKey.isEmpty {
      manager.setupOpenAI(apiKey: openAIKey)
      try? manager.setActiveProvider("OpenAI")
    }

    // 如果用户配置了 Deepseek
    if let deepseekKey = UserDefaults.standard.string(forKey: "deepseek_api_key"),
      !deepseekKey.isEmpty
    {
      manager.setupDeepseek(apiKey: deepseekKey)
    }
  }
}
