# Aider Script

This script helps you to run the Aider tool with a specific model and API key for  
 either Groq or OpenRouter.

## Usage

To use this script, follow these steps:

1.  Install [Aider](https://github.com/aider-ai/aider) globally:

`npm install -g aider`

2.  Set your API key for either Groq or OpenRouter:

- For Groq:
  ```
  export GROQ_API_KEY=your_groq_api_key
  ```
- For OpenRouter:
  ```
  export OPEN_ROUTER_KEY=your_openrouter_api_key
  ```

3.  Run the script with the desired provider (Groq or OpenRouter):

`./aiderstart.sh groq`

or

`./aiderstart.sh openrouter`

If no provider is provided, the script will default to OpenRouter.

4.  Select a model from the list provided by the script. You can either press Enter to select the default model or enter a different model name.

5.  The script will then run Aider with the selected model and API key.

## TODO

- Add error handling for invalid API keys and models.
- Add support for other providers.
- Add support for custom commands and flags.

* Note: This script was completed developed using Aider and OpenRouter (gemini model).
