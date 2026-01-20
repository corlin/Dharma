// FeedbackHomeView.swift
// Dharma Features - Feedback Layer Home

import SwiftData
import SwiftUI

/// 反馈层首页
struct FeedbackHomeView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \DailyLeverModel.date, order: .reverse) private var dailyLevers: [DailyLeverModel]

  @State private var showWeeklyReview = false
  @State private var showSocraticChat = false

  var body: some View {
    NavigationStack {
      ZStack {
        // 背景
        Color.backgroundPrimary
          .ignoresSafeArea()

        // 右上角青色光晕 (Feedback Theme)
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color.feedback.opacity(0.3),
                Color.feedback.opacity(0.1),
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

        // 左下角冷蓝光晕
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color(hex: "#D0F0FD").opacity(0.4),
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
          DharmaScreenHeader("Feedback", subtitle: "Close the loops")

          ScrollView {
            VStack(spacing: Spacing.lg) {
              // 仪表盘卡片
              cyberneticDashboardCard

              // 每周回顾入口
              weeklyReviewCard

              // 言行差距卡片
              sayDoGapCard

              Spacer(minLength: 60)
            }
            .padding(.horizontal)
            .padding(.top, Spacing.xxs)
          }
        }
        
      }
      .toolbar(.hidden, for: .navigationBar)
      .sheet(isPresented: $showSocraticChat) {
        SocraticChatView()
      }
      .sheet(isPresented: $showWeeklyReview) {
        WeeklyReviewView()
      }
    }
  }

  // MARK: - Cybernetic Dashboard
  private var cyberneticDashboardCard: some View {
    let completedCount = dailyLevers.filter { $0.isCompleted }.count
    let totalCount = dailyLevers.count
    let percentage = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0.0

    return DharmaCard {
      VStack(spacing: Spacing.md) {
        // Stats Row
        HStack(spacing: Spacing.xl) {
          VStack(alignment: .leading) {
            Text("\(completedCount)")
              .font(.dharmaTitle)
              .foregroundColor(.textPrimary)
            Text("Completed")
              .font(.dharmaCaption)
              .foregroundColor(.textSecondary)
          }

          VStack(alignment: .leading) {
            Text("\(totalCount)")
              .font(.dharmaTitle)
              .foregroundColor(.textPrimary)
            Text("Total Tasks")
              .font(.dharmaCaption)
              .foregroundColor(.textSecondary)
          }

          Spacer()

          // Circular Progress
          ZStack {
            Circle()
              .stroke(Color.feedback.opacity(0.2), lineWidth: 8)
            Circle()
              .trim(from: 0, to: percentage)
              .stroke(Color.feedback, style: StrokeStyle(lineWidth: 8, lineCap: .round))
              .rotationEffect(.degrees(-90))

            Text("\(Int(percentage * 100))%")
              .font(.dharmaHeadline)
              .foregroundColor(.textPrimary)
          }
          .frame(width: 60, height: 60)
        }
      }
    } header: {
      HStack {
        Image(systemName: "gauge.medium")
          .foregroundColor(.feedback)
          .font(.title3)
        Text("Cybernetic Dashboard")
          .font(.dharmaHeadline)
          .foregroundColor(.textPrimary)
        Spacer()
      }
    }
  }

  // MARK: - Weekly Review
  private var weeklyReviewCard: some View {
    HStack {
      VStack(alignment: .leading, spacing: Spacing.sm) {
        Text("Weekly Review")
          .font(.titleMedium)
          .foregroundColor(.white)
        Text("Close your loops. Learning from last week.")
          .font(.bodySmall)
          .foregroundColor(.white.opacity(0.9))
      }
      Spacer()
      Button {
        showWeeklyReview = true
      } label: {
        Image(systemName: "arrow.right.circle.fill")
          .font(.largeTitle)
          .foregroundColor(.white)
      }
    }
    .padding()
    .background(
      LinearGradient(
        colors: [Color.feedback, Color(hex: "#0A84FF")],
        startPoint: .leading,
        endPoint: .trailing
      )
    )
    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
    .shadow(color: Color.feedback.opacity(0.3), radius: 8, y: 4)
  }

  // MARK: - Say/Do Gap
  private var sayDoGapCard: some View {
    DharmaCard {
      VStack(alignment: .leading, spacing: Spacing.md) {
        Text(
          "\"The gap between your intentions and your actions is where your potential leaks out.\""
        )
        .font(.dharmaBodyMedium)
        .italic()
        .foregroundColor(.textPrimary)
        .multilineTextAlignment(.leading)

        Button("Reflect with Orb") {
          HapticManager.shared.impact(.medium)
          showSocraticChat = true
        }
        .buttonStyle(.bordered)
        .tint(.feedback)
      }
    } header: {
      HStack {
        Image(systemName: "sparkles")
          .foregroundColor(.feedback)
        Text("Insight Generator")
          .font(.dharmaHeadline)
          .foregroundColor(.textPrimary)
        Spacer()
      }
    }
  }
}

#Preview {
  FeedbackHomeView()
}
