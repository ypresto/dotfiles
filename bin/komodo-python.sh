#!/usr/bin/env bash

script_dir="`dirname $0`"
komodo_path="$script_dir/../komodo_remote_debug_712/python" 
/usr/bin/env python -S "$komodo_path/bin/pydbgp" -d localhost:9000 "$@"
