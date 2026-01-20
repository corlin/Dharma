# Dharma App 技术架构 v1.0

> 基于 iOS 26 + Swift 6 + SwiftUI 的现代化架构设计  
> 采用 TCA (The Composable Architecture) 架构模式

---

## 一、技术栈概览

### 1.1 核心技术选型

| 层级 | 技术选型 | 版本 | 理由 |
|-----|---------|------|-----|
| **语言** | Swift | 6.0 | Actor 隔离、严格并发检查 |
| **UI 框架** | SwiftUI | iOS 26 | 原生声明式 UI |
| **架构模式** | TCA | 1.x | 可预测状态管理、易测试 |
| **本地存储** | SwiftData | iOS 26 | 原生 Swift 持久化 |
| **云同步** | CloudKit | - | 苹果生态无缝集成 |
| **AI 引擎** | Core ML + OpenAI | GPT-4 | 本地推理 + 云端分析 |
| **通知** | UserNotifications | - | 觉察打断功能 |
| **Widget** | WidgetKit | iOS 26 | 桌面组件 |
| **动画** | SwiftUI Animations | iOS 26 | 原生流畅动效 |

### 1.2 架构原则

```
┌─────────────────────────────────────────────────────────────────────┐
│                        DHARMA 技术架构                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                    Presentation Layer                       │   │
│  │  SwiftUI Views + ViewState + TCA Reducers                   │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                     Domain Layer                            │   │
│  │  Use Cases + Entities + Business Logic                      │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                      Data Layer                             │   │
│  │  SwiftData Models + CloudKit Sync + API Clients             │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│                              ▼                                      │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                   Infrastructure Layer                      │   │
│  │  Core ML + OpenAI SDK + Notifications + Analytics           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 二、项目结构

### 2.1 模块划分

```
Dharma/
├── App/
│   ├── DharmaApp.swift              # 应用入口
│   ├── AppDelegate.swift            # AppDelegate 适配
│   └── ContentView.swift            # 根视图
│
├── Core/
│   ├── Architecture/
│   │   ├── AppReducer.swift         # 根 Reducer
│   │   ├── AppState.swift           # 全局状态
│   │   └── Dependencies.swift       # 依赖注入容器
│   │
│   ├── DesignSystem/
│   │   ├── Colors.swift             # 颜色 Token
│   │   ├── Typography.swift         # 字体系统
│   │   ├── Spacing.swift            # 间距系统
│   │   └── Shadows.swift            # 阴影系统
│   │
│   └── Extensions/
│       ├── View+Extensions.swift
│       ├── Color+Hex.swift
│       └── Date+Extensions.swift
│
├── Features/
│   ├── Excavate/                    # 挖掘层
│   │   ├── ExcavateFeature.swift    # TCA Feature
│   │   ├── ExcavateView.swift       # 主视图
│   │   ├── AntiVisionWorkshop/      # 反愿景工坊
│   │   ├── PainPointLogger/         # 痛点日志
│   │   └── IdentityArchaeology/     # 身份考古
│   │
│   ├── Orient/                      # 定向层
│   │   ├── OrientFeature.swift
│   │   ├── OrientView.swift
│   │   ├── VisionMVP/
│   │   ├── GoalHierarchy/
│   │   ├── ProjectWorkshop/
│   │   └── DisappearList/           # 消失清单
│   │
│   ├── Execute/                     # 执行层
│   │   ├── ExecuteFeature.swift
│   │   ├── ExecuteView.swift
│   │   ├── DeepWorkSession/
│   │   ├── FlowCalibrator/
│   │   └── RecoveryMode/
│   │
│   ├── Feedback/                    # 反馈层
│   │   ├── FeedbackFeature.swift
│   │   ├── FeedbackView.swift
│   │   ├── CyberneticDashboard/
│   │   ├── WeeklyReview/
│   │   └── FailurePortfolio/        # 失败投资组合
│   │
│   └── Evolve/                      # 进化层
│       ├── EvolveFeature.swift
│       ├── EvolveView.swift
│       ├── IdentityConsolidation/
│       ├── XPSystem/
│       └── StageAssessment/
│
├── Components/
│   ├── Cards/
│   │   ├── GlassCard.swift
│   │   └── TaskCard.swift
│   ├── Buttons/
│   │   ├── GradientButton.swift
│   │   └── SecondaryButton.swift
│   ├── Tags/
│   │   └── TagChip.swift
│   ├── AI/
│   │   ├── OrbBubble.swift
│   │   └── OrbCharacter.swift
│   ├── Progress/
│   │   ├── XPProgressRing.swift
│   │   └── FlowMeter.swift
│   └── Charts/
│       └── WeeklyChart.swift
│
├── Domain/
│   ├── Entities/
│   │   ├── User.swift
│   │   ├── AntiVision.swift
│   │   ├── VisionMVP.swift
│   │   ├── GoalHierarchy.swift
│   │   ├── Project.swift
│   │   ├── DailyTask.swift
│   │   ├── Failure.swift
│   │   └── IdentityEvolution.swift
│   │
│   └── UseCases/
│       ├── ExcavateUseCases.swift
│       ├── OrientUseCases.swift
│       ├── ExecuteUseCases.swift
│       ├── FeedbackUseCases.swift
│       └── EvolveUseCases.swift
│
├── Data/
│   ├── SwiftData/
│   │   ├── Models/
│   │   │   ├── UserModel.swift
│   │   │   ├── GoalModel.swift
│   │   │   ├── TaskModel.swift
│   │   │   └── ReflectionModel.swift
│   │   └── ModelContainer+Dharma.swift
│   │
│   ├── CloudKit/
│   │   ├── CloudKitManager.swift
│   │   └── SyncEngine.swift
│   │
│   └── API/
│       ├── OpenAIClient.swift
│       └── AnalyticsClient.swift
│
├── Services/
│   ├── AI/
│   │   ├── AIAnalysisEngine.swift
│   │   ├── SocraticQuestionGenerator.swift
│   │   └── PatternRecognizer.swift
│   │
│   ├── Notifications/
│   │   ├── AwarenessInterrupter.swift
│   │   └── NotificationManager.swift
│   │
│   └── XP/
│       ├── XPCalculator.swift
│       └── LevelSystem.swift
│
├── Widgets/
│   ├── DailyLeverWidget/
│   ├── XPProgressWidget/
│   └── QuoteWidget/
│
└── Resources/
    ├── Assets.xcassets/
    ├── Localizable.strings
    └── OrbAnimations/              # Lottie/RealityKit 动画
