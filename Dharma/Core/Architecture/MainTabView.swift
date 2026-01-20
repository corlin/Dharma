// MainTabView.swift
// Dharma - Main Navigation

import SwiftUI

/// 主导航视图
/// 5层架构对应5个Tab
struct MainTabView: View {
  @State private var selectedTab: Tab = .excavate

  enum Tab: String, CaseIterable {
    case excavate = "Excavate"
    case orient = "Orient"
    case execute = "Execute"
    case feedback = "Feedback"
    case evolve = "Evolve"

    var icon: String {
      switch self {
      case .excavate: return "magnifyingglass"
      case .orient: return "target"
      case .execute: return "bolt.fill"
      case .feedback: return "chart.bar.fill"
      case .evolve: return "sparkles"
      }
    }

    var color: Color {
      switch self {
      case .excavate: return .excavate
      case .orient: return .orient
      case .execute: return .execute
      case .feedback: return .feedback
      case .evolve: return .evolve
      }
    }
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      // 主内容区域
      TabView(selection: $selectedTab) {
        ExcavateHomeView()
          .tag(Tab.excavate)

        OrientHomeView()
          .tag(Tab.orient)

        ExecuteHomeView()
          .tag(Tab.execute)

        FeedbackHomeView()
          .tag(Tab.feedback)

        EvolveHomeView()
          .tag(Tab.evolve)
      }
      .tabViewStyle(.page(indexDisplayMode: .never))

      // 自定义浮动 Tab Bar
      FloatingTabBar(selectedTab: $selectedTab)
    }
    .ignoresSafeArea(.keyboard)
  }
}

// MARK: - Floating Tab Bar
struct FloatingTabBar: View {
  @Binding var selectedTab: MainTabView.Tab

  var body: some View {
    HStack(spacing: 0) {
      ForEach(MainTabView.Tab.allCases, id: \.self) { tab in
        TabBarButton(
          tab: tab,
          isSelected: selectedTab == tab
        ) {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedTab = tab
          }
        }
      }
    }
    .padding(.horizontal, Spacing.sm)
    .padding(.vertical, 8)  // Reduced from xs(8) inner + extra outer padding
    .background(
      RoundedRectangle(cornerRadius: CornerRadius.floating)
        .fill(Color.white.opacity(0.95))
        .shadow(color: Color.black.opacity(0.1), radius: 20, y: 8)
    )
    .overlay(
      RoundedRectangle(cornerRadius: CornerRadius.floating)
        .stroke(Color.white.opacity(0.5), lineWidth: 1)
    )
    .padding(.horizontal, Spacing.lg)
    .padding(.bottom, 2)  // Minimal bottom padding off the edge
  }
}

// MARK: - Tab Bar Button
struct TabBarButton: View {
  let tab: MainTabView.Tab
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 2) {
        // 图标
        ZStack {
          if isSelected {
            Circle()
              .fill(tab.color.opacity(0.15))
              .frame(width: 36, height: 36)
          }

          Image(systemName: tab.icon)
            .font(.system(size: 18, weight: isSelected ? .semibold : .regular))
            .foregroundColor(isSelected ? tab.color : .textTertiary)
        }
        .frame(height: 36)

        // 标签
        Text(tab.rawValue)
          .font(.system(size: 10, weight: .medium))
          .foregroundColor(isSelected ? tab.color : .textTertiary)
      }
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
  }
}

// MARK: - Preview
#Preview {
  MainTabView()
}
