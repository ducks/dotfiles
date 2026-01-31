---
name: person-eval
description: This skill should be used when the user asks to "evaluate a person", "person evaluation", "professional evaluation", "analyze user activity", "Graham Duncan framework", "what's going on with this human", or wants to generate a professional assessment from Discourse forum activity.
version: 20260131
---

# Person Evaluation Skill

Generate a professional evaluation based on Discourse forum activity, inspired
by Graham Duncan's "What's going on here, with this human?" framework.

## When This Skill Applies

This skill activates when the user wants to:
- Evaluate someone based on their forum activity
- Generate a professional assessment for 1:1s or reviews
- Analyze communication patterns and strengths from posts
- Apply the Graham Duncan evaluation framework

## Usage

Provide a username and Discourse site URL:
- "evaluate ducks on https://dev.discourse.org"
- "person evaluation for sam on https://meta.discourse.org"

## Instructions

Follow these phases IN ORDER:

### Phase 1: Data Gathering

Use the discourse-mcp tools to collect data:

1. Call `discourse_select_site` with the provided site URL
2. Call `discourse_get_user` to get the user's profile
3. Call `discourse_list_user_posts` to get their recent posts (2-3 pages, ~60-90 posts)
4. Call `discourse_read_post` on 8-12 substantive posts (longer content, interesting topics)

Summarize what you gathered before proceeding.

### Phase 2: Analysis

Analyze the gathered data through these lenses:

- **Communication Style**: Clarity, tone, how they explain things
- **Technical/Domain Depth**: Areas of expertise, quality of explanations
- **Collaboration Patterns**: How they interact, help others, respond to feedback
- **Initiative & Drive**: Starting discussions vs responding, proposing solutions
- **Handling Disagreement**: Response to pushback, updating views
- **Self-Awareness Signals**: Acknowledging gaps, asking questions, qualifying statements

Note specific examples from posts for each dimension.

### Phase 3: Format Output

CRITICAL: Use the EXACT template below. Copy headers VERBATIM. Do not reorganize,
rename sections, or add new sections. Fill in the bracketed placeholders with
your analysis.

---

```
=============================================================================
                        PROFESSIONAL EVALUATION
                     Based on Discourse Activity
=============================================================================

SUBJECT: [username]
PERIOD:  [date range of posts analyzed]
SOURCE:  [site URL]
DATE:    [today's date]

-----------------------------------------------------------------------------
EXECUTIVE SUMMARY
-----------------------------------------------------------------------------
[2-3 sentence overview. What stands out? What impression would someone form?]

-----------------------------------------------------------------------------
CORE STRENGTHS
-----------------------------------------------------------------------------
[Bullet list of 3-5 strengths with brief evidence]

* [Strength 1]: [one sentence of supporting evidence from posts]
* [Strength 2]: [one sentence of supporting evidence from posts]
* [Strength 3]: [one sentence of supporting evidence from posts]

-----------------------------------------------------------------------------
GROWTH AREAS
-----------------------------------------------------------------------------
[Bullet list of 2-3 areas for development, framed constructively]

* [Area 1]: [observation and suggestion]
* [Area 2]: [observation and suggestion]

-----------------------------------------------------------------------------
COMMUNICATION PROFILE
-----------------------------------------------------------------------------
Style:      [e.g., "Direct and technical" / "Warm and explanatory"]
Tone:       [e.g., "Helpful" / "Measured" / "Enthusiastic"]
Clarity:    [High/Medium/Low with brief note]

Notable pattern: [One specific observation about how they communicate]

-----------------------------------------------------------------------------
COLLABORATION DYNAMICS
-----------------------------------------------------------------------------
[How do they work with others? Multiplier for team? Build on others' ideas?]

-----------------------------------------------------------------------------
AREAS OF EXPERTISE
-----------------------------------------------------------------------------
[Bullet list of topics/domains where they demonstrate depth]

* [Domain 1]
* [Domain 2]
* [Domain 3]

-----------------------------------------------------------------------------
REPRESENTATIVE QUOTES
-----------------------------------------------------------------------------
[2-3 direct quotes from their posts that exemplify their voice/approach]

> "[Quote 1]"

> "[Quote 2]"

-----------------------------------------------------------------------------
DISCUSSION PROMPTS FOR 1:1
-----------------------------------------------------------------------------
[3-4 questions a manager could use based on patterns in their activity]

1. [Question based on an interest or passion visible in posts]
2. [Question about a challenge or growth area]
3. [Question about aspirations or what energizes them]

-----------------------------------------------------------------------------
LIMITATIONS OF THIS EVALUATION
-----------------------------------------------------------------------------
This evaluation is based solely on public forum activity and has inherent
limitations:
- Only captures written communication, not verbal or in-person dynamics
- Forum persona may differ from day-to-day work behavior
- Sample size: [X posts over Y period]
- Cannot assess: private communications, meeting contributions, code quality,
  deadline reliability, or interpersonal dynamics outside the forum

=============================================================================
```

## Template Compliance Tips

If you're having trouble with Claude not following templates:

1. **Embed the template directly** - Don't reference external files by path
2. **Put the template at the END** - Recency bias helps compliance
3. **Use explicit language** - Words like "EXACT", "VERBATIM", "copy headers exactly"
4. **Separate phases** - Data gathering, analysis, and formatting as distinct steps
5. **Show the structure** - Literal headers are easier to copy than descriptions
