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

### Progress Tracker

Check if `letterman-automation-progress.json` exists. If yes, read it to resume.
If no, create it:
```json
{
  "started": "[timestamp]",
  "currentStep": 1,
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

## The Steps

### Step 1: Letterman API Key

**Say:**
> "👋 **Let's set up your Letterman article automation!**
>
> First, I need your **Letterman API key**. Here's how to get it:
>
> 1. Log into **app.letterman.ai**
> 2. Go to **Settings** (gear icon)
> 3. Click **API**
> 4. Copy your API key
>
> Paste it here when you're ready!"

**When they provide the key:**
- Save to `credentials/letterman-api-key.txt` or your credentials file
- Test it by calling `GET /user` endpoint

**On success:**
> "✅ **Connected!** I can see your account: [show name and email from API response]"

**Update progress:**
```json
{ "currentStep": 2, "completed": ["api-key"] }
```

---

### Step 2: List Publications

**Say:**
> "Now let me pull up your publications..."

**Execute:**
Call `GET /newsletters-storage` with their API key

**Show them:**
> "📰 **Here are your publications:**
>
> | # | Name | Type | Articles |
> |---|------|------|----------|
> | 1 | [name] | [LOCAL/NICHE] | X published |
> | 2 | [name] | [LOCAL/NICHE] | X published |
> ...
>
> Which ones do you want to automate? (Give me the numbers, like: 1, 3, 4)"

**Save their selection to progress:**
```json
{ "currentStep": 3, "completed": ["api-key", "list-publications"], "publications": [...selected IDs and names...] }
```

---

### Step 3: Understand Each Publication

**For EACH selected publication, ask:**
> "📝 **Let's learn about [Publication Name]**
>
> 1. **What's the focus?** (e.g., local news, food, pets, sports)
> 2. **Who's the audience?** (e.g., Summerlin residents, dog lovers, foodies)
> 3. **Can you share a link to one of your published articles?** (so I can match your style)
>
> Just describe it in your own words!"

**When they answer:**
- Save the focus/description
- If they share a URL, fetch it to understand the style
- Summarize back: "Got it! [Publication] is about [focus] for [audience]. The style is [what you learned]."

**After understanding ALL selected publications:**
> "✅ **I now understand your publications:**
>
> - **[Pub 1]**: [focus summary]
> - **[Pub 2]**: [focus summary]
> ...
>
> Ready to set up the automation schedule?"

**Update progress:**
```json
{ "currentStep": 4, "completed": ["api-key", "list-publications", "understand-publications"] }
```

---

### Step 4: Article Bank Schedule

**Say:**
> "📅 **Let's set up your Article Bank**
>
> Every week, I'll search for fresh news stories relevant to your publications and save them to a 'bank' — a list of content ready to become articles.
>
> **When should I do this search?**
>
> Most people do it Monday mornings so they have content for the week. Something like:
> - Monday at 8 AM
>
> What day and time works for you? (Use your timezone)"

**When they answer:**
- Create the cron job for article bank search
- Include their selected publications in the job

**On success:**
> "✅ **Article bank search scheduled!**
>
> Every [day] at [time], I'll find fresh stories for:
> - [Publication 1]
> - [Publication 2]
> ..."

**Update progress:**
```json
{ "currentStep": 5, "completed": [..., "bank-schedule"], "cronJobs": ["bank-search-job-id"] }
```

---

### Step 5: Article Creation Schedule

**Say:**
> "✍️ **Now let's schedule article creation**
>
> I can automatically create draft articles from the bank. They'll stay as **drafts** until you review and publish them.
>
> **Questions:**
>
> 1. **Which days?** (e.g., Monday, Wednesday, Friday)
> 2. **How many per day?** (1 per publication is typical)
> 3. **What times?** (I'll vary them slightly to look natural)
>
> What works for you?"

**When they answer:**
- Create cron jobs for each article creation day
- Use varied times within daylight hours
- Confirm AI-generated articles (uses their OpenAI tokens in Letterman)

**On success:**
> "✅ **Article creation scheduled!**
>
> | Day | Time | What Happens |
> |-----|------|--------------|
> | [Mon] | [9:30 AM] | Create [X] draft articles |
> | [Wed] | [1:45 PM] | Create [X] draft articles |
> | [Fri] | [11:15 AM] | Create [X] draft articles |
>
> All articles stay as **drafts** — nothing goes live without you!"

**Update progress:**
```json
{ "currentStep": 6, "completed": [..., "creation-schedule"], "cronJobs": [...] }
```

---

### Step 6: Summary Notification (Optional)

**Say:**
> "📊 **One more optional thing!**
>
> Want me to send you a quick summary after I build the bank? Just a simple message like:
>
> *'Added 12 sources to the bank — 5 for [Pub 1], 4 for [Pub 2], 3 for [Pub 3]'*
>
> Want this? If yes, what time? (Most do Monday evening, like 9 PM)"

**If yes:**
- Create the summary cron job

**If they skip:**
- That's fine, mark as skipped

**Update progress:**
```json
{ "currentStep": 7, "completed": [..., "summary-notification"] }
```
or
```json
{ "currentStep": 7, "skipped": ["summary-notification"] }
```

---

### Step 7: Completion

**Show summary:**
> "🎉 **You're all set!**
>
> Here's your automation schedule:
>
> | What | When |
> |------|------|
> | Search for sources | [Day] at [Time] |
> | Create articles | [Days] at [Times] |
> | Summary (optional) | [Day] at [Time] |
>
> **Publications automated:**
> - [Pub 1] — [focus]
> - [Pub 2] — [focus]
>
> **What happens now:**
> 1. I search for stories and build your bank
> 2. I create draft articles on schedule
> 3. You review and publish when ready
>
> **Helpful commands:**
> - *'Show me the article bank'* — see what's saved
> - *'Create an article for [pub] now'* — manual creation
> - *'What's scheduled?'* — see your cron jobs
> - *'Pause automation'* — disable the jobs temporarily
>
> Any questions? Otherwise, you're good to go! 🎬"

**Cleanup:**
After user confirms, you can delete the progress file or keep it for reference.

---

## Resume Support

If user comes back later:
1. Read `letterman-automation-progress.json`
2. Say: "Welcome back! We left off at [step]. Ready to continue?"
3. Resume from that step

If they want to start over:
> "Want me to start fresh? I'll reset the progress and we can begin again."

---

## Error Handling

**API key doesn't work:**
> "Hmm, that key didn't work. Double-check you copied the whole thing from Letterman's API settings. It should start with 'eyJ...' and be pretty long."

**No publications found:**
> "I don't see any publications in your account yet. You'll need to create at least one newsletter in Letterman first. Want me to wait while you do that?"

**Cron job fails:**
> "Something went wrong setting up the schedule. Let me try again..."

Never leave them stuck — always offer a path forward.

---

*This guide helps you set up automated article creation. Once complete, your AI handles the routine work while you stay in control.* 🎬
