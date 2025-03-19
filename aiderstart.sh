#!/bin/bash

## get provider
provider=$1

## keys
export OPEN_ROUTER_KEY=${OPEN_ROUTER_KEY:-""}
export GROQ_API_KEY=${GROQ_API_KEY:-""}

## models
gmodel="groq/llama-3.3-70b-versatile"
ormodel="openrouter/google/gemini-2.0-flash-lite-preview-02-05:free"

# Function to list models
list_models() {
  provider_arg=$1
  if [[ "$provider_arg" == "groq" || "$provider_arg" == "g" ]]; then
    aider --list-models groq
  elif [[ "$provider_arg" == "openrouter" || "$provider_arg" == "o" || "$provider_arg" == "" ]]; then
    aider --list-models openrouter
  else
    echo "Invalid provider for listing models."
    return 1
  fi
  return 0
}

# Function to select a model
select_model() {
  provider_arg=$1
  if [[ "$provider_arg" == "groq" || "$provider_arg" == "g" ]]; then
    default_model="$gmodel"
  elif [[ "$provider_arg" == "openrouter" || "$provider_arg" == "o" || "$provider_arg" == "" ]]; then
    default_model="$ormodel"
  else
    echo "Invalid provider for selecting model."
    return 1
  fi

  echo "Available models for $provider_arg (or default):"
  list_models "$provider_arg"
  read -p "Enter model name (or press Enter for default '$default_model'): " selected_model

  if [[ -z "$selected_model" ]]; then
    selected_model="$default_model"
  fi
  echo "Using model: $selected_model"
  echo "$selected_model"
  return "$?"
}

# Function to set API key
set_api_key() {
  provider_arg=$1
  case "$provider_arg" in
    groq|g)
      api_key="groq=${GROQ_API_KEY}"
      ;;
    openrouter|o|"")
      api_key="openrouter=${OPEN_ROUTER_KEY}"
      ;;
    *)
      echo "Invalid provider for setting API key."
      return 1
      ;;
  esac
  echo "$api_key"
  return 0
}

# Function to run aider
run_aider() {
  local model="$1"
  local api_key="$2"

  if [ -z "$model" ] || [ -z "$api_key" ]; then
    echo "Model or API key is empty, aborting."
    return 1
  fi

  aider --no-auto-commits --no-dirty-commits --model "$model" --api-key "$api_key"
  return "$?"
}

# Main script logic
case $1 in
  groq|g)
    selected_model=$(select_model "$1")
    if [ $? -ne 0 ]; then
      exit 1
    fi
    api_key=$(set_api_key "$1")
    if [ $? -ne 0 ]; then
      exit 1
    fi
    run_aider "$selected_model" "$api_key"
    ;;
  openrouter|o|"")
    selected_model=$(select_model "$1")
    if [ $? -ne 0 ]; then
      exit 1
    fi
    api_key=$(set_api_key "$1")
    if [ $? -ne 0 ]; then
      exit 1
    fi
    run_aider "$selected_model" "$api_key"
    ;;
  list)
    list_models "$2"
    exit 0
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac
