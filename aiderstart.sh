## get provider
provider=$1

## keys
export OPEN_ROUTER_KEY=${OPEN_ROUTER_KEY:-""}
export GROQ_API_KEY=${GROQ_API_KEY:-""}


## models
gmodel="groq/llama-3.3-70b-versatile"
ormodel="openrouter/google/gemini-2.0-flash-lite-preview-02-05:free"

# Add option to launch aider with either groq or openrouter
model=""
api_key=""

case $1 in
  groq|g)
    model="$gmodel"
    api_key="groq=${GROQ_API_KEY}"
    ;;
  openrouter|o)
    model="$ormodel"
    api_key="openrouter=${OPEN_ROUTER_KEY}"
    ;;
  *)
    echo "Invalid option"
    exit 1
    ;;
esac

if [ -z "$model" ] || [ -z "$api_key" ]; then
  echo "Model or API key is empty, aborting."
  exit 1
fi

aider --no-auto-commits --no-dirty-commits --model "$model" --api-key $api_key
