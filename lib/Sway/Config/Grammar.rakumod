use v6.d;

unit grammar Sway::Config::Grammar:auth($?DISTRIBUTION.meta<auth>);

token TOP {
    :my Bool $*inside_mode = False;
    [<comment> | <config> { $*inside_mode = False } | \s]*
}

token comment {
    '#' \N*
}

rule config {
    || <command> { with $<command> { when 'mode' { $*inside_mode = True } } } <command_option>* <value>? <block>?
    || <value> <block>?
}

token command_option {
    '--' \S+
}

token block {
    '{' ~ '}' [<comment> || \s || <?command> <config> || <inner_block> || <value>]*
}

rule inner_block {
    <value>? <block>
}

token command {
    | <config_command>
    | <common_command>
    | <criteria>
}

token common_command {
    < assign bar bindcode bindswitch bindsym
      client.background client.focused client.focused_inactive
      client.placeholder client.unfocused client.urgent default_border
      default_floating_border exec exec_always floating_maximum_size
      floating_minimum_size floating_modifier focus focus_follows_mouse
      focus_on_window_activation focus_wrapping font for_window
      force_display_urgency_hint force_focus_wrapping fullscreen gaps
      hide_edge_borders input mode mouse_warping no_focus output
      popup_during_fullscreen seat set show_marks smart_borders
      smart_gaps tiling_drag tiling_drag_threshold title_align
      titlebar_border_thickness titlebar_padding unbindcode unbindswitch
      unbindsym workspace workspace_auto_back_and_forth >
}

token config_command {
    | < default_orientation include swaybg_command swaynag_command workspace_layout xwayland >
    | <input_command>
    | <output_command>
}

token input_command {
    < input seat >
}

token output_command {
    < output >
}

token criteria {
    '[' ~ ']' <-[\]]>+
}

token value {
    [
        || <variable_name>
        || <generic_value>
        || <backslash_newline>
    ]+
}

token backslash_newline {
    \h* \\ \n
}

# Currently unused
# token runtime_command {
#     < border create_output exit floating
#       fullscreen inhibit_idle kill layout mark max_render_time move nop
#       opacity reload rename resize scratchpad shortcuts_inhibitor split
#       splith splitt splitv sticky swap title_format unmark urgent >
# }

token generic_value {
    [<!before <variable_name> | \h* <[{}\\]> \h* \n> \N]+
}

token variable_name {
    <!after ^^ \s* 'set' \s+ | '$'> '$' <[\w-]>+
}


=COPYRIGHT Copyright © 2021, 2022 Siavash Askari Nasr

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
