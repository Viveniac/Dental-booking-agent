# Setup Guide

Comprehensive setup instructions for the Acme Dental AI Agent.

## System Requirements

- **Python**: 3.11 or higher
- **Memory**: 512MB RAM minimum
- **Storage**: 100MB free space
- **Network**: Internet connection for API calls

## Installation Methods

### Method 1: Local Development (Recommended)

1. **Install uv package manager**:
   ```bash
   # Windows (PowerShell)
   powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
   
   # macOS/Linux
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. **Clone and setup**:
   ```bash
   cd acme-dental-main
   uv sync
   ```

3. **Configure environment**:
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

### Method 2: Docker Deployment

1. **Build Docker image**:
   ```bash
   docker build -t acme-dental-agent .
   ```

2. **Run with environment file**:
   ```bash
   docker run --env-file .env -it acme-dental-agent
   ```

3. **Or run with inline environment**:
   ```bash
   docker run -e LLM_PROVIDER=openai -e OPENAI_API_KEY=your-key -it acme-dental-agent
   ```

## API Key Configuration

### LLM Providers

Choose one based on your needs:

#### OpenAI (Recommended for Production)
- **Pros**: Most reliable tool calling, excellent performance
- **Cons**: Requires paid credits
- **Setup**:
  1. Visit https://platform.openai.com/api-keys
  2. Create new secret key
  3. Add credits to your account ($5-10 for testing)
  4. Set in `.env`:
     ```
     LLM_PROVIDER=openai
     OPENAI_API_KEY=sk-proj-your-key-here
     ```

#### Anthropic Claude
- **Pros**: Excellent reasoning, good for complex workflows
- **Cons**: Requires paid credits
- **Setup**:
  1. Visit https://console.anthropic.com/
  2. Create API key
  3. Add credits to your account
  4. Set in `.env`:
     ```
     LLM_PROVIDER=anthropic
     ANTHROPIC_API_KEY=sk-ant-your-key-here
     ```

#### Google Gemini (Free Tier Available)
- **Pros**: Free tier, good performance
- **Cons**: Newer, less battle-tested
- **Setup**:
  1. Visit https://makersuite.google.com/app/apikey
  2. Create API key
  3. Set in `.env`:
     ```
     LLM_PROVIDER=gemini
     GOOGLE_API_KEY=your-google-api-key
     ```

#### Groq (Free but Limited)
- **Pros**: Fast, completely free
- **Cons**: Limited tool calling reliability
- **Setup**:
  1. Visit https://console.groq.com/keys
  2. Create API key
  3. Set in `.env`:
     ```
     LLM_PROVIDER=groq
     GROQ_API_KEY=gsk_your-groq-key
     ```

#### AWS Bedrock (Enterprise)
- **Pros**: Enterprise features, good for AWS environments
- **Cons**: Complex setup, requires AWS account
- **Setup**:
  1. Configure AWS credentials
  2. Enable Bedrock in your AWS region
  3. Set in `.env`:
     ```
     LLM_PROVIDER=bedrock
     AWS_REGION=us-east-1
     AWS_ACCESS_KEY_ID=your-access-key
     AWS_SECRET_ACCESS_KEY=your-secret-key
     ```

### Calendly Integration

1. **Get Calendly API Token**:
   - Visit https://calendly.com/integrations/api_webhooks
   - Click "Generate new token"
   - Copy the Personal Access Token

2. **Configure Calendly Account**:
   - Ensure you have at least one event type configured
   - Recommended: Create a "Dental Check-up" event type (30 minutes)
   - Set your availability preferences

3. **Add to environment**:
   ```
   CALENDLY_API_TOKEN=your-calendly-token-here
   ```

## Environment Configuration

### Complete .env Example

```bash
# LLM Provider Selection
LLM_PROVIDER=openai  # openai, anthropic, groq, gemini, bedrock

# OpenAI Configuration
OPENAI_API_KEY=sk-proj-your-openai-key-here

# Anthropic Configuration
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key-here

# Groq Configuration
GROQ_API_KEY=gsk_your-groq-key-here

# Google Gemini Configuration
GOOGLE_API_KEY=your-google-api-key-here

# AWS Bedrock Configuration
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key

# Calendly Integration
CALENDLY_API_TOKEN=your-calendly-token-here

