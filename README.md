# ChatKit
[![Swift Package Manager](https://img.shields.io/badge/SPM-supported-green.svg)](https://github.com/ebarquin/ChatKit)
[![GitHub license](https://img.shields.io/github/license/ebarquin/ChatKit)](https://github.com/ebarquin/ChatKit/blob/main/LICENSE)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey)]()

ChatKit is a lightweight, UI-focused SwiftUI SDK for building chat interfaces in iOS apps.

It is intentionally **LLM-agnostic**: ChatKit does not perform networking, streaming, or model inference.
You control how messages are produced; ChatKit only renders what you give it.

---

## ✨ Features

- SwiftUI-first, modern architecture
- Fully customizable appearance and layout
- Decoupled from LLMs and backends
- Quick prompts support
- Awaiting / loading states
- Example app included

---

## 🚀 Quick Start

### 1. Add ChatKit via Swift Package Manager

In Xcode:

**File → Add Packages…**  
Paste the repository URL:

```
https://github.com/ebarquin/ChatKit
```

---

### 2. Create a `ChatViewModel`

ChatKit does **not** perform any network or LLM logic.  
You are responsible for sending messages to your backend or model and feeding responses back into the SDK.

```swift
import ChatKit

let viewModel = ChatViewModel(
    initialMessages: [],
    quickPrompts: [
        QuickPrompt(title: "Explain this"),
        QuickPrompt(title: "Summarize"),
        QuickPrompt(title: "Give an example")
    ],
    onSend: { message in
        // Called when the user sends a message.
        // Forward `message` to your LLM or backend here.
    }
)
```

---

### 3. Render the chat UI

```swift
ChatView(
    viewModel: viewModel,
    appearance: .default,
    layout: .default,
    behavior: .default
)
```

---

### 4. Append assistant responses

When your LLM or backend responds, simply inject messages back into the view model:

```swift
viewModel.appendMessage(
    ChatMessage(
        role: .assistant,
        content: "Here is the response from the assistant.",
        status: .completed
    )
)
```

ChatKit will automatically update the UI.

---

### 5. Handle loading and error states (optional)

```swift
viewModel.setAwaitingAssistant()

// On error:
viewModel.setError("Something went wrong")

// To reset:
viewModel.resetError()
```

---

## 🧠 Design Philosophy

- ChatKit is a **rendering client**, not a chat engine.
- It does not care how many assistant messages you send.
- It does not enforce request/response symmetry.
- If you send two assistant messages in a row, both are rendered.

This makes ChatKit suitable for:
- LLM-based apps
- Rule-based assistants
- Customer support chats
- Educational tools

---

## 📦 Repository Structure

```
ChatKit/
├── ChatKit/           # Swift Package
├── ChatKitExample/    # Example iOS app
└── ChatKit.xcworkspace
```

---

## 🛣 Roadmap

- Streaming / typing effects
- More built-in appearance presets
- Message attachments
- Accessibility refinements

---

## 🚧 Status

This project is in active development.
Public API stability is not guaranteed before 1.0.0.

---

## 📄 License

MIT
