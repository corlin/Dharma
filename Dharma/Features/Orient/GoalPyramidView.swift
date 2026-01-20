// GoalPyramidView.swift
// Dharma Features - Orient Layer - Goal Pyramid Editor

import SwiftData
import SwiftUI

struct GoalPyramidView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  @Query private var hierarchies: [GoalHierarchyModel]

  @State private var decadeVision = ""
  @State private var yearGoal = ""
  @State private var quarterProject = ""
  @State private var weekMilestone = ""

  @State private var expandedLevel: PyramidLevel? = .week
  @State private var appearAnimation = false

  enum PyramidLevel: String, CaseIterable, Identifiable {
    case decade = "Decade Vision"
    case year = "1-Year Goal"
    case quarter = "Quarterly Project"
    case week = "Weekly Milestone"

    var id: String { self.rawValue }

    var color: Color {
      switch self {
      case .decade: return Color(hex: "#5A3E85")
      case .year: return Color.orient
      case .quarter: return Color(hex: "#FFD8A8")
      case .week: return Color.white
      }
    }

    // Pyramid Width Factor (1.0 = Full Width)
    var widthFactor: CGFloat {
      switch self {
      case .decade: return 0.6
      case .year: return 0.75
      case .quarter: return 0.88
      case .week: return 1.0
      }
    }

    var icon: String {
      switch self {
      case .decade: return "crown.fill"
      case .year: return "flag.fill"
      case .quarter: return "hammer.fill"
      case .week: return "target"
      }
    }
  }

  var body: some View {
    ZStack {
      Color.backgroundPrimary.ignoresSafeArea()

      ScrollView {
        VStack(spacing: Spacing.xl) {

          headerView
            .padding(.top, Spacing.lg)

          // Pyramid Stack
          VStack(spacing: 0) {
            // Top-Down Visuals (Decade on Top)
            pyramidLevelView(
              level: .decade, text: $decadeVision, placeholder: "Who will you be in 10 years?")
            pyramidLevelView(
              level: .year, text: $yearGoal, placeholder: "What is your main goal for this year?")
            pyramidLevelView(
              level: .quarter, text: $quarterProject,
              placeholder: "What project will you crush this quarter?")
            pyramidLevelView(
              level: .week, text: $weekMilestone,
              placeholder: "What actions will you take this week?")
          }
          .padding(.horizontal)
          .padding(.top, Spacing.md)

          Spacer(minLength: 60)

          saveButton
        }
        .padding(.vertical)
      }
    }
    .navigationTitle("Alignment")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button("Close") { dismiss() }
      }
    }
    .onAppear {
      loadData()
      withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
        appearAnimation = true
      }
    }
  }

  // MARK: - Views

  private var headerView: some View {
    VStack(spacing: Spacing.sm) {
      Image(systemName: "triangle.fill")
        .font(.system(size: 44))
        .foregroundStyle(
          LinearGradient(
            colors: [.orient, Color(hex: "#FFD8A8")], startPoint: .top, endPoint: .bottom)
        )
        .shadow(color: .orient.opacity(0.4), radius: 10, y: 5)

      VStack(spacing: 4) {
        Text("Construct the Pyramid")
          .font(.titleMedium)
          .foregroundColor(.textPrimary)
        Text("Build your legacy from the top down.")
          .font(.caption)
          .foregroundColor(.textSecondary)
      }
    }
  }

  private func pyramidLevelView(level: PyramidLevel, text: Binding<String>, placeholder: String)
    -> some View
  {
    let isExpanded = expandedLevel == level

    return VStack(spacing: 4) {
      // The Level Block
      Button {
        HapticManager.shared.impact(.medium)
        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
          expandedLevel = isExpanded ? nil : level
        }
      } label: {
        ZStack {
          // Trapezoid Shape via customized Rectangle
          // For simplicity in SwiftUI, we use width modification and padding
          RoundedRectangle(cornerRadius: 12)
            .fill(level.color)
            .shadow(
              color: level.color.opacity(0.3), radius: isExpanded ? 12 : 6, y: isExpanded ? 6 : 3)

          HStack {
            Image(systemName: level.icon)
              .foregroundColor(level == .week ? .textPrimary : .white)
              .frame(width: 24)

            Text(level.rawValue)
              .font(.headline)
              .foregroundColor(level == .week ? .textPrimary : .white)
              .minimumScaleFactor(0.8)

            Spacer()

            if !text.wrappedValue.isEmpty {
              Image(systemName: "checkmark.circle.fill")
                .foregroundColor(level == .week ? .green : .white.opacity(0.8))
            }
          }
          .padding(.horizontal)
          .padding(.vertical, 16)
        }
      }
      .frame(maxWidth: UIScreen.main.bounds.width * level.widthFactor)  // Apply the Pyramid Width
      .offset(y: appearAnimation ? 0 : 50)
      .opacity(appearAnimation ? 1 : 0)

      // Connecting Line (if not last)
      if level != .week && !isExpanded {
        Rectangle()
          .fill(Color.textTertiary.opacity(0.3))
          .frame(width: 2, height: 12)
      }

      // Expanded Editor
      if isExpanded {
        VStack(alignment: .leading, spacing: 8) {
          Text(placeholder)
            .font(.caption)
            .foregroundColor(.textSecondary)
            .padding(.horizontal)
            .padding(.top, 8)

          TextEditor(text: text)
            .frame(minHeight: 100)
            .padding(12)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 4)
            .padding(.bottom, 12)
        }
        .padding(8)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
        .padding(.horizontal, 24)
        .transition(.scale(scale: 0.95).combined(with: .opacity))
        .padding(.bottom, 16)
      }
    }
  }

  private var saveButton: some View {
    GradientButton("Seal the Alignment", icon: "lock.shield.fill", style: .orient) {
      HapticManager.shared.notification(.success)
      saveData()
      dismiss()
    }
    .padding(.horizontal, 32)
  }

  // MARK: - Logic

  private func loadData() {
    if let existing = hierarchies.first {
      decadeVision = existing.decadeVisionDescription
      yearGoal = existing.yearGoalDescription
      quarterProject = existing.quarterProjectTitle
      weekMilestone = existing.weekMilestoneDescription
    }
  }

  private func saveData() {
    let hierarchy: GoalHierarchyModel
    if let existing = hierarchies.first {
      hierarchy = existing
    } else {
      hierarchy = GoalHierarchyModel()
      modelContext.insert(hierarchy)
    }

    hierarchy.decadeVisionDescription = decadeVision
    hierarchy.yearGoalDescription = yearGoal
    hierarchy.quarterProjectTitle = quarterProject
    hierarchy.weekMilestoneDescription = weekMilestone
    hierarchy.updatedAt = Date()
  }
}

#Preview {
  GoalPyramidView()
}
