# Quick Start Guide

Get the Acme Dental AI Agent running in 5 minutes.

## Prerequisites

- Python 3.11+
- [uv](https://github.com/astral-sh/uv) package manager

## 1. Install uv (if needed)

**Windows:**
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## 2. Install Dependencies

```bash
uv sync
```

## 3. Configure Environment

Copy the example environment file:
```bash
cp .env.example .env
```

Edit `.env` and add your API keys:

### Option A: OpenAI (Recommended)
```bash
LLM_PROVIDER=openai
OPENAI_API_KEY=sk-proj-your-key-here
CALENDLY_API_TOKEN=your-calendly-token
```

### Option B: Free Tier (Google Gemini)
```bash
LLM_PROVIDER=gemini
GOOGLE_API_KEY=your-google-api-key
CALENDLY_API_TOKEN=your-calendly-token
```

### Option C: Free Tier (Groq - Limited)
```bash
LLM_PROVIDER=groq
GROQ_API_KEY=gsk_your-groq-key
CALENDLY_API_TOKEN=your-calendly-token
```

## 4. Get API Keys

### LLM Provider Keys

**OpenAI** (Most reliable):
1. Visit https://platform.openai.com/api-keys
2. Create new secret key
3. Add $5-10 credits for testing

**Google Gemini** (Free tier):
1. Visit https://makersuite.google.com/app/apikey
2. Create API key (free tier available)

**Groq** (Free but limited):
1. Visit https://console.groq.com/keys
2. Create API key (free tier available)
3. Note: Tool calling may be unreliable

### Calendly Token

1. Visit https://calendly.com/integrations/api_webhooks
2. Generate Personal Access Token
3. Copy the token to your `.env` file

## 5. Run the Agent

```bash
make run
```

Or directly:
```bash
uv run python src/main.py
```

## 6. Test the Agent

Try these example interactions:

```
You: Hello, I'd like to book an appointment
Agent: I'd be happy to help you book a dental check-up! Let me show you the available time slots.

You: What are your prices?
Agent: A standard dental check-up costs €60. We offer discounts for students and seniors (65+) at €50.

You: Show me available slots
Agent: [Shows real Calendly availability]
```

## Troubleshooting

### Tool Calling Issues
**Problem**: Agent can answer questions but can't show slots or book appointments.
**Solution**: Use OpenAI or Anthropic instead of Groq for reliable tool calling.

### API Errors
**Problem**: "Error checking availability" messages.
**Solution**: 
1. Check your Calendly token is valid
2. Ensure your Calendly account has event types configured
3. Verify API key permissions

### Dependencies
**Problem**: Import errors or missing packages.
**Solution**: Run `uv sync` to ensure all packages are installed.

## Docker Alternative

If you prefer Docker:

```bash
# Build image
docker build -t acme-dental-agent .

# Run with environment file
docker run --env-file .env -it acme-dental-agent
```

## Next Steps

- Read [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for code organization
- Check [docs/architecture.md](docs/architecture.md) for technical details
- See [docs/api_integration.md](docs/api_integration.md) for Calendly integration

## Development Commands

```bash
make install    # Install dependencies
make format     # Format code with ruff
make lint       # Lint code with ruff
make check      # Format and lint code
make run        # Run the agent
make test       # Run tests
make help       # Show all available commands
```

## Getting Help

1. Check the troubleshooting section above
2. Review error messages for specific guidance
3. Ensure all API keys are valid and have proper permissions
4. Try with OpenAI if using free tier providers