use v6.d;

use Pod::Contents:auth<zef:CIAvash>;

use Sway::Config:auth($?DISTRIBUTION.meta<auth>);

unit module Sway::Config::CLI:auth($?DISTRIBUTION.meta<auth>):ver(v0.1.0);

=NAME sway-config

=TITLE sway-config - Parses Sway config and prints the specified section

=begin DESCRIPTION
By default gets the config from sway, unless config or config path is provided via stdin or command option.

Then parses the config and prints the requested output as JSON.
=end DESCRIPTION

my Sway::Config $config;

my $app_name        = $=pod.&join_pod_contents_of: 'NAME';
my $app_title       = $=pod.&join_pod_contents_of: 'TITLE';
my $app_description = $=pod.&join_pod_contents_of: 'DESCRIPTION';

constant $app_version   = $?MODULE.^ver;
constant $app_copyright = q:to/END/;
Copyright (C) 2021 Siavash Askari Nasr.

License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
This program comes with NO WARRANTY.
END

#| Prints configs, variables, modes, key_bindings as JSON
proto MAIN (Bool :i(:$stdin), Str :c(:$config-path), |) is export {
    $config = do if $stdin {
        Sway::Config.new: config => $*IN.slurp, config_path => $config-path;
    } elsif $config-path {
        Sway::Config.new: config_path => $config-path;
    } else {
        Sway::Config.new;
    }
    {*}
}

#| Prints version
multi MAIN (Bool:D :v(:$version)!) {
    put "$app_name v$app_version\n";

    print $app_copyright;
}

#| Prints configs, variables, modes and key_bindings as JSON
multi MAIN ('all', Bool :i(:$stdin), Str :c(:$config-path)) {
    put $config.all: :json;
}

#| Prints configs as JSON
multi MAIN ('configs', Bool :i(:$stdin), Str :c(:$config-path)) {
    put $config.configs: :json;
}

#| Prints raw match as JSON
multi MAIN ('match', Bool :i(:$stdin), Str :c(:$config-path)) {
    put $config.match: :json;
}

#| Prints variables as JSON
multi MAIN ('variable', Bool :i(:$stdin), Str :c(:$config-path)) {
    put $config.variable: :json;
}

#| Prints modes as JSON
multi MAIN ('mode', Bool :i(:$stdin), Str :c(:$config-path)) {
    put $config.mode: :json;
}

#| Prints key bindings as JSON (Object/Hash)
multi MAIN ('key_binding', Bool :i(:$stdin), Str :c(:$config-path)) {
    put $config.key_binding: :json;
}

#| Prints key bindings as JSON (Array)
multi MAIN ('key_bindings', Bool :i(:$stdin), Str :c(:$config-path)) {
    put $config.key_bindings: :json;
}

sub USAGE is export {
    put $app_title, "\n";
    put $app_description, "\n";

    put $*USAGE;
}

=REPOSITORY L<https://github.com/CIAvash/Sway-Config/>

=BUG L<https://github.com/CIAvash/Sway-Config/issues>

=AUTHOR Siavash Askari Nasr - L<https://www.ciavash.name>

=COPYRIGHT Copyright © 2021 Siavash Askari Nasr

=begin LICENSE
sway-config is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

sway-config is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with sway-config.  If not, see <http://www.gnu.org/licenses/>.
=end LICENSE
