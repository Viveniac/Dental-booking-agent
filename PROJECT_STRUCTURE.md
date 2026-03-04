# Project Structure

## Directory Layout

```
acme-dental-main/
├── README.md                    # Main project documentation
├── KNOWLEDGE_BASE.md            # Clinic FAQ content (loaded by app)
├── requirements.txt             # Python dependencies
├── pyproject.toml               # Project configuration & dependencies
├── Makefile                     # Development commands
├── Dockerfile                   # Docker image definition
├── .dockerignore                # Docker build exclusions
├── .gitignore                   # Git exclusions
├── .env.example                 # Environment variables template
│
├── src/                         # Main application code
│   ├── __init__.py
│   ├── main.py                  # CLI entry point
│   │
│   ├── agent/                   # LangGraph agent implementation
│   │   ├── __init__.py          # Agent factory
│   │   ├── graph.py             # LangGraph state machine
│   │   ├── nodes.py             # Tool implementations
│   │   ├── state.py             # State schema
│   │   └── prompts.py           # LLM system prompts
│   │
│   ├── services/                # External service integrations
│   │   ├── __init__.py
│   │   ├── calendly.py          # Calendly API client
│   │   ├── llm.py               # Multi-provider LLM service
│   │   ├── knowledge_base.py    # FAQ search system
│   │   └── booking_cache.py     # In-memory booking cache
│   │
│   └── utils/                   # Utility functions
│       ├── __init__.py
│       ├── validators.py        # Email/name validation
│       └── formatters.py        # Date/time formatting
│
├── tests/                       # Unit tests
│   ├── __init__.py
│   └── test_validators.py       # Validator tests
│
└── docs/                        # Additional documentation
    ├── architecture.md          # Architecture decisions
    └── api_integration.md       # Calendly API integration details
```

## Component Overview

### Core Application (`src/`)

**main.py**: CLI interface with conversation loop and state management
- Handles user input/output
- Manages conversation state between agent calls
- Processes special responses (slot selection, booking completion)

### Agent Package (`src/agent/`)

**graph.py**: LangGraph state machine implementation
- Defines agent workflow with tool calling
- Context-aware prompting based on booking state
- Handles message flow between user and LLM

**nodes.py**: Tool implementations for agent actions
- `get_available_slots()`: Fetches Calendly availability
- `book_appointment()`: Creates new bookings
- `reschedule_appointment()`: Changes existing bookings
- `cancel_appointment()`: Removes bookings
- `search_knowledge_base()`: Answers FAQ questions

**state.py**: TypedDict schema for conversation state
- Tracks user info, selected slots, booking steps
- Maintains message history and context

**prompts.py**: System prompts and instructions for LLM
- Context-aware prompting based on booking flow
- Instructions for natural conversation handling

### Services Package (`src/services/`)

**llm.py**: Multi-provider LLM service
- Supports OpenAI, Anthropic, Groq, Google, AWS Bedrock
- Configurable via environment variables
- Handles API key management

**calendly.py**: Calendly API integration
- Real API calls for availability and user info
- Mock implementations for booking operations (demo mode)
- Error handling and timeout management

**knowledge_base.py**: FAQ search system
- Loads KNOWLEDGE_BASE.md content
- Simple keyword-based search
- Returns relevant sections for user questions

**booking_cache.py**: In-memory booking storage
- Stores booking info for demo purposes
- Enables reschedule/cancel operations
- Simple email-based lookup

### Utilities (`src/utils/`)

**validators.py**: Input validation functions
- Email format validation with regex
- Name validation (length, non-numeric)

**formatters.py**: Date/time formatting
- Converts ISO timestamps to readable format
- Handles timezone conversion

## Key Design Patterns

### State Machine Architecture
- **LangGraph**: Manages conversation flow as a graph
- **State Persistence**: Maintains context across interactions
- **Tool Integration**: Seamless function calling from LLM

### Service Layer Pattern
- **Separation of Concerns**: Business logic separate from agent logic
- **Dependency Injection**: Services injected into tools
- **Mock-Friendly**: Easy to test with mock services

### Configuration Management
- **Environment Variables**: All secrets and config via .env
- **Provider Abstraction**: Switch LLM providers without code changes
- **Graceful Degradation**: Fallback behaviors for API failures

## Development Workflow

### Adding New Features

**Add a New Tool:**
1. Create tool function in `src/agent/nodes.py` with `@tool` decorator
2. Add to `create_tools()` function
3. Tool automatically available to LLM

**Add a New Service:**
1. Create service class in `src/services/`
2. Export from `src/services/__init__.py`
3. Import and use in relevant tools

**Modify Conversation Flow:**
1. Update state schema in `src/agent/state.py`
2. Modify context prompts in `src/agent/graph.py`
3. Update main loop in `src/main.py` if needed

### Testing

```bash
# Run existing tests
make test

# Add new tests
# Create test_*.py files in tests/
# Follow existing patterns in test_validators.py
```

### Code Quality

```bash
# Format code
make format

# Lint code
make lint

# Both format and lint
make check
```

## Configuration

### Environment Variables

```bash
# LLM Provider Selection
LLM_PROVIDER=openai  # openai, anthropic, groq, gemini, bedrock

# API Keys (add only what you need)
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GROQ_API_KEY=gsk_...
GOOGLE_API_KEY=AI...

# AWS Bedrock (if using)
AWS_REGION=us-east-1
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...

# Calendly Integration
CALENDLY_API_TOKEN=...
```

### LLM Provider Notes

- **OpenAI**: Most reliable tool calling, requires credits
- **Anthropic**: Excellent reasoning, requires credits
- **Groq**: Fast and free, but limited tool calling reliability
- **Google Gemini**: Free tier available, good performance
- **AWS Bedrock**: Enterprise option, requires AWS setup
