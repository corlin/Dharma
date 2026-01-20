// DharmaCard.swift
// Dharma Core - Design System - Unified Card Component

import SwiftUI

/// 统一样式的 Dharma 卡片
/// 基于 Glassmorphism 设计语言，替代旧的 ThemedCard 和 GlassCard
struct DharmaCard<Content: View, Header: View>: View {
  let content: Content
  let header: Header

  init(
    @ViewBuilder content: () -> Content,
    @ViewBuilder header: () -> Header
  ) {
    self.content = content()
    self.header = header()
  }

  var body: some View {
    VStack(spacing: 0) {
      // Header Area
      header
        .padding()
        .background(Color.white.opacity(0.1))  // Subtle separation

      // Divider
      Divider()
        .overlay(Color.white.opacity(0.2))

      // Content Area
      content
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .background(.ultraThinMaterial)  // The "Glass"
    .background(Color.white.opacity(0.05))  // Haze
    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
    .overlay(
      RoundedRectangle(cornerRadius: CornerRadius.large)
        .stroke(Color.white.opacity(0.3), lineWidth: 1)  // Frost border
    )
    .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
  }
}

// Convenience Init for simple titles
extension DharmaCard where Header == TupleView<(HStack<TupleView<(Image, Text)>>, Spacer)> {
  // Custom init tailored for standard icon+title headers would be complex to genericize perfectly in SwiftUI
  // without more boilerplate. Let's keep the usage simple in the Views instead.
}

// Convenience for standard usage
struct UnifiedCard<Content: View>: View {
  let title: String
  let icon: String
  let themeColor: Color
  let content: Content

  init(
    _ title: String, icon: String, color: Color = .textPrimary, @ViewBuilder content: () -> Content
  ) {
    self.title = title
    self.icon = icon
    self.themeColor = color
    self.content = content()
  }

  var body: some View {
    DharmaCard {
      content
    } header: {
      HStack {
        Image(systemName: icon)
          .foregroundColor(themeColor)
          .font(.title3)
        Text(title)
          .font(.headline)  // Will be replaced by Font.dharmaHeadline later
          .foregroundColor(.textPrimary)
        Spacer()
      }
    }
  }
}

#Preview {
  ZStack {
    Color.blue.opacity(0.3).ignoresSafeArea()
    UnifiedCard("Test Card", icon: "star.fill", color: .yellow) {
      Text("This is the content of the unified card.")
    }
    .padding()
  }
}