```

---

## 三、TCA 架构详解

### 3.1 Feature 结构模板

每个功能模块遵循统一的 TCA Feature 结构：

```swift
import ComposableArchitecture

@Reducer
struct ExcavateFeature {
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var currentStep: ExcavationStep = .welcome
        var antiVision: AntiVision?
        var painPoints: [PainPoint] = []
        var identityStatement: String = ""
        var isLoading: Bool = false
        var orbMessage: String = ""
        
        // 子功能状态
        @Presents var antiVisionWorkshop: AntiVisionWorkshopFeature.State?
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case startAntiVisionWorkshop
        case antiVisionWorkshop(PresentationAction<AntiVisionWorkshopFeature.Action>)
        case saveCompleted(Result<Void, Error>)
        case orbMessageReceived(String)
    }
    
    // MARK: - Dependencies
    @Dependency(\.excavateClient) var excavateClient
    @Dependency(\.aiEngine) var aiEngine
    @Dependency(\.continuousClock) var clock
    
    // MARK: - Reducer Body
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let message = await aiEngine.generateWelcomeMessage()
                    await send(.orbMessageReceived(message))
                }
                
            case .startAntiVisionWorkshop:
                state.antiVisionWorkshop = AntiVisionWorkshopFeature.State()
                return .none
                
            case .antiVisionWorkshop(.presented(.completed(let antiVision))):
                state.antiVision = antiVision
                state.antiVisionWorkshop = nil
                return .run { send in
                    try await excavateClient.save(antiVision)
                    await send(.saveCompleted(.success(())))
                }
                
            case .orbMessageReceived(let message):
                state.orbMessage = message
                return .none
                
            default:
                return .none
            }
        }
        .ifLet(\.$antiVisionWorkshop, action: \.antiVisionWorkshop) {
            AntiVisionWorkshopFeature()
        }
    }
}
```

### 3.2 依赖注入

使用 TCA 的依赖系统管理所有服务：

```swift
// Dependencies.swift
import ComposableArchitecture

// MARK: - AI Engine Dependency
struct AIEngineClient {
    var generateWelcomeMessage: @Sendable () async -> String
    var generateSocraticQuestion: @Sendable (Context) async -> String
    var analyzePatterns: @Sendable ([Behavior]) async -> PatternAnalysis
}

extension AIEngineClient: DependencyKey {
    static let liveValue = AIEngineClient(
        generateWelcomeMessage: {
            // 实际 AI 调用
            await OpenAIService.shared.generateWelcome()
        },
        generateSocraticQuestion: { context in
            await OpenAIService.shared.generateQuestion(context: context)
        },
        analyzePatterns: { behaviors in
            await OpenAIService.shared.analyzePatterns(behaviors)
        }
    )
    
    static let testValue = AIEngineClient(
        generateWelcomeMessage: { "Test welcome message" },
        generateSocraticQuestion: { _ in "Test question?" },
        analyzePatterns: { _ in PatternAnalysis.mock }
    )
}

extension DependencyValues {
    var aiEngine: AIEngineClient {
        get { self[AIEngineClient.self] }
        set { self[AIEngineClient.self] = newValue }
    }
}

// MARK: - SwiftData Client
struct SwiftDataClient {
    var fetchUser: @Sendable () async throws -> User?
    var saveAntiVision: @Sendable (AntiVision) async throws -> Void
    var fetchGoalHierarchy: @Sendable () async throws -> GoalHierarchy?
    // ... 更多数据操作
}

extension SwiftDataClient: DependencyKey {
    static let liveValue = SwiftDataClient(
        fetchUser: {
            try await SwiftDataManager.shared.fetchUser()
        },
        saveAntiVision: { antiVision in
            try await SwiftDataManager.shared.save(antiVision)
        },
        fetchGoalHierarchy: {
            try await SwiftDataManager.shared.fetchGoalHierarchy()
        }
    )
}
```

---

## 四、数据层设计

### 4.1 SwiftData 模型

```swift
import SwiftData

// MARK: - User Model
@Model
final class UserModel {
    @Attribute(.unique) var id: UUID
    var currentMindStage: Int
    var activeIdentityStatement: String
    var totalXP: Int
    var currentLevel: String
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade)
    var antiVision: AntiVisionModel?
    
    @Relationship(deleteRule: .cascade)
    var visionMVP: VisionMVPModel?
    
    @Relationship(deleteRule: .cascade)
    var goalHierarchy: GoalHierarchyModel?
    
    @Relationship(deleteRule: .cascade)
    var failures: [FailureModel]
    
    @Relationship(deleteRule: .cascade)
    var reflections: [ReflectionModel]
    
    init(
        id: UUID = UUID(),
        currentMindStage: Int = 4,
        activeIdentityStatement: String = "",
        totalXP: Int = 0,
        currentLevel: String = "新手"
    ) {
        self.id = id
        self.currentMindStage = currentMindStage
        self.activeIdentityStatement = activeIdentityStatement
        self.totalXP = totalXP
        self.currentLevel = currentLevel
        self.createdAt = Date()
        self.updatedAt = Date()
        self.failures = []
        self.reflections = []
    }
}

