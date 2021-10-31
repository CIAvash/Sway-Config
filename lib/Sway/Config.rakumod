use v6.d;

use JSON::Fast;

use Sway::Config::Utils:auth($?DISTRIBUTION.meta<auth>) :config, :match;
use Sway::Config::Grammar:auth($?DISTRIBUTION.meta<auth>);
use Sway::Config::Actions:auth($?DISTRIBUTION.meta<auth>);

=NAME Sway::Config - a L<Raku|https://www.raku-lang.ir/en> module for parsing L<Sway|https://swaywm.org/> window manager's config.

=DESCRIPTION Sway::Config is a module for parsing L<Sway|https://swaywm.org/> window manager's config,
and getting the raw C<Match>, configs, variables, modes and key bindings, either as Raku data structures or as
JSON.

=begin SYNOPSIS
=begin code :lang<raku>
use Sway::Config:auth<zef:CIAvash>;

# By default Sway::Config gets the config from Sway
my $config = Sway::Config.new;

# Giving the config content to Sway::Config
my $config2 = Sway::Config.new: :config('Your Config Here');

# Giving path of a config file to Sway::Config
my $config3 = Sway::Config.new: :config_path<Path to config file>;

put $config.match;

put $config.mode<resize>;

put $config.configs: :json;

=end code

=end SYNOPSIS

=begin INSTALLATION

You need to have L<Raku|https://www.raku-lang.ir/en> and L<zef|https://github.com/ugexe/zef>,
then run:

=begin code :lang<console>

zef install --/test "Sway::Config:auth<zef:CIAvash>"

=end code

or if you have cloned the repo:

=begin code :lang<console>

zef install .

=end code

=end INSTALLATION

=begin TESTING

=begin code :lang<console>

prove -ve 'raku -I.' --ext rakutest

=end code

=end TESTING

unit class Sway::Config:auth($?DISTRIBUTION.meta<auth>):ver($?DISTRIBUTION.meta<version>);

=ATTRIBUTES

has Str   $.config;      #= Content of the config to parse
has IO()  $.config_path; #= Path to the config file

has Match $!match;       #= The raw match object

=METHODS

submethod TWEAK {
    my IO::Path $config_dir;

    $!config_path //= get_config_path unless $!config;

    with $!config_path {
        $config_dir = .parent;
        $!config //= .slurp;
    }

    unless $!config or ($!config_path and $!config_path.f) {
        note 'Sway::Config: Need at least a config or config path' and exit 1;
    }

    $!match = Sway::Config::Grammar.subparse: $!config, actions => Sway::Config::Actions.new: :$config_dir;
}

#| Returns the raw match object
multi method match returns Match {
    $!match;
}

#| Returns the raw C<Match> object as JSON
multi method match (Bool:D :json($) --> Str) {
    to-json :sorted-keys, match_to_strs $!match;
}

#| Returns the parsed confis as an C<Array>
multi method configs returns Array {
    $!match.made;
}

#| Returns the parsed confis as JSON
multi method configs (Bool:D :json($) --> Str) {
    to-json callsame;
}

#| Returns the parsed variables as a C<Hash>
multi method variable returns Hash {
    $!match.actions.variable;
}

#| Returns the parsed variables as JSON
multi method variable (Bool:D :json($) --> Str) {
    to-json :sorted-keys, callsame;
}

#| Returns the parsed modes as a C<Hash>
multi method mode returns Hash {
    $!match.actions.mode;
}

#| Returns the parsed modes as JSON
multi method mode (Bool:D :json($) --> Str) {
    to-json :sorted-keys, callsame;
}

#| Returns the parsed key bindings as a C<Hash>
multi method key_binding returns Hash {
    $!match.actions.key_binding;
}

#| Returns the parsed key bindings as JSON (Object/Hash)
multi method key_binding (Bool:D :json($) --> Str) {
    to-json :sorted-keys, callsame;
}

#| Returns the parsed key bindings as a C<List>
multi method key_bindings returns List {
    $!match.actions.key_bindings;
}

#| Returns the parsed key bindings as JSON (Array)
multi method key_bindings (Bool:D :json($) --> Str) {
    to-json :sorted-keys, callsame;
}

#| Returns the parsed configs, variables, modes and key bindings as a C<Hash>
multi method all returns Hash {
    {
        configs => self.configs,
        variable => self.variable,
        mode => self.mode,
        key_binding => self.key_binding,
        key_bindings => self.key_bindings,
    };
}

#| Returns the parsed configs, variables, modes and key bindings as JSON
multi method all (Bool:D :json($) --> Str) {
    to-json :sorted-keys, callsame;
}

=REPOSITORY L<https://github.com/CIAvash/Sway-Config/>

=BUG L<https://github.com/CIAvash/Sway-Config/issues>

=AUTHOR Siavash Askari Nasr - L<https://www.ciavash.name>

=COPYRIGHT Copyright © 2021 Siavash Askari Nasr

=begin LICENSE
This file is part of Sway::Config.

Sway::Config is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Sway::Config is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Sway::Config.  If not, see <http://www.gnu.org/licenses/>.
=end LICENSE
