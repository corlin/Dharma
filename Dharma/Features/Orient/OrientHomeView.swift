// OrientHomeView.swift
// Dharma Features - Orient Layer Home

import SwiftData
import SwiftUI

/// Orient Layer Home
struct OrientHomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \DisappearItemModel.createdAt, order: .reverse)
  private var allDisappearItems: [DisappearItemModel]

  private var disappearItems: [DisappearItemModel] {
    allDisappearItems.filter { $0.status != .gone }
  }

  @Query(sort: \VisionMVPModel.createdAt, order: .reverse)
  private var visionMVPs: [VisionMVPModel]

  @Query private var goalHierarchies: [GoalHierarchyModel]
  @Query private var users: [UserModel]

  @State private var showVisionWorkshop = false
  @State private var showGoalPyramid = false

  var body: some View {
    NavigationStack {
      ZStack {
        // Background + Glow
        Color.backgroundPrimary
          .ignoresSafeArea()

        // Top Right Golden Glow (Orient Theme)
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color.orient.opacity(0.3),
                Color.orient.opacity(0.1),
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

        // Bottom Left Warm Orange Glow
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color(hex: "#FFD8A8").opacity(0.4),  // Warm Orange
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
          // Custom Premium Header
          DharmaScreenHeader("Orient", subtitle: "Set your direction") {
            // Updated to Safari/Compass icon for consistency
            DharmaHeaderButton(icon: "safari.fill") {
              showGoalPyramid = true
            }
          }

          ScrollView {
            VStack(spacing: Spacing.lg) {
              // Orb Guide
              OrbBubble("Where are we heading today?")
                .padding(.top)

              // Vision MVP Card
              visionMVPCard

              // Disappear List (From Pain Log)
              if !disappearItems.isEmpty {
                disappearListCard
              }

              // Goal Hierarchy Preview
              goalHierarchyPreviewCard

              // This Week Focus
              thisWeekFocusCard

              Spacer(minLength: 60)
            }
            .padding(.horizontal)
            .padding(.top, Spacing.xxs)
          }
        }
        
      }
      .toolbar(.hidden, for: .navigationBar)  // Hide system bar
      .sheet(isPresented: $showVisionWorkshop) {
        NavigationStack {
          AntiVisionWorkshopView()
        }
      }
      .sheet(isPresented: $showGoalPyramid) {
        NavigationStack {
          GoalPyramidView()
        }
      }
    }
  }

  // MARK: - Vision MVP Card
  private var visionMVPCard: some View {
    ThemedCard("Trajectory", icon: "safari.fill", theme: .orient) {
      VStack(alignment: .leading, spacing: Spacing.md) {
        Text("Your North Star")
          .font(.titleMedium)
          .foregroundColor(.textPrimary)

        if let latestVision = visionMVPs.first {
          Text("\"\(latestVision.statement)\"")
            .font(.bodyLarge)
            .italic()
            .foregroundColor(.textPrimary)
            .padding(.vertical, Spacing.xs)

          Divider()

          HStack {
            Label("Vision MVP v1.\(visionMVPs.count)", systemImage: "flag.fill")
              .font(.labelSmall)
              .foregroundColor(.orient)
            Spacer()
            Button("Refine") {
              showVisionWorkshop = true
            }
            .font(.labelMedium)
          }
        } else {
          Text("No vision defined yet. Start by defining your Anti-Vision.")
            .font(.bodyMedium)
            .foregroundColor(.textSecondary)
            .padding(.vertical, Spacing.xs)

          Button("Define Anti-Vision") {
            showVisionWorkshop = true
          }
          .font(.labelMedium)
        }
      }
    }
  }

  // MARK: - Goal Hierarchy Preview
  private var goalHierarchyPreviewCard: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      Text("Hierarchy of Goals")
        .font(.titleMedium)
        .foregroundColor(.sectionTitle)

      Button {
        showGoalPyramid = true
      } label: {
        HStack(spacing: Spacing.md) {
          // Simplified Visualization
          VStack(spacing: 4) {
            Triangle()
              .fill(Color.orient)
              .frame(width: 40, height: 40)

          }
          .frame(width: 60)

          VStack(alignment: .leading, spacing: 4) {
            if let hierarchy = goalHierarchies.first, !hierarchy.yearGoalDescription.isEmpty {
              Text("Goal: \(hierarchy.yearGoalDescription)")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
                .lineLimit(1)
              Text("Focus: \(hierarchy.weekMilestoneDescription)")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
                .lineLimit(1)
            } else {
              Text("Align your goals")
                .font(.bodyMedium)
                .foregroundColor(.textPrimary)
              Text("Tap to set hierarchy")
                .font(.bodySmall)
                .foregroundColor(.textSecondary)
            }
          }

          Spacer()

          Image(systemName: "chevron.right")
            .foregroundColor(.textTertiary)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)
      }
    }
  }

  // MARK: - This Week Focus
  private var thisWeekFocusCard: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      Text("This Week's Milestone")
        .font(.titleMedium)
        .foregroundColor(.sectionTitle)

      VStack(alignment: .leading, spacing: Spacing.sm) {
        HStack {
          Image(systemName: "target")
          if let hierarchy = goalHierarchies.first, !hierarchy.weekMilestoneDescription.isEmpty {
            Text(hierarchy.weekMilestoneDescription)
          } else {
            Text("Set Weekly Milestone")
          }
        }
        .font(.headline)
        .foregroundColor(.white)

        ProgressView(value: 0.33)
          .tint(.white)
          .background(Color.white.opacity(0.3))

        HStack {
          Text("1/3 Completed")
            .font(.caption)
          Spacer()
          Text("2 days left")
            .font(.caption)
        }
        .foregroundColor(.white.opacity(0.9))
      }
      .padding()
      .background(
        LinearGradient(
          colors: [Color.orient, Color(hex: "#FFD8A8")],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
      .shadow(color: Color.orient.opacity(0.3), radius: 8, y: 4)
      .onTapGesture {
        showGoalPyramid = true
      }
    }
  }

  // MARK: - Disappear List Card
  private var disappearListCard: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      Text("Disappear List")
        .font(.titleMedium)
        .foregroundColor(.sectionTitle)

      ThemedCard("Disappear", icon: "xmark.bin.fill", theme: .excavate) {
        VStack(alignment: .leading, spacing: Spacing.sm) {
          Text("Things to remove from your life")
            .font(.caption)
            .foregroundColor(.textSecondary)

          if disappearItems.isEmpty {
            Text("Nothing identified yet. Go to Excavate > Pain Log.")
              .font(.bodySmall)
              .foregroundColor(.textTertiary)
          } else {
            ForEach(disappearItems) { item in
              HStack {
                Image(systemName: "trash")
                  .font(.caption)
                  .foregroundColor(.error)
                Text(item.name)
                  .font(.bodyMedium)
                  .foregroundColor(.textPrimary)
                Spacer()
                Text(item.status.rawValue)
                  .font(.caption2)
                  .padding(.horizontal, 6)
                  .padding(.vertical, 2)
                  .background(
                    item.status == .identified
                      ? Color.warning.opacity(0.1) : Color.info.opacity(0.1)
                  )
                  .foregroundColor(item.status == .identified ? .warning : .info)
                  .clipShape(Capsule())
              }
              .padding(.vertical, 4)

              if item != disappearItems.last {
                Divider()
              }
            }
          }
        }
      }
    }
  }
}

// Helper Shape
struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.closeSubpath()
    return path
  }
}

#Preview {
  OrientHomeView()
}
