# Acme Dental AI Agent

A complete AI-powered booking agent for Acme Dental clinic that handles appointment scheduling through natural language conversation.

## Overview

This agent enables users to book, reschedule, and cancel dental appointments using natural language. Built with LangGraph and integrated with Calendly API for real appointment management.

**Key Features:**
- Natural language appointment booking
- Real-time availability checking via Calendly API
- Appointment rescheduling and cancellation
- FAQ answering from knowledge base
- Input validation and error handling
- Multi-LLM provider support

**Clinic Information:**
- **Service**: Dental Check-up (30 minutes)
- **Staff**: Single dentist
- **Scheduling**: Calendly API integration
- **Pricing**: €60 (€50 for students/seniors)

### Functional Requirements

The agent must support the following core booking operations:

**1. Create New Bookings**
- Greet users and understand their booking intent
- Check available appointment slots via the Calendly calendar
- Present available time slots to users
- Help users select a suitable time slots
- Collect necessary patient information (i.e full name and email address)
- Create the booking through the Calendly API
- Provide confirmation with appointment details (date, time, duration)

**2. Reschedule Existing Bookings**
- Allow users to Reschedule their existing appointments
- Identify the booking to update
- Retrieve current appointment details
- Check availability for the new requested time slot
- Reschedule the booking through the Calendly API
- Provide updated confirmation with new appointment details

**3. Cancel Bookings**
- Allow users to cancel their appointments
- Identify the booking to cancel
- Retrieve current appointment details
- Process cancellation through the Calendly API
- Provide cancellation confirmation

**4. Answer FAQs from the Knowledge Base**: 
- A document containing the clinic's knowledge base (KB) will be provided
- Extract and process information from the docu to build a searchable knowledge basent
- Answer frequently asked questions about the clinic using information from the KB

### Non Functional Requirements

- Implement the agent using [LangGraph](https://docs.langchain.com/oss/python/langgraph/overview)
- You are free to choose the LLM model(s) or combination of models you consider most appropriate for this task
- Be aware that API integrations (e.g. Calendly) may be unreliable or experience delays.
- Document your architectural decisions

## Getting Started

### Prerequisites

- Python 3.11 or higher
- [uv](https://github.com/astral-sh/uv) package manager
- LLM API key (OpenAI, Anthropic, Groq, Google, or AWS Bedrock)
- Calendly API token (for booking functionality)

### Installation

1. **Install uv** (if not already installed):

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

2. **Install dependencies**:

```bash
make run
```

or 

```bash
uv sync
```

3. **Set up environment variables**:

Copy the example environment file and add your API keys:

```bash
cp .env.example .env
```

Edit `.env` with your credentials:

```
# Choose your LLM provider
LLM_PROVIDER=openai  # or anthropic, groq, gemini, bedrock

# Add the corresponding API key
OPENAI_API_KEY=your_openai_api_key_here
ANTHROPIC_API_KEY=your_anthropic_api_key_here
GROQ_API_KEY=your_groq_api_key_here
GOOGLE_API_KEY=your_google_api_key_here

# Calendly integration
CALENDLY_API_TOKEN=your_calendly_api_token_here
```

### Starting the Agent

To start the agent, run:

```bash
make run
```

Or directly:

```bash
uv run python src/main.py
```

You can then interact with the agent using natural language. 
Type `exit`, `quit`, or `q` to end the session.

### Development Commands

The project includes a Makefile with convenient commands:

```bash
make install    # Install dependencies
make format     # Format code with ruff
make lint       # Lint code with ruff
make check      # Format and lint code
make run        # Run the agent
make test       # Run tests
make help       # Show all available commands
```

## Features

### Supported Operations
- **Book Appointments**: Check availability and create new bookings
- **Reschedule**: Change existing appointment times
- **Cancel**: Remove appointments
- **FAQ**: Answer questions about services, pricing, and policies

### LLM Provider Support
- **OpenAI**: GPT-3.5-turbo, GPT-4 (recommended for reliability)
- **Anthropic**: Claude 3.5 Sonnet
- **Groq**: Llama models (free tier, limited tool calling)
- **Google**: Gemini models (free tier available)
- **AWS Bedrock**: Nova models

### Example Interactions

```
You: Hello, I'd like to book an appointment
Agent: I'd be happy to help you book a dental check-up! Let me show you the available time slots.

You: What are your prices?
Agent: A standard dental check-up costs €60. We offer discounts for students and seniors (65+) at €50.

You: I need to reschedule my appointment
Agent: I can help you reschedule. What's the email address you used for booking?
```

## Architecture

LangGraph: State machine for conversation flow

LangChain: LLM integration and tool calling

Calendly API: Real appointment scheduling

Multi-Provider LLM: Flexible model selection

Docker: Containerized deployment

![Python](https://img.shields.io/badge/python-v3.11+-blue.svg)
![LangGraph](https://img.shields.io/badge/LangGraph-latest-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## ✨ Features

- 🤖 **Natural Language Booking** - Book appointments through conversation
- 📅 **Real-time Availability** - Live Calendly API integration
- 🔄 **Complete Workflow** - Book, reschedule, cancel appointments
- ❓ **FAQ System** - Answers questions about services and pricing
- 🔧 **Multi-LLM Support** - OpenAI, Anthropic, Groq, Google Gemini, AWS Bedrock
- 🐳 **Docker Ready** - Containerized deployment
- ✅ **Production Ready** - Error handling, validation, monitoring

## 🚀 Quick Start

### Prerequisites
- Python 3.11+
- [uv](https://github.com/astral-sh/uv) package manager
- OpenAI API key (recommended) or other LLM provider

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/acme-dental-ai-agent.git
   cd acme-dental-ai-agent


   # Install uv (if needed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install project dependencies
uv sync

**Configure environment**
cp .env.example .env
# Edit .env and add your API keys

**Run the agent**
uv run python src/main.py

**Docker Deployment**

# Build and run
docker build -t acme-dental-agent .
docker run --env-file .env -it acme-dental-agent

# Or use docker-compose
docker-compose up

**Testing**
# Run tests
make test

# Code quality
make format  # Format code
make lint    # Lint code
make check   # Format + lint


**Project Structure**

acme-dental-main/
├── src/
│   ├── agent/          # LangGraph implementation
│   ├── services/       # API integrations
│   ├── utils/          # Utilities
│   └── main.py         # Entry point
├── tests/              # Unit tests
├── docs/               # Documentation
├── Dockerfile          # Container config
└── README.md           # This file

**Example Conversation**

You: Hello, I'd like to book an appointment
Agent: I'd be happy to help you book a dental check-up! Let me show you the available time slots.

You: What are your prices?
Agent: A standard dental check-up costs €60. We offer discounts for students and seniors (65+) at €50.

You: Show me available slots
Agent: Here are the available appointment slots:
        1. Monday, January 15, 2024 at 09:00 AM
        2. Monday, January 15, 2024 at 10:30 AM
        ...

**Acknowledgments**

Built with LangGraph

Powered by LangChain

Integrated with Calendly API

📞 Support
📧 Email: mail: vivekanand.kulkarni23@gmail.com
