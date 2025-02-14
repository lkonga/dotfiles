# Tdrop and Tmux Title Handling Improvements

## Current State
- Basic title handling implemented in `.tmux.conf.local` with global settings:
  ```tmux
  set-option -g allow-rename off #!important
  set-window-option -g automatic-rename off #!important
  set-option -g set-titles off #!important
  ```
- URxvt launched with `-name dropdown_debug` parameter
- Title remains static for tdrop dropdown terminal

## Planned Improvements

### Selective Tmux Configuration
1. Create separate tmux configuration profiles:
   - One for tdrop dropdown terminal
   - One for regular tmux sessions

2. Implement conditional loading based on session type:
   - Detect if tmux is launched via tdrop
   - Apply appropriate title/rename settings

### PopOS Transparency Integration
1. Research and document how PopOS handles transparency via:
   - Window class names
   - Window titles
   - X11 window properties

2. Create specific configurations for:
   - tdrop dropdown terminal (needs static title for transparency)
   - Regular terminal windows (can have dynamic titles)

### Implementation Tasks
- [ ] Create mechanism to detect tdrop launch context
- [ ] Develop separate tmux config files or sections
- [ ] Test transparency behavior with different title configurations
- [ ] Document optimal settings for PopOS transparency
- [ ] Create fallback configurations for other window managers

### Technical Considerations
- Need to maintain compatibility with Oh My Tmux! framework
- Consider performance impact of conditional config loading
- Ensure smooth transition between different tmux sessions
- Preserve user customization options 