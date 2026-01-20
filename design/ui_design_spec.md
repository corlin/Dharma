# Dharma App UI/UX 设计规范 v1.0

> 遵循 iOS 26 Human Interface Guidelines  
> 参考设计：温和渐变 + 毛玻璃 + 3D 角色风格

---

## 一、设计理念

### 核心设计原则

| 原则 | 描述 | 在 Dharma 中的体现 |
|-----|-----|-------------------|
| **温和引导** | 不施压，让用户自主探索 | 柔和配色、渐进式问题呈现 |
| **清晰层次** | 信息层级分明，减少认知负担 | 卡片分层、毛玻璃效果区分前后景 |
| **情感连接** | 创造温暖、支持性的体验 | 3D 角色"Orb"作为AI向导 |
| **进步可见** | 让用户看到自己的成长 | XP 系统、身份进化可视化 |

### 参考设计分析

![参考设计](uploaded_image_1768835527466.png)

**从参考图提取的设计元素**：

1. **毛玻璃卡片** - 半透明白色背景，模糊效果
2. **渐变主题色** - 紫色到蓝色的渐变头部
3. **3D 角色** - 可爱的球形AI向导"Orb"
4. **标签芯片** - 圆角胶囊形状的快捷标签
5. **渐变CTA按钮** - 橙红到粉紫的渐变
6. **光晕背景** - 柔和的粉紫光晕效果
7. **对话气泡** - AI 引导提示

---

## 二、设计系统 (Design Tokens)

### 2.1 色彩系统

#### 主色调 (Primary Colors)

```swift
// Dharma 品牌色
static let brand = Color(
    light: Color(hex: "#7B5EA7"),  // 智慧紫
    dark: Color(hex: "#9B7FD1")
)

static let brandGradient = LinearGradient(
    colors: [
        Color(hex: "#7B5EA7"),  // 深紫
        Color(hex: "#5B8DEF")   // 天蓝
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

#### 功能色 (Semantic Colors)

| 用途 | 浅色模式 | 深色模式 | 使用场景 |
|-----|---------|---------|---------|
| 成功/进步 | #34C759 | #30D158 | XP获得、任务完成 |
| 警告/觉察 | #FF9500 | #FFB340 | 两周检验警报 |
| 错误/失败 | #FF3B30 | #FF453A | 失败记录（但以XP框架呈现） |
| 信息/引导 | #007AFF | #0A84FF | 苏格拉底式提问 |

#### 中性色 (Neutral Colors)

```swift
// 背景层级
static let backgroundPrimary = Color(hex: "#FBF9F7")    // 温暖米白
static let backgroundSecondary = Color(hex: "#F5F2EE")  // 浅米色
static let backgroundTertiary = Color(hex: "#FFFFFF")   // 纯白卡片

// 文字层级
static let textPrimary = Color(hex: "#1C1C1E")      // 主要文字
static let textSecondary = Color(hex: "#6E6E73")    // 次要文字
static let textTertiary = Color(hex: "#AEAEB2")     // 占位符
```

#### 光晕背景渐变

```swift
// 页面背景光晕效果
static let ambientGlow = RadialGradient(
    colors: [
        Color(hex: "#E8D5F2").opacity(0.6),  // 淡紫
        Color(hex: "#FFE5EC").opacity(0.4),  // 淡粉
        Color(hex: "#FBF9F7").opacity(1.0)   // 米白
    ],
    center: .topTrailing,
    startRadius: 0,
    endRadius: 400
)
```

---

### 2.2 字体系统

遵循 iOS 26 Dynamic Type 规范，使用 SF Pro 系列：

| 样式名称 | 字重 | 字号 | 行高 | 使用场景 |
|---------|-----|------|-----|---------|
| Large Title | Bold | 34pt | 41pt | 页面主标题 |
| Title 1 | Bold | 28pt | 34pt | 章节标题 |
| Title 2 | Bold | 22pt | 28pt | 卡片标题 |
| Title 3 | Semibold | 20pt | 25pt | 组件标题 |
| Headline | Semibold | 17pt | 22pt | 强调文字 |
| Body | Regular | 17pt | 22pt | 正文内容 |
| Callout | Regular | 16pt | 21pt | 辅助说明 |
| Subheadline | Regular | 15pt | 20pt | 次要信息 |
| Footnote | Regular | 13pt | 18pt | 脚注、时间戳 |
| Caption 1 | Regular | 12pt | 16pt | 标签、徽章 |
| Caption 2 | Regular | 11pt | 13pt | 最小说明 |

```swift
// SwiftUI 实现
extension Font {
    static let dharmaLargeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let dharmaTitle1 = Font.system(size: 28, weight: .bold, design: .rounded)
    static let dharmaBody = Font.system(size: 17, weight: .regular, design: .default)
}
```

---

### 2.3 间距系统

基于 4pt 网格系统：

| Token | 值 | 使用场景 |
|-------|-----|---------|
| `spacing-xs` | 4pt | 紧凑元素间距 |
| `spacing-sm` | 8pt | 相关元素间距 |
| `spacing-md` | 12pt | 组件内部间距 |
| `spacing-lg` | 16pt | 组件之间间距 |
| `spacing-xl` | 24pt | 区块之间间距 |
| `spacing-2xl` | 32pt | 主要区域分隔 |
| `spacing-3xl` | 48pt | 页面顶部/底部边距 |

---

### 2.4 圆角系统

```swift
// 圆角规范
static let radiusSmall: CGFloat = 8      // 小元素：标签、徽章
static let radiusMedium: CGFloat = 12    // 中等元素：输入框、按钮
static let radiusLarge: CGFloat = 16     // 大元素：卡片
static let radiusXLarge: CGFloat = 24    // 特大元素：底部弹窗
static let radiusFull: CGFloat = 9999    // 胶囊形状：标签芯片
```

---

### 2.5 阴影系统

```swift
// 阴影层级
static let shadowSmall = Shadow(
    color: Color.black.opacity(0.04),
    radius: 4,
    x: 0, y: 2
)