// MARK: - Anti Vision Model
@Model
final class AntiVisionModel {
    var fiveYearTuesday: String
    var tenYearTuesday: String
    var lifetimeCost: String
    var compressedStatement: String
    var roleModel: String
    var createdAt: Date
    
    init(
        fiveYearTuesday: String = "",
        tenYearTuesday: String = "",
        lifetimeCost: String = "",
        compressedStatement: String = "",
        roleModel: String = ""
    ) {
        self.fiveYearTuesday = fiveYearTuesday
        self.tenYearTuesday = tenYearTuesday
        self.lifetimeCost = lifetimeCost
        self.compressedStatement = compressedStatement
        self.roleModel = roleModel
        self.createdAt = Date()
    }
}

// MARK: - Goal Hierarchy Model
@Model
final class GoalHierarchyModel {
    var decadeGoalDescription: String
    var yearGoalDescription: String
    var quarterProjectDescription: String
    var weekMilestoneDescription: String
    
    @Relationship(deleteRule: .cascade)
    var dailyTasks: [DailyTaskModel]
    
    @Relationship(deleteRule: .cascade)
    var projects: [ProjectModel]
    
    var updatedAt: Date
    
    init() {
        self.decadeGoalDescription = ""
        self.yearGoalDescription = ""
        self.quarterProjectDescription = ""
        self.weekMilestoneDescription = ""
        self.dailyTasks = []
        self.projects = []
        self.updatedAt = Date()
    }
}

// MARK: - Failure Model (XP System)
@Model
final class FailureModel {
    @Attribute(.unique) var id: UUID
    var description: String
    var learningExtracted: String?
    var appliedToNextAttempt: Bool
    var xpEarned: Int
    var createdAt: Date
    var category: String  // 对应哪个项目/目标
    
    init(
        id: UUID = UUID(),
        description: String,
        learningExtracted: String? = nil,
        appliedToNextAttempt: Bool = false,
        category: String = ""
    ) {
        self.id = id
        self.description = description
        self.learningExtracted = learningExtracted
        self.appliedToNextAttempt = appliedToNextAttempt
        self.category = category
        self.createdAt = Date()
        
        // 计算 XP
        var xp = 10  // 基础失败 XP
        if learningExtracted != nil { xp += 20 }
        if appliedToNextAttempt { xp += 30 }
        self.xpEarned = xp
    }
}
```

### 4.2 CloudKit 同步

```swift
import CloudKit

actor CloudKitSyncEngine {
    static let shared = CloudKitSyncEngine()
    
    private let container = CKContainer(identifier: "iCloud.com.dharma.app")
    private let privateDatabase: CKDatabase
    
    init() {
        self.privateDatabase = container.privateCloudDatabase
    }
    
    // MARK: - Sync Configuration
    func setupSync() async throws {
        // 创建自定义 Zone
        let zone = CKRecordZone(zoneName: "DharmaZone")
        try await privateDatabase.save(zone)
        
        // 订阅变更
        let subscription = CKDatabaseSubscription(subscriptionID: "dharma-changes")
        subscription.recordType = nil  // 监听所有类型
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        try await privateDatabase.save(subscription)
    }
    
    // MARK: - Sync Operations
    func syncLocalToCloud(_ user: UserModel) async throws {
        let record = CKRecord(recordType: "User")
        record["id"] = user.id.uuidString
        record["mindStage"] = user.currentMindStage
        record["identityStatement"] = user.activeIdentityStatement
        record["totalXP"] = user.totalXP
        record["updatedAt"] = user.updatedAt
        
        try await privateDatabase.save(record)
    }
    
    func fetchCloudChanges() async throws -> [CKRecord] {
        let query = CKQuery(recordType: "User", predicate: NSPredicate(value: true))
        let (results, _) = try await privateDatabase.records(matching: query)
        return results.compactMap { try? $0.1.get() }
    }
}
```

---

## 五、AI 分析引擎（多引擎架构）

### 5.1 架构设计

支持多种 AI 后端，包括 OpenAI 及其兼容服务：

```
┌─────────────────────────────────────────────────────────────────────┐
│                      AI Analysis Engine v2.0                        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │                  AI Provider Abstraction                    │   │
│  │                    (Protocol-based)                         │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                              │                                      │
│         ┌────────────────────┼────────────────────┐                │
│         ▼                    ▼                    ▼                │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐             │
│  │   OpenAI    │    │  兼容模式   │    │  本地推理   │             │
│  │   官方 API   │    │  (多服务商)  │    │  (Core ML)  │             │
│  ├─────────────┤    ├─────────────┤    ├─────────────┤             │
│  │ • GPT-4o    │    │ • Ollama    │    │ • 情绪分类  │             │
│  │ • GPT-4     │    │ • Deepseek  │    │ • 模式识别  │             │
│  │ • GPT-3.5   │    │ • Groq      │    │ • 标签推荐  │             │
│  │             │    │ • Together  │    │             │             │
│  │             │    │ • Azure     │    │             │             │
│  │             │    │ • Claude*   │    │             │             │
│  │             │    │ • 自定义    │    │             │             │
│  └─────────────┘    └─────────────┘    └─────────────┘             │
│         │                    │                    │                │
│         └────────────────────┼────────────────────┘                │
│                              ▼                                      │
│  ┌──────────────────────────────────────────────────────────────┐  │
│  │                   AI Orchestrator                             │  │
│  │   智能选择最佳引擎，基于：                                    │  │
│  │   • 任务类型（简单/复杂）                                     │  │
│  │   • 用户配置（首选引擎）                                      │  │
│  │   • 网络状态（在线/离线）                                     │  │
│  │   • 成本优化（本地优先）                                      │  │
│  │   • 隐私级别（敏感数据本地处理）                              │  │
│  └──────────────────────────────────────────────────────────────┘  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

