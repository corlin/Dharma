// DeepWorkSessionView.swift
// Dharma Features - Execute Layer - Deep Work Session

import SwiftData
import SwiftUI

/// Deep Work Session View
/// Immersive focus timer tracking flow state
struct DeepWorkSessionView: View {
  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext

  let task: DailyLeverModel?

  @State private var workType: WorkType = .build
  @State private var elapsedTime: TimeInterval = 0
  @State private var isRunning = false
  @State private var isPaused = false
  @State private var flowState: Double = 0.5
  @State private var distractionsBlocked = 0
  @State private var knowledgeGaps = 0
  @State private var showFlowCheck = false
  @State private var timer: Timer?

  init(task: DailyLeverModel? = nil) {
    self.task = task
  }

  var body: some View {
    ZStack {
      // Background + Glows (Consistent with App, but Darker for Focus)
      Color.backgroundPrimary
        .ignoresSafeArea()
        .overlay(Color.black.opacity(0.6))  // Darken for focus mode

      // Top Right Blue Glow (Focus/Flow)
      Circle()
        .fill(
          RadialGradient(
            colors: [
              Color.execute.opacity(0.3),
              Color.execute.opacity(0.1),
              Color.clear,
            ],
            center: .center,
            startRadius: 0,
            endRadius: 200
          )
        )
        .frame(width: 400, height: 400)
        .offset(x: 120, y: -150)
        .blur(radius: 60)

      // Bottom Left Purple Glow (Wisdom)
      Circle()
        .fill(
          RadialGradient(
            colors: [
              Color.evolve.opacity(0.2),  // Purple
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
        // MARK: - Premium Header
        // Integrated Close Button (X) - Consistent with other headers
        DharmaScreenHeader("Deep Work", subtitle: "Enter the flow") {
          DharmaHeaderButton(icon: "xmark") {
            if isRunning {
              pauseSession()  // Safety pause
            }
            dismiss()
          }
        }

        ScrollView {
          VStack(spacing: Spacing.xl) {

            // Work Type Segmented Control
            workTypeSelector
              .padding(.top, Spacing.md)

            // Timer Display
            timerDisplay
              .padding(.vertical, Spacing.lg)

            // Current Task Capsule
            if let task = task {
              taskLabel(task.title)
            }

            // Flow State Indicator
            flowStateIndicator

            // Flow Check (Orb Question)
            if showFlowCheck {
              flowCheckCard
                .transition(.scale.combined(with: .opacity))
            }

            // Stats
            statsBar

            Spacer(minLength: Spacing.xl)
          }
          .padding(.horizontal)
        }

        // Bottom Action Button (Fixed)
        controlButtons
          .padding()
          .background(
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
              .ignoresSafeArea()
          )
      }
    }
    .preferredColorScheme(.dark)  // Always dark for focus
    .onDisappear {
      timer?.invalidate()
    }
  }

  // MARK: - Work Type Selector
  private var workTypeSelector: some View {
    HStack(spacing: 0) {
      ForEach(WorkType.allCases, id: \.self) { type in
        Button {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            workType = type
          }
        } label: {
          Text(type.localizedName)
            .font(.dharmaCaption)
            .fontWeight(workType == type ? .bold : .medium)
            .foregroundColor(workType == type ? .white : .textTertiary)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
              ZStack {
                if workType == type {
                  Capsule()
                    .fill(Color.execute)
                    .matchedGeometryEffect(id: "ActiveTab", in: animationNamespace)
                    .shadow(color: Color.execute.opacity(0.4), radius: 8, y: 4)
                }
              }
            )
        }
      }
    }
    .padding(4)
    .background(Color.white.opacity(0.1))
    .clipShape(Capsule())
    .padding(.horizontal, Spacing.lg)
  }
  @Namespace private var animationNamespace

  // MARK: - Timer Display
  private var timerDisplay: some View {
    VStack(spacing: Spacing.sm) {
      Text(formatTime(elapsedTime))
        .font(.system(size: 72, weight: .bold, design: .rounded))  // Rounded for consistency
        .foregroundColor(.white)
        .shadow(color: Color.execute.opacity(0.5), radius: 20, x: 0, y: 0)  // Neo-glow

      if let task = task {
        Label("Est: \(task.estimatedDurationFormatted)", systemImage: "hourglass")
          .font(.dharmaCaption)
          .foregroundColor(.textTertiary)
      }
    }
  }

  // MARK: - Task Label
  private func taskLabel(_ title: String) -> some View {
    HStack {
      Image(systemName: "checkmark.circle")
        .foregroundColor(.execute)
      Text(title)
        .font(.dharmaBody)  // 15pt
        .foregroundColor(.white)
        .lineLimit(1)

      Spacer()
    }
    .padding()
    .background(Color.white.opacity(0.08))
    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    .overlay(
      RoundedRectangle(cornerRadius: CornerRadius.medium)
        .stroke(Color.white.opacity(0.1), lineWidth: 1)
    )
  }