static let shadowMedium = Shadow(
    color: Color.black.opacity(0.08),
    radius: 12,
    x: 0, y: 4
)

static let shadowLarge = Shadow(
    color: Color.black.opacity(0.12),
    radius: 24,
    x: 0, y: 8
)

// 光晕效果（用于强调卡片）
static let glowPurple = Shadow(
    color: Color(hex: "#7B5EA7").opacity(0.3),
    radius: 20,
    x: 0, y: 0
)
```

---

## 三、核心组件

### 3.1 毛玻璃卡片 (Glass Card)

参考设计中的核心元素，用于承载主要内容：

```swift
struct GlassCard: View {
    let title: String
    let icon: String
    let gradientColors: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 渐变头部
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.dharmaTitle3)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: gradientColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // 内容区域
            content
                .padding(16)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }
}
```

**变体**：

| 变体 | 渐变色 | 用途 |
|-----|--------|-----|
| 反愿景卡片 | 紫 → 蓝 | 挖掘层 |
| 愿景卡片 | 金 → 橙 | 定向层 |
| 任务卡片 | 青 → 蓝 | 执行层 |
| 反馈卡片 | 绿 → 青 | 反馈层 |
| 进化卡片 | 粉 → 紫 | 进化层 |

---

### 3.2 渐变按钮 (Gradient Button)

主要行动按钮，如"开始挖掘"：

```swift
struct GradientButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                if let icon = icon {
                    Image(systemName: icon)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "#FF6B4A"),  // 橙红
                        Color(hex: "#D64EAF")   // 粉紫
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color(hex: "#FF6B4A").opacity(0.4), radius: 12, y: 4)
        }
    }
}
```

---

### 3.3 标签芯片 (Tag Chip)

用于快速选择，如"拖延症"、"怀疑"等：

```swift
struct TagChip: View {
    let text: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Text(text)
            .font(.subheadline)
            .foregroundColor(isSelected ? .white : .textPrimary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                isSelected 
                    ? AnyView(Color.brand)
                    : AnyView(Color.white.opacity(0.8))
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.brand.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
            )
            .onTapGesture {
                withAnimation(.spring(response: 0.3)) {
                    isSelected.toggle()
                }
            }
    }
}
```

---

### 3.4 AI 对话气泡 (Orb Bubble)

3D 角色"Orb"的引导提示：

```swift
struct OrbBubble: View {
    let message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 对话气泡
            Text(message)
                .font(.callout)
                .foregroundColor(.textPrimary)
                .padding(12)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
            
            // Orb 角色
            Text("- Orb")
                .font(.caption)
                .foregroundColor(.textSecondary)
            
            // 3D 角色图标（使用 SF Symbols 或自定义资产）
            Image("orb_character")
                .resizable()
                .frame(width: 40, height: 40)
        }
    }
}
```

---

### 3.5 进度环 (Progress Ring)

XP 等级进度可视化：

```swift
struct XPProgressRing: View {
    let currentXP: Int
    let targetXP: Int
    let level: String
    
    var progress: Double {
        Double(currentXP) / Double(targetXP)
    }
    
