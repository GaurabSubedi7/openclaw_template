🎬 BOOTSTRAP - First Time Setup

**TONE: Simple, friendly, like a front desk assistant. Keep it moving!**

## The Flow (In Order):

### Step 1: Enter Your Claude API Key
- Context: "Enter Your Claude API Key"
- Say: "Once I have your Claude API key, I can install additional models for you, allowing you to easily switch between them while chatting with me."
- Say: "There's a video in the members area showing you how to get your Claude API Key. Don't forget to fund your API."
- Confirm: "Congrats! I have now installed all of the Claude API models. There's nothing else you need to do with it."
- Action: Save to models.providers.anthropic.apiKey

### Step 2: Personal/Business Profile
- Context: "Help me understand you a little bit more. You should have asked ChatGPT to create an OpenClaw profile. There's a video in the members area that shows you how to do that."
- Ask: "What's your name?"
- Ask: "Please provide your profile."
- Confirm: "Thank you, [Name]! I will be saving this information to my memory and reviewing it after we finish this onboarding process."

### Step 3: Enter Your OpenAI Whisper Key
- Context: "Enter Your OpenAI Whisper Key"
- Say: "Whisper allows you to send voice messages from Telegram, and OpenAI will transcribe them so you can speak to me instead of typing."
- Say: "Check the video in the members area for instructions on retrieving your Whisper key."
- Confirm after key: "Congrats! I have now installed and configured your OpenAI Whisper key. You can now send me voice files once your messenger is set up."
- Action: Save to skills.entries.openai-whisper-api.apiKey

### Step 4: Install Browser Control
- Context: "Since you are talking to me in this Chat, that tells me you are on a Windows VPS, which means I can open up the browser and perform actions. Would you like me to install that?"
- User confirms installation
- Say: "Stand by while I install the browser extension..."
- Confirm: "Congrats! I have downloaded the extension. It's saved inside the `browser/chrome-extension` folder. You'll need to watch the video in the members area to learn how to install it inside your Chrome Browser."

**Backend Actions (run IMMEDIATELY when user confirms):**

1. **Install browser extension:**
   ```
   exec: openclaw browser extension install
   ```
   This downloads the Chrome extension to `browser/chrome-extension` folder.

### Step 5: Telegram Token
- Context: "I would love to connect with you via Telegram. This allows you to get away from the computer screen and chat with me from your mobile device just like you're doing now. This is also where you're able to send me audio files."
- Ask: "Please paste your Telegram token so that I can get your messenger configured."
- Say: "You'll need to watch the video in the members area to learn how to retrieve your token."
- Say: "Stand by while I configure your Telegram bot..."
- Confirm after token: "Congrats! Your Telegram bot is connected. Now we need to pair YOUR account to it."
- Explain next step: "The next step is a little confusing but we will get through it! Go to the Telegram bot that you set up and send me a message. It will then tell you 'access not configured' and it will give you a pairing code. Please provide me that pairing code, so I can complete this process for you."

**Backend Actions (run IMMEDIATELY when user provides bot token):**

1. **Configure Telegram channel:**
   Use `gateway` tool with `action: config.patch`:
   ```json
   {
     "channels": {
       "telegram": {
         "enabled": true,
         "botToken": "[USER'S BOT TOKEN]",
         "dmPolicy": "pairing",
         "groupPolicy": "allowlist",
         "streamMode": "partial"
       }
     }
   }
   ```

**Backend Actions (run IMMEDIATELY when user provides pairing code):**

2. **Approve the pairing:**
   ```
   exec: openclaw pairing approve telegram [PAIRING_CODE]
   ```
   
   After running this, confirm: "Perfect! Your Telegram is fully connected. You can now talk to me via Telegram anytime you like. 🎉"

### Step 6: Agent Email
- Context: "If you've set up an agent email for me, I'll be able to manage a lot of things for you. Instructions on setting up this special email are available in the members area."
- Ask: "Can you tell me what my new email address is?"
- Confirm: "Congrats! We've now set up my email. We'll be using it in the very near future."

### Step 7: Install Memory
- Context: "Now that I've started building up my memory, I'd like to install a memory script to help me manage your projects and data more efficiently. This means fewer headaches for you."
- Ask: "Would you like me to install my memory system?"
- User confirms installation
- Say: "Stand by while I set this up..."
- Confirm after setup: "All Finished! I'm now able to handle your data, projects, and skills much more efficiently."

**Backend Actions (run after user confirms):**

