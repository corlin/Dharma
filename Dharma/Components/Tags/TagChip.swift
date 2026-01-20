// TagChip.swift
// Dharma Components - Interactive Tag Chip

import SwiftUI

/// 标签芯片组件
/// 用于快速选择分类、情绪标签等
struct TagChip: View {
  let title: String
  let icon: String?
  let isSelected: Bool
  let color: Color
  let action: () -> Void

  init(
    _ title: String,
    icon: String? = nil,
    isSelected: Bool = false,
    color: Color = .excavate,
    action: @escaping () -> Void = {}
  ) {
    self.title = title
    self.icon = icon
    self.isSelected = isSelected
    self.color = color
    self.action = action
  }

  var body: some View {
    Button(action: action) {
      HStack(spacing: Spacing.xxs) {
        if let icon = icon {
          Image(systemName: icon)
            .font(.labelMedium)
        }

        Text(title)
          .font(.labelMedium)
      }
      .padding(.horizontal, Spacing.sm)
      .padding(.vertical, Spacing.xs)
      .foregroundColor(isSelected ? .white : color)
      .background(
        isSelected
          ? AnyShapeStyle(color)
          : AnyShapeStyle(color.opacity(0.1))
      )
      .clipShape(Capsule())
      .overlay(
        Capsule()
          .stroke(color.opacity(isSelected ? 0 : 0.3), lineWidth: 1)
      )
    }
    .buttonStyle(.plain)
    .animation(.spring(response: 0.3), value: isSelected)
  }
}

// MARK: - Tag Chip Group
struct TagChipGroup: View {
  let tags: [String]
  @Binding var selectedTags: Set<String>
  let color: Color
  let allowMultiple: Bool

  init(
    tags: [String],
    selectedTags: Binding<Set<String>>,
    color: Color = .excavate,
    allowMultiple: Bool = true
  ) {
    self.tags = tags
    self._selectedTags = selectedTags
    self.color = color
    self.allowMultiple = allowMultiple
  }

  var body: some View {
    FlowLayout(spacing: Spacing.xs) {
      ForEach(tags, id: \.self) { tag in
        TagChip(
          tag,
          isSelected: selectedTags.contains(tag),
          color: color
        ) {
          if allowMultiple {
            if selectedTags.contains(tag) {
              selectedTags.remove(tag)
            } else {
              selectedTags.insert(tag)
            }
          } else {
            selectedTags = [tag]
          }
        }
      }
    }
  }
}

// MARK: - Flow Layout (用于标签换行)
struct FlowLayout: Layout {
  var spacing: CGFloat = 8

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    let result = arrangeSubviews(proposal: proposal, subviews: subviews)
    return result.size
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    let result = arrangeSubviews(proposal: proposal, subviews: subviews)

    for (index, position) in result.positions.enumerated() {
      subviews[index].place(
        at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
        proposal: .unspecified
      )
    }
  }

  private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (
    size: CGSize, positions: [CGPoint]
  ) {
    let maxWidth = proposal.width ?? .infinity
    var positions: [CGPoint] = []
    var currentX: CGFloat = 0
    var currentY: CGFloat = 0
    var lineHeight: CGFloat = 0
    var totalHeight: CGFloat = 0

    for subview in subviews {
      let size = subview.sizeThatFits(.unspecified)

      if currentX + size.width > maxWidth && currentX > 0 {
        currentX = 0
        currentY += lineHeight + spacing
        lineHeight = 0
      }

      positions.append(CGPoint(x: currentX, y: currentY))
      currentX += size.width + spacing
      lineHeight = max(lineHeight, size.height)
      totalHeight = currentY + lineHeight
    }

    return (CGSize(width: maxWidth, height: totalHeight), positions)
  }
}

// MARK: - Preview
#Preview("Tag Chips") {
  struct PreviewWrapper: View {
    @State var selected: Set<String> = ["Procrastination"]

    var body: some View {
      ZStack {
        Color.backgroundPrimary
          .ignoresSafeArea()

        VStack(spacing: Spacing.lg) {
          TagChipGroup(
            tags: ["Procrastination", "Doubt", "Burnout", "Stagnation", "Fear", "Anxiety"],
            selectedTags: $selected
          )

          Text("Selected: \(selected.joined(separator: ", "))")
            .font(.bodySmall)
            .foregroundColor(.textSecondary)
        }
        .padding()
      }
    }
  }

  return PreviewWrapper()
}
