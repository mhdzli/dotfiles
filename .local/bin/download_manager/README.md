# Download Manager (dlmgr)

A lightweight, menu-driven download manager using aria2c with clipboard integration and desktop notifications.

## Features

- **Queue-based downloads** - Add multiple files to a download queue
- **Clipboard integration** - Automatically grab URLs from clipboard
- **Resume support** - Continue interrupted downloads
- **Multiple progress views** - Terminal, Notification, or Silent modes
- **Multi-connection downloads** - Uses up to 16 connections per file for faster downloads
- **Desktop notifications** - Get notified when downloads start, complete, or fail
- **Cross-platform clipboard** - Works with both X11 (xclip) and Wayland (wl-paste)
- **Batch operations** - Add all URLs from clipboard at once

## Requirements

- `aria2c` - The download utility
- `xclip` (for X11) or `wl-copy`/`wl-paste` (for Wayland) - Clipboard access
- `fuzzel`, `dmenu`, `rofi`, or similar menu program (set via $MENU environment variable)
- `notify-send` - For desktop notifications
- `exec-terminal` - For opening terminal windows (or modify to use your terminal)

### Installation

```bash
# Install dependencies (Arch Linux)
sudo pacman -S aria2 xclip wl-clipboard fuzzel

# Install dependencies (Debian/Ubuntu)
sudo apt install aria2 xclip wl-clipboard fuzzel

# Install dependencies (Fedora)
sudo dnf install aria2 xclip wl-clipboard fuzzel
```

## Setup

1. Copy the scripts to your bin directory (e.g., `~/.local/bin/download_manager/`):
   - `dlmgr` - Main script
   - `dl_nf_start` - Start notification helper
   - `dl_nf_complete` - Complete notification helper
   - `dl_nf_error` - Error notification helper

2. (Optional) Add icon files for notifications:
   - `download.svg` - Downloading icon
   - `complete.svg` - Download complete icon
   - `pause.svg` - Download paused icon
   - `error.svg` - Download error icon
   
   Or modify the icon paths in the scripts to use system icons.

3. Make scripts executable:
```bash
chmod +x dlmgr dl_nf_start dl_nf_complete dl_nf_error
```

4. Add the directory to your PATH or create symlinks:
```bash
# Option 1: Add to PATH in ~/.bashrc or ~/.zshrc
export PATH="$HOME/.local/bin/download_manager:$PATH"

# Option 2: Create symlinks
ln -s ~/.local/bin/download_manager/dlmgr ~/.local/bin/dlmgr
ln -s ~/.local/bin/download_manager/dl_nf_start ~/.local/bin/dl_nf_start
ln -s ~/.local/bin/download_manager/dl_nf_complete ~/.local/bin/dl_nf_complete
ln -s ~/.local/bin/download_manager/dl_nf_error ~/.local/bin/dl_nf_error
```

5. Set your menu program:
```bash
# Add to your shell config (~/.bashrc, ~/.zshrc, etc.)
export MENU="fuzzel -d"  # or dmenu, rofi, wofi, etc.
```

6. Edit the default download directory in the script:
```bash
# Open dlmgr and change this line to your preferred location:
dl_dir="/home/mzeinali/Data/tvs"  # Change this to your path
```

## Usage

### Interactive Menu

Simply run:
```bash
dlmgr
```

This will show a menu with options:
- **Start Download** - Begin downloading queued files
- **Stop Download** - Stop/pause current downloads
- **Add Link** - Add URL(s) from clipboard to download queue
- **Remove Link** - Remove URL from download queue
- **Exit** - Exit the program

### Command Line

```bash
# Add a link to download queue
dlmgr add "https://example.com/file.zip" "$HOME/Downloads"

# Add a link using default directory
dlmgr add "https://example.com/file.zip"

# Start downloading
dlmgr start

# Stop downloading
dlmgr stop

# Remove a link (opens menu)
dlmgr remove
```

## Workflow Examples

### Single File Download

