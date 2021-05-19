#!/usr/bin/env bash
#
# dwl-tags.sh - display dwl tags
#
# USAGE: dwl-tags.sh 1
#
# REQUIREMENTS:
#  - inotifywait ( 'inotify-tools' on arch )
#  - Launch dwl with `dwl > ~.cache/dwltags` or change $fname
#
# TAGS:
#  Name              Type    Return
#  ----------------------------------------------------
#  {tag_N}           string  dwl tags name
#  {tag_N_occupied}  bool    dwl tags state occupied
#  {tag_N_focused}   bool    dwl tags state focused
#  {layout}          string  dwl layout
#  {title}           string  client title
#
# Now the fun part
#
# Exemple configuration:
#
#     - script:
#         path: /absolute/path/to/dwl-tags.sh
#         args: [1]
#         anchors:
#           - occupied: &occupied {foreground: 57bbf4ff}
#           - focused: &focused {foreground: fc65b0ff}
#           - default: &default {foreground: d2ccd6ff}
#         content:
#           - map:
#               margin: 4
#               tag: tag_0_occupied
#               values:
#                 true:
#                   map:
#                     tag: tag_0_focused
#                     values:
#                       true: {string: {text: "{tag_0}", <<: *focused}}
#                       false: {string: {text: "{tag_0}", <<: *occupied}}
#                 false:
#                   map:
#                     tag: tag_0_focused
#                     values:
#                       true: {string: {text: "{tag_0}", <<: *focused}}
#                       false: {string: {text: "{tag_0}", <<: *default}}
#           ...
#           ... 
#           ...
#           - map:
#               margin: 4
#               tag: tag_8_occupied
#               values:
#                 true:
#                   map:
#                     tag: tag_8_focused
#                     values:
#                       true: {string: {text: "{tag_8}", <<: *focused}}
#                       false: {string: {text: "{tag_8}", <<: *occupied}}
#                 false:
#                   map:
#                     tag: tag_8_focused
#                     values:
#                       true: {string: {text: "{tag_8}", <<: *focused}}
#                       false: {string: {text: "{tag_8}", <<: *default}}
#           - list:
#               spacing: 3
#               items:
#                   - string: {text: "{layout}"}
#                   - string: {text: "{title}"}


# Variables
declare output title layout activetags selectedtags
declare -a tags name
readonly fname="$HOME"/.cache/dwltags


_cycle() {
  tags=( "1" "2" "3" "4" "5" "6" "7" "8" "9" )

  # Name of tag (optional)
  # If there is no name, number are used
  #
  # Example:
  #  name=( "" "" "" "Media" )
  #  -> return "" "" "" "Media" 5 6 7 8 9)
  name=("1:" "2:"	"3:" "4:" "5:" "6:" "7:" "8:" "9:﬎")

  for tag in "${!tags[@]}"; do
    mask=$((1<<tag))

    tag_name="tag"
    declare "${tag_name}_${tag}"
    name[tag]="${name[tag]:-${tags[tag]}}"

    printf -- '%s\n' "${tag_name}_${tag}|string|${name[tag]}"

    if (( "${selectedtags}" & mask )) 2>/dev/null; then
      printf -- '%s\n' "${tag_name}_${tag}_focused|bool|true"
      printf -- '%s\n' "title|string|${title}"
    else
      printf '%s\n' "${tag_name}_${tag}_focused|bool|false"
    fi

    if (( "${activetags}" & mask )) 2>/dev/null; then
      printf -- '%s\n' "${tag_name}_${tag}_occupied|bool|true"
    else
      printf -- '%s\n' "${tag_name}_${tag}_occupied|bool|false"
    fi
  done

  printf -- '%s\n' "layout|string|${layout}"
  printf -- '%s\n' ""

}

# Call the function here so the tags are displayed at dwl launch
_cycle

while true; do

  [[ ! -f "${fname}" ]] && printf -- '%s\n' \
      "You need to redirect dwl stdout to ~/.cache/dwltags" >&2

  inotifywait -qq --event modify "${fname}"

  # Get info from the file
  output="$(tail -n4 "${fname}")"
  title="$(echo "${output}" | grep title | cut -d ' ' -f 3- )"
  #selmon="$(echo "${output}" | grep 'selmon')"
  layout="$(echo "${output}" | grep layout | cut -d ' ' -f 3- )"

  # Get the tag bit mask as a decimal
  activetags="$(echo "${output}" | grep tags | awk '{print $3}')"
  selectedtags="$(echo "${output}" | grep tags | awk '{print $4}')"

  _cycle

done

unset -v output title layout activetags selectedtags
unset -v tags name

