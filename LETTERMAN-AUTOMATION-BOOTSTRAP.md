# 🚀 LETTERMAN AUTOMATION BOOTSTRAP

## How to Use This

Give this file to your OpenClaw and say:
> "Read LETTERMAN-AUTOMATION-BOOTSTRAP.md and guide me through setting up article automation."

Your AI will walk you through each step, ask the right questions, and set everything up for you.

---

## For the AI: Instructions

**You are guiding a user through setting up Letterman article automation.**

### Core Rules:
1. **Be friendly and patient** — they may not be technical
2. **Track progress** — use `letterman-automation-progress.json` to know where you are
3. **Be flexible** — if they ask something off-script, answer it, then guide back
4. **Don't skip steps** — each step builds on the previous
5. **Confirm success** — show them what you did after each step
6. **Create the skill first** — before anything else, install the Letterman skill

### ⚠️ IMPORTANT: This is a GUIDE, Not a Prison!

Users can:
- Ask random questions anytime
- Take breaks and come back later
- Go completely off-topic
- Change their mind about settings

**Always be helpful FIRST.** Answer whatever they ask, even if it has nothing to do with Letterman. Then gently offer to continue:

> "Great question! [answer their question]. Whenever you're ready, we can continue setting up your automation — we were on [step]."

**Never say things like:**
- "Let's stay focused on the setup"
- "We can talk about that after"
- "That's not related to what we're doing"

**This is their AI assistant, not a rigid wizard.** The setup guide is here to help, not to restrict.

### Progress Tracker

Check if `letterman-automation-progress.json` exists. If yes, read it to resume.
If no, create it:
```json
{
  "started": "[timestamp]",
  "currentStep": 0,
  "completed": [],
  "skipped": [],
  "publications": [],
  "cronJobs": []
}
```

### Handling Off-Script Questions

If the user asks something unrelated:
1. Answer their question helpfully
2. Then say: "Now, let's continue setting up! We were on [step description]..."
3. Resume from where you left off

---

## Step 0: Install the Letterman Skill

**IMPORTANT: Do this FIRST before anything else!**

**Say:**
> "👋 **Welcome! Let's set up your Letterman article automation!**
>
> First, I need to install the Letterman skill so I know how to work with the platform. Give me one moment..."

**Create the skill folder structure:**
```
skills/
  letterman/
    SKILL.md
    references/
      api.md
```

**Create `skills/letterman/SKILL.md` with this content:**

```markdown
---
name: letterman
description: Letterman newsletter platform API for managing publications, articles, and AI-generated content. Use when asked to create articles, manage publications, update SEO settings, check URL availability, or generate article content from URLs/text.
---

# Letterman Skill

Letterman is a newsletter/article management platform with AI content generation.

## Credentials

**Check in this order:**

1. **Gateway config** (for distributed installs):
   ```
   skills.entries.letterman.apiKey
   ```

2. **Credentials file** (for workspace setups):
   ```
   credentials/letterman-api-key.txt
   ```

3. **Ask user** if neither exists

**API Setup:**
- **Header:** `Authorization: Bearer {jwt_token}`
- **Base URL:** `https://api.letterman.ai/api`

## Quick Actions

| Action | Endpoint | Method |
|--------|----------|--------|
| Get current user | `/user` | GET |
| List publications | `/newsletters-storage` | GET |
| List articles | `/newsletters-storage/{pubId}/newsletters?state=DRAFT&type=ARTICLE` | GET |
| Create article | `/newsletters` | POST |
| Get article | `/newsletters/:id` | GET |
| Update SEO | `/newsletters/update-seo-settings/:id` | POST |
| Update summary | `/newsletters/update-article-summary/:id` | POST |
| Check URL path | `/newsletters/check-url-path` | POST |

## Common Workflows

### ⚠️ BEFORE CREATING ANY ARTICLE — ASK USER:
1. **AI-generated** — Use Letterman's OpenAI (costs tokens)
2. **Blank** — Empty article, user writes content (no tokens)

### Create BLANK Article (No AI)

```json
POST /newsletters
{
  "storageId": "{publication_id}",
  "type": "ARTICLE",
  "title": "Article Title Here"
}
```

No `articleOptions` needed. Creates empty draft article.

### Create AI Article from URL

```json
POST /newsletters
{
  "storageId": "{publication_id}",
  "type": "ARTICLE",
  "articleOptions": {
    "contentFrom": "URL",
    "url": "https://source-article.com/article",
    "wordsCount": 500,
    "keywords": "topic1,topic2",
    "aiModel": "OPEN_AI"
  }
}
```

### Create Article from Content

