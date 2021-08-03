use v6.d;

use Sway::Config::Grammar:auth($?DISTRIBUTION.meta<auth>);
use Sway::Config::Utils:auth($?DISTRIBUTION.meta<auth>) :config;

unit class Sway::Config::Actions:auth($?DISTRIBUTION.meta<auth>);

has IO::Path $.config_dir;
has %.variable;
has %.mode;
has %.key_binding;
has @.key_bindings;

method TOP ($/) {
    make $<config>».made;
}

method comment ($/) {
    make ~$/;
}

my rule set_bind_mode {
    ^^['bind'\S+ | 'mode' | 'set'] $<option>=['--'\S+]* %% \s* $<name>=\S+ $<value>=\N+
}

method config ($match) {
    my $command = $match<command>.made;
    my $command_option = $match<command_option>».made || Empty;
    my $value = $match<value>.made // Empty;
    my $config = join ' ', $command, $command_option || Empty, $value;

    $match.make: do with $match<block> {
        slip $config X[&(* ~ ' ' ~ *)] .made;
    } else {
        $config;
    }

    for $match.made -> $made_config {
        with $command {
            when 'set' {
                %!variable{~$<name>} = ~$<value> if $made_config ~~ &set_bind_mode;
            }
            when 'include' {
                $!config_dir //= get_config_path.parent;
                with get_file_content $!config_dir, ~$made_config.words.tail(*-1) -> $config {
                    $match.make: Sway::Config::Grammar.subparse($config, actions => self).made.Slip;
                }
            }
            when *.starts-with: 'bind' {
                if $made_config ~~ &set_bind_mode {
                    my @options = .words with $<option>;

                    %!key_binding{~$<name>}<command> = ~$<value>;
                    %!key_binding{~$<name>}<options> = @options;

                    @!key_bindings.append: ~$<name> => %(
                        command => ~$<value>,
                        options => @options
                    );
                }
            }
            when 'mode' {
                if $made_config ~~ &set_bind_mode -> $mode_match {
                    my Bool:D $pango_markup = $mode_match<option> ~~ '--pango_markup';

                    my $mode_name = do if $pango_markup {
                        ~$mode_match<name>;
                    } else {
                        $mode_match<name>.subst: /<["']>/, '', :g;
                    }

                    my $sub_command = ~$mode_match<value>;

                    %!mode{$mode_name}<pango_markup> = $pango_markup;
                    %!mode{$mode_name}<sub_commands>.append: $sub_command;

                    if $sub_command ~~ &set_bind_mode {
                        my $name = ~$<name>;
                        my $value = ~$<value>;
                        my @options = .words with $<option>;

                        %!mode{$mode_name}<key_binding>{$name}<command> = $value;
                        %!mode{$mode_name}<key_binding>{$name}<options> = @options;

                        %!mode{$mode_name}<key_bindings>.append: $name => %(
                            command => $value,
                            options => @options
                        );

                        with %!key_binding{$name}<command> {
                            %!key_binding{$name}:delete when $value;
                        }

                        with @!key_bindings.first: { .key eq $name and .value<command> eq $value }, :k {
                            @!key_bindings.splice: $_, 1;
                        }
                    }
                }
            }
        }
    }
}

method command_option ($/) {
    make ~$/;
}

method block ($/) {
    make $/.caps.hyper.map: {
        |.value.made unless .key eq 'comment';
    }
}

method inner_block ($/) {
    make ($<value>.made // Empty) X[&(* ~ ' ' ~ *)] $<block>.made;
}

method command ($/) {
    with $<variable_name> {
        make .made;
    } else {
        make ~$/;
    }
}

method config_command ($/) {
    make ~$/;
}

method common_command ($/) {
    make ~$/;
}

method input_command ($/) {
    make ~$/;
}

method output_command ($/) {
    make ~$/;
}

method criteria ($/) {
    make ~$/;
}

method value ($/) {
    make $/.caps.hyper.map(*.value.made).grep(&so).join;
}

method variable_name ($/) {
    make %!variable{~$/} // ~$/;
}

method backslash_newline ($/) {
    make ~$/;
}

method generic_value ($/) {
    make ~$/;
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