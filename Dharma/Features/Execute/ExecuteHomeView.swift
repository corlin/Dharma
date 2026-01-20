// ExecuteHomeView.swift
// Dharma Features - Execute Layer Home

import SwiftData
import SwiftUI

/// 执行层首页
struct ExecuteHomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \DailyLeverModel.priority) private var todayTasks: [DailyLeverModel]

  @State private var showNewTaskSheet = false
  @State private var selectedTask: DailyLeverModel?
  @State private var showDeepWorkSession = false

  var body: some View {
    NavigationStack {
      ZStack {
        // 背景 + 光晕效果 (不变)
        Color.backgroundPrimary
          .ignoresSafeArea()

        // 右上角蓝色光晕
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color.execute.opacity(0.25),
                Color.execute.opacity(0.08),
                Color.clear,
              ],
              center: .center,
              startRadius: 0,
              endRadius: 200
            )
          )
          .frame(width: 400, height: 400)
          .offset(x: 120, y: -80)
          .blur(radius: 60)

        // 左下角淡青光晕
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color(hex: "#E3F2FD").opacity(0.4),
                Color.clear,
              ],
              center: .center,
              startRadius: 0,
              endRadius: 150
            )
          )
          .frame(width: 300, height: 300)
          .offset(x: -80, y: 280)
          .blur(radius: 60)

        // Main Content Area
        VStack(spacing: 0) {
          // Custom Premium Header
          DharmaScreenHeader("Execute", subtitle: "Deep work & action") {
            DharmaHeaderButton(icon: "plus") {
              showNewTaskSheet = true
            }
          }

          ScrollView {
            VStack(spacing: Spacing.lg) {
              // 快速开始卡片
              quickStartCard

              // 今日杠杆任务
              todayTasksSection

              // 工作类型统计
              workTypeStatsSection

              Spacer(minLength: 60)
            }
            .padding(.horizontal)
            .padding(.top, Spacing.xxs)  // Add some breathing room after header
          }
        }
          // Let header go underneath status bar
      }
      .toolbar(.hidden, for: .navigationBar)  // Hide system "Low" nav bar
      .sheet(isPresented: $showNewTaskSheet) {
        NewTaskSheet()
      }
      .fullScreenCover(isPresented: $showDeepWorkSession) {
        DeepWorkSessionView(task: selectedTask)
      }
    }
  }

  // MARK: - Quick Start Card
  private var quickStartCard: some View {
    DharmaCard {
      VStack(spacing: Spacing.md) {
        HStack {
          VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Ready to focus?")
              .font(.dharmaSectionTitle)
              .foregroundColor(.textPrimary)
            Text("Start a deep work session")
              .font(.dharmaBody)
              .foregroundColor(.textSecondary)
          }
          Spacer()
          // Play Button
          Button {
            selectedTask = nil
            showDeepWorkSession = true
          } label: {
            ZStack {
              Circle()
                .fill(
                  LinearGradient(
                    colors: [.execute, Color(hex: "#00D4FF")], startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                )
                .frame(width: 60, height: 60)
              Image(systemName: "play.fill")
                .font(.title2)
                .foregroundColor(.white)
            }
            .shadow(color: Color.execute.opacity(0.4), radius: 12, y: 4)
          }
        }
        // Work Type Quick Select
        HStack(spacing: Spacing.sm) {
          WorkTypeQuickButton(type: .build, isSelected: true) {
            selectedTask = nil
            showDeepWorkSession = true
          }
          WorkTypeQuickButton(type: .maintain, isSelected: false) {
            selectedTask = nil
            showDeepWorkSession = true
          }
          WorkTypeQuickButton(type: .recover, isSelected: false) {
            selectedTask = nil
            showDeepWorkSession = true
          }
        }
      }
    } header: {
      EmptyView()  // No header for Quick Start to keep it clean, or could add one.
    }
  }

  // MARK: - Today Tasks Section
  private var todayTasksSection: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      HStack {
        Text("Today's Levers")
          .font(.titleMedium)
          .foregroundColor(.sectionTitle)

        Spacer()

        Text("\(completedCount)/\(todayTasks.count)")
          .font(.labelMedium)
          .foregroundColor(.textSecondary)
      }

      if todayTasks.isEmpty {
        emptyTasksCard
      } else {
        ForEach(todayTasks) { task in
          TaskRowCard(task: task) {
            selectedTask = task
            showDeepWorkSession = true
          }
        }
      }
    }
  }

  private var emptyTasksCard: some View {
    DharmaCard {
      VStack(spacing: Spacing.md) {
        Image(systemName: "tray")
          .font(.system(size: 40))
          .foregroundColor(.textTertiary)

        Text("No tasks for today")
          .font(.dharmaBodyMedium)
          .foregroundColor(.textSecondary)

        Button("Add Task") {
          HapticManager.shared.impact(.light)
          showNewTaskSheet = true
        }
        .foregroundColor(.execute)
        .font(.dharmaHeadline)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, Spacing.lg)
    } header: {
      EmptyView()
    }
  }

  private var completedCount: Int {
    todayTasks.filter { $0.isCompleted }.count
  }

  // MARK: - Work Type Stats Section
  private var workTypeStatsSection: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      Text("This Week")
        .font(.titleMedium)
        .foregroundColor(.sectionTitle)

      HStack(spacing: Spacing.md) {
        WorkTypeStatCard(
          type: .build,
          hours: 12.5,
          percentage: 0.6
        )

        WorkTypeStatCard(
          type: .maintain,
          hours: 5.0,
          percentage: 0.25
        )

        WorkTypeStatCard(
          type: .recover,
          hours: 3.0,
          percentage: 0.15
        )
      }
    }
  }
}