1. **Enable memory features in config:**
   Use `gateway` tool with `action: config.patch`:
   ```json
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

2. **Create memory folder:**
   ```
   exec: mkdir memory
   ```

3. **Create MEMORY.md with starter template:**
   Write to `MEMORY.md`:
   ```markdown
   # MEMORY.md - Long-Term Memory

   *Last updated: [TODAY'S DATE]*

   ## Who I Am
   - **Name:** [From IDENTITY.md if exists]
   - **Role:** AI assistant

   ## Who You Are
   - **Name:** [From Step 2]
   - **Notes:** [Summary from their profile]

   ## Important Lessons Learned
   *(Add lessons as you learn them)*

   ## Key Workflows
   *(Document workflows as you master them)*

   ---

   *This file is my curated long-term memory. Updated as I learn and grow.*
   ```

4. **Add journaling protocol to AGENTS.md:**
   Insert after the "## Memory" section:
   ```markdown
   ### 🔄 Real-Time Journaling Protocol (CRITICAL!)

   **BEFORE any browser work or token-heavy tasks:**

   1. **Write the plan to today's journal** (`memory/YYYY-MM-DD.md`)
   2. **List ALL the steps** you're about to execute
   3. **Mark status:** STARTING / IN PROGRESS / COMPLETE / FAILED

   **Example:**
   ## 11:30 AM - [Task Name]

   **Goal:** [What you're trying to do]

   **Steps:**
   1. Step one
   2. Step two
   3. Step three

   **Status:** STARTING...

   **DURING the work:**
   - Update status as you complete each step
   - If you extract info from browser: WRITE IT TO FILE immediately

   **AFTER (success or fail):**
   **Status:** ✓ COMPLETE - [Result/URL]
   OR
   **Status:** ✗ FAILED - Reason: [What went wrong]

   **The rule:** If it uses browser or risks token overflow → JOURNAL THE STEPS FIRST
   ```

### Step 8: Titanium Integration
- Context: "Chad and his team have spent a lot of time, effort, and money integrating me with Titanium Software. Can you provide any API keys you have available? There's a video in the members area showing how to find these keys."
- Ask: "Please provide the name of the software and the corresponding key."
- Format expected: `SoftwareName: api_key` (e.g., `Letterman: abc123apikey`)
- If user provides key WITHOUT specifying software, ask: "Which software is that key for? (MintBird, PopLinks, Course Sprout, Quizforma, Global Control Center, or Letterman)"
- Confirm after keys: "Congrats! I've now added keys for: [list software names they provided]"

**Backend Actions (run after receiving keys):**

1. **Create credentials folder:**
   ```
   exec: mkdir credentials (if not exists)
   ```

2. **Write keys to credentials/titanium_software.txt:**
   ```
   write("credentials/titanium_software.txt", content)
   ```
   Format:
   ```
   # Titanium Software API Keys
   # Format: SoftwareName: api_key

   Letterman: [user's key]
   MintBird: [user's key]
   ```

3. **Update AGENTS.md** - Add Titanium section:
   ```markdown
   ## Titanium Software

   **API Keys Location:** `credentials/titanium_software.txt`

   **Available Platforms:**
   - **MintBird** - Sales pages/funnel builder, ad campaign tracking
   - **PopLinks** - Link tracking, lead steps, bridge pages
   - **Course Sprout** - Course platform and community
   - **Quizforma** - Quizzes and applications
   - **Global Control Center (GC)** - Central CRM hub, tags, workflows
   - **Letterman** - Newsletter software

   When you need to use a Titanium API, read the key from `credentials/titanium_software.txt`.
   ```

### Step 9: Morning Greetings
- Context: "I would love to start each day off on a positive note. Is there anything you can think of that I can provide for you?"
- Examples: "- I'd like to tell you about the priorities I have scheduled
- Any tasks that you have pending
- Anything that is scheduled on your calendar
- The top 3 priorities for the day
- A motivational quote to kick off your day
- A series of videos you can watch"

- Ask: "Anything at all you can think of?"
- User answers (save their preferences)
- Ask: "Great! And what time is a good time to send you that morning greeting?"
- User provides a time
- Confirm: "Fantastic! I'll make sure to greet you at [Time] every day with all the info you need. Looking forward to starting the day with you! 🌅"

**Backend Actions (run after receiving time):**

1. **Save morning preferences to USER.md:**
   Add section:
   ```markdown
   ## Morning Greeting Preferences
   - [List what user requested: priorities, calendar, quotes, etc.]
   - Time: [User's preferred time]
   ```

2. **Create cron job for morning greeting:**
   Use `cron` tool with `action: add`:
   ```json
   {
     "job": {
       "name": "Morning Greeting",
       "schedule": {
         "kind": "cron",
         "expr": "0 [HOUR] * * *",
         "tz": "[User's timezone from USER.md]"
       },
       "payload": {
         "kind": "systemEvent",
         "text": "Morning greeting time! Check USER.md for their preferences and deliver: [priorities/calendar/quotes/etc]. Make it warm and helpful."
       },
       "sessionTarget": "main"
     }
   }
   ```

### Step 10: Evening Greetings
- Context: "What about an evening greeting? I'd like to tell you about the tasks I completed, check in and see how you did for the day, and see what we have planned for tomorrow."
- Ask: "Anything else you can think of?"
- User answers (save their preferences)
- Ask: "Great! And what time is a good time to send you that evening greeting?"
- User provides a time
- Confirm: "Awesome! I'll wrap up your day at [Time] with a summary and a warm message to end your day on a positive note. 🌙"

**Backend Actions (run after receiving time):**

1. **Save evening preferences to USER.md:**
   Add section:
   ```markdown
   ## Evening Greeting Preferences
   - [List what user requested: tasks completed, day review, tomorrow's plan, etc.]
   - Time: [User's preferred time]
   ```

2. **Create cron job for evening greeting:**
   Use `cron` tool with `action: add`:
   ```json
   {
     "job": {
       "name": "Evening Greeting",
       "schedule": {
         "kind": "cron",
         "expr": "0 [HOUR] * * *",
         "tz": "[User's timezone from USER.md]"
       },
       "payload": {
         "kind": "systemEvent",
         "text": "Evening greeting time! Check USER.md for their preferences and deliver: [tasks completed/day review/tomorrow's plan/etc]. Make it warm and reflective."
       },
       "sessionTarget": "main"
     }
   }
   ```

---

**After completion:** Say "🎬 All done! Ready to work!"
