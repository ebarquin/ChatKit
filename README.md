# ChatKit
[![Swift Package Manager](https://img.shields.io/badge/SPM-supported-green.svg)](https://github.com/ebarquin/ChatKit)
[![GitHub license](https://img.shields.io/github/license/ebarquin/ChatKit)](https://github.com/ebarquin/ChatKit/blob/main/LICENSE)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS-lightgrey)]()

ChatKit is a lightweight SwiftUI chat UI framework focused exclusively on rendering messages.

It is intentionally **LLM-agnostic**:
- It does not talk to language models
- It does not perform networking
- It does not manage conversational logic

ChatKit renders whatever messages you provide, in the order you provide them.

---

## ✨ Features

- Pure SwiftUI chat UI
- Fully decoupled from LLMs and backends
- Predictable, message-driven rendering
- Customizable appearance, layout, and behavior
- Explicit awaiting / loading states

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
    quickPrompts: [],
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

## 🧠 Design Philosophy

ChatKit is a rendering client, not a chat engine.

- It does not enforce user/assistant alternation
- It does not assume request/response symmetry
- It does not manage retries, streaming, or tool calls

If you send two assistant messages in a row, both will be rendered.
If you inject system messages mid‑conversation, they will appear in place.

All conversational rules live outside ChatKit.

---

## 📦 Repository Structure

```
ChatKit/
├── ChatKit/           # Swift Package
├── ChatKitExample/    # Example iOS app
└── ChatKit.xcworkspace
```

---

## 🛣 Scope

ChatKit 1.0 focuses on API stability and architectural clarity.

The following are intentionally out of scope:
- Streaming helpers
- Multi‑turn orchestration
- Agent abstractions
- Networking or LLM clients

---

## 🚧 Status

ChatKit 1.0 provides a stable public API focused on rendering and composition.

Future versions may explore additional helpers, but the core rendering model is expected to remain stable.

---

## 📄 License

MIT