    var body: some View {
        ZStack {
            // 背景环
            Circle()
                .stroke(Color.brand.opacity(0.2), lineWidth: 12)
            
            // 进度环
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "#7B5EA7"), Color(hex: "#5B8DEF")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6), value: progress)
            
            // 中心内容
            VStack(spacing: 4) {
                Text(level)
                    .font(.dharmaTitle2)
                    .foregroundColor(.textPrimary)
                Text("\(currentXP) XP")
                    .font(.caption)
                    .foregroundColor(.textSecondary)
            }
        }
    }
}
```

---

## 四、页面布局规范

### 4.1 导航结构

遵循 iOS 26 的浮动标签栏设计：

```
┌─────────────────────────────────────────┐
│  [Safe Area Top]                        │
├─────────────────────────────────────────┤
│                                         │
│  页面内容区域                            │
│  (ScrollView)                           │
│                                         │
│                                         │
│                                         │
├─────────────────────────────────────────┤
│      ╭─────────────────────────╮        │
│      │  🔍  🎯  📊  🌱  👤   │        │
│      ╰─────────────────────────╯        │
│  [Safe Area Bottom]                     │
└─────────────────────────────────────────┘
```

**5个主标签页**：

| 图标 | 名称 | 对应层级 |
|-----|-----|---------|
| 🔍 | 挖掘 | EXCAVATE |
| 🎯 | 方向 | ORIENT |
| ⚡ | 执行 | EXECUTE |
| 📊 | 反馈 | FEEDBACK |
| 🌱 | 进化 | EVOLVE |

---

### 4.2 页面模板

#### 标准页面布局

```swift
struct StandardPageLayout<Content: View>: View {
    let title: String
    let subtitle: String?
    let content: Content
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 页面头部
                VStack(spacing: 8) {
                    Text(title)
                        .font(.dharmaLargeTitle)
                        .foregroundColor(.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.body)
                            .foregroundColor(.textSecondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.top, 16)
                
                // 步骤指示器（如有）
                StepIndicator(currentStep: 1, totalSteps: 3)
                
                // 主要内容
                content
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 100) // 为浮动标签栏留空
        }
        .background(Color.ambientGlow)
    }
}
```

---

## 五、5层架构界面详细设计

### 5.1 挖掘层 (EXCAVATE)

#### 反愿景工坊界面

```
┌─────────────────────────────────────────┐
│                                         │
│         Set Your Frame                  │
│    Define your Anti-vision and Vision   │
│         to anchor your lens.            │
│                                         │
│              ● ○ ○                      │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Hey there! Let's uncover your   │   │
│  │ path. Tap on "Anti-vision" to   │   │
│  │ start.                   - Orb  │ 🔮│
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ ⛈️ Anti-vision                  │   │
│  ├─────────────────────────────────┤   │
│  │ What are you escaping?          │   │
│  │ ┌─────────────────────────────┐ │   │
│  │ │ Describe your current       │ │   │
│  │ │ struggle or limitation...   │ │   │
│  │ └─────────────────────────────┘ │   │
│  │                                 │   │
│  │ [拖延症] [怀疑] [倦怠] [停滞]   │   │
│  │                                 │   │
│  │ What are the consequences?      │   │
│  │ ┌─────────────────────────────┐ │   │
│  │ │ Describe the negative       │ │   │
│  │ │ outcome...                  │ │   │
│  │ └─────────────────────────────┘ │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌═══════════════════════════════════┐ │
│  │     Begin Excavation  ⛏️          │ │
│  └═══════════════════════════════════┘ │
│                                         │
│            Skip for now                 │
│                                         │
└─────────────────────────────────────────┘
```

---

### 5.2 定向层 (ORIENT)

#### 目标金字塔界面

```
┌─────────────────────────────────────────┐
│                                         │
│         Goal Hierarchy                  │
│    From vision to daily action          │
│                                         │
│           ╱╲                            │
│          ╱  ╲   10-Year Vision          │
│         ╱────╲  "财务自由+深度工作"      │
│        ╱      ╲                         │
│       ╱────────╲ 1-Year Goal            │
│      ╱          ╲ "启动个人品牌"         │
│     ╱────────────╲                      │
│    ╱              ╲ Q1 Project          │
│   ╱────────────────╲ "完成课程MVP"      │
│  ╱                  ╲                   │
│ ╱────────────────────╲ This Week        │
│╱                      ╲ "录制3节视频"    │
│                                         │
│  Today's Levers                         │
│  ┌─────────────────────────────────┐   │
│  │ ☐ 写视频脚本 (2h)               │   │
│  │ ☐ 研究竞品 (1h)                 │   │
│  │ ☐ 设置录制环境 (30min)          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Skill Gaps                             │
│  [视频剪辑 🔴] [文案写作 🟡] [SEO 🟢]  │
│                                         │
└─────────────────────────────────────────┘
```

---

### 5.3 执行层 (EXECUTE)

#### 深度工作会话界面

```
┌─────────────────────────────────────────┐
│                                         │
│  [BUILD]  [MAINTAIN]  [RECOVER]         │
│    ━━━                                  │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │                                 │   │
│  │         01:23:45                │   │
│  │                                 │   │
│  │      ╭───────────────╮          │   │
│  │      │   写视频脚本   │          │   │
│  │      ╰───────────────╯          │   │
│  │                                 │   │
│  │   Flow State: ████████░░ 80%   │   │
│  │                                 │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🔮 How's your focus right now?  │   │
│  │                                 │   │
│  │ [Laser-focused] [Wandering]     │   │
│  │ [Need a break]                  │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Distractions blocked: 3               │
│  Knowledge gaps marked: 1              │
│                                         │
│  ┌═══════════════════════════════════┐ │
│  │     ⏸️  Pause Session             │ │
│  └═══════════════════════════════════┘ │
│                                         │
└─────────────────────────────────────────┘
```

---

### 5.4 反馈层 (FEEDBACK)

#### 控制论仪表盘界面

```
┌─────────────────────────────────────────┐
│                                         │
│         Weekly Review                   │
│         Jan 13 - Jan 19                 │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  Goal vs Reality                │   │
│  │                                 │   │
│  │  Said: "完成3个视频"            │   │
│  │  Did:  完成1个视频, 2个草稿     │   │
│  │                                 │   │
│  │  Gap: ████████░░ 60%           │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ 🔮 你说你想完成3个视频，但数据   │   │
│  │ 显示你花了40%时间在"研究"上。  │   │
│  │                                 │   │
│  │ 这让你想到什么？                │   │
│  │ ┌─────────────────────────────┐ │   │
│  │ │ 输入你的反思...             │ │   │
│  │ └─────────────────────────────┘ │   │
│  └─────────────────────────────────┘   │
│                                         │
│  XP Earned This Week                    │
│  ┌─────────────────────────────────┐   │
│  │  +10 基础失败 (未完成视频)      │   │
│  │  +20 记录学习 (识别拖延模式)    │   │
│  │  ───────────────────────────── │   │
│  │  Total: +30 XP                  │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

