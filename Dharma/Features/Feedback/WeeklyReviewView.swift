// WeeklyReviewView.swift
// Dharma Features - Feedback Layer
// Realizes the "Weekly Review" feature by aggregating past week's data and capturing reflection.

import SwiftData
import SwiftUI

struct WeeklyReviewView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  // Query all daily levers to filter locally (SwiftData dynamic dates in predicates can be tricky, simple filter is safer for MVP)
  @Query(sort: \DailyLeverModel.date, order: .reverse) private var allLevers: [DailyLeverModel]
  @Query(sort: \ReflectionModel.createdAt, order: .reverse) private var reflections:
    [ReflectionModel]

  // State
  @State private var reflectionContent: String = ""
  @State private var currentStep = 0

  // Computed Properties for "The Past Week"
  private var pastWeekLevers: [DailyLeverModel] {
    let calendar = Calendar.current
    let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
    return allLevers.filter { $0.date >= oneWeekAgo }
  }

  private var completedTasks: [DailyLeverModel] {
    pastWeekLevers.filter { $0.isCompleted }
  }

  private var incompleteTasks: [DailyLeverModel] {
    pastWeekLevers.filter { !$0.isCompleted }
  }

  private var completionRate: Double {
    guard !pastWeekLevers.isEmpty else { return 0 }
    return Double(completedTasks.count) / Double(pastWeekLevers.count)
  }

  var body: some View {
    NavigationStack {
      ZStack {
        Color.backgroundPrimary.ignoresSafeArea()

        VStack(spacing: Spacing.lg) {
          // Progress Bar
          ProgressView(value: Double(currentStep), total: 2)
            .tint(.feedback)
            .padding(.horizontal)
            .padding(.top)

          TabView(selection: $currentStep) {
            // Step 1: Data Review
            dataReviewView
              .tag(0)

            // Step 2: Reflection
            reflectionInputView
              .tag(1)

            // Step 3: Closing
            closingView
              .tag(2)
          }
          .tabViewStyle(.page(indexDisplayMode: .never))
        }
      }
      .navigationTitle("Weekly Review")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close") { dismiss() }
        }
      }
    }
    .onAppear {
      // Check if we already have a reflection for this week to pre-fill?
      // For MVP, just start fresh.
    }
  }

  // MARK: - Step 1: Data Review
  private var dataReviewView: some View {
    ScrollView {
      VStack(spacing: Spacing.xl) {

        // Header
        VStack(spacing: Spacing.sm) {
          Text("The Cybernetic Loop")
            .font(.dharmaSectionTitle)
            .foregroundColor(.textSecondary)
          Text("Look at the raw data.")
            .font(.dharmaTitle)
            .foregroundColor(.textPrimary)
        }
        .padding(.top)

        // Big Stat
        ZStack {
          Circle()
            .stroke(Color.feedback.opacity(0.1), lineWidth: 20)
            .frame(width: 200, height: 200)

          Circle()
            .trim(from: 0, to: completionRate)
            .stroke(
              LinearGradient(
                colors: [.feedback, Color(hex: "#00C6FF")], startPoint: .top, endPoint: .bottom),
              style: StrokeStyle(lineWidth: 20, lineCap: .round)
            )
            .frame(width: 200, height: 200)
            .rotationEffect(.degrees(-90))
            .shadow(color: .feedback.opacity(0.3), radius: 10)

          VStack {
            Text("\(Int(completionRate * 100))%")
              .font(.system(size: 48, weight: .bold, design: .rounded))
              .foregroundColor(.textPrimary)
            Text("Execution Rate")
              .font(.dharmaBody)
              .foregroundColor(.textSecondary)
          }
        }

        // Lists
        VStack(spacing: Spacing.md) {
          if !completedTasks.isEmpty {
            reviewList(
              title: "Wins (\(completedTasks.count))", items: completedTasks,
              icon: "checkmark.circle.fill", color: .success)
          }

          if !incompleteTasks.isEmpty {
            reviewList(
              title: "Misses (\(incompleteTasks.count))", items: incompleteTasks,
              icon: "xmark.circle.fill", color: .error)
          }
        }
        .padding(.horizontal)

        Button {
          withAnimation { currentStep = 1 }
        } label: {
          Text("I've seen the data")
            .font(.dharmaHeadline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.feedback)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
        }
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
  }

  private func reviewList(title: String, items: [DailyLeverModel], icon: String, color: Color)
    -> some View
  {
    VStack(alignment: .leading, spacing: Spacing.xs) {
      Text(title)
        .font(.dharmaHeadline)
        .foregroundColor(.textPrimary)
        .padding(.leading, 4)

      ForEach(items) { item in
        HStack {
          Image(systemName: icon)
            .foregroundColor(color)
          Text(item.title)
            .font(.dharmaBody)
            .strikethrough(color == .success)
            .foregroundColor(.textSecondary)
          Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
      }
    }
  }

  // MARK: - Step 2: Reflection
  private var reflectionInputView: some View {
    VStack(spacing: Spacing.xl) {
      VStack(spacing: Spacing.sm) {
        Text("Closing the Loop")
          .font(.dharmaSectionTitle)
          .foregroundColor(.textSecondary)
        Text("What did you learn?")
          .font(.dharmaTitle)
          .foregroundColor(.textPrimary)
      }
      .padding(.top)

      VStack(alignment: .leading) {
        Text("Gap Analysis")
          .font(.dharmaHeadline)
          .foregroundColor(.textPrimary)

        TextEditor(text: $reflectionContent)
          .font(.dharmaBody)
          .padding()
          .background(Color.white)
          .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
          .overlay(
            RoundedRectangle(cornerRadius: CornerRadius.medium)
              .stroke(Color.backgroundTertiary, lineWidth: 1)
          )

        Text("Why was there a gap between what you said and what you did? capture the insight.")
          .font(.caption)
          .foregroundColor(.textTertiary)
          .padding(.top, 4)
      }
      .padding(.horizontal)

      Spacer()

      Button {
        saveReflection()
        withAnimation { currentStep = 2 }
      } label: {
        Text("Commit Reflection")
          .font(.dharmaHeadline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(reflectionContent.isEmpty ? Color.backgroundTertiary : Color.feedback)
          .foregroundColor(.white)
          .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
      }
      .disabled(reflectionContent.isEmpty)
      .padding(.horizontal)
      .padding(.bottom)
    }
  }

  // MARK: - Step 3: Closing
  private var closingView: some View {
    VStack(spacing: Spacing.xl) {
      Spacer()

      Image(systemName: "checkmark.seal.fill")
        .font(.system(size: 80))
        .foregroundColor(.feedback)
        .symbolEffect(.bounce)

      Text("System Updated")
        .font(.dharmaTitle)
        .foregroundColor(.textPrimary)

      Text("Your reflection has been recorded.\n+50 XP")
        .font(.dharmaBody)
        .multilineTextAlignment(.center)
        .foregroundColor(.textSecondary)

      Spacer()

      Button {
        dismiss()
      } label: {
        Text("Return to Feedback")
          .font(.dharmaHeadline)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.backgroundSecondary)
          .foregroundColor(.textPrimary)
          .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
      }
      .padding()
    }
  }

  // MARK: - Logic
  private func saveReflection() {
    let calendar = Calendar.current
    let weekNumber = calendar.component(.weekOfYear, from: Date())
    let year = calendar.component(.year, from: Date())

    let reflection = ReflectionModel(
      content: reflectionContent,
      weekNumber: weekNumber,
      year: year
    )

    // Auto-populate 'said' and 'did' from querying data
    reflection.saidGoals = allLevers.map { $0.title }  // Ideally this would be "Goals set that week"
    reflection.actualBehaviors = completedTasks.map { $0.title }
    reflection.xpEarned = 50

    modelContext.insert(reflection)

    // Haptic
    HapticManager.shared.notification(.success)
  }
}
