//
//  ContentView.swift
//  Dharma
//
//  Created by 陈永林 on 19/01/2026.
//

import SwiftData
import SwiftUI

struct ContentView: View {
  @State private var selectedTab: Tab = .excavate

  enum Tab {
    case excavate
    case orient
    case execute
    case feedback
    case evolve
  }

  var body: some View {
    TabView(selection: $selectedTab) {
      ExcavateHomeView()
        .tabItem {
          Label("Excavate", systemImage: "magnifyingglass")
        }
        .tag(Tab.excavate)

      OrientHomeView()
        .tabItem {
          Label("Orient", systemImage: "safari")
        }
        .tag(Tab.orient)

      ExecuteHomeView()
        .tabItem {
          Label("Execute", systemImage: "bolt.fill")
        }
        .tag(Tab.execute)

      FeedbackHomeView()
        .tabItem {
          Label("Feedback", systemImage: "chart.bar.fill")
        }
        .tag(Tab.feedback)

      EvolveHomeView()
        .tabItem {
          Label("Evolve", systemImage: "leaf.fill")
        }
        .tag(Tab.evolve)
    }
    .tint(Color.brand)  // Using brand color for active tab
  }
}

#Preview {
  ContentView()
    .modelContainer(
      for: [
        UserModel.self,
        DailyLeverModel.self,
        AntiVisionModel.self,
      ], inMemory: true)
}
