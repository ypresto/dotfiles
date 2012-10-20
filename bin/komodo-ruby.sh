#!/usr/bin/env bash

script_dir="`dirname $0`"
komodo_path="$script_dir/../komodo_remote_debug_712/ruby"
RUBYDB_LIB=$komodo_path \
RUBYDB_OPTS="HOST=localhost PORT=9000" \
ruby -I$komodo_path -r $komodo_path/rdbgp.rb "$@"
