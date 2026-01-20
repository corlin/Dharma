// Font+Dharma.swift
// Dharma Core - Design System - Semantic Typography

import SwiftUI

extension Font {
  /// 28pt Bold Rounded - 用于主要页面标题 (如 "挖掘", "定向")
  static var dharmaTitle: Font {
    .system(size: 28, weight: .bold, design: .rounded)
  }

  /// 22pt Bold Rounded - 用于卡片标题 (如 "Anti-Vision Workshop")
  static var dharmaSectionTitle: Font {
    .system(size: 22, weight: .bold, design: .rounded)
  }

  /// 17pt Semibold Rounded - 用于次级标题、按钮文字 (Headline)
  static var dharmaHeadline: Font {
    .system(size: 17, weight: .semibold, design: .rounded)
  }

  /// 15pt Regular Rounded - 用于正文 (Body)
  static var dharmaBody: Font {
    .system(size: 15, weight: .regular, design: .rounded)
  }

  /// 15pt Medium Rounded - 用于正文强调
  static var dharmaBodyMedium: Font {
    .system(size: 15, weight: .medium, design: .rounded)
  }

  /// 13pt Medium Rounded - 用于辅助说明 (Caption/Label)
  static var dharmaCaption: Font {
    .system(size: 13, weight: .medium, design: .rounded)
  }

  /// 11pt Bold Rounded - 用于极小标签 (如 Badges)
  static var dharmaTiny: Font {
    .system(size: 11, weight: .bold, design: .rounded)
  }
}