// MARK: - Supporting Views
struct WorkTypeQuickButton: View {
  let type: WorkType
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: Spacing.xxs) {
        Text(type.rawValue)
          .font(.labelSmall)
          .fontWeight(isSelected ? .semibold : .regular)

        Text(type.localizedName)
          .font(.system(size: 10))
      }
      .foregroundColor(isSelected ? typeColor : .textSecondary)
      .padding(.horizontal, Spacing.md)
      .padding(.vertical, Spacing.sm)
      .background(isSelected ? typeColor.opacity(0.15) : Color.backgroundTertiary)
      .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
    }
  }

  private var typeColor: Color {
    switch type {
    case .build: return .execute
    case .maintain: return .orient
    case .recover: return .feedback
    }
  }
}

struct TaskRowCard: View {
  let task: DailyLeverModel
  let onStart: () -> Void

  var body: some View {
    HStack(spacing: Spacing.md) {
      // 完成状态
      Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
        .foregroundColor(task.isCompleted ? .success : .textTertiary)
        .font(.title3)

      // 任务信息
      VStack(alignment: .leading, spacing: Spacing.xxs) {
        Text(task.title)
          .font(.bodyMedium)
          .strikethrough(task.isCompleted)
          .foregroundColor(task.isCompleted ? .textTertiary : .textPrimary)

        HStack(spacing: Spacing.sm) {
          Label(formatDuration(task.estimatedDuration), systemImage: "clock")
          Label(task.workType, systemImage: "bolt")
        }
        .font(.labelSmall)
        .foregroundColor(.textSecondary)
      }

      Spacer()

      // 开始按钮
      if !task.isCompleted {
        Button(action: onStart) {
          Image(systemName: "play.fill")
            .foregroundColor(.execute)
            .padding(Spacing.sm)
            .background(Color.execute.opacity(0.1))
            .clipShape(Circle())
        }
      }
    }
    .padding()
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)
  }

  private func formatDuration(_ seconds: Double) -> String {
    let hours = Int(seconds) / 3600
    let minutes = Int(seconds) % 3600 / 60
    if hours > 0 {
      return "\(hours)h \(minutes)m"
    }
    return "\(minutes)m"
  }
}

struct WorkTypeStatCard: View {
  let type: WorkType
  let hours: Double
  let percentage: Double

  var body: some View {
    VStack(spacing: Spacing.sm) {
      Text(type.rawValue)
        .font(.labelSmall)
        .foregroundColor(typeColor)

      Text(String(format: "%.1fh", hours))
        .font(.titleMedium)

      GeometryReader { geo in
        RoundedRectangle(cornerRadius: 2)
          .fill(typeColor.opacity(0.3))
          .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
              .fill(typeColor)
              .frame(width: geo.size.width * percentage)
          }
      }
      .frame(height: 4)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
  }

  private var typeColor: Color {
    switch type {
    case .build: return .execute
    case .maintain: return .orient
    case .recover: return .feedback
    }
  }
}

// MARK: - New Task Sheet
struct NewTaskSheet: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @Query private var users: [UserModel]  // To access GoalHierarchy

  private var user: UserModel? { users.first }

  @State private var title = ""
  @State private var estimatedHours = 1.0
  @State private var workType: WorkType = .build
  @State private var priority = 2

  var body: some View {
    NavigationStack {
      Form {
        Section("Task") {
          TextField("What do you need to do?", text: $title)

          if let milestone = user?.goalHierarchy?.weekMilestoneDescription, !milestone.isEmpty {
            HStack(alignment: .top) {
              Image(systemName: "target")
                .foregroundColor(.orient)
              VStack(alignment: .leading) {
                Text("Aligns with Weekly Milestone:")
                  .font(.caption)
                  .foregroundColor(.textSecondary)
                Text(milestone)
                  .font(.caption)
                  .foregroundColor(.orient)
                  .fixedSize(horizontal: false, vertical: true)
              }
            }
            .padding(.vertical, 4)
          }
        }

        Section("Duration") {
          Stepper(
            "\(String(format: "%.1f", estimatedHours)) hours",
            value: $estimatedHours,
            in: 0.5...8,
            step: 0.5
          )
        }

        Section("Work Type") {
          Picker("Type", selection: $workType) {
            ForEach(WorkType.allCases, id: \.self) { type in
              Text("\(type.rawValue) - \(type.localizedName)")
                .tag(type)
            }
          }
          .pickerStyle(.segmented)
        }

        Section("Priority") {
          Picker("Priority", selection: $priority) {
            Text("🔴 High").tag(1)
            Text("🟡 Medium").tag(2)
            Text("🟢 Low").tag(3)
          }
          .pickerStyle(.segmented)
        }
      }
      .navigationTitle("New Task")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") { dismiss() }
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Add") {
            addTask()
            dismiss()
          }
          .disabled(title.isEmpty)
        }
      }
    }
  }

  private func addTask() {
    let task = DailyLeverModel(
      title: title,
      estimatedDuration: estimatedHours * 3600,
      workType: workType.rawValue,
      priority: priority
    )
    modelContext.insert(task)

    // Hook: Link to Goal Hierarchy
    if let goalHierarchy = user?.goalHierarchy {
      goalHierarchy.dailyLevers.append(task)
    }
  }
}

// MARK: - Preview
#Preview {
  ExecuteHomeView()
}