# Optional: Ollama Configuration (for local models)
OLLAMA_MODEL=llama3.2
```

### Environment Variables Reference

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `LLM_PROVIDER` | Yes | LLM provider to use | `openai` |
| `OPENAI_API_KEY` | If using OpenAI | OpenAI API key | `sk-proj-...` |
| `ANTHROPIC_API_KEY` | If using Anthropic | Anthropic API key | `sk-ant-...` |
| `GROQ_API_KEY` | If using Groq | Groq API key | `gsk_...` |
| `GOOGLE_API_KEY` | If using Gemini | Google API key | `AI...` |
| `AWS_REGION` | If using Bedrock | AWS region | `us-east-1` |
| `AWS_ACCESS_KEY_ID` | If using Bedrock | AWS access key | `AKIA...` |
| `AWS_SECRET_ACCESS_KEY` | If using Bedrock | AWS secret key | `...` |
| `CALENDLY_API_TOKEN` | Yes | Calendly API token | `...` |
| `OLLAMA_MODEL` | If using Ollama | Local model name | `llama3.2` |

## Verification

### Test Installation

1. **Check Python version**:
   ```bash
   python --version  # Should be 3.11+
   ```

2. **Verify dependencies**:
   ```bash
   uv run python -c "import langchain, langgraph, httpx; print('Dependencies OK')"
   ```

3. **Test environment**:
   ```bash
   uv run python -c "from src.services.llm import get_llm; print('LLM service OK')"
   ```

### Test API Connections

1. **Test LLM connection**:
   ```bash
   uv run python -c "
   from src.services.llm import get_llm
   llm = get_llm()
   response = llm.invoke('Hello')
   print('LLM connection OK')
   "
   ```

2. **Test Calendly connection**:
   ```bash
   uv run python -c "
   from src.services.calendly import CalendlyClient
   client = CalendlyClient()
   user = client.get_user()
   print('Calendly connection OK')
   "
   ```

## Running the Agent

### Development Mode

```bash
# Using Makefile
make run

# Direct execution
uv run python src/main.py

# With debug logging
DEBUG=1 uv run python src/main.py
```

### Production Mode

```bash
# Build and run with Docker
docker build -t acme-dental-agent .
docker run --env-file .env acme-dental-agent

# Or with docker-compose
docker-compose up
```

## Troubleshooting

### Common Issues

#### "Module not found" errors
```bash
# Solution: Reinstall dependencies
uv sync --reinstall
```

#### "Invalid API key" errors
```bash
# Solution: Check your API keys
echo $OPENAI_API_KEY  # Should not be empty
# Verify key format and permissions
```

#### "Tool calling failed" errors
```bash
# Solution: Switch to OpenAI or Anthropic
LLM_PROVIDER=openai  # More reliable than Groq
```

#### "Calendly API error" errors
```bash
# Solution: Check Calendly setup
# 1. Verify token is valid
# 2. Ensure event types are configured
# 3. Check account permissions
```

### Debug Mode

Enable debug logging:
```bash
export DEBUG=1
uv run python src/main.py
```

### Health Check

Run the built-in health check:
```bash
uv run python -c "
from src.services.llm import get_llm
from src.services.calendly import CalendlyClient
from src.services.knowledge_base import KnowledgeBase

print('Testing LLM...')
llm = get_llm()
print('✓ LLM OK')

print('Testing Calendly...')
client = CalendlyClient()
user = client.get_user()
print('✓ Calendly OK')

print('Testing Knowledge Base...')
kb = KnowledgeBase()
result = kb.search('pricing')
print('✓ Knowledge Base OK')

print('All systems operational!')
"
```

## Performance Optimization

### For Development
- Use Groq for fast, free testing (limited tool calling)
- Enable caching for repeated availability checks
- Use local Ollama models for offline development

### For Production
- Use OpenAI or Anthropic for reliable tool calling
- Implement Redis caching for availability data
- Add monitoring and logging
- Use Docker for consistent deployments

## Security Considerations

### API Key Security
- Never commit `.env` files to version control
- Use environment variables in production
- Rotate API keys regularly
- Use least-privilege access tokens

### Network Security
- Use HTTPS for all API calls
- Implement rate limiting
- Add request timeout handling
- Validate all user inputs

## Next Steps

After successful setup:
1. Read [QUICKSTART.md](QUICKSTART.md) for basic usage
2. Review [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) for code organization
3. Check [docs/architecture.md](docs/architecture.md) for technical details
4. Explore [docs/api_integration.md](docs/api_integration.md) for API details