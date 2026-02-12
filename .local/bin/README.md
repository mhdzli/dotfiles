# Scripts — `~/.local/bin`

A collection of utility shell scripts for Linux, primarily targeting Wayland compositors (Sway/Hyprland) with support for menu-driven interfaces via `$MENU` (fuzzel, rofi, dmenu, fzf, etc.).

---

## Table of Contents

- [Dependencies](#dependencies)
- [Scripts](#scripts)
  - [wayscreenshot](#wayscreenshot)
  - [wayrecord](#wayrecord)
  - [screenshare](#screenshare)
  - [phone-control](#phone-control)
  - [fzf-bluetooth](#fzf-bluetooth)
  - [noisereduce](#noisereduce)
  - [tum](#tum)
  - [menusysmon](#menusysmon)
  - [exec-terminal](#exec-terminal)
  - [prompt](#prompt)
  - [update](#update)
- [Environment Variables](#environment-variables)
- [Installation](#installation)
- [Known Issues](#known-issues)

---

## Dependencies

| Script | Dependencies |
|---|---|
| wayscreenshot | `grim`, `slurp`, `swaymsg`, `jq` |
| wayrecord | `wf-recorder`, `swaymsg`, `jq` |
| screenshare | `wf-recorder`, `v4l2loopback-dkms`, `v4l2-utils` |
| phone-control | `adb`, `scrcpy`, `fzf` or `$MENU` |
| fzf-bluetooth | `fzf`, `bluetoothctl`, `rfkill` |
| noisereduce | `ffmpeg`, `sox` |
| tum | `ffmpeg`, `songrec` (optional) |
| menusysmon | `$MENU`, `htop`, `upower`, `nmcli` |

---

## Scripts

---

### wayscreenshot

Take screenshots on Wayland using `grim` and `slurp`.

**Dependencies:** `grim`, `slurp`, `swaymsg`, `jq`

**Usage:**

```sh
wayscreenshot
```

Opens a menu prompting you to select the screenshot type:

| Option | Description |
|---|---|
| `fullscreen` | Capture the entire screen |
| `region` | Select an arbitrary region with `slurp` |
| `focused` | Capture the currently focused window |
| `[window name]` | Select from a list of visible windows |

Output files are saved in the current directory with the following naming conventions:
- `pic-full-YYYY-MM-DD-HHMMss_screenshot.png`
- `pic-selected-...`
- `pic-focused-...`
- `pic-window-...`

**`list_geometry` function:**

An internal helper that queries `swaymsg` and parses the output with `jq` to retrieve the position and dimensions of Sway windows. Accepts `focused` or `visible` as the first argument, and optionally `with_description` as the second to also return the window title.

```sh
list_geometry focused                   # coordinates only
list_geometry visible with_description  # coordinates + window title
```

---

### wayrecord

Screen recorder for Wayland using `wf-recorder`.

**Dependencies:** `wf-recorder`, `swaymsg`, `jq`

**Usage:**

```sh
wayrecord              # open recording mode menu
wayrecord screencast   # record screen + audio
wayrecord video        # record screen only
wayrecord window       # record a specific window
wayrecord vaapi        # record using GPU hardware acceleration
wayrecord kill         # stop the current recording
```

**Recording modes:**

| Mode | Output filename | Codec | Description |
|---|---|---|---|
| `screencast` | `screencast-YYMMdd-HHmm-SS.mkv` | `libx264rgb` | Screen + microphone |
| `video` | `video-YYMMdd-HHmm-SS.mkv` | `libx264` | Video only |
| `window` | `window-YYMMdd-HHmm-SS.mkv` | `libx264rgb` | Selected window |
| `vaapi` | `video-YYMMdd-HHmm-SS.mkv` | `h264_vaapi` | GPU-accelerated encoding |

Files are saved to `$HOME`. The recording process PID is stored in `/tmp/recordingpid` so it can be stopped later.

If a recording is already in progress when the script is launched again, the user is asked whether to end it.

---

### screenshare

Share your screen as a virtual webcam for video conferencing applications on Wayland.

**Dependencies:** `wf-recorder`, `v4l2loopback-dkms`, `v4l2-utils`

**Usage:**

```sh
screenshare -s | --start    # start sharing
screenshare -p | --stop     # stop sharing
screenshare -h | --help     # show help
```

**How it works:**

1. Loads the `v4l2loopback` kernel module and creates a virtual device named `VirtualVideoDevice`
2. Uses `wf-recorder` to capture the screen as rawvideo and pipe it into the virtual device at `/dev/video2`
3. In your video conferencing app (Zoom, Google Meet, etc.), select `VirtualVideoDevice` as your camera

To verify it is working:
```sh
ffplay /dev/video2
# or
mpv av://v4l2:/dev/video2
```

> **Arch Linux note:** The script automatically checks for the presence of `v4l2loopback-dkms` and `wf-recorder` on Arch-based systems.

---

### phone-control

Control an Android device from your desktop using `adb` and `scrcpy`.

**Dependencies:** `adb`, `scrcpy`, `fzf` or `$MENU`

**Usage:**

```sh
phone-control
```

**Features:**

- USB or wireless (TCP/IP) connection
- Screen mirroring at various resolutions and framerates
- Phone screen recording
- Phone screenshot capture
- Front/back camera as a webcam source
- File transfer (push/pull) with progress display
- Launch installed applications
- OTG support (USB connection)

**Connection:**

If no device is detected, the script asks whether to use wireless debugging and prompts for the device IP address.

**Audio options:**

| Option | Description |
|---|---|
| No Audio | Disable audio forwarding |
| playback | Forward phone audio playback |
| output | Forward phone audio output |
| mic | Use phone microphone |

**File transfer progress modes:**

| Mode | Description |
|---|---|
| Terminal | Display progress in a terminal window |
| Notification | Display progress as desktop notifications |
| Don't Show | Transfer silently |

> **Note:** For wireless debugging, the phone must first be connected via USB and `adb tcpip 5555` must run at least once.

---

### fzf-bluetooth

A Bluetooth manager using `fzf` — a port of [rofi-bluetooth](https://github.com/nickclyde/rofi-bluetooth).

**Upstream:** [varbhat/fzf-bluetooth](https://github.com/varbhat/fzf-bluetooth)

**Dependencies:** `fzf`, `bluetoothctl`, `rfkill`

**Usage:**

```sh
fzf-bluetooth           # open main menu
fzf-bluetooth --status  # print status string for status bars
```

**Main menu:**

| Option | Description |
|---|---|
| Power: on/off | Toggle the Bluetooth controller |
| Scan: on/off | Scan for new devices (runs for 5 seconds) |
| Pairable: on/off | Toggle pairable state |
| Discoverable: on/off | Toggle discoverable state |
| [device name] | Open the device submenu |

**Device submenu:**

| Option | Description |
|---|---|
| Connected: yes/no | Connect or disconnect |
| Paired: yes/no | Pair or remove pairing |
| Trusted: yes/no | Trust or untrust |

**Status bar integration:**

```sh
# polybar
exec = fzf-bluetooth --status

# waybar
"exec": "fzf-bluetooth --status"
```

`--status` prints the Bluetooth icon with connected device names when powered on, or the off icon when powered off.

---

### noisereduce

Remove background noise from audio and video files using `sox` and `ffmpeg`.

**Dependencies:** `ffmpeg`, `sox`

**Usage:**

```sh
noisereduce <input_file> <output_file>
```

**Examples:**

```sh
noisereduce video.mp4 video-clean.mp4
noisereduce podcast.wav podcast-clean.wav
```

**How it works:**

1. Detects whether the input is a video or audio file
2. Prompts for the start and end time of a noise sample (defaults to the first 0.9 seconds)
3. Prompts for noise reduction sensitivity (default: `0.21`)
4. Extracts a noise profile with `sox noiseprof`
5. Applies the `noisered` filter to the audio
6. Remuxes the cleaned audio back into the video container (if input was video)

**Parameters:**

| Parameter | Default | Description |
|---|---|---|
| Sample start | `00:00:00` | Start of the noise sample |
| Sample end | `00:00:00.900` | End of the noise sample |
| Sensitivity | `0.21` | Noise reduction strength (higher = more aggressive) |

> **Tip:** Best results when the first few tenths of a second contain only background noise with no speech or music.

---

### tum

Manage audio file metadata tags.

**Dependencies:** `ffmpeg`, `songrec` (only for `--songrc`)

**Usage:**

```sh
tum [option] [music_directory]
```

If `music_directory` is not specified, defaults to `~/Music/`.

**Options:**

| Option | Description |
|---|---|
| `-h`, `--help` | Show help message |
| `-l`, `--lowerext` | Lowercase all file extensions in the directory |
| `-t`, `--types` | List all unique file extensions found |
| `-c`, `--clear` | Strip all metadata from audio files |
| `-s`, `--songrc` | Identify songs with `songrec` and set tags automatically |

**Supported formats:** `mp3`, `ogg`, `m4a`, `wma`, `wav`

**`--songrc` option:**

Uses [SongRec](https://github.com/marin-m/songrec) to identify each track via audio fingerprinting and automatically writes `title`, `artist`, `album`, `genre`, and `date` tags using `ffmpeg`. Unrecognized files are logged to a `notfound` file in the working directory.

---

### menusysmon

A menu-driven system monitoring and information tool.

**Dependencies:** `$MENU`, `htop`, `nmcli`, `upower`, `lspci`, `lsblk`

**Usage:**

```sh
menusysmon
```

Requires the `$MENU` environment variable to be set (e.g. `fuzzel -d`, `rofi -dmenu`, `dmenu`).

**Menu sections:**

| Option | Description | Tools used |
|---|---|---|
| `VGA` | GPU info and display list | `lspci`, `xrandr` / `wlr-randr` |
| `audio` | Sound card info and active audio devices | `lspci`, `aplay`, `pactl` |
| `memory` | RAM usage | `free` |
| `disk` | Disk usage, partitions, block devices | `df`, `lsblk`, `hdparm` / `nvme`, `blkid` |
| `cpu` | CPU information | `/proc/cpuinfo`, `lscpu` |
| `System` | Launch a system monitor program | `htop`, `glances`, `gtop`, etc. |
| `clockset` | View and sync system clock | `timedatectl`, `hwclock`, `ntpd` |
| `battery` | Battery status | `upower` |
| `network` | Network interfaces, IPs, open ports | `nmcli`, `ip`, `ss` / `netstat` |

**System submenu:**

Monitoring programs are launched in `$TERMINAL` (falls back to `alacritty`):

| Programs | Requires sudo |
|---|---|
| `htop`, `glances`, `gtop`, `nmon`, `s-tui` | No |
| `iftop`, `iotop`, `powertop`, `iptraf-ng` | Yes |

**Network submenu:**

| Option | Description |
|---|---|
| `general` | NetworkManager status, interfaces, DNS |
| `ip` | Local addresses + public IP (via `curl`) |
| `ports` | Listening ports (via `ss` or `netstat`) |

---

### exec-terminal

Runs a command in a standalone terminal window. Uses the `$TERMINAL` environment variable to determine which terminal emulator to launch.

---

### prompt

Displays a yes/no confirmation dialog via `$MENU`. Typically called by other scripts (e.g. `wayrecord`) rather than directly.

---

### update

System package update script. Uses `$TERMINAL` and the distribution's package manager to run updates in a terminal window.

---

## Environment Variables

| Variable | Description | Examples |
|---|---|---|
| `$MENU` | Menu program used for interactive selection | `fuzzel -d`, `rofi -dmenu`, `dmenu`, `fzf` |
| `$TERMINAL` | Preferred terminal emulator | `alacritty`, `kitty`, `foot` |

Add these to `~/.profile` or your compositor config (e.g. `~/.config/sway/config`):

```sh
export MENU="fuzzel -d"
export TERMINAL="alacritty"
```

---

## Installation

Place scripts in `~/.local/bin/` and make them executable:

```sh
chmod +x ~/.local/bin/*
```

Ensure `~/.local/bin` is in your `$PATH`:

```sh
echo $PATH | grep -q "$HOME/.local/bin" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.profile
```

---

