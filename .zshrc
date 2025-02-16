# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source API keys from private file
if [[ -f "$HOME/.zsh_api_keys" ]]; then
  source "$HOME/.zsh_api_keys"
fi

# Android Studio paths
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
source ~/.zsh/catppuccin-zsh-syntax-highlighting/themes/catppuccin_frappe-zsh-syntax-highlighting.zsh
ZSH_THEME="powerlevel10k/powerlevel10k"

if [[ -r /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh ]]; then
    source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
fi


# Which plugins would you like to load?
plugins=(
git
zsh-autosuggestions
ranger-zoxide
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# User configuration
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='vim'
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
alias pop-shop-on='sed -i "s/X-GNOME-Autostart-enabled=false/X-GNOME-Autostart-enabled=true/" /home/lkonga/.config/autostart/io.elementary.appcenter-daemon.desktop; echo "Pop! Store enabled"; nohup io.elementary.appcenter -s >/dev/null 2>&1 &'
alias pop-shop-off='sed -i "s/X-GNOME-Autostart-enabled=true/X-GNOME-Autostart-enabled=false/" /home/lkonga/.config/autostart/io.elementary.appcenter-daemon.desktop; echo "Pop! Store disabled"; killall io.elementary.appcenter'

. /usr/share/autojump/autojump.sh

source /home/lkonga/.config/broot/launcher/bash/br

alias mpv="__GLX_VENDOR_LIBRARY_NAME=nvidia __NV_PRIME_RENDER_OFFLOAD=1 mpv"
alias animdl="__GLX_VENDOR_LIBRARY_NAME=nvidia __NV_PRIME_RENDER_OFFLOAD=1 animdl"
alias ani-cli="__GLX_VENDOR_LIBRARY_NAME=nvidia __NV_PRIME_RENDER_OFFLOAD=1 ani-cli"
alias nano='vim'
alias vim='nvim'
alias ll='ls -lah'

function yy() {
	tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# quits to last folder in ranger and also adds zoxide https://github.com/fdw/ranger-zoxide/tree/main
function ra() {
    local target_dir="$1"

    # Create a temporary file to hold the current directory after exiting ranger
    local tmp="$(mktemp -t "ranger-cwd.XXXXX")"

    # Decide the target directory based on the arguments
    if [ -n "$target_dir" ]; then
        if [ -d "$target_dir" ]; then
            ranger --choosedir="$tmp" "$target_dir"
        else
            target_dir="$(zoxide query $target_dir)"
            [ -n "$target_dir" ] && ranger --choosedir="$tmp" "$target_dir" || ranger --choosedir="$tmp"
        fi
    else
        ranger --choosedir="$tmp"
    fi

    # If ranger exited in a different directory than it started, change to that directory
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi

    # Clean up the temporary file
    rm -f -- "$tmp"
}

alias bat='batcat'

function nsfw() {
    HISTFILE=~/.zsh_history_nsfw zsh
}

# AI development aliases
alias aider-sonnet-35='aider --dark-mode --model openrouter/anthropic/claude-3.5-sonnet'
alias aider-deepseek-coder='aider --dark-mode --model openrouter/deepseek/deepseek-coder'
alias aider-gpt-4o-august='aider --dark-mode --model openrouter/openai/gpt-4o-2024-08-06'
alias aider-gemini-1.5-pro='aider --dark-mode --model gemini/gemini-1.5-pro-latest'
alias aider-gemini-1.5-pro-openrouter='aider --dark-mode --model openrouter/google/gemini-pro-1.5'
alias aider-vertex-ai-sonnet-35='aider --dark-mode --model vertex_ai/claude-3-5-sonnet@20240620'

# vertex ai
export VERTEXAI_PROJECT=semiotic-garden-433501-m7
export VERTEXAI_LOCATION=europe-west1

export GOOGLE_APPLICATION_CREDENTIALS="/home/lkonga/codes/gcloud/semiotic-garden-433501-m7.json"

alias xc='xclip -sel clip'

. "$HOME/.cargo/env"

export PATH=~/.npm-global/bin:$PATH

# Ensure aliases are expanded
setopt aliases

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

gcm2 () {
    # Define color codes for enhanced readability
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    CYAN='\033[0;36m'
    NC='\033[0m' # No Color

    # Default to multiline format
    local message_format="multi"

    # Function to read user input compatibly with both Bash and Zsh
    read_input () {
        prompt="$1"
        if [ -n "$ZSH_VERSION" ]; then
            echo -n "$prompt"
            read -r REPLY
        elif [ -n "$BASH_VERSION" ]; then
            read -p "$prompt" -r REPLY
        else
            # Fallback for other shells
            echo -n "$prompt"
            IFS= read -r REPLY
        fi
    }

    # Check for required commands
    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: git is not installed. Please install git to use the gcm function.${NC}"
        return 1
    fi

    if ! command -v llm &> /dev/null; then
        echo -e "${RED}Error: llm CLI tool is not installed. Please install it from https://llm.datasette.io/en/stable/${NC}"
        return 1
    fi

    # Check for staged changes
    if git diff --cached --quiet; then
        echo -e "${YELLOW}No staged changes to commit.${NC}"
        return 1
    fi

    # Define exclusion patterns
    GCM_EXCLUDED_PATTERNS=( ':!pnpm-lock.yaml' ':!package-lock.json' ':!yarn.lock' )
    if [ -n "$GCM_EXCLUDED_PATTERNS_USER" ]; then
        IFS=';' read -r -a USER_EXCLUSIONS <<< "$GCM_EXCLUDED_PATTERNS_USER"
        GCM_EXCLUDED_PATTERNS+=( "${USER_EXCLUSIONS[@]}" )
    fi

    # Ask for message format preference
    read_input "Do you want a (s)ingle-line or (m)ulti-line commit message? [s/m]: "
    case "$REPLY" in
        s|S ) message_format="single" ;;
        m|M|* ) message_format="multi" ;;
    esac

    # Function to generate commit message
    generate_commit_message() {
        local format="$1"
        # Capture the diff in a variable and process it
        local diff_content=$(git diff --cached -- . "${GCM_EXCLUDED_PATTERNS[@]}")
        
        local base_prompt='You are a helpful assistant that generates Git commit messages based on the provided diffs.

===== COMMIT MESSAGE RULES =====
1. Output ONLY the commit message
2. NO diff content
3. NO git commands
4. NO technical markers
5. NO extra text
6. NO explanations
7. EXACTLY follow the format shown

===== DIFF CONTENT START =====
'"$diff_content"'
===== DIFF CONTENT END ====='

        if [ "$format" = "single" ]; then
            local format_rules='FORMAT RULES:
- Output only one line
- Start with type prefix
- Maximum 72 characters total
- Be specific and concise
- Use imperative mood

Type must be one of: feat, fix, docs, style, refactor, perf, test, ci, build, chore, revert

Example format:
feat: add user authentication to API'
        else
            local format_rules='FORMAT RULES:
- First line: type prefix + summary (max 72 chars)
- Blank line after summary
- Multiple bullet points describing changes
- Each bullet starts with hyphen
- Each bullet max 72 chars
- Be specific about changes
- Use imperative mood

Type must be one of: feat, fix, docs, style, refactor, perf, test, ci, build, chore, revert

Example format:
feat: add authentication system

- Add JWT validation in auth.php
- Implement password hashing
- Create auth routes'
        fi

        # Combine prompts with clear separators
        local full_prompt="$base_prompt

$format_rules

===== YOUR RESPONSE START BELOW THIS LINE ====="

        # Use echo to avoid issues with newlines
        echo "$diff_content" | llm --no-log --model "${GCM_LLM_MODEL:-openrouter/anthropic/claude-3-haiku}" --system "$full_prompt"
    }

    # Log file
    GCM_LOG_FILE="${GCM_LOG_FILE:-"$HOME/.gcm.log"}"

    # Main script
    echo -e "${CYAN}Generating AI-powered commit message...${NC}"
    echo "$(date) - Generating commit message..." >> "$GCM_LOG_FILE"
    commit_message=$(generate_commit_message "$message_format" 2>> "$GCM_LOG_FILE")

    # Check if commit_message was successfully generated
    if [ $? -ne 0 ] || [ -z "$commit_message" ]; then
        echo -e "${RED}Error: Failed to generate commit message using LLM.${NC}"
        echo "$(date) - Failed to generate commit message." >> "$GCM_LOG_FILE"
        return 1
    fi

    while true; do
        echo -e "\n${YELLOW}Proposed commit message:${NC}"
        echo -e "${GREEN}$commit_message${NC}"

        read_input "Do you want to (a)ccept, (e)dit, (r)egenerate, (m)anual, or (c)ancel? [a/e/r/m/c]: "
        choice=$REPLY

        case "$choice" in
            a|A )
                if git commit -m "$commit_message"; then
                    echo -e "${GREEN}✔ Changes committed successfully!${NC}"
                    echo "$(date) - Committed with message: $commit_message" >> "$GCM_LOG_FILE"
                    return 0
                else
                    echo -e "${RED}✖ Commit failed. Please check your changes and try again.${NC}"
                    echo "$(date) - Commit failed." >> "$GCM_LOG_FILE"
                    return 1
                fi
                ;;
            e|E )
                read_input "Enter your commit message: "
                commit_message=$REPLY
                if [ -n "$commit_message" ]; then
                    if git commit -m "$commit_message"; then
                        echo -e "${GREEN}✔ Changes committed successfully with your message!${NC}"
                        echo "$(date) - Committed with user-provided message: $commit_message" >> "$GCM_LOG_FILE"
                        return 0
                    else
                        echo -e "${RED}✖ Commit failed. Please check your message and try again.${NC}"
                        echo "$(date) - Commit failed with user message." >> "$GCM_LOG_FILE"
                        return 1
                    fi
                else
                    echo -e "${RED}✖ Empty commit message. Please try again.${NC}"
                fi
                ;;
            r|R )
                echo -e "${CYAN}Regenerating commit message...${NC}"
                echo "$(date) - Regenerating commit message..." >> "$GCM_LOG_FILE"
                commit_message=$(generate_commit_message "$message_format" 2>> "$GCM_LOG_FILE")
                if [ $? -ne 0 ] || [ -z "$commit_message" ]; then
                    echo -e "${RED}Error: Failed to regenerate commit message using LLM.${NC}"
                    echo "$(date) - Failed to regenerate commit message." >> "$GCM_LOG_FILE"
                    return 1
                fi
                ;;
            m|M )
                echo -e "${CYAN}Opening your default editor to compose a commit message...${NC}"
                git commit
                return $?
                ;;
            c|C )
                echo -e "${YELLOW}Commit cancelled.${NC}"
                echo "$(date) - Commit cancelled by user." >> "$GCM_LOG_FILE"
                return 1
                ;;
            * )
                echo -e "${RED}Invalid choice. Please try again.${NC}"
                ;;
        esac
    done
}

eval "$(zoxide init zsh)"

alias teeclip='tee >(xclip -selection clipboard)'
export PATH="$PATH:$HOME/.config/composer/vendor/bin"

. "$HOME/.atuin/bin/env"

# eval "$(atuin init zsh)"
# eval "$(atuin init zsh --disable-up-arrow)"

alias cerebras33='aichat -m cerebras:llama3.3-70b'
