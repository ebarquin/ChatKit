# ChatKit

**ChatKit** is a lightweight SwiftUI chat UI SDK designed to act as a **pure rendering client** for LLM-based conversations.

It does **not** perform networking, inference, or prompt management.  
You bring the messages — **ChatKit renders them**.

---

## ✨ Features

- SwiftUI-native chat UI
- User / assistant / system message rendering
- Quick prompts bar
- Configurable appearance & layout
- Explicit conversation phases (`ready`, `awaitingAssistant`, `error`)
- Example app included
- No assumptions about LLMs or networking

---

## 🚫 What ChatKit is NOT

- ❌ Not an LLM client
- ❌ Not a networking layer
- ❌ Not a conversation manager
- ❌ Not opinionated about prompts or responses

ChatKit **only renders what you give it**.

---

## 📦 Installation (Swift Package Manager)

```swift
.package(
    url: "https://github.com/ebarquin/ChatKit.git",
    from: "0.1.0"
)
```

---

## 🧠 Core Concepts

### ChatMessage

```swift
ChatMessage(
    role: .user | .assistant | .system,
    content: String,
    status: .completed
)
```

ChatKit does **not** infer roles.  
If you pass two assistant messages in a row, both will be rendered.

---

### ChatViewModel

You provide a callback that is triggered when the user sends a message:

```swift
let viewModel = ChatViewModel(
    initialMessages: [],
    quickPrompts: [...],
    onSend: { message in
        // Send message to your LLM here
    }
)
```

When your LLM responds:

```swift
viewModel.appendMessage(
    ChatMessage(
        role: .assistant,
        content: "Hello!",
        status: .completed
    )
)
```

---

## 🖼️ ChatView

```swift
ChatView(
    viewModel: viewModel,
    appearance: appearancePair,
    layout: .default,
    behavior: .default
)
```

---

## 🎨 Appearance & Theming

ChatKit supports **explicit light & dark configurations** using `ChatAppearancePair`.

```swift
let appearance = ChatAppearancePair(
    light: ChatAppearance(...),
    dark: ChatAppearance(...)
)
```

If you only provide one appearance, it will be used for both light and dark modes.

---

## ⏳ Conversation State

ChatKit exposes a `ChatPhase` enum:

- `ready`
- `awaitingAssistant`
- `error(String)`

You decide how and when these states transition.

---

## 🧪 Example App

The repository includes **ChatKitExample**, showcasing:

- Fake LLM responses
- Quick prompts
- Awaiting assistant UI
- Styling and layout configuration

The example is meant as a **reference and smoke test**, not as a production app.

---

## 📄 License

MIT

---

## 🚧 Status

This project is in **active development**.  
Public API stability is not guaranteed before `1.0.0`.
