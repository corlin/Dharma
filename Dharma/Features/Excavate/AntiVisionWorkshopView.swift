// AntiVisionWorkshopView.swift
// Dharma Features - Excavate Layer - Anti Vision Workshop

import SwiftData
import SwiftUI

/// 反愿景工坊视图
/// 用户通过3个步骤揭示自己的反愿景
struct AntiVisionWorkshopView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss

  @State private var currentStep = 0
  @State private var painPoints: Set<String> = []
  @State private var fiveYearTuesday = ""
  @State private var tenYearTuesday = ""
  @State private var lifetimeCost = ""
  @State private var compressedStatement = ""
  @State private var orbMessage =
    "Hey there! Let's uncover your path. What patterns are you trying to escape?"
  @State private var isOrbTyping = false
  @State private var isGenerating = false

  private let steps = ["Pain Points", "Future Projection", "Compression"]

  var body: some View {
    ZStack {
      // 背景
      Color.backgroundPrimary
        .ignoresSafeArea()

      // 光晕效果
      Circle()
        .fill(Color.excavate.opacity(0.15))
        .frame(width: 300, height: 300)
        .blur(radius: 100)
        .offset(x: 100, y: -200)

      VStack(spacing: Spacing.lg) {
        // 头部
        headerView

        // Orb 对话
        OrbBubble(orbMessage, isTyping: isOrbTyping)
          .padding(.horizontal)

        // 步骤内容
        stepContent
          .animation(.easeInOut, value: currentStep)

        Spacer()

        // 底部按钮
        bottomButtons
      }
      .padding(.top)
    }
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button("取消") { dismiss() }
      }
    }
    .disabled(isGenerating)
    .overlay {
      if isGenerating {
        ZStack {
          Color.black.opacity(0.7).ignoresSafeArea()
          VStack(spacing: Spacing.md) {
            ProgressView()
              .tint(.excavate)
              .scaleEffect(1.5)
            Text("Consulting the Oracle...")
              .font(.headline)
              .foregroundColor(.white)
            Text("Inverting your Anti-Vision into a North Star")
              .font(.caption)
              .foregroundColor(.white.opacity(0.8))
          }
        }
      }
    }
  }

  // MARK: - Header
  private var headerView: some View {
    VStack(spacing: Spacing.sm) {
      Text("Set Your Frame")
        .font(.system(size: 28, weight: .bold, design: .rounded))  // Title 1
        .foregroundColor(.textPrimary)  // 确保深色

      Text("Define your Anti-vision to anchor your lens.")
        .font(.system(size: 15))  // Subheadline
        .foregroundColor(.textSecondary)

      // 步骤指示器
      HStack(spacing: Spacing.sm) {
        ForEach(0..<steps.count, id: \.self) { index in
          Circle()
            .fill(index <= currentStep ? Color.excavate : Color.excavate.opacity(0.3))
            .frame(width: 10, height: 10)
        }
      }
      .padding(.top, Spacing.xs)
    }
  }

  // MARK: - Step Content
  @ViewBuilder
  private var stepContent: some View {
    ScrollView {
      VStack(spacing: Spacing.lg) {
        switch currentStep {
        case 0:
          painPointsStep
        case 1:
          futureProjectionStep
        case 2:
          compressionStep
        default:
          EmptyView()
        }
      }
      .padding(.horizontal)
    }
  }

  // MARK: - Step 1: Pain Points
  private var painPointsStep: some View {
    GlassCard {
      VStack(alignment: .leading, spacing: Spacing.md) {
        Text("What are you escaping?")
          .font(.titleMedium)

        Text("Select the patterns that resonate with you")
          .font(.bodySmall)
          .foregroundColor(.textSecondary)

        TagChipGroup(
          tags: PainPointCategory.allCases.map { $0.rawValue },
          selectedTags: $painPoints,
          color: .excavate
        )

        if !painPoints.isEmpty {
          Divider()

          Text("Describe your experience")
            .font(.labelMedium)
            .foregroundColor(.textSecondary)

          TextEditor(text: $fiveYearTuesday)
            .frame(minHeight: 100)
            .padding(Spacing.sm)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
        }
      }
    } header: {
      HStack {
        Image(systemName: "cloud.bolt.fill")
        Text("Anti-vision")
          .font(.titleMedium)
      }
      .foregroundColor(.white)
    }
  }

  // MARK: - Step 2: Future Projection
  private var futureProjectionStep: some View {
    VStack(spacing: Spacing.lg) {
      // 5年投射
      GlassCard {
        VStack(alignment: .leading, spacing: Spacing.md) {
          HStack {
            Image(systemName: "calendar")
              .foregroundColor(.excavate)
            Text("5年后的普通星期二")
              .font(.titleMedium)
          }

          Text("如果什么都不改变，5年后的一个普通星期二会是什么样？")
            .font(.bodySmall)
            .foregroundColor(.textSecondary)

          TextEditor(text: $fiveYearTuesday)
            .frame(minHeight: 120)
            .padding(Spacing.sm)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
        }
      }

      // 10年投射
      GlassCard {
        VStack(alignment: .leading, spacing: Spacing.md) {
          HStack {
            Image(systemName: "clock.arrow.circlepath")
              .foregroundColor(.excavate)
            Text("10年后的代价")
              .font(.titleMedium)
          }

          Text("描述10年后这条路的终点...")
            .font(.bodySmall)
            .foregroundColor(.textSecondary)

          TextEditor(text: $tenYearTuesday)
            .frame(minHeight: 120)
            .padding(Spacing.sm)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
        }
      }
    }
  }

  // MARK: - Step 3: Compression
  private var compressionStep: some View {
    VStack(spacing: Spacing.lg) {
      GlassCard {
        VStack(alignment: .leading, spacing: Spacing.md) {
          HStack {
            Image(systemName: "text.quote")
              .foregroundColor(.excavate)
            Text("一生的代价")
              .font(.titleMedium)
          }

          Text("用一句话总结：如果继续现在的模式，你的人生会付出什么代价？")
            .font(.bodySmall)
            .foregroundColor(.textSecondary)

          TextField("例如：我会成为一个充满遗憾的旁观者...", text: $lifetimeCost)
            .textFieldStyle(.plain)
            .padding()
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
        }
      }

      GlassCard {
        VStack(alignment: .leading, spacing: Spacing.md) {
          HStack {
            Image(systemName: "sparkles")
              .foregroundColor(.evolve)
            Text("反愿景陈述")
              .font(.titleMedium)
          }

          Text("将以上内容压缩成一句能触发你的反愿景陈述")
            .font(.bodySmall)
            .foregroundColor(.textSecondary)

          TextEditor(text: $compressedStatement)
            .frame(minHeight: 80)
            .padding(Spacing.sm)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
        }
      }

      // 预览卡片
      if !compressedStatement.isEmpty {
        GlassCard {
          VStack(spacing: Spacing.sm) {
            Text("Your Anti-Vision")
              .font(.labelMedium)
              .foregroundColor(.textSecondary)

            Text("\"\(compressedStatement)\"")
              .font(.titleMedium)
              .multilineTextAlignment(.center)
              .foregroundColor(.excavate)
          }
        }
      }
    }
  }

  // MARK: - Bottom Buttons
  private var bottomButtons: some View {
    VStack(spacing: Spacing.sm) {
      if currentStep < steps.count - 1 {
        GradientButton("Continue", icon: "arrow.right") {
          withAnimation {
            currentStep += 1
            updateOrbMessage()
          }
        }
      } else {
        GradientButton("Complete Excavation", icon: "checkmark") {
          Task {
            isGenerating = true
            await saveAntiVision()
            isGenerating = false
            dismiss()
          }
        }
      }

      if currentStep > 0 {
        Button("Back") {
          withAnimation {
            currentStep -= 1
            updateOrbMessage()
          }
        }
        .foregroundColor(.textSecondary)
      }
    }
    .padding(.horizontal)
    .padding(.bottom, Spacing.xl)
  }

  // MARK: - Helpers
  private func updateOrbMessage() {
    isOrbTyping = true

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      isOrbTyping = false
      switch currentStep {
      case 0:
        orbMessage = "这些模式在你生活中是如何体现的？"
      case 1:
        orbMessage = "想象一下那个未来...它让你有什么感受？"
      case 2:
        orbMessage = "很好。现在把这一切浓缩成一句话——你的反愿景。"
      default:
        break
      }
    }
  }

  private func saveAntiVision() async {
    let antiVision = AntiVisionModel(
      fiveYearTuesday: fiveYearTuesday,
      tenYearTuesday: tenYearTuesday,
      lifetimeCost: lifetimeCost,
      compressedStatement: compressedStatement
    )
    modelContext.insert(antiVision)

    // Hook: Generate Vision MVP (AI Powered)
    do {
      let visionMVP = try await LogicController.generateVisionFromAntiVisionAI(antiVision)
      modelContext.insert(visionMVP)
    } catch {
      print("Failed to generate vision via AI, falling back...")
      let visionMVP = LogicController.generateVisionFromAntiVision(antiVision)
      modelContext.insert(visionMVP)
    }

    // TODO: Link to user and award XP
  }
}

// MARK: - Preview
#Preview {
  NavigationStack {
    AntiVisionWorkshopView()
  }
}
