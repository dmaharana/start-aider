#!/bin/bash

# Define the script's main function
main() {
  # Check if a valid provider is provided
  case $1 in
    groq|g|openrouter|o|"")
      # valid providers, so continue to the rest of the script
      ;;
    *)
      echo "Invalid option"
      exit 1;;
  esac

  # List models for the selected provider
  list_models "$1"

  # Select a model from the list
  selected_model=$(select_model "$1")

  # Set the API key for the selected provider
  api_key=$(set_api_key "$1")

  # Run aider with the selected model and API key
  run_aider "$selected_model" "$api_key"
}

# Function to list models for a given provider
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

# Function to select a model from the list
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

  read -p "Enter model name (or press Enter for default '$default_model'): " selected_model

  if [[ -z "$selected_model" ]]; then
    selected_model="$default_model"
  fi
  #echo "Using model: $selected_model" # Removed the "Using model:" message
  echo "$selected_model"
  return 0 # Return 0 for success
}

# Function to set API key for the selected provider
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

# Function to run aider with the selected model and API key
run_aider() {
  local model="$1"
  local api_key="$2"

  if [ -z "$model" ] || [ -z "$api_key" ]; then
    echo "Model or API key is empty, aborting."
    return 1
  fi

  echo "Running aider with model: $model and API key: $api_key"

  echo aider --no-auto-commits --no-dirty-commits --model "$model" --api-key "$api_key"
  aider --no-auto-commits --no-dirty-commits --model "$model" --api-key "$api_key"

  return 0
}

# Call the main function
main