### 5.5 进化层 (EVOLVE)

#### 身份进化界面

```
┌─────────────────────────────────────────┐
│                                         │
│         Identity Evolution              │
│                                         │
│         ╭─────────────╮                 │
│         │             │                 │
│         │   Lv.2      │                 │
│         │  探索者      │                 │
│         │  320/500 XP │                 │
│         │             │                 │
│         ╰─────────────╯                 │
│                                         │
│  Identity Statement                     │
│  ┌─────────────────────────────────┐   │
│  │ "我是那种每天都会创造内容的人"   │   │
│  │                                 │   │
│  │ Evidence: 14天连续创作          │   │
│  │ Consolidation: ████████░░ 78%   │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Behaviors Becoming Automatic           │
│  ┌─────────────────────────────────┐   │
│  │ ✅ 晨间写作 (21天)              │   │
│  │ 🔄 每日反思 (7天)               │   │
│  │ ⏳ 深度工作3小时 (3天)          │   │
│  └─────────────────────────────────┘   │
│                                         │
│  Failure Portfolio                      │
│  ┌─────────────────────────────────┐   │
│  │  Total Failures: 23             │   │
│  │  Learnings Extracted: 18        │   │
│  │  Applied to Next Attempt: 12    │   │
│  │                                 │   │
│  │  🎯 Distance to Breakthrough:   │   │
│  │     ████████████░░ 85%          │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

---

## 六、动效规范

### 6.1 过渡动画

遵循 iOS 26 的流畅过渡原则：

| 动效类型 | 时长 | 曲线 | 使用场景 |
|---------|-----|------|---------|
| 微交互 | 0.2s | easeOut | 按钮点击、选中状态 |
| 元素进入 | 0.35s | spring(0.6) | 卡片出现、列表加载 |
| 页面过渡 | 0.5s | spring(0.7) | 页面切换 |
| 强调动画 | 0.6s | spring(0.5) | XP获得、等级提升 |

### 6.2 特色动效

```swift
// XP 获得动效
struct XPGainAnimation: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        Text("+30 XP")
            .font(.dharmaTitle2)
            .foregroundColor(.brand)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    scale = 1.2
                    opacity = 1
                }
                withAnimation(.spring(response: 0.3).delay(0.3)) {
                    scale = 1.0
                }
            }
    }
}

