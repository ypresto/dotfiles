#!/usr/bin/env bash


script_dir="`dirname $0`"
komodo_path="$script_dir/../komodo_remote_debug_712/perl" 
PERL5LIB="$PERL5LIB:$komodo_path" \
PERL5DB="BEGIN { require q($komodo_path/perl5db.pl) }" \
PERLDB_OPTS="RemotePort=localhost:9000" \
DBGP_IDEKEY="whatever" \
/usr/bin/env perl -d "$@"
