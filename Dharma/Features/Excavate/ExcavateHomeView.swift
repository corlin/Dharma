// ExcavateHomeView.swift
// Dharma Features - Excavate Layer Home

import SwiftData
import SwiftUI

/// 挖掘层首页
struct ExcavateHomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var antiVisions: [AntiVisionModel]

  @State private var showWorkshop = false
  @State private var showPainLog = false
  @State private var selectedFeature: ExcavationFeature?
  @State private var welcomeMessage = "Hey there! Let's uncover your path."

  private var hasAntiVision: Bool {
    !antiVisions.isEmpty
  }

  var body: some View {
    NavigationStack {
      ZStack {
        // 背景 + 光晕效果
        Color.backgroundPrimary
          .ignoresSafeArea()

        // 右上角紫色光晕
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color.excavate.opacity(0.3),
                Color.excavate.opacity(0.1),
                Color.clear,
              ],
              center: .center,
              startRadius: 0,
              endRadius: 200
            )
          )
          .frame(width: 400, height: 400)
          .offset(x: 120, y: -120)
          .blur(radius: 60)

        // 左下角淡粉光晕
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color(hex: "#FFE5EC").opacity(0.4),
                Color.clear,
              ],
              center: .center,
              startRadius: 0,
              endRadius: 150
            )
          )
          .frame(width: 300, height: 300)
          .offset(x: -100, y: 300)
          .blur(radius: 80)

        VStack(spacing: 0) {
          DharmaScreenHeader("Excavate", subtitle: "Uncover your path") {
            DharmaHeaderButton(icon: hasAntiVision ? "pencil" : "plus") {
              showWorkshop = true
            }
          }

          ScrollView {
            VStack(spacing: Spacing.lg) {
              // Orb 欢迎
              OrbBubble(welcomeMessage)
                .padding(.top)

              if hasAntiVision {
                // 已有反愿景 - 显示摘要
                antiVisionSummaryCard
                // 相关功能入口
                relatedFeaturesSection
              } else {
                // 未创建反愿景 - 引导创建
                antiVisionIntroCard
              }

              Spacer(minLength: 60)
            }
            .padding(.horizontal)
            .padding(.top, Spacing.xxs)
          }
        }
        
      }
      .toolbar(.hidden, for: .navigationBar)
      .sheet(isPresented: $showWorkshop) {
        NavigationStack {
          AntiVisionWorkshopView()
        }
      }
      .sheet(isPresented: $showPainLog) {
        PainLogSheet()
      }
      .sheet(item: $selectedFeature) { feature in
        FeaturePreviewSheet(feature: feature)
      }
    }
  }

  // MARK: - Anti Vision Intro Card
  private var antiVisionIntroCard: some View {
    VStack(spacing: Spacing.md) {
      GlassCard {
        VStack(alignment: .leading, spacing: Spacing.md) {
          Text("Anti-Vision Workshop")
            .font(.system(size: 22, weight: .bold, design: .rounded))  // Title 2
            .foregroundColor(.textPrimary)

          Text(
            "Discover what you're escaping from. By visualizing the future you don't want, you'll find the motivation to build the one you do."
          )
          .font(.system(size: 15))  // Subheadline
          .foregroundColor(.textSecondary)

          HStack(spacing: Spacing.sm) {
            FeatureTag(icon: "clock", text: "15 min")
            FeatureTag(icon: "sparkles", text: "+50 XP")
          }
          .padding(.top, Spacing.xs)
        }
      } header: {
        HStack {
          Image(systemName: "cloud.bolt.fill")
          Text("Anti-vision")
            .font(.titleMedium)
        }
        .foregroundColor(.white)
      }
      .onTapGesture {
        showWorkshop = true
      }

      GradientButton("Begin Excavation", icon: "pickaxe") {
        showWorkshop = true
      }
    }
  }

  // MARK: - Anti Vision Summary Card
  private var antiVisionSummaryCard: some View {
    VStack(spacing: Spacing.md) {
      if let latestAntiVision = antiVisions.last {
        GlassCard {
          VStack(alignment: .leading, spacing: Spacing.md) {
            HStack {
              Image(systemName: "quote.opening")
                .foregroundColor(.excavate)
              Text("Your Anti-Vision")
                .font(.system(size: 17, weight: .semibold))  // Headline
                .foregroundColor(.textPrimary)
              Text("Active")
                .font(.labelSmall)
                .foregroundColor(.success)
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, 2)
                .background(Color.success.opacity(0.1))
                .clipShape(Capsule())
            }

            Text("\"\(latestAntiVision.compressedStatement)\"")
              .font(.bodyLarge)
              .italic()
              .foregroundColor(.textPrimary)

            Divider()

            HStack {
              VStack(alignment: .leading) {
                Text("Created")
                  .font(.labelSmall)
                  .foregroundColor(.textTertiary)
                Text(latestAntiVision.createdAt.formatted(date: .abbreviated, time: .omitted))
                  .font(.labelMedium)
              }

              Spacer()

              Button {
                showWorkshop = true
              } label: {
                HStack {
                  Image(systemName: "pencil")
                  Text("Edit")
                }
                .font(.labelMedium)
                .foregroundColor(.excavate)
              }
            }
          }
        }
      }
    }
  }

  // MARK: - Related Features Section
  private var relatedFeaturesSection: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      Text("Excavation Tools")
        .font(.titleMedium)
        .foregroundColor(.sectionTitle)
        .padding(.top)

      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
        FeatureCard(
          title: "Pain Log",
          icon: "heart.text.square",
          color: .excavate,
          description: "Track recurring patterns"
        ) {
          showPainLog = true
        }

        FeatureCard(
          title: "Identity Archaeology",
          icon: "person.crop.rectangle.stack",
          color: .excavate,
          description: "Uncover hidden beliefs"
        ) {
          selectedFeature = .identityArchaeology
        }

        FeatureCard(
          title: "Trigger Map",
          icon: "map",
          color: .orient,
          description: "Identify your triggers"
        ) {
          selectedFeature = .triggerMap
        }

        FeatureCard(
          title: "Weekly Excavation",
          icon: "calendar.badge.clock",
          color: .feedback,
          description: "Scheduled reflection"
        ) {
          selectedFeature = .weeklyExcavation
        }
      }
    }
  }
}

