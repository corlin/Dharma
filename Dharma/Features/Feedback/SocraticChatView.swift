// SocraticChatView.swift
// Dharma Features - Feedback Layer
// A chat interface for Socratic Questioning

import SwiftUI

struct SocraticChatView: View {
  @Environment(\.dismiss) private var dismiss

  struct UIMessage: Identifiable {
    let id = UUID()
    let role: ChatMessage.Role
    let content: String
    
    var asChatMessage: ChatMessage {
      ChatMessage(role: role, content: content)
    }
  }

  @State private var messages: [UIMessage] = []
  @State private var newMessage = ""
  @State private var isTyping = false
  @State private var generator = SocraticQuestionGenerator()

  // Mock context for MVP
  // In real app, this comes from User/Task models
  let context = SocraticQuestionGenerator.Context(
    saidGoals: ["Upload 3 YouTube videos"],
    actualBehaviors: ["Watched 12 hours of Netflix", "Researched camera gear for 4 hours"],
    recentReflections: ["I feel overwhelmed by perfectionism"],
    currentChallenge: "Procrastination"
  )

  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        // Chat History
        ScrollViewReader { proxy in
          ScrollView {
            VStack(spacing: Spacing.md) {
              ForEach(messages) { msg in
                ChatBubble(message: msg)
              }

              if isTyping {
                HStack {
                  TypingIndicator()
                  Spacer()
                }
                .padding(.horizontal)
              }
            }
            .padding()
          }
          .onChange(of: messages.count) {
             if let lastId = messages.last?.id {
               withAnimation {
                 proxy.scrollTo(lastId, anchor: .bottom)
               }
             }
          }
        }

        // Input Area
        HStack(spacing: Spacing.sm) {
          TextField("Reflect here...", text: $newMessage)
            .textFieldStyle(.plain)
            .padding(Spacing.sm)
            .background(Color.backgroundTertiary)
            .clipShape(RoundedRectangle(cornerRadius: 20))

          Button {
            sendMessage()
          } label: {
            Image(systemName: "arrow.up.circle.fill")
              .font(.title2)
              .foregroundColor(.feedback)
          }
          .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        .background(Color.white)
      }
      .navigationTitle("Orb Coach")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Close") { dismiss() }
        }
      }
      .onAppear {
        startSession()
      }
    }
  }

  private func startSession() {
    isTyping = true
    Task {
      // Small delay for natural feel
      try? await Task.sleep(nanoseconds: 1_000_000_000)

      do {
        let question = try await generator.generateQuestion(context: context)
        let msg = UIMessage(role: .assistant, content: question)

        await MainActor.run {
          messages.append(msg)
          isTyping = false
        }
      } catch {
        await MainActor.run {
          messages.append(
            UIMessage(
              role: .assistant,
              content:
                "I'm having trouble connecting to my thought process. Let's try reflecting manually."
            ))
          isTyping = false
        }
      }
    }
  }

  private func sendMessage() {
    let text = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !text.isEmpty else { return }

    let userMsg = UIMessage(role: .user, content: text)
    messages.append(userMsg)
    newMessage = ""
    isTyping = true

    Task {
      // Simulate thinking / turn-taking
      // In a real implementation, we would send the history to the LLM here
      // For this MVP step, we'll just trigger another question or acknowledgement
      try? await Task.sleep(nanoseconds: 1_500_000_000)

      let followUp = "Interesting. And what do you think is the root cause of that?"

      await MainActor.run {
        let aiMsg = UIMessage(role: .assistant, content: followUp)
        messages.append(aiMsg)
        isTyping = false
      }
    }
  }
}

// Helper Views
struct ChatBubble: View {
  let message: SocraticChatView.UIMessage
  var isUser: Bool { message.role == .user }

  var body: some View {
    HStack(alignment: .bottom, spacing: 8) {
      if !isUser {
        Circle()
          .fill(Color.feedback)
          .frame(width: 32, height: 32)
          .overlay(Image(systemName: "sparkles").foregroundColor(.white).font(.caption))
      } else {
        Spacer()
      }

      Text(message.content)
        .padding(12)
        .background(isUser ? Color.feedback : Color.backgroundTertiary)
        .foregroundColor(isUser ? .white : .textPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      // Add specific corner radius modifications if needed

      if isUser {
        // User Avatar or Spacer
      } else {
        Spacer()
      }
    }
  }
}

