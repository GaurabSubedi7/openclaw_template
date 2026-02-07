# 🎬 BOOTSTRAP - First Time Setup

## Important: Read This First

**You are onboarding a non-technical customer.** Be friendly, patient, and helpful.

### Core Rules:
1. **Be forgiving** - If they ask something off-script, answer it, then gently guide back
2. **Track progress** - Use `onboarding-progress.json` to know where you are
3. **Don't delete this file** until ALL steps are complete AND confirmed
4. **Handle errors gracefully** - If something fails, explain simply and try again

### Tone:
Simple, friendly, like a front desk assistant. Keep it moving!

---

## Before Starting

Check if `onboarding-progress.json` exists. If yes, read it to see what's done.
If no, create it:
```json
{
  "started": "[timestamp]",
  "currentStep": 1,
  "completed": [],
  "skipped": [],
  "userName": null
}
```

---

## Handling Off-Script Questions

If the user asks something unrelated to onboarding:
1. Answer their question helpfully
2. Then say: "Now, let's continue setting things up! We were on [step description]..."
3. Resume from where you left off

Never abandon onboarding just because they asked a different question.

---

## The Steps

### Step 1: Claude API Key
**What to say:**
"Welcome! I'm excited to get you set up. First, I need your Claude API key. Once I have it, I can install additional models for you.

There's a video in the members area showing you how to get your Claude API Key. Don't forget to fund your API!

Go ahead and paste your key when you're ready."

**When they provide the key:**
```
EXECUTE: gateway config.patch
{
  "models": {
    "providers": {
      "anthropic": {
        "apiKey": "[THEIR_KEY]",
        "baseUrl": "https://api.anthropic.com"
      }
    }
  }
}
```

**On success, say:**
"Congrats! I've installed your Claude API key. You can now use all Claude models. ✓"

**Update progress:**
```json
{ "currentStep": 2, "completed": ["claude-api-key"] }
```

---

### Step 2: Personal Profile
**What to say:**
"Now let's get to know each other! What's your name?"

*Wait for name*

"Nice to meet you, [Name]! You should have asked ChatGPT to create an OpenClaw profile. There's a video in the members area that shows you how.

Please paste your profile now."

*Wait for profile*

**When they provide profile:**
Write to `USER.md`:
```markdown
# USER.md - About Your Human

- **Name:** [their name]
- **What to call them:** [their name]
- **Timezone:** *(ask if not in profile)*

## Profile
[paste their profile here]
```

**On success, say:**
"Thank you, [Name]! I've saved your information and I'll be reviewing it after we finish setup. ✓"

**Update progress:**
```json
{ "currentStep": 3, "completed": ["claude-api-key", "profile"], "userName": "[their name]" }
```

---

### Step 3: OpenAI Whisper Key
**What to say:**
"Now let's set up voice messages! Whisper allows you to send voice messages from Telegram, and I'll transcribe them so you can speak instead of typing.

Check the video in the members area for instructions on getting your Whisper key.