*注：Claude 需使用 OpenAI 兼容层（如 LiteLLM）

---

### 5.2 AI Provider 协议定义

```swift
// AIProvider.swift
import Foundation

/// AI 提供商协议 - 所有引擎必须实现
protocol AIProvider: Sendable {
    /// 提供商名称
    var name: String { get }
    
    /// 是否可用
    var isAvailable: Bool { get async }
    
    /// 生成聊天响应
    func chat(
        messages: [ChatMessage],
        model: String?,
        temperature: Double?,
        maxTokens: Int?
    ) async throws -> String
    
    /// 流式生成（可选）
    func streamChat(
        messages: [ChatMessage],
        model: String?,
        temperature: Double?,
        maxTokens: Int?
    ) -> AsyncThrowingStream<String, Error>
}

/// 聊天消息
struct ChatMessage: Codable, Sendable {
    enum Role: String, Codable, Sendable {
        case system, user, assistant
    }
    
    let role: Role
    let content: String
}

/// OpenAI 兼容 API 响应
struct OpenAICompatibleResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
        let finishReason: String?
        
        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
        }
    }
    
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    
    struct Usage: Codable {
        let promptTokens: Int
        let completionTokens: Int
        let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }
    }
    let usage: Usage?
}
```

---

### 5.3 OpenAI 兼容模式客户端

```swift
// OpenAICompatibleClient.swift
import Foundation

/// 通用 OpenAI 兼容客户端
/// 支持所有遵循 OpenAI API 规范的服务
actor OpenAICompatibleClient: AIProvider {
    
    // MARK: - Configuration
    struct Configuration: Codable, Sendable {
        let name: String
        let baseURL: URL
        let apiKey: String
        let defaultModel: String
        let headers: [String: String]?
        let timeout: TimeInterval
        
        /// 预设配置
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
        
        static func ollama(baseURL: String = "http://localhost:11434", model: String = "llama3.2") -> Configuration {
            Configuration(
                name: "Ollama",
                baseURL: URL(string: "\(baseURL)/v1")!,
                apiKey: "ollama",  // Ollama 不需要真实 key
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
                timeout: 30  // Groq 非常快
            )
        }
        
        static func togetherAI(apiKey: String, model: String = "meta-llama/Llama-3.3-70B-Instruct-Turbo") -> Configuration {
            Configuration(
                name: "Together AI",
                baseURL: URL(string: "https://api.together.xyz/v1")!,
                apiKey: apiKey,
                defaultModel: model,
                headers: nil,
                timeout: 60
            )
        }
        
        static func azureOpenAI(endpoint: String, apiKey: String, deploymentName: String) -> Configuration {
            Configuration(
                name: "Azure OpenAI",
                baseURL: URL(string: "\(endpoint)/openai/deployments/\(deploymentName)")!,
                apiKey: apiKey,
                defaultModel: deploymentName,
                headers: ["api-key": apiKey],
                timeout: 60
            )
        }
        
        static func custom(name: String, baseURL: String, apiKey: String, model: String) -> Configuration {
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
    
    // MARK: - Properties
    private let configuration: Configuration
    private let session: URLSession
    
    var name: String { configuration.name }
    
    // MARK: - Initialization
    init(configuration: Configuration) {
        self.configuration = configuration
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = configuration.timeout
        self.session = URLSession(configuration: sessionConfig)
    }
    
    // MARK: - Availability Check
    var isAvailable: Bool {
        get async {
            // 对于本地服务（如 Ollama），检查是否可连接
            if configuration.baseURL.host == "localhost" || configuration.baseURL.host == "127.0.0.1" {
                return await checkLocalAvailability()
            }
            // 云服务假设可用（有网络时）
            return true
        }
    }
    
    private func checkLocalAvailability() async -> Bool {
        guard let url = URL(string: "\(configuration.baseURL.absoluteString.replacingOccurrences(of: "/v1", with: ""))/api/tags") else {
            return false
        }
        
        do {
            let (_, response) = try await session.data(from: url)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
    
    // MARK: - Chat Completion
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
        
        // 添加自定义 headers
        configuration.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let body: [String: Any] = [
            "model": model ?? configuration.defaultModel,
            "messages": messages.map { ["role": $0.role.rawValue, "content": $0.content] },
            "temperature": temperature ?? 0.7,
            "max_tokens": maxTokens ?? 1024
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIProviderError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AIProviderError.apiError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
        
        let result = try JSONDecoder().decode(OpenAICompatibleResponse.self, from: data)
        
        guard let content = result.choices.first?.message.content else {
            throw AIProviderError.emptyResponse
        }
        
        return content
    }
    
    // MARK: - Streaming Chat
    func streamChat(
        messages: [ChatMessage],
        model: String? = nil,
        temperature: Double? = nil,
        maxTokens: Int? = nil
    ) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let url = configuration.baseURL.appendingPathComponent("chat/completions")
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(configuration.apiKey)", forHTTPHeaderField: "Authorization")
                    
                    let body: [String: Any] = [
                        "model": model ?? configuration.defaultModel,
                        "messages": messages.map { ["role": $0.role.rawValue, "content": $0.content] },
                        "temperature": temperature ?? 0.7,
                        "max_tokens": maxTokens ?? 1024,
                        "stream": true
                    ]
                    
                    request.httpBody = try JSONSerialization.data(withJSONObject: body)
                    
                    let (bytes, _) = try await session.bytes(for: request)
                    
                    for try await line in bytes.lines {
                        if line.hasPrefix("data: ") {
                            let jsonString = String(line.dropFirst(6))
                            if jsonString == "[DONE]" {
                                continuation.finish()
                                return
                            }
                            
                            if let data = jsonString.data(using: .utf8),
                               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let choices = json["choices"] as? [[String: Any]],
                               let delta = choices.first?["delta"] as? [String: Any],
                               let content = delta["content"] as? String {
                                continuation.yield(content)
                            }
                        }
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

// MARK: - Errors
enum AIProviderError: Error, LocalizedError {
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
```

