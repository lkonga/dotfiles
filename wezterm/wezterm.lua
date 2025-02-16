local wezterm = require 'wezterm'

local config = {
    -- Window configuration
    window_decorations = "NONE",
    window_background_opacity = 1.0,
    
    -- Theme
    color_scheme = 'Catppuccin Mocha',
    
    -- Font configuration
    font = wezterm.font_with_fallback({
        'Hack',  -- Clean and readable font, great for long sessions
        'JetBrains Mono', -- Fallback
        'Noto Color Emoji',
    }),
    font_size = 13.0,
    
    -- Adjust line height for better readability
    line_height = 1.0,  -- Hack has good built-in spacing
    
    -- Cursor configuration
    cursor_blink_rate = 800,  -- Adjust blink speed (milliseconds)
    cursor_blink_ease_in = "Constant",  -- No fade-in
    cursor_blink_ease_out = "Constant", -- No fade-out
    default_cursor_style = "BlinkingBlock",
    -- Disable fading effects
    text_background_opacity = 1.0,
    inactive_pane_hsb = {
        saturation = 1.0,
        brightness = 1.0,
    },
    
    -- Tab bar
    use_fancy_tab_bar = true,
    hide_tab_bar_if_only_one_tab = true,
    
    -- Other preferences
    scrollback_lines = 10000,
    enable_scroll_bar = false,
    check_for_updates = false,
    window_close_confirmation = 'NeverPrompt',
    audible_bell = "Disabled",
}

-- Your existing tdrop configuration
if os.getenv("TDROP_WEZTERM") then
    config.window_background_opacity = 0.8
    config.font_size = 13.0
end

-- Handle tmux detection
if os.getenv("TMUX") then
    config.term = "wezterm-tmux"
end

return config