```json
POST /newsletters
{
  "storageId": "{publication_id}",
  "type": "ARTICLE",
  "articleOptions": {
    "contentFrom": "CONTENT",
    "content": "Your source text here...",
    "wordsCount": 300,
    "keywords": "keyword1,keyword2",
    "imageUrl": "https://example.com/image.jpg",
    "aiModel": "OPEN_AI"
  }
}
```

### Update Article Content (After Creation)

```json
POST /newsletters/update-article-summary/:id
{
  "summary": {
    "title": "Article Title",
    "description": "Article description",
    "content": "<p>HTML content here...</p>"
  }
}
```

### Update SEO Settings

```json
POST /newsletters/update-seo-settings/:id
{
  "urlPath": "my-article-slug",
  "title": "SEO Title",
  "description": "Meta description",
  "noIndex": false
}
```

## Article States

- `DRAFT` — Not published (default for new articles)
- `PUBLISHED` — Live on the site
- `ARCHIVED` — Hidden from public

## AI Models Available

- `OPEN_AI` — OpenAI GPT models (most common)
- `GOOGLE_GEN_AI` — Google's AI
- `GROK` — xAI's Grok
- `CLAUDE` — Anthropic's Claude

(Available models depend on user's account tier)

## Safety Rules

- **ALWAYS create articles as DRAFT** — never auto-publish
- **Read operations** — safe to run anytime
- **Create article** — safe, creates as draft
- **Publish/Delete** — ALWAYS confirm with user first

## Full API Reference

→ See [references/api.md](references/api.md)
```

**Create `skills/letterman/references/api.md` with this content:**

```markdown
# Letterman API Reference

**Base URL:** `https://api.letterman.ai/api`  
**Auth:** `Authorization: Bearer {jwt_token}`

---

## User

### Get Current User
```
GET /user
```
Returns authenticated user info including name, email, and available AI models.

**Response:**
```json
{
  "user": {
    "id": "user_id",
    "name": "User Name",
    "email": "user@example.com",
    "accessLevel": "PLATINUM",
    "hasGptApiKey": true
  },
  "availableAIModels": ["OPEN_AI", "CLAUDE", "GROK"]
}
```

---

## Publications

### List Publications
```
GET /newsletters-storage
```
Returns all publications (newsletter containers) for the user.

**Response:** Array of publication objects with:
- `_id` — Publication ID (use this for creating articles)
- `name` — Publication name
- `description` — Publication description
- `type` — "LOCAL" or "NICHE"
- `term` — Search term/location
- `articleCount` — Count of articles by state

---

## Articles

### List Articles
```
GET /newsletters-storage/{storageId}/newsletters?state=DRAFT&type=ARTICLE
```

**Query Parameters:**
| Parameter | Type | Values |
|-----------|------|--------|
| `state` | string | `DRAFT`, `PUBLISHED`, `ARCHIVED` |
| `type` | string | `ARTICLE`, `NEWSLETTER` |
| `limit` | number | Max results to return |

### Create Article (AI-Generated)
```
POST /newsletters
```

**Request Body:**
```json
{
  "storageId": "publication_id",
  "type": "ARTICLE",
  "articleOptions": {
    "contentFrom": "URL",
    "url": "https://source-article.com",
    "wordsCount": 500,
    "keywords": "keyword1,keyword2",
    "aiModel": "OPEN_AI"
  }
}
```

**contentFrom options:**
- `"URL"` — AI reads the URL and writes article based on it
- `"CONTENT"` — AI uses provided text to write article

### Create Article (Blank)
```
POST /newsletters
```

**Request Body:**
```json
{
  "storageId": "publication_id",
  "type": "ARTICLE",
  "title": "My Article Title"
}
```

Creates empty draft article (no AI, no tokens used).

### Get Article
```
GET /newsletters/:id
```

### Update Article Summary/Content
```
POST /newsletters/update-article-summary/:id
```

**Request Body:**
```json
{
  "summary": {
    "title": "Article Title",
    "description": "Short description",
    "imageUrl": "https://example.com/image.jpg",
    "content": "<p>Full HTML content...</p>"
  }
}
```

### Update SEO Settings
```
POST /newsletters/update-seo-settings/:id
```

**Request Body:**
```json
{
  "urlPath": "article-url-slug",
  "title": "SEO Title",
  "description": "Meta description",
  "noIndex": false
}
```

### Check URL Availability
```
POST /newsletters/check-url-path
```

**Request Body:**
```json
{
  "urlPath": "desired-slug",
  "newsletterId": "article_id"
}
```

---

## Making API Calls (PowerShell Example)

```powershell
$headers = @{
    "Authorization" = "Bearer YOUR_API_KEY_HERE"
    "Content-Type" = "application/json"
}

# Get user info
Invoke-RestMethod -Uri "https://api.letterman.ai/api/user" -Headers $headers

# List publications
Invoke-RestMethod -Uri "https://api.letterman.ai/api/newsletters-storage" -Headers $headers

# Create blank article
$body = @{
    storageId = "publication_id_here"
    type = "ARTICLE"
    title = "My Article Title"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://api.letterman.ai/api/newsletters" -Method POST -Headers $headers -Body $body
```

---

## Error Codes

| Code | Meaning | Solution |
|------|---------|----------|
| 401 | Unauthorized | Check API key is valid |
| 404 | Not found | Check resource ID exists |
| 422 | Validation error | Check required fields |
| 500 | Server error | Try again or contact support |
```

**After creating both files, say:**
> "✅ **Letterman skill installed!** I now know how to:
> - Connect to your Letterman account
> - List your publications
> - Create articles (AI-generated or blank)
> - Update SEO settings
> - And more!
>
> Now let's connect your account..."

**Update progress:**
```json
{ "currentStep": 1, "completed": ["skill-installed"] }
```

---

## Step 1: Letterman API Key

**Say:**
> "🔑 **I need your Letterman API key.**
>
> Here's how to get it:
> 1. Log into **app.letterman.ai**
> 2. Click the **gear icon** (Settings)
> 3. Click **API**
> 4. Copy your API key (starts with `eyJ...`)
>
> Paste it here when you're ready!"

**When they provide the key:**

1. Create credentials file:
```
credentials/letterman-api-key.txt
```

With content:
```
# Letterman API Key
# Added: [date]

Letterman: [their_key_here]
```

2. Test the key by calling the API:
```
GET https://api.letterman.ai/api/user
Authorization: Bearer [their_key]
```

**On success:**
> "✅ **Connected!** I can see your account:
> - **Name:** [name from response]
> - **Email:** [email from response]
> - **Access Level:** [accessLevel]
> - **AI Models Available:** [list models]"

**If it fails:**
> "Hmm, that didn't work. Make sure you copied the entire key — it should start with `eyJ` and be pretty long. Want to try again?"

**Update progress:**
```json
{ "currentStep": 2, "completed": ["skill-installed", "api-key"] }
```

---

## Step 2: List Publications

**Say:**
> "📰 **Let me pull up your publications...**"

**Execute:**
```
GET https://api.letterman.ai/api/newsletters-storage
```

**Show them a clean table:**
> "Here are your publications:
>
> | # | Name | Type | Focus | Articles |
> |---|------|------|-------|----------|
> | 1 | [name] | [LOCAL/NICHE] | [term] | [X] published |
> | 2 | [name] | [LOCAL/NICHE] | [term] | [X] published |
> ...
>
> **Which ones do you want to automate?** (Give me the numbers, like: 1, 3)"

**Save their selection:**
Store the selected publication IDs and names in progress:
```json
{
  "currentStep": 3,
  "completed": ["skill-installed", "api-key", "list-publications"],
  "publications": [
    {"id": "abc123", "name": "My Newsletter", "type": "LOCAL", "term": "Las Vegas"},
    {"id": "def456", "name": "Food Blog", "type": "NICHE", "term": "restaurants"}
  ]
}
```

---

## Step 3: Understand Each Publication

**For EACH selected publication, ask:**
> "📝 **Tell me about [Publication Name]**
>
> 1. **What kind of content?** (e.g., local news, restaurant reviews, pet adoption)
> 2. **Who reads it?** (e.g., Summerlin residents, Vegas foodies, dog lovers)
> 3. **Share a link to one of your articles** (optional, helps me match your style)
>
> Just describe it however you want!"

**When they answer:**
- Note the focus/audience
- If they share a URL, fetch it to understand the tone and format
- Summarize back what you learned

**After ALL publications:**
> "✅ **Got it! Here's what I understand:**
>
> - **[Pub 1]**: [focus] for [audience]
> - **[Pub 2]**: [focus] for [audience]
>
> Sound right?"

**Update progress:**
```json
{ "currentStep": 4, "completed": [..., "understand-publications"] }
```

---

## Step 4: Article Bank Schedule

**Say:**
> "📅 **Let's set up your Article Bank**
>
> Every week, I'll search the web for news stories that fit your publications and save them to a 'bank' — ready to become articles.
>
> **When should I search?** Most people do Monday mornings. For example:
> - Monday at 8 AM
>
> What day and time works for you?"

**When they answer:**

Create a cron job:
```json
{
  "name": "Article Bank Search",
  "schedule": { "kind": "cron", "expr": "[their schedule]", "tz": "[their timezone]" },
  "payload": {
    "kind": "systemEvent",
    "text": "ARTICLE BANK REFRESH - Search for fresh sources for: [list their publications with IDs and focus areas]. Save to content-bank/[date]/sources.md"
  },
  "sessionTarget": "main"
}
```

**On success:**
> "✅ **Article bank scheduled!**
>
> Every **[day]** at **[time]**, I'll find fresh stories for your publications."

**Update progress:**
```json
{ "currentStep": 5, "completed": [..., "bank-schedule"], "cronJobs": ["job-id"] }
```

---

## Step 5: Article Creation Schedule

**Say:**
> "✍️ **Now let's schedule article creation**
>
> I can automatically create draft articles from the bank. They'll stay as **drafts** until you review and publish.
>
> **Questions:**
> 1. **Which days?** (e.g., Monday, Wednesday, Friday)
> 2. **How many articles per day?** (1 per publication is typical)
> 3. **Preferred times?** (I'll vary them to look natural)
>
> What works for you?"

**When they answer:**

Create cron jobs for each day with varied times:
```json
{
  "name": "[Day] Article Creation",
  "schedule": { "kind": "cron", "expr": "[time on that day]", "tz": "[timezone]" },
  "payload": {
    "kind": "systemEvent",
    "text": "ARTICLE CREATION - Create 1 AI-generated draft article for each publication: [list publications with IDs]. Use sources from content-bank. Keep as DRAFT."
  },
  "sessionTarget": "main"
}
```

**On success:**
> "✅ **Article creation scheduled!**
>
> | Day | Time | Articles |
> |-----|------|----------|
> | [Mon] | [9:30 AM] | [X] drafts |
> | [Wed] | [1:45 PM] | [X] drafts |
> | [Fri] | [11:15 AM] | [X] drafts |
>
> **Remember:** All articles stay as drafts. You review and publish when ready!"

**Update progress:**
```json
{ "currentStep": 6, "completed": [..., "creation-schedule"], "cronJobs": [...] }
```

---

## Step 6: Summary Notification (Optional)

**Say:**
> "📊 **One more optional thing!**
>
> Want me to send you a quick summary after I build the bank? Something simple like:
>
> *'Added 12 sources to the bank — 5 for [Pub 1], 4 for [Pub 2]'*
>
> Want this? (yes/no) If yes, what time?"

**If yes:**
Create summary cron job

**If no/skip:**
> "No problem! You can always ask me 'show me the article bank' anytime."

**Update progress:**
```json
{ "currentStep": 7, "completed": [..., "summary"] }
```
or
```json
{ "skipped": ["summary"] }
```

---

## Step 7: Completion

**Show final summary:**
> "🎉 **You're all set!**
>
> **Your Schedule:**
> | What | When |
> |------|------|
> | Search for sources | [Day] at [Time] |
> | Create articles | [Days] at [Times] |
> | Summary | [Day] at [Time] or skipped |
>
> **Publications automated:**
> - [Pub 1] — [focus]
> - [Pub 2] — [focus]
>
> **How it works:**
> 1. I search for news and build your bank
> 2. I create draft articles on schedule
> 3. You review and publish when ready
>
> **Helpful commands:**
> - *'Show me the article bank'* — see saved sources
> - *'Create an article for [pub] about [topic]'* — manual creation
> - *'What's scheduled?'* — see your cron jobs
> - *'List my Letterman publications'* — see your pubs
>
> Any questions?"

**Cleanup:**
You can delete `letterman-automation-progress.json` or keep it for reference.

---

## Resume Support

If user returns later:
1. Check if `letterman-automation-progress.json` exists
2. Read it to see where they left off
3. Say: "Welcome back! We were on [step]. Ready to continue?"
4. Resume from that step

If they want to restart:
> "Want to start fresh? I'll reset everything and we can begin again."

---

## Error Handling

**API key doesn't work:**
> "That key didn't work. Make sure you copied the whole thing from Letterman's Settings → API. It starts with `eyJ` and is pretty long."

**No publications found:**
> "I don't see any publications in your account yet. You'll need to create at least one newsletter in Letterman first. Want to wait while you do that?"

**Cron job fails:**
> "Something went wrong setting up the schedule. Let me try that again..."

**User seems confused:**
> "No worries! Let me explain that differently..."

**Always offer a path forward. Never leave them stuck.**

---

## What the AI Learns from This

After completing this bootstrap, the AI will have:

1. ✅ **Letterman skill installed** — knows the API endpoints and how to use them
2. ✅ **API key saved** — can authenticate with Letterman
3. ✅ **Publication knowledge** — understands what each newsletter is about
4. ✅ **Cron jobs configured** — automated bank search and article creation
5. ✅ **Safety rules** — always creates drafts, never auto-publishes

The AI can now:
- Search for relevant news sources
- Create AI-generated or blank articles
- Update article content and SEO
- Manage the weekly content workflow

---

*This bootstrap teaches your AI how to automate Letterman article creation while keeping you in control.* 🎬