  // MARK: - Flow State Indicator
  private var flowStateIndicator: some View {
    DharmaCard {
      HStack(spacing: Spacing.lg) {
        // Ring
        ZStack {
          Circle()
            .stroke(Color.white.opacity(0.1), lineWidth: 8)

          Circle()
            .trim(from: 0, to: flowState)
            .stroke(
              LinearGradient(
                colors: [.execute, .evolve],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              style: StrokeStyle(lineWidth: 8, lineCap: .round)
            )
            .rotationEffect(.degrees(-90))
            .shadow(color: Color.execute.opacity(0.3), radius: 5)

          VStack(spacing: 0) {
            Text("\(Int(flowState * 100))%")
              .font(.dharmaHeadline)
              .foregroundColor(.white)
            Text("FLOW")
              .font(.system(size: 8, weight: .bold))
              .foregroundColor(.textTertiary)
              .tracking(1)  // Letter spacing
          }
        }
        .frame(width: 70, height: 70)

        // Text & Bar
        VStack(alignment: .leading, spacing: Spacing.xs) {
          HStack {
            Spacer()
            Text(flowState > 0.8 ? "Peak Performance" : "Focusing...")
              .font(.dharmaCaption)
              .foregroundColor(.execute)
          }

          GeometryReader { geo in
            ZStack(alignment: .leading) {
              Capsule()
                .fill(Color.white.opacity(0.1))

              Capsule()
                .fill(
                  LinearGradient(
                    colors: [.execute, .evolve],
                    startPoint: .leading,
                    endPoint: .trailing
                  )
                )
                .frame(width: geo.size.width * flowState)
            }
          }
          .frame(height: 6)
        }
      }
    } header: {
      HStack {
        Text("Flow State")
          .font(.dharmaBody)
          .foregroundColor(.white)
        Spacer()
      }
    }
  }

  // MARK: - Flow Check Card
  private var flowCheckCard: some View {
    VStack(spacing: Spacing.md) {
      OrbBubble("How is your focus right now?")

      HStack(spacing: Spacing.sm) {
        FlowResponseButton(title: "Laser", icon: "bolt.fill", color: .success) {
          respondToFlowCheck(level: 1.0)
        }
        FlowResponseButton(title: "Drifting", icon: "wind", color: .warning) {
          respondToFlowCheck(level: 0.5)
        }
        FlowResponseButton(title: "Stuck", icon: "exclamationmark.triangle", color: .error) {
          respondToFlowCheck(level: 0.2)
        }
      }
    }
    .padding(.vertical, Spacing.sm)
  }

  // MARK: - Stats Bar
  private var statsBar: some View {
    HStack(spacing: Spacing.md) {
      StatItem(
        icon: "shield.fill",
        value: "\(distractionsBlocked)",
        label: "Blocked"
      )

      Divider()
        .background(Color.white.opacity(0.2))

      StatItem(
        icon: "brain.head.profile",
        value: "\(knowledgeGaps)",
        label: "Gaps"
      )
    }
    .padding()
    .background(Color.white.opacity(0.05))
    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
  }

  // MARK: - Control Buttons
  private var controlButtons: some View {
    VStack(spacing: Spacing.sm) {
      GradientButton(
        isRunning ? "Pause Session" : (isPaused ? "Resume" : "Start Session"),
        icon: isRunning ? "pause.fill" : "play.fill",
        style: .execute
      ) {
        if isRunning {
          pauseSession()
        } else {
          startOrResumeSession()
        }
      }

      if isPaused {
        Button("End Session") {
          endSession()
        }
        .font(.dharmaBody)
        .foregroundColor(.error)
        .padding(.top, 4)
      }
    }
  }

  // MARK: - Helper Methods
  private func formatTime(_ interval: TimeInterval) -> String {
    let hours = Int(interval) / 3600
    let minutes = Int(interval) % 3600 / 60
    let seconds = Int(interval) % 60
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }

  private func startOrResumeSession() {
    isRunning = true
    isPaused = false

    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      elapsedTime += 1

      // Every 15 mins check flow
      if Int(elapsedTime) % 900 == 0 && Int(elapsedTime) > 0 {
        withAnimation {
          showFlowCheck = true
        }
      }

      // Sim flow noise
      let noise = Double.random(in: -0.02...0.02)
      flowState = min(1, max(0.2, flowState + noise))
    }
  }

  private func pauseSession() {
    isRunning = false
    isPaused = true
    timer?.invalidate()
  }

  private func endSession() {
    timer?.invalidate()

    // Update task
    if let task = task {
      task.actualDuration = elapsedTime
      task.isCompleted = true
    }

    dismiss()
  }

  private func respondToFlowCheck(level: Double) {
    withAnimation {
      flowState = level
      showFlowCheck = false
    }
  }
}

// MARK: - Supporting Views
struct FlowResponseButton: View {
  let title: String
  let icon: String
  let color: Color
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 4) {
        Image(systemName: icon)
          .font(.system(size: 20))
        Text(title)
          .font(.dharmaCaption)
      }
      .foregroundColor(color)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 12)
      .background(color.opacity(0.1))
      .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
      .overlay(
        RoundedRectangle(cornerRadius: CornerRadius.small)
          .stroke(color.opacity(0.3), lineWidth: 1)
      )
    }
  }
}

struct StatItem: View {
  let icon: String
  let value: String
  let label: String

  var body: some View {
    HStack(spacing: Spacing.sm) {
      Image(systemName: icon)
        .font(.system(size: 20))
        .foregroundColor(.execute)
        .frame(width: 32)

      VStack(alignment: .leading, spacing: 0) {
        Text(value)
          .font(.dharmaHeadline)
          .foregroundColor(.white)
        Text(label)
          .font(.dharmaCaption)
          .foregroundColor(.textTertiary)
      }
      Spacer()
    }
  }
}

// Minimal Visual Effect View for old iOS support if needed, or just use standard
struct VisualEffectBlur: UIViewRepresentable {
  var blurStyle: UIBlurEffect.Style

  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: blurStyle)
  }
}

#Preview {
  DeepWorkSessionView()
}