---

### 5.4 AI 引擎管理器

```swift
// AIEngineManager.swift
import Foundation

/// AI 引擎管理器 - 统一管理多个 AI 提供商
actor AIEngineManager {
    static let shared = AIEngineManager()
    
    // MARK: - Provider Registry
    private var providers: [String: any AIProvider] = [:]
    private var activeProviderName: String?
    
    // MARK: - Configuration
    struct Settings: Codable {
        var activeProvider: String
        var providerConfigs: [String: OpenAICompatibleClient.Configuration]
        var fallbackToLocal: Bool
        var localModelEnabled: Bool
        
        static let `default` = Settings(
            activeProvider: "OpenAI",
            providerConfigs: [:],
            fallbackToLocal: true,
            localModelEnabled: true
        )
    }
    
    private var settings: Settings = .default
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Provider Management
    func configure(with settings: Settings) async {
        self.settings = settings
        
        // 注册配置的提供商
        for (name, config) in settings.providerConfigs {
            let client = OpenAICompatibleClient(configuration: config)
            providers[name] = client
        }
        
        // 设置活动提供商
        activeProviderName = settings.activeProvider
    }
    
    func registerProvider(_ provider: any AIProvider, name: String) {
        providers[name] = provider
    }
    
    func setActiveProvider(_ name: String) throws {
        guard providers[name] != nil else {
            throw AIProviderError.providerUnavailable(name: name)
        }
        activeProviderName = name
    }
    
    func getActiveProvider() -> (any AIProvider)? {
        guard let name = activeProviderName else { return nil }
        return providers[name]
    }
    
    func listProviders() -> [String] {
        Array(providers.keys)
    }
    
    // MARK: - Quick Setup Helpers
    func setupOpenAI(apiKey: String) {
        let config = OpenAICompatibleClient.Configuration.openAI(apiKey: apiKey)
        let client = OpenAICompatibleClient(configuration: config)
        providers["OpenAI"] = client
    }
    
    func setupOllama(baseURL: String = "http://localhost:11434", model: String = "llama3.2") {
        let config = OpenAICompatibleClient.Configuration.ollama(baseURL: baseURL, model: model)
        let client = OpenAICompatibleClient(configuration: config)
        providers["Ollama"] = client
    }
    
    func setupDeepseek(apiKey: String) {
        let config = OpenAICompatibleClient.Configuration.deepseek(apiKey: apiKey)
        let client = OpenAICompatibleClient(configuration: config)
        providers["Deepseek"] = client
    }
    
    func setupGroq(apiKey: String, model: String = "llama-3.3-70b-versatile") {
        let config = OpenAICompatibleClient.Configuration.groq(apiKey: apiKey, model: model)
        let client = OpenAICompatibleClient(configuration: config)
        providers["Groq"] = client
    }
    
    func setupTogetherAI(apiKey: String, model: String = "meta-llama/Llama-3.3-70B-Instruct-Turbo") {
        let config = OpenAICompatibleClient.Configuration.togetherAI(apiKey: apiKey, model: model)
        let client = OpenAICompatibleClient(configuration: config)
        providers["Together AI"] = client
    }
    
    func setupAzureOpenAI(endpoint: String, apiKey: String, deploymentName: String) {
        let config = OpenAICompatibleClient.Configuration.azureOpenAI(
            endpoint: endpoint,
            apiKey: apiKey,
            deploymentName: deploymentName
        )
        let client = OpenAICompatibleClient(configuration: config)
        providers["Azure OpenAI"] = client
    }
    
    func setupCustomProvider(name: String, baseURL: String, apiKey: String, model: String) {
        let config = OpenAICompatibleClient.Configuration.custom(
            name: name,
            baseURL: baseURL,
            apiKey: apiKey,
            model: model
        )
        let client = OpenAICompatibleClient(configuration: config)
        providers[name] = client
    }
}
```

---

### 5.5 苏格拉底式提问生成器（多引擎版本）

```swift
// SocraticQuestionGenerator.swift
import Foundation

actor SocraticQuestionGenerator {
    private let aiManager = AIEngineManager.shared
    
    // MARK: - System Prompt
    private let systemPrompt = """
    你是 Dharma App 的 AI 教练 "Orb"。你的角色是：
    1. 沉默观察用户的行为和反思
    2. 在关键时刻通过苏格拉底式提问引导用户自我发现
    3. 绝不直接给出答案或建议
    4. 用温和、好奇的语气提问
    5. 每次只问一个问题
    
    苏格拉底式提问的类型：
    - 澄清问题：帮助用户更清晰地表达想法
    - 探索假设：挑战用户的隐含假设
    - 寻求证据：引导用户用事实支撑观点
    - 考虑替代：帮助用户看到其他可能性
    - 探索影响：引导用户思考行为的后果
    - 反思问题：帮助用户审视自己的思维过程
    
    重要：只返回问题本身，不要任何前缀、解释或标点符号以外的内容。
    """
    
    struct Context: Codable, Sendable {
        let saidGoals: [String]
        let actualBehaviors: [String]
        let recentReflections: [String]
        let currentChallenge: String?
    }
    
    // MARK: - Generate Question
    func generateQuestion(context: Context) async throws -> String {
        guard let provider = await aiManager.getActiveProvider() else {
            throw AIProviderError.configurationMissing
        }
        
        let userMessage = """
        用户情况：
        - 声称的目标：\(context.saidGoals.joined(separator: ", "))
        - 实际行为：\(context.actualBehaviors.joined(separator: ", "))
        - 最近反思：\(context.recentReflections.joined(separator: "; "))
        - 当前挑战：\(context.currentChallenge ?? "无")
        
        基于以上信息，生成一个苏格拉底式问题，帮助用户自己发现言行之间的差距或隐藏的动机。
        """
        
        let messages = [
            ChatMessage(role: .system, content: systemPrompt),
            ChatMessage(role: .user, content: userMessage)
        ]
        
        let response = try await provider.chat(
            messages: messages,
            model: nil,
            temperature: 0.8,
            maxTokens: 200
        )
        
        return response.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - Generate Welcome Message
    func generateWelcomeMessage() async -> String {
        guard let provider = await aiManager.getActiveProvider() else {
            return "欢迎回来。今天你想探索什么？"
        }
        
        let messages = [
            ChatMessage(role: .system, content: "你是温和的 AI 向导 Orb。生成一句简短的欢迎语，鼓励用户开始今天的自我探索。不超过20个字。"),
            ChatMessage(role: .user, content: "生成欢迎语")
        ]
        
        do {
            return try await provider.chat(messages: messages, model: nil, temperature: 0.9, maxTokens: 50)
        } catch {
            return "欢迎回来。今天你想探索什么？"
        }
    }
}
```

