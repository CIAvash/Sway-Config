NAME
====

Sway::Config - A [Raku](https://www.raku-lang.ir/en) library and script for parsing [Sway](https://swaywm.org/) window manager's config.

DESCRIPTION
===========

Sway::Config is a module and program for parsing [Sway](https://swaywm.org/) window manager's config, and getting the raw `Match`, configs, variables, modes and key bindings, either as Raku data structures or as JSON.

INSTALLATION
============

You need to have [Raku](https://www.raku-lang.ir/en) and [zef](https://github.com/ugexe/zef), then run:

```console
zef install --/test "Sway::Config:auth<zef:CIAvash>"
```

or if you have cloned the repo:

```console
zef install .
```

TESTING
=======

```console
prove -ve 'raku -I.' --ext rakutest
```

CLI
===

## SYNOPSIS
```
sway-config - Parses Sway config and prints the specified section

By default gets the config from sway, unless config or config path is provided via stdin or command option.

Then parses the config and prints the requested output as JSON.

Usage:
  bin/sway-config -v|--version -- Prints version
  bin/sway-config all [-i|--stdin] [-c|--config-path=<Str>] -- Prints configs, variables, modes and key_bindings as JSON
  bin/sway-config configs [-i|--stdin] [-c|--config-path=<Str>] -- Prints configs as JSON
  bin/sway-config match [-i|--stdin] [-c|--config-path=<Str>] -- Prints raw match as JSON
  bin/sway-config variable [-i|--stdin] [-c|--config-path=<Str>] -- Prints variables as JSON
  bin/sway-config mode [-i|--stdin] [-c|--config-path=<Str>] -- Prints modes as JSON
  bin/sway-config key_binding [-i|--stdin] [-c|--config-path=<Str>] -- Prints key bindings as JSON (Object/Hash)
  bin/sway-config key_bindings [-i|--stdin] [-c|--config-path=<Str>] -- Prints key bindings as JSON (Array)
```

## COPYRIGHT

Copyright © 2021 Siavash Askari Nasr

## LICENSE

sway-config is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

sway-config is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with sway-config. If not, see <http://www.gnu.org/licenses/>.

LIBRARY
=======

## SYNOPSIS

```raku
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
```

## ATTRIBUTES

### has Str $.config

Content of the config to parse

### has IO() $.config_path

Path to the config file

## METHODS

### multi method match

```raku
multi method match() returns Match
```

Returns the raw match object

### multi method match

```raku
multi method match(
    Bool:D :json($)
) returns Str
```

Returns the raw `Match` object as JSON

### multi method configs

```raku
multi method configs() returns Array
```

Returns the parsed confis as an `Array`

### multi method configs

```raku
multi method configs(
    Bool:D :json($)
) returns Str
```

Returns the parsed confis as JSON

### multi method variable

```raku
multi method variable() returns Hash
```

Returns the parsed variables as a `Hash`

### multi method variable

```raku
multi method variable(
    Bool:D :json($)
) returns Str
```

Returns the parsed variables as JSON

### multi method mode

```raku
multi method mode() returns Hash
```

Returns the parsed modes as a `Hash`

### multi method mode

```raku
multi method mode(
    Bool:D :json($)
) returns Str
```

Returns the parsed modes as JSON

### multi method key_binding

```raku
multi method key_binding() returns Hash
```

Returns the parsed key bindings as a `Hash`

### multi method key_binding

```raku
multi method key_binding(
    Bool:D :json($)
) returns Str
```

Returns the parsed key bindings as JSON (Object/Hash)

### multi method key_bindings

```raku
multi method key_bindings() returns List
```

Returns the parsed key bindings as a `List`

### multi method key_bindings

```raku
multi method key_bindings(
    Bool:D :json($)
) returns Str
```

Returns the parsed key bindings as JSON (Array)

### multi method all

```raku
multi method all() returns Hash
```

Returns the parsed configs, variables, modes and key bindings as a `Hash`

### multi method all

```raku
multi method all(
    Bool:D :json($)
) returns Str
```

Returns the parsed configs, variables, modes and key bindings as JSON

## COPYRIGHT

Copyright © 2021 Siavash Askari Nasr

## LICENSE

Sway::Config is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Sway::Config is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with Sway::Config. If not, see <http://www.gnu.org/licenses/>.

REPOSITORY
==========

[https://github.com/CIAvash/Sway-Config/](https://github.com/CIAvash/Sway-Config/)

BUG
===

[https://github.com/CIAvash/Sway-Config/issues](https://github.com/CIAvash/Sway-Config/issues)

AUTHOR
======

Siavash Askari Nasr - [https://www.ciavash.name](https://www.ciavash.name)
