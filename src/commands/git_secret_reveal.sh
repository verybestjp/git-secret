#!/usr/bin/env bash


function reveal {
  local homedir=''
  local passphrase=''
  local force=0

  OPTIND=1

  while getopts 'hfd:p:' opt; do
    case "$opt" in
      h) _show_manual_for 'reveal';;

      f) force=1;;

      p) passphrase=$OPTARG;;

      d) homedir=$OPTARG;;

      *) _invalid_option_for 'reveal';;
    esac
  done

  shift $((OPTIND-1))
  [ "$1" = '--' ] && shift

  _user_required

  # Command logic:

  local path_mappings
  path_mappings=$(_get_secrets_dir_paths_mapping)

  local counter=0
  for line in $(cat "$path_mappings"); do
    local filename
    local path
    filename=$(_get_record_filename "$line")
    path=$(_append_root_path "$filename")

    # The parameters are: filename, write-to-file, force, homedir, passphrase
    _decrypt "$path" "1" "$force" "$homedir" "$passphrase"

    counter=$((counter+1))
  done

  echo "done. all $counter files are revealed."
}