---

### 5.6 本地模式识别 (Core ML)

```swift
import CoreML
import NaturalLanguage

actor PatternRecognizer {
    private var sentimentClassifier: NLModel?
    private var behaviorPattern: BehaviorPatternModel?  // 自定义 Core ML 模型
    
    init() async {
        // 加载内置情感分类器
        sentimentClassifier = try? NLModel(mlModel: NLModel.sentimentClassifier)
        
        // 加载自定义行为模式模型
        if let modelURL = Bundle.main.url(forResource: "BehaviorPattern", withExtension: "mlmodelc") {
            behaviorPattern = try? BehaviorPatternModel(contentsOf: modelURL)
        }
    }
    
    // MARK: - 情感分析
    func analyzeSentiment(text: String) -> Sentiment {
        guard let classifier = sentimentClassifier else {
            return .neutral
        }
        
        let result = classifier.predictedLabel(for: text)
        switch result {
        case "Positive": return .positive
        case "Negative": return .negative
        default: return .neutral
        }
    }
    
    // MARK: - 行为模式识别
    struct BehaviorData {
        let taskCompletionRate: Double
        let averageFocusDuration: Double
        let distractionCount: Int
        let timeOfDay: Int  // 0-23
        let dayOfWeek: Int  // 1-7
    }
    
    func recognizePattern(data: [BehaviorData]) -> Pattern {
        // 使用 Core ML 模型预测行为模式
        // 返回：高效期、拖延期、恢复期 等
        return .productive  // 简化示例
    }
}

enum Sentiment {
    case positive, neutral, negative
}

enum Pattern {
    case productive, procrastinating, recovering, exploring
}
```

---

### 5.7 设置界面 - AI 引擎配置

用户可在设置中选择和配置 AI 引擎：

```swift
// AISettingsView.swift
import SwiftUI

struct AISettingsView: View {
    @State private var selectedProvider = "OpenAI"
    @State private var apiKey = ""
    @State private var customEndpoint = ""
    @State private var customModel = ""
    @State private var isTestingConnection = false
    @State private var connectionStatus: ConnectionStatus = .unknown
    
    enum ConnectionStatus {
        case unknown, testing, success, failed
    }
    
    let providers = [
        "OpenAI",
        "Ollama (本地)",
        "Deepseek",
        "Groq",
        "Together AI",
        "Azure OpenAI",
        "自定义兼容服务"
    ]
    
    var body: some View {
        Form {
            Section("AI 引擎选择") {
                Picker("提供商", selection: $selectedProvider) {
                    ForEach(providers, id: \.self) { provider in
                        Text(provider).tag(provider)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Section("配置") {
                switch selectedProvider {
                case "Ollama (本地)":
                    TextField("服务地址", text: $customEndpoint)
                        .textContentType(.URL)
                        .autocapitalization(.none)
                    TextField("模型名称", text: $customModel)
                        .autocapitalization(.none)
                    Text("提示：确保 Ollama 已在本地运行")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                case "自定义兼容服务":
                    TextField("API 端点", text: $customEndpoint)
                        .textContentType(.URL)
                        .autocapitalization(.none)
                    SecureField("API Key", text: $apiKey)
                    TextField("模型名称", text: $customModel)
                        .autocapitalization(.none)
                    
                default:
                    SecureField("API Key", text: $apiKey)
                    if selectedProvider == "Azure OpenAI" {
                        TextField("端点 URL", text: $customEndpoint)
                        TextField("部署名称", text: $customModel)
                    }
                }
            }
            
            Section {
                Button(action: testConnection) {
                    HStack {
                        if isTestingConnection {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text("测试连接")
                        Spacer()
                        switch connectionStatus {
                        case .success:
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        case .failed:
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        default:
                            EmptyView()
                        }
                    }
                }
                .disabled(isTestingConnection)
            }
            
            Section("支持的服务") {
                VStack(alignment: .leading, spacing: 8) {
                    Label("OpenAI (GPT-4, GPT-4o)", systemImage: "brain")
                    Label("Ollama (本地运行)", systemImage: "laptopcomputer")
                    Label("Deepseek (高性价比)", systemImage: "sparkles")
                    Label("Groq (超快响应)", systemImage: "bolt")
                    Label("Together AI (开源模型)", systemImage: "person.3")
                    Label("Azure OpenAI (企业级)", systemImage: "building.2")
                    Label("任何 OpenAI 兼容 API", systemImage: "link")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .navigationTitle("AI 引擎设置")
    }
    
    private func testConnection() {
        isTestingConnection = true
        connectionStatus = .testing
        
        Task {
            do {
                // 配置并测试
                let manager = AIEngineManager.shared
                
                switch selectedProvider {
                case "Ollama (本地)":
                    await manager.setupOllama(
                        baseURL: customEndpoint.isEmpty ? "http://localhost:11434" : customEndpoint,
                        model: customModel.isEmpty ? "llama3.2" : customModel
                    )
                case "Deepseek":
                    await manager.setupDeepseek(apiKey: apiKey)
                case "Groq":
                    await manager.setupGroq(apiKey: apiKey)
                case "Together AI":
                    await manager.setupTogetherAI(apiKey: apiKey)
                case "自定义兼容服务":
                    await manager.setupCustomProvider(
                        name: "Custom",
                        baseURL: customEndpoint,
                        apiKey: apiKey,
                        model: customModel
                    )
                default:
                    await manager.setupOpenAI(apiKey: apiKey)
                }
                
                try await manager.setActiveProvider(selectedProvider == "Ollama (本地)" ? "Ollama" : selectedProvider)
                
                // 测试一个简单请求
                let generator = SocraticQuestionGenerator()
                _ = await generator.generateWelcomeMessage()
                
                await MainActor.run {
                    connectionStatus = .success
                    isTestingConnection = false
                }
            } catch {
                await MainActor.run {
                    connectionStatus = .failed
                    isTestingConnection = false
                }
            }
        }
    }
}
```

