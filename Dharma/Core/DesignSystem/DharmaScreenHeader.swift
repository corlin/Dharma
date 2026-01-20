// DharmaScreenHeader.swift
// Dharma Core - Design System - Premium Screen Header

import SwiftUI

/// A premium, custom header to replace the standard "Low" looking NavigationBar.
/// Features Dharma typography and distinct action buttons.
struct DharmaScreenHeader<TrailingContent: View>: View {
  let title: String
  let subtitle: String?
  let trailing: TrailingContent

  init(
    _ title: String,
    subtitle: String? = nil,
    @ViewBuilder trailing: () -> TrailingContent = { EmptyView() }
  ) {
    self.title = title
    self.subtitle = subtitle
    self.trailing = trailing()
  }

  var body: some View {
    VStack(spacing: 0) {
      Color.clear.frame(height: 0)  // Anchor for safe area

      HStack(alignment: .center, spacing: Spacing.md) {
        // Title Section
        VStack(alignment: .leading, spacing: 0) {
          Text(title)
            .font(.dharmaTitle)  // 28pt Rounded Bold
            .foregroundColor(.textPrimary)

          if let subtitle = subtitle {
            Text(subtitle)
              .font(.dharmaBody)  // 15pt Rounded Regular
              .foregroundColor(.textSecondary)
          }
        }

        Spacer()

        // Trailing Action Section
        trailing
      }
      .padding(.horizontal)
      .padding(.vertical, Spacing.sm)  // Minimal vertical padding (12pt)
      .background(
        LinearGradient(
          colors: [
            Color.backgroundPrimary.opacity(0.95),
            Color.backgroundPrimary.opacity(0.0),
          ], startPoint: .top, endPoint: .bottom
        )
        .blur(radius: 2)
        .ignoresSafeArea(edges: .top)  // Background ignores safe area
      )
    }
  }
}

/// Standardized Circular Icon Button for Headers
struct DharmaHeaderButton: View {
  let icon: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Image(systemName: icon)
        .font(.system(size: 18, weight: .bold))  // Slightly smaller, tighter icon
        .foregroundColor(.textPrimary)
        .frame(width: 40, height: 40)
        .background(
          Circle()
            .fill(Color.white.opacity(0.6))
            .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
        )
        .overlay(
          Circle()
            .stroke(Color.white.opacity(0.8), lineWidth: 1)
        )
    }
  }
}

#Preview {
  ZStack {
    Color.gray.opacity(0.1).ignoresSafeArea()
    VStack {
      DharmaScreenHeader("Excavate", subtitle: "Uncover your path") {
        DharmaHeaderButton(icon: "plus", action: {})
      }
      Spacer()
    }
  }
}
