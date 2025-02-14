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

## Current Issues
1. Multiple Global URxvt Settings Sources:
   - Settings in `.Xresources_newer` and `.Xdefaults` both use global `URxvt*` syntax
   - Settings from both files might conflict or stack
   - PopOS transparency rules affecting all URxvt windows

2. Potential Solution Found:
   - URxvt supports instance-specific configuration:
     ```
     urxvt.instance_name.setting: value
     ```
   - Example found in commented code:
     ```
     urxvt.dropdown_urxvt.transient-for: root
     ```
   - This suggests we can use instance names to separate configurations

## Planned Improvements

### URxvt Instance-Specific Configuration
1. Use instance-specific syntax for tdrop terminal:
   ```
   urxvt.dropdown.allowTitleOps: false
   urxvt.dropdown.allowWindowOps: false
   urxvt.dropdown.title: dropdown
   ```

2. Keep global settings for regular URxvt instances:
   ```
   URxvt*termName: xterm-256color
   URxvt*scrollTtyOutput: false
   ```

3. Test instance naming:
   - Launch tdrop with `-name dropdown`
   - Verify settings apply only to dropdown instance
   - Test transparency rules with instance-specific names

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
- [ ] Test URxvt instance-specific configuration syntax
- [ ] Convert tdrop-specific settings to use instance name
- [ ] Verify transparency rules work with instance names
- [ ] Document working configuration pattern
- [ ] Create fallback configurations for other window managers
- [ ] Create mechanism to detect tdrop launch context
- [ ] Develop separate tmux config files or sections
- [ ] Test transparency behavior with different title configurations
- [ ] Document optimal settings for PopOS transparency

### Technical Considerations
- Need to maintain compatibility with Oh My Tmux! framework
- Consider performance impact of conditional config loading
- Ensure smooth transition between different tmux sessions
- Preserve user customization options
- URxvt instance naming must be consistent between:
  - tdrop `-name` parameter
  - X resources instance-specific settings
  - PopOS transparency rules
- Document the relationship between global and instance-specific settings
- Test if instance-specific settings override global ones
- Consider using `#ifdef` conditionals in X resource files for different configurations 