---

## 六、通知系统（觉察打断）

### 6.1 智能提醒调度

```swift
import UserNotifications

actor AwarenessInterrupter {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    // MARK: - 问题库
    private let awarenessQuestions = [
        "11:00": "我现在做的事情在逃避什么？",
        "13:30": "如果有人录下过去两小时，他们会认为我想要什么样的生活？",
        "15:15": "我正在走向我讨厌的生活还是我想要的生活？",
        "17:00": "我假装不重要的最重要的事是什么？",
        "19:30": "今天我做了哪些事是出于身份保护而非真正的渴望？",
        "21:00": "今天我什么时候感觉最有活力？什么时候感觉最死气沉沉？"
    ]
    
    // MARK: - 调度提醒
    func scheduleAwarenessInterrupts() async throws {
        // 请求权限
        let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound])
        guard granted else { return }
        
        // 清除旧提醒
        notificationCenter.removeAllPendingNotificationRequests()
        
        // 调度新提醒
        for (time, question) in awarenessQuestions {
            let components = time.split(separator: ":").map { Int($0)! }
            
            var dateComponents = DateComponents()
            dateComponents.hour = components[0]
            dateComponents.minute = components[1]
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents,
                repeats: true  // 每天重复
            )
            
            let content = UNMutableNotificationContent()
            content.title = "🔮 Orb 想问你一个问题"
            content.body = question
            content.sound = .default
            content.categoryIdentifier = "AWARENESS"
            content.interruptionLevel = .timeSensitive
            
            let request = UNNotificationRequest(
                identifier: "awareness-\(time)",
                content: content,
                trigger: trigger
            )
            
            try await notificationCenter.add(request)
        }
    }
    
    // MARK: - 动态问题（基于用户状态）
    func scheduleDynamicInterrupt(question: String, after delay: TimeInterval) async throws {
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: delay,
            repeats: false
        )
        
        let content = UNMutableNotificationContent()
        content.title = "🔮 Orb 有话想说"
        content.body = question
        content.sound = .default
        content.categoryIdentifier = "AWARENESS"
        
        let request = UNNotificationRequest(
            identifier: "dynamic-\(UUID().uuidString)",
            content: content,
            trigger: trigger
        )
        
        try await notificationCenter.add(request)
    }
}
```

---

## 七、Widget 扩展

### 7.1 每日杠杆 Widget

```swift
import WidgetKit
import SwiftUI

struct DailyLeverWidget: Widget {
    let kind: String = "DailyLeverWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyLeverProvider()) { entry in
            DailyLeverWidgetView(entry: entry)
                .containerBackground(.ultraThinMaterial, for: .widget)
        }
        .configurationDisplayName("今日杠杆")
        .description("显示最重要的每日任务")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct DailyLeverEntry: TimelineEntry {
    let date: Date
    let tasks: [DailyTask]
    let completedCount: Int
}

struct DailyLeverWidgetView: View {
    let entry: DailyLeverEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "target")
                    .foregroundColor(.brand)
                Text("今日杠杆")
                    .font(.headline)
                Spacer()
                Text("\(entry.completedCount)/\(entry.tasks.count)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ForEach(entry.tasks.prefix(3)) { task in
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? .green : .secondary)
                    Text(task.title)
                        .font(.subheadline)
                        .strikethrough(task.isCompleted)
                }
            }
        }
        .padding()
    }
}
```

### 7.2 XP 进度 Widget

```swift
struct XPProgressWidget: Widget {
    let kind: String = "XPProgressWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: XPProgressProvider()) { entry in
            XPProgressWidgetView(entry: entry)
                .containerBackground(
                    LinearGradient(
                        colors: [Color(hex: "#7B5EA7"), Color(hex: "#5B8DEF")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    for: .widget
                )
        }
        .configurationDisplayName("XP 进度")
        .description("显示你的成长等级和XP")
        .supportedFamilies([.systemSmall])
    }
}

struct XPProgressWidgetView: View {
    let entry: XPProgressEntry
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.3), lineWidth: 8)
                
                Circle()
                    .trim(from: 0, to: entry.progress)
                    .stroke(Color.white, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 2) {
                    Text(entry.level)
                        .font(.system(size: 14, weight: .bold))
                    Text("\(entry.currentXP) XP")
                        .font(.system(size: 10))
                        .opacity(0.8)
                }
                .foregroundColor(.white)
            }
            .frame(width: 80, height: 80)
        }
    }
}
```

---

## 八、性能优化

### 8.1 启动优化