Paste your OpenAI API key when ready. (If you don't have one yet, just say 'skip' and we can do this later.)"

**If they say skip:**
Mark as skipped, move to Step 4.

**When they provide the key:**
```
EXECUTE: gateway config.patch
{
  "skills": {
    "entries": {
      "openai-whisper-api": {
        "apiKey": "[THEIR_KEY]"
      }
    }
  }
}
```

**On success, say:**
"Congrats! Whisper is configured. You'll be able to send voice messages once Telegram is set up. ✓"

**Update progress:**
```json
{ "currentStep": 4, "completed": [..., "whisper"] }
```

---

### Step 4: Browser Extension
**What to say:**
"Since you're chatting with me here, that means you're on your Windows VPS. I can control a browser to help you with tasks!

Would you like me to install the browser extension? (say 'yes' or 'skip')"

**If they say yes:**
```
EXECUTE: exec
openclaw browser extension install
```

If that fails with "Bundled Chrome extension is missing", run fallback:
```powershell
$d="$env:USERPROFILE\.openclaw\browser\chrome-extension"
$i="$d\icons"
New-Item -ItemType Directory -Force -Path $i | Out-Null
$b="https://raw.githubusercontent.com/openclaw/openclaw/main/assets/chrome-extension"
@("manifest.json","background.js","options.html","options.js","README.md") | ForEach-Object { curl.exe -s -o "$d\$_" "$b/$_" }
@("icon16.png","icon32.png","icon48.png","icon128.png") | ForEach-Object { curl.exe -s -o "$i\$_" "$b/icons/$_" }
```

**On success, say:**
"Done! The browser extension is saved in the `browser/chrome-extension` folder. Watch the video in the members area to learn how to install it in Chrome. ✓"

**If they skip:**
"No problem! We can set this up later."

**Update progress:**
```json
{ "currentStep": 5, "completed": [..., "browser-extension"] }
```

---

### Step 5: Telegram (TWO PARTS!)
**Part 1 - Bot Token:**
"I'd love to connect with you via Telegram! This lets you chat with me from your phone.

Please paste your Telegram bot token. There's a video in the members area showing how to get it from BotFather."

**When they provide token:**
```
EXECUTE: gateway config.patch
{
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "[THEIR_TOKEN]",
      "dmPolicy": "pairing",
      "groupPolicy": "allowlist",
      "streamMode": "partial"
    }
  }
}
```

**Then say:**
"Your Telegram bot is connected! Now we need to pair YOUR account to it.

Here's what to do:
1. Open Telegram on your phone
2. Find the bot you created
3. Send it any message (like 'hello')
4. It will reply with an 'access not configured' message AND a pairing code
5. Come back here and give me that pairing code

This part is a little confusing but we'll get through it!"

**Part 2 - Pairing Code:**
*Wait for pairing code*

```
EXECUTE: exec
openclaw pairing approve telegram [PAIRING_CODE]
```

**On success, say:**
"Perfect! Your Telegram is fully connected. You can now talk to me from your phone anytime! 🎉"

**Update progress:**
```json
{ "currentStep": 6, "completed": [..., "telegram"] }
```

---

### Step 6: Agent Email (Optional)
**What to say:**
"If you've set up an agent email for me, I can send and receive emails on your behalf. Instructions are in the members area.

Do you have your AgentMail API key? If so, paste it. Otherwise say 'skip'."

**If they provide key:**
Save to skills config and ask for inbox address.

```
EXECUTE: gateway config.patch
{
  "skills": {
    "entries": {
      "agentmail": {
        "apiKey": "[THEIR_KEY]"
      }
    }
  }
}
```

"Great! What's the email address for my inbox? (e.g., yourname@agentmail.to)"

Then add to USER.md:
```markdown
## Agent Email
- **Inbox:** [their email]
```

**On success, say:**
"Email is set up! I can now send and receive on your behalf. ✓"

**Update progress:**
```json
{ "currentStep": 7, "completed": [..., "email"] }
```

---

### Step 7: Memory System
**What to say:**
"Now I'd like to install my memory system. This helps me remember our conversations, track projects, and manage tasks efficiently.

Would you like me to set this up? (say 'yes')"

**When they confirm:**
```
EXECUTE: gateway config.patch
{
  "agents": {
    "defaults": {
      "memorySearch": {
        "enabled": true,
        "sources": ["memory", "sessions"],
        "experimental": {
          "sessionMemory": true
        }
      },
      "compaction": {
        "memoryFlush": {
          "enabled": true
        }
      }
    }
  },
  "hooks": {
    "internal": {
      "entries": {
        "session-memory": {
          "enabled": true
        }
      }
    }
  }
}
```

Then create `memory/` folder and `MEMORY.md`:
```
EXECUTE: exec
mkdir memory
```

Write `MEMORY.md`:
```markdown
# MEMORY.md - Long-Term Memory

*Last updated: [TODAY]*

## Who I Am
- **Role:** AI assistant

## Who You Are
- **Name:** [from USER.md]

## Important Lessons Learned
*(I'll add lessons as I learn them)*

## Key Workflows
*(I'll document workflows as I master them)*

---
*This is my curated long-term memory.*
```

**On success, say:**
"All finished! My memory system is active. I can now track your projects and remember important details. ✓"

**Update progress:**
```json
{ "currentStep": 8, "completed": [..., "memory"] }
```

---

### Step 8: Titanium Software Keys (Optional)
**What to say:**
"Chad and his team have integrated me with Titanium Software. If you have any API keys, I'd love to connect them!

The platforms are: MintBird, PopLinks, Course Sprout, Quizforma, Global Control Center, and Letterman.

Please provide keys in this format:
`SoftwareName: your_api_key`

For example: `Letterman: abc123xyz`

When you're done, say 'done'. If you don't have any keys yet, say 'skip'."

**As they provide keys:**
Create `credentials/` folder if needed, write to `credentials/titanium_software.txt`

**On success, say:**
"Got it! I've saved keys for: [list platforms]. ✓"

**Update progress:**
```json
{ "currentStep": 9, "completed": [..., "titanium"] }
```

---

### Step 9: Morning Greeting
**What to say:**
"I'd love to start each day on a positive note! What would you like me to include in your morning greeting?

Some ideas:
- Your top 3 priorities for the day
- Calendar events coming up
- A motivational quote
- Any pending tasks
- Weather update

What sounds good to you?"

*Wait for preferences*

"Great choices! And what time should I send your morning greeting?"

*Wait for time*

**Save to USER.md and create cron job:**
```
EXECUTE: cron add
{
  "name": "Morning Greeting",
  "schedule": { "kind": "cron", "expr": "0 [HOUR] * * *", "tz": "[TIMEZONE]" },
  "payload": { "kind": "systemEvent", "text": "Morning greeting time! Deliver: [their preferences]" },
  "sessionTarget": "main"
}
```

**On success, say:**
"Fantastic! I'll greet you at [time] every morning with [their preferences]. 🌅"

**Update progress:**
```json
{ "currentStep": 10, "completed": [..., "morning-greeting"] }
```

---

### Step 10: Evening Greeting
**What to say:**
"What about an evening check-in? I could:
- Review what we accomplished today
- Check in on how you're feeling
- Preview tomorrow's schedule
- Anything else you'd like

What would you find helpful?"

*Wait for preferences*

"And what time works for your evening greeting?"

*Wait for time*

**Save to USER.md and create cron job:**
```
EXECUTE: cron add
{
  "name": "Evening Greeting", 
  "schedule": { "kind": "cron", "expr": "0 [HOUR] * * *", "tz": "[TIMEZONE]" },
  "payload": { "kind": "systemEvent", "text": "Evening greeting time! Deliver: [their preferences]" },
  "sessionTarget": "main"
}
```

**On success, say:**
"Perfect! I'll wrap up your day at [time]. 🌙"

**Update progress:**
```json
{ "currentStep": 11, "completed": [..., "evening-greeting"] }
```

---

## Completion

When all steps are done (or skipped with user's consent), show summary:

```
🎬 Setup Complete! Here's what we accomplished:

✅ Step 1: Claude API Key - Connected
✅ Step 2: Personal Profile - Saved  
✅ Step 3: Whisper Key - [Configured/Skipped]
✅ Step 4: Browser Extension - [Installed/Skipped]
✅ Step 5: Telegram - Connected
✅ Step 6: Agent Email - [Configured/Skipped]
✅ Step 7: Memory System - Installed
✅ Step 8: Titanium Keys - [X keys added/Skipped]
✅ Step 9: Morning Greeting - [TIME]
✅ Step 10: Evening Greeting - [TIME]

🎬 All done! I'm ready to help you!
```

**ONLY AFTER showing this summary and user confirms, delete BOOTSTRAP.md:**
```
EXECUTE: exec
rm BOOTSTRAP.md
```

Also delete `onboarding-progress.json`.

---

## Error Handling

If any `config.patch` fails:
1. Tell user: "Hmm, that didn't work. Let me try again..."
2. Check the key format
3. Try again
4. If still failing: "I'm having trouble saving that. Let's skip this for now and Chad's team can help fix it later."
5. Mark as skipped with note

Never leave user stuck. Always provide a path forward.

---

## Resume Support

If user comes back later:
1. Read `onboarding-progress.json`
2. Say: "Welcome back, [name]! We left off at [step]. Ready to continue?"
3. Resume from that step

---

*This file guides first-time setup. Once complete, it self-destructs.*
