// EvolveHomeView.swift
// Dharma Features - Evolve Layer Home

import SwiftData
import SwiftUI

/// 进化层首页
struct EvolveHomeView: View {
  @Environment(\.modelContext) private var modelContext
  // TODO: Add models for Identity and XP
  @State private var showSettings = false

  var body: some View {
    NavigationStack {
      ZStack {
        // 背景
        Color.backgroundPrimary
          .ignoresSafeArea()

        // 右上角紫色光晕 (Evolve Theme)
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color.evolve.opacity(0.3),
                Color.evolve.opacity(0.1),
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

        // 左下角深紫光晕
        Circle()
          .fill(
            RadialGradient(
              colors: [
                Color(hex: "#E8D5F2").opacity(0.4),
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
          DharmaScreenHeader("Evolve", subtitle: "Upgrade your self") {
            DharmaHeaderButton(icon: "gearshape.fill") {
              showSettings = true
            }
          }

          ScrollView {
            VStack(spacing: Spacing.lg) {
              // 身份进化卡片 (Level + XP)
              identityEvolutionCard

              // 身份声明卡片
              identityStatementCard

              // 失败投资组合
              failurePortfolioCard

              Spacer(minLength: 60)
            }
            .padding(.horizontal)
            .padding(.top, Spacing.xxs)
          }
        }
        
      }
      .toolbar(.hidden, for: .navigationBar)
      .sheet(isPresented: $showSettings) {
        SettingsView()
      }
    }
  }

  // MARK: - Identity Evolution Card
  private var identityEvolutionCard: some View {
    VStack(spacing: Spacing.md) {
      ZStack {
        Circle()
          .stroke(Color.evolve.opacity(0.2), lineWidth: 12)
          .frame(width: 150, height: 150)

        Circle()
          .trim(from: 0, to: 0.64)  // 320/500
          .stroke(
            LinearGradient(
              colors: [Color.evolve, Color(hex: "#5B8DEF")],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            style: StrokeStyle(lineWidth: 12, lineCap: .round)
          )
          .frame(width: 150, height: 150)
          .rotationEffect(.degrees(-90))

        VStack(spacing: 4) {
          Text("Lv.2")
            .font(.title)
            .bold()
          Text("Explorer")
            .font(.bodyMedium)
            .foregroundColor(.textSecondary)
          Text("320/500 XP")
            .font(.caption)
            .foregroundColor(.textTertiary)
        }
      }
      .padding(.vertical, Spacing.lg)
    }
  }

  // MARK: - Identity Statement
  private var identityStatementCard: some View {
    ThemedCard("Who I Am", icon: "person.crop.circle.badge.checkmark", theme: .evolve) {
      VStack(alignment: .leading, spacing: Spacing.md) {
        Text("Active Identity")
          .font(.caption)
          .foregroundColor(.textSecondary)
          .textCase(.uppercase)

        Text("\"I am the type of person who creates content every single day.\"")
          .font(.title3)
          .fontWeight(.medium)
          .foregroundColor(.textPrimary)
          .multilineTextAlignment(.leading)

        Divider()

        HStack {
          VStack(alignment: .leading) {
            Text("Evidence")
              .font(.caption)
              .foregroundColor(.textSecondary)
            Text("14 Days Streak")
              .font(.bodySmall)
          }
          Spacer()
          VStack(alignment: .leading) {
            Text("Consolidation")
              .font(.caption)
              .foregroundColor(.textSecondary)
            Text("78%")
              .font(.bodySmall)
              .foregroundColor(.success)
          }
        }
      }
    }
  }

  // MARK: - Failure Portfolio
  private var failurePortfolioCard: some View {
    VStack(alignment: .leading, spacing: Spacing.md) {
      Text("Failure Portfolio")
        .font(.titleMedium)
        .foregroundColor(.sectionTitle)

      HStack(spacing: Spacing.md) {
        VStack {
          Text("23")
            .font(.title)
            .bold()
            .foregroundColor(.evolve)
          Text("Failures")
            .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))

        VStack {
          Text("18")
            .font(.title)
            .bold()
            .foregroundColor(.success)
          Text("Learnings")
            .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
      }
    }
  }
}

#Preview {
  EvolveHomeView()
}