// MARK: - Feature Preview Models
enum ExcavationFeature: String, Identifiable {
  case identityArchaeology
  case triggerMap
  case weeklyExcavation

  var id: String { rawValue }

  var title: String {
    switch self {
    case .identityArchaeology: return "Identity Archaeology"
    case .triggerMap: return "Trigger Map"
    case .weeklyExcavation: return "Weekly Excavation"
    }
  }

  var description: String {
    switch self {
    case .identityArchaeology:
      return
        "Dig deep into your past to find the root of your limiting beliefs. By understanding where you came from, you can rewrite where you are going."
    case .triggerMap:
      return
        "Trace your emotional triggers to their source. Create a visual map of what sets you off and why."
    case .weeklyExcavation:
      return
        "A scheduled deep-dive to keep your soul clean. Review your week's emotional landscape and clear out the psychic debris."
    }
  }

  var icon: String {
    switch self {
    case .identityArchaeology: return "person.crop.rectangle.stack"
    case .triggerMap: return "map"
    case .weeklyExcavation: return "calendar.badge.clock"
    }
  }
}

struct FeaturePreviewSheet: View {
  let feature: ExcavationFeature
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      VStack(spacing: Spacing.xl) {
        Spacer()

        Image(systemName: feature.icon)
          .font(.system(size: 80))
          .foregroundColor(.excavate)
          .padding()
          .background(Color.excavate.opacity(0.1))
          .clipShape(Circle())

        VStack(spacing: Spacing.md) {
          Text(feature.title)
            .font(.dharmaTitle)
            .foregroundColor(.textPrimary)

          Text(feature.description)
            .font(.dharmaBody)
            .foregroundColor(.textSecondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }

        Spacer()

        Text("Coming in Phase 6")
          .font(.dharmaCaption)
          .foregroundColor(.textTertiary)
          .padding(.bottom)
      }
      .padding()
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close") { dismiss() }
        }
      }
    }
    .presentationDetents([.medium])
  }
}

// MARK: - Supporting Views
struct FeatureTag: View {
  let icon: String
  let text: String

  var body: some View {
    HStack(spacing: Spacing.xxs) {
      Image(systemName: icon)
        .font(.labelSmall)
      Text(text)
        .font(.labelSmall)
    }
    .foregroundColor(.textSecondary)
    .padding(.horizontal, Spacing.sm)
    .padding(.vertical, Spacing.xxs)
    .background(Color.backgroundTertiary)
    .clipShape(Capsule())
  }
}

struct FeatureCard: View {
  let title: String
  let icon: String
  let color: Color
  let description: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(alignment: .leading, spacing: Spacing.sm) {
        Image(systemName: icon)
          .font(.title2)
          .foregroundColor(color)

        Text(title)
          .font(.titleSmall)
          .foregroundColor(.textPrimary)

        Text(description)
          .font(.labelSmall)
          .foregroundColor(.textSecondary)
          .lineLimit(2)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
      .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Pain Log Sheet
struct PainLogSheet: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  @State private var description = ""
  @State private var intensity: Double = 5

  var body: some View {
    NavigationStack {
      Form {
        Section("What's bothering you?") {
          TextEditor(text: $description)
            .frame(height: 100)

          VStack(alignment: .leading) {
            Text("Intensity: \(Int(intensity))")
              .font(.caption)
              .foregroundColor(.textSecondary)
            Slider(value: $intensity, in: 1...10, step: 1)
              .tint(.excavate)
          }
        }

        Section {
          Button("Log Pain") {
            savePainLog()
            dismiss()
          }
          .frame(maxWidth: .infinity)
          .foregroundColor(description.isEmpty ? .textTertiary : .white)
          .listRowBackground(description.isEmpty ? Color.backgroundSecondary : Color.excavate)
          .disabled(description.isEmpty)
        }
      }
      .navigationTitle("Log Pain")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
      }
    }
  }

  private func savePainLog() {
    let log = PainLogModel(
      logDescription: description,
      intensity: Int(intensity)
    )
    modelContext.insert(log)

    // Auto-Hook: Logic to create Disappear Item
    // In a real app, this might be async or AI-driven
    let disappearItem = DisappearItemModel(
      name: extractKeyword(from: description),
      category: "Derived",
      status: .identified
    )
    disappearItem.sourcePainLogs.append(log)
    log.relatedDisappearItem = disappearItem

    modelContext.insert(disappearItem)
  }

  private func extractKeyword(from text: String) -> String {
    // Simple heuristic for MVP: take the first 3 words or the whole text if short
    let words = text.components(separatedBy: .whitespacesAndNewlines)
    if words.count > 3 {
      return words.prefix(3).joined(separator: " ") + "..."
    }
    return text
  }
}

// MARK: - Preview
#Preview {
  ExcavateHomeView()
}