1. Copy download URL to clipboard
2. Run `dlmgr`
3. Select "Add Link"
4. Select the URL or "All"
5. Choose download directory
6. Select "Start Download"
7. Choose progress display mode (Terminal/Notification/Don't Show)

### Batch Download

1. Copy multiple URLs to clipboard (one per line)
2. Run `dlmgr`
3. Select "Add Link"
4. Select "All" when prompted
5. Choose download directory
6. Select "Start Download"

### Quick Add from Command Line

```bash
# Copy URL to clipboard, then:
dlmgr add "$(wl-paste)" "$HOME/Downloads"

# Or for X11:
dlmgr add "$(xclip -o)" "$HOME/Downloads"
```

## Configuration

### Data Directory

All download lists and logs are stored in:
```
~/.local/share/aria2/
├── dl_list       # Current download queue
├── dl_completed  # Completed downloads log
└── dl_error      # Failed downloads log (if any errors occur)
```

### Download Directory

Default: Configured in the script (line 8)

You can change this by:
1. Editing the `dl_dir` variable in the `dlmgr` script, or
2. Choosing a different directory each time you add a link

### Download List Format

The `dl_list` file uses aria2c's input file format:
```
https://example.com/file1.zip
    dir=/path/to/download
https://example.com/file2.zip
    dir=/path/to/download
```

You can manually edit `~/.local/share/aria2/dl_list` to add or modify downloads.

### aria2c Settings

The script uses these aria2c options:
- `-c` - Continue/resume downloads
- `-x 16` - Use up to 16 connections per download
- `-s 16` - Split downloads into 16 segments
- `-k 1M` - Keep segments at least 1MB in size
- `-j 1` - Download 1 file at a time (sequential)

To modify these, edit the `start_download()` function in the script.

## Progress Display Modes

### Terminal Mode
- Opens a new terminal window
- Shows detailed aria2c progress output
- Best for monitoring large downloads

### Notification Mode
- Shows desktop notifications with progress percentage
- Minimal UI disruption
- Updates every second

### Don't Show Mode
- Silent background downloads
- Still sends start/complete/error notifications
- Best for unattended downloads

## Advanced Usage

### Resume Downloads

Downloads are automatically resumed if interrupted. Just run `dlmgr start` again.

### Priority Downloads

Edit `~/.local/share/aria2/dl_list` to reorder URLs - files at the top download first.

### Custom aria2c Options

Add a custom aria2c config file at `~/.aria2/aria2.conf`:
```
# Example aria2.conf
max-connection-per-server=16
min-split-size=1M
continue=true
file-allocation=falloc
max-concurrent-downloads=1
```

### Keyboard Shortcuts

Bind `dlmgr` to a keyboard shortcut in your window manager:

```bash
# i3/sway config
bindsym $mod+d exec dlmgr

# Hyprland config
bind = $mod, D, exec, dlmgr

# Quick add from clipboard
bindsym $mod+Shift+d exec dlmgr add "$(wl-paste)" "$HOME/Downloads" && dlmgr start
```

## Notification IDs

The script uses specific notification IDs to update notifications in place:
- `2224` - Download progress notifications
- `2225` - Status notifications (pause, error, etc.)

These won't conflict with other applications unless they use the same IDs.

## Troubleshooting

### Menu doesn't appear
- Make sure `$MENU` environment variable is set
- Test your menu: `echo "test" | $MENU`
- Common values: `fuzzel -d`, `dmenu`, `rofi -dmenu`, `wofi -d`

### Clipboard not working
- For X11: Install `xclip`
- For Wayland: Install `wl-clipboard`
- Test clipboard: `wl-paste` or `xclip -o`

### exec-terminal not found
Replace `exec-terminal` with your terminal emulator:
- `kitty` → `kitty -e`
- `alacritty` → `alacritty -e`
- `foot` → `foot`
- `xterm` → `xterm -e`
- `gnome-terminal` → `gnome-terminal --`

Edit line 24 and other `exec-terminal` occurrences in the script.

### Downloads fail
- Check internet connection
- Verify the URL is accessible
- Check disk space
- Review `~/.local/share/aria2/dl_error` for failed downloads

### Icons not showing
If notification icons aren't working, you can:
1. Add SVG/PNG icon files to `~/.local/bin/download_manager/`
2. Or change icon paths in scripts to use system icons:
   ```bash
   # In dl_nf_start, change:
   -i "$HOME/.local/bin/download_manager/download.svg"
   # To:
   -i "emblem-downloads"  # System icon name
   ```

### Permission denied
- Make sure scripts are executable: `chmod +x dlmgr dl_nf_*`
- Check download directory is writable

## Tips & Tricks

### Download from Browser
1. Right-click a link → Copy link address
2. Run `dlmgr` → Add Link → Start Download

### Batch Download from File
```bash
# If you have a file with URLs (one per line)
cat urls.txt | xclip -selection clipboard  # X11
cat urls.txt | wl-copy                     # Wayland
# Then run dlmgr → Add Link → All
```

### Monitor Downloads
```bash
# Watch the download list
watch -n 1 cat ~/.local/share/aria2/dl_list

# Check completed downloads
cat ~/.local/share/aria2/dl_completed

# Check failed downloads
cat ~/.local/share/aria2/dl_error
```

### Integration with Other Tools
```bash
# Download all images from a webpage
curl https://example.com | grep -oP 'https://[^"]+\.jpg' | wl-copy
# Then: dlmgr → Add Link → All

# Download with custom script
dlmgr add "https://example.com/file.zip" && 
dlmgr start && 
notify-send "Downloads queued"
```

## File Structure

```
~/.local/bin/download_manager/
├── dlmgr              # Main script
├── dl_nf_start        # Start notification hook
├── dl_nf_complete     # Complete notification hook
├── dl_nf_error        # Error notification hook
├── download.svg       # (Optional) Downloading icon
├── complete.svg       # (Optional) Complete icon
├── pause.svg          # (Optional) Pause icon
└── error.svg          # (Optional) Error icon

~/.local/share/aria2/
├── dl_list            # Download queue
├── dl_completed       # Completed log
└── dl_error           # Error log
```

## Why aria2c?

aria2c is:
- **Fast** - Multi-connection downloads
- **Reliable** - Resume support, retry logic
- **Lightweight** - Low resource usage
- **Versatile** - Supports HTTP, HTTPS, FTP, BitTorrent
- **Well-maintained** - Active development and wide adoption

## Related Projects

- **ytmgr** - Similar manager for YouTube videos using yt-dlp
- **aria2c** - The underlying download utility
- **aria2p** - Python interface for aria2c (alternative approach)

## Contributing

Feel free to modify the scripts for your needs. Common modifications:
- Change default directories
- Adjust aria2c parameters for faster/slower downloads
- Add more notification types
- Integrate with other tools

## License

These scripts are provided as-is for personal use. Modify freely.

## Credits

Uses aria2c by Tatsuhiro Tsujikawa and contributors.