// Orb 角色呼吸动效
struct OrbBreathingAnimation: View {
    @State private var isBreathing = false
    
    var body: some View {
        Image("orb_character")
            .scaleEffect(isBreathing ? 1.05 : 1.0)
            .animation(
                .easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true),
                value: isBreathing
            )
            .onAppear { isBreathing = true }
    }
}
```

---

## 七、无障碍设计

### 7.1 Dynamic Type 支持

所有文字必须支持 Dynamic Type，自动适应用户的字体大小偏好：

```swift
Text("反愿景工坊")
    .font(.dharmaTitle2)
    .dynamicTypeSize(.small ... .accessibility3)
```

### 7.2 VoiceOver 支持

所有可交互元素必须有清晰的 accessibility label：

```swift
GradientButton(title: "开始挖掘", icon: "pickaxe")
    .accessibilityLabel("开始挖掘按钮")
    .accessibilityHint("点击开始反愿景工坊")
```

### 7.3 色彩对比度

确保所有文字与背景的对比度满足 WCAG 2.1 AA 标准（最低 4.5:1）。

### 7.4 Reduce Motion

尊重用户的"减少动态效果"设置：

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

withAnimation(reduceMotion ? nil : .spring(response: 0.5)) {
    // 动画内容
}
```

---

## 八、深色模式

所有颜色使用语义化 Token，自动适应深浅模式：

```swift
extension Color {
    static let dharmaBackground = Color("BackgroundPrimary")
    static let dharmaText = Color("TextPrimary")
    static let dharmaCard = Color("CardBackground")
}
```

| 元素 | 浅色模式 | 深色模式 |
|-----|---------|---------|
| 页面背景 | #FBF9F7 (温暖米白) | #1C1C1E (深灰) |
| 卡片背景 | #FFFFFF | #2C2C2E |
| 毛玻璃 | .ultraThinMaterial | .ultraThinMaterial |
| 主要文字 | #1C1C1E | #FFFFFF |
| 次要文字 | #6E6E73 | #8E8E93 |
| 品牌色 | #7B5EA7 | #9B7FD1 |

---

## 九、图标规范

### 9.1 SF Symbols 使用

优先使用 SF Symbols 6，支持 iOS 26 的新动画：

| 功能 | 图标名称 | 变体 |
|-----|---------|-----|
| 挖掘 | `magnifyingglass` | hierarchical |
| 方向 | `target` | hierarchical |
| 执行 | `bolt.fill` | multicolor |
| 反馈 | `chart.bar.fill` | hierarchical |
| 进化 | `leaf.fill` | multicolor |
| 反愿景 | `cloud.rain.fill` | hierarchical |
| 愿景 | `sun.max.fill` | multicolor |
| XP | `star.fill` | multicolor |

### 9.2 Orb 角色资产

3D 角色"Orb"需要自定义设计，作为 AI 向导的视觉化身：

- 基础状态：平静呼吸
- 提问状态：好奇倾斜
- 鼓励状态：发光/微笑
- 警示状态：轻微摇晃

---

## 十、组件库索引

| 组件名称 | 文件路径 | 描述 |
|---------|---------|------|
| `GlassCard` | Components/Cards/GlassCard.swift | 毛玻璃效果卡片 |
| `GradientButton` | Components/Buttons/GradientButton.swift | 渐变主按钮 |
| `SecondaryButton` | Components/Buttons/SecondaryButton.swift | 次级按钮 |
| `TagChip` | Components/Tags/TagChip.swift | 标签芯片 |
| `OrbBubble` | Components/AI/OrbBubble.swift | AI对话气泡 |
| `XPProgressRing` | Components/Progress/XPProgressRing.swift | XP进度环 |
| `GoalPyramid` | Components/Visualization/GoalPyramid.swift | 目标金字塔 |
| `FlowMeter` | Components/Progress/FlowMeter.swift | 心流状态指示器 |
| `StepIndicator` | Components/Navigation/StepIndicator.swift | 步骤指示器 |
| `WeeklyChart` | Components/Charts/WeeklyChart.swift | 周报图表 |

---

## 十一、设计交付物清单

- [ ] Figma 设计文件
- [ ] 设计 Token JSON 导出
- [ ] SF Symbols 自定义集合
- [ ] Orb 角色 3D 资产（Lottie 或 RealityKit）
- [ ] 深浅模式颜色资产目录
- [ ] 组件库 SwiftUI 代码
- [ ] 动效规范视频示例
