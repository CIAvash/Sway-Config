use v6.d;

use JSON::Fast;

unit module Sway::Config::Utils:auth($?DISTRIBUTION.meta<auth>);

=SUBROUTINE

#| Gets the config from Sway, using C<swaymsg>, then returns the config as C<Str>
sub get_config returns Str:D is export(:config) {
    my $sway = run <swaymsg -t get_config>, :out;
    my $config = from-json($sway.out.slurp: :close)<config>;

    CATCH {
        when X::AdHoc {
            note 'Sway::Config: Could not get config.'
        }
    }

    $config;
}

#| Gets the config path from Sway, using C<swaymsg> and returns its IO::Path
sub get_config_path returns IO::Path:D is export(:config) {
     run <swaymsg -t get_version -r>, :out
     andthen .out.slurp: :close
     andthen my IO::Path $config_path .= new: .&from-json<loaded_config_file_name>;

    CATCH {
        when X::AdHoc {
            note 'Sway::Config: Could not get config path.';
        }
    }

    $config_path
}

#| Gets the config file content, using config path and directory(for getting files if sehll expansion is used)
#| and returns its IO::Path
sub get_file_content (IO::Path:D() $config_dir, IO::Path:D() $path is copy --> Str:D) is export(:config) {
    shell "echo -ne $path", :out andthen my @files = .out.slurp: :close;

    CATCH {
        when X::AdHoc {
            note "Sway::Config: Could not find the file. $_." and exit 1
        }
    }

    indir $config_dir, { @files».IO.grep(* ~~ :f & :r)».slurp.join("\n") }
}

#| Convert a raw C<Grammar> C<Match> object to a C<Seq> of key value pair of configs(as C<Str>)
sub match_to_strs (Match $match --> Seq) is export(:match) {
    flat $match.caps.hyper.map: -> (:$key, :$value) {
        my $cap = $key => $value.caps ?? samewith $value !! ~$value;

        if $key eq any <command config_command> and $cap.value !~~ Str {
            $key => $cap.value.hash;
        } else {
            $cap;
        }
    }
}

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