```swift
@main
struct DharmaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // 延迟非关键初始化
        Task.detached(priority: .background) {
            await CloudKitSyncEngine.shared.setupSync()
            await PatternRecognizer().loadModels()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    // 主线程初始化
                    await setupCriticalServices()
                }
        }
    }
    
    private func setupCriticalServices() async {
        // 只初始化首屏必需的服务
        await SwiftDataManager.shared.configure()
    }
}
```

### 8.2 内存管理

```swift
// 使用 @Observable 替代 @ObservedObject 减少内存开销
@Observable
final class SessionState {
    var currentTask: DailyTask?
    var elapsedTime: TimeInterval = 0
    var flowLevel: Double = 0
}

// 图片缓存
actor ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
```

### 8.3 后台任务

```swift
import BackgroundTasks

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // 注册后台任务
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.dharma.sync",
            using: nil
        ) { task in
            self.handleBackgroundSync(task: task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    private func handleBackgroundSync(task: BGAppRefreshTask) {
        Task {
            do {
                try await CloudKitSyncEngine.shared.syncLocalToCloud()
                task.setTaskCompleted(success: true)
            } catch {
                task.setTaskCompleted(success: false)
            }
        }
        
        // 调度下一次同步
        scheduleBackgroundSync()
    }
    
    func scheduleBackgroundSync() {
        let request = BGAppRefreshTaskRequest(identifier: "com.dharma.sync")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)  // 15分钟后
        
        try? BGTaskScheduler.shared.submit(request)
    }
}
```

---

## 九、安全与隐私

### 9.1 数据加密

```swift
import CryptoKit

actor SecureStorage {
    private let keychain = Keychain(service: "com.dharma.app")
    
    // 加密敏感数据
    func encrypt(_ data: Data) throws -> Data {
        let key = try getOrCreateKey()
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }
    
    func decrypt(_ encryptedData: Data) throws -> Data {
        let key = try getOrCreateKey()
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    private func getOrCreateKey() throws -> SymmetricKey {
        if let existingKey = try? keychain.getData("encryption_key") {
            return SymmetricKey(data: existingKey)
        }
        
        let newKey = SymmetricKey(size: .bits256)
        try keychain.set(newKey.withUnsafeBytes { Data($0) }, key: "encryption_key")
        return newKey
    }
}
```

### 9.2 隐私设计

```swift
// 所有敏感数据只存储在本地和 iCloud（用户控制）
// AI 分析时使用匿名化处理

struct PrivacyManager {
    // 发送给 OpenAI 前的数据处理
    static func anonymize(_ context: SocraticQuestionGenerator.Context) -> SocraticQuestionGenerator.Context {
        var anonymized = context
        
        // 移除可识别信息
        anonymized.saidGoals = context.saidGoals.map { removePersonalInfo($0) }
        anonymized.recentReflections = context.recentReflections.map { removePersonalInfo($0) }
        
        return anonymized
    }
    
    private static func removePersonalInfo(_ text: String) -> String {
        // 移除姓名、地点等可识别信息
        var result = text
        // 实现具体的脱敏逻辑
        return result
    }
}
```

---

## 十、测试策略

### 10.1 单元测试

```swift
import XCTest
import ComposableArchitecture
@testable import Dharma

final class ExcavateFeatureTests: XCTestCase {
    
    @MainActor
    func testStartAntiVisionWorkshop() async {
        let store = TestStore(initialState: ExcavateFeature.State()) {
            ExcavateFeature()
        } withDependencies: {
            $0.excavateClient = .testValue
            $0.aiEngine = .testValue
        }
        
        await store.send(.startAntiVisionWorkshop) {
            $0.antiVisionWorkshop = AntiVisionWorkshopFeature.State()
        }
    }
    
    @MainActor
    func testXPCalculation() async {
        let failure = FailureModel(
            description: "测试失败",
            learningExtracted: "学到了东西",
            appliedToNextAttempt: true
        )
        
        // 基础10 + 学习20 + 应用30 = 60
        XCTAssertEqual(failure.xpEarned, 60)
    }
}
```

### 10.2 UI 测试

```swift
import XCTest

final class DharmaUITests: XCTestCase {
    
    func testAntiVisionWorkshopFlow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // 导航到挖掘层
        app.tabBars.buttons["挖掘"].tap()
        
        // 开始反愿景工坊
        app.buttons["Begin Excavation"].tap()
        
        // 验证工坊已打开
        XCTAssertTrue(app.staticTexts["What are you escaping?"].exists)
        
        // 输入反愿景描述
        let textField = app.textFields["Describe your current struggle"]
        textField.tap()
        textField.typeText("拖延和自我怀疑")
        
        // 选择标签
        app.buttons["Procrastination"].tap()
        app.buttons["Doubt"].tap()
        
        // 验证标签已选中
        XCTAssertTrue(app.buttons["Procrastination"].isSelected)
    }
}
```

---

## 十一、发布清单

### 11.1 App Store 准备

- [ ] App 图标（所有尺寸）
- [ ] 启动屏幕
- [ ] App Store 截图（6.7", 6.5", 5.5"）
- [ ] App 预览视频
- [ ] 隐私政策 URL
- [ ] 支持 URL
- [ ] App Store 描述（所有语言）
- [ ] 关键词优化

### 11.2 技术检查

- [ ] 所有 Scheme 配置正确
- [ ] 代码签名配置
- [ ] Entitlements 配置（CloudKit, Push Notifications）
- [ ] 后台模式配置
- [ ] 隐私权限描述（相机、通知等）
- [ ] Core ML 模型优化
- [ ] 内存泄漏检查
- [ ] 性能优化（Instruments 分析）

### 11.3 测试矩阵

| 设备 | iOS 版本 | 测试状态 |
|-----|---------|---------|
| iPhone 16 Pro | iOS 26 | ⏳ |
| iPhone 15 | iOS 26 | ⏳ |
| iPhone 14 | iOS 26 | ⏳ |
| iPhone SE | iOS 26 | ⏳ |
