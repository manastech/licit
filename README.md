# Licit

Licit allows you to easily add a copyright and licensing text to the beginning of each of your Ruby files in your project. It respects magic comments, such as encoding or shebang lines, by appending the licensing text after them.

## Installation

Add this line to your application's Gemfile:

    gem 'licit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install licit

## Configuration

Licit looks for a file `licit.yml` in either the project root or the `config` folder with project-specific configuration. 

This file should look like the following:

    copyright: Copyright (C) 2013, My company
    program_name: My web application
    exclude:
    - db/schema.db
    - db/migrate/

This will make Licit generate the following text for all files except those marked for exclusion:

    # Copyright (C) 2013, My company
    #
    # This file is part of My web application.
    #
    # My web application is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.
    #
    # My web application is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.
    #
    # You should have received a copy of the GNU General Public License
    # along with My web application.  If not, see <http://www.gnu.org/licenses/>.


The complete list of settings that `licit.yml` accepts is:

* `copyright`: Copyright text including year and company name
* `program_name`: Name of the project
* `exclude`: List of files or directories to exclude from licit
* `dir`: Root directory of the project, defaults to `.`
* `license`: License header to use, currently the only supported value is `GPLv3`, but you are welcome to fork the project and add support for more

## Usage

You can check which files are missing its licensing text by runnng:

    bundle exec licit

Note that Licit will also warn you if the LICENSE file is missing in the root directory.

To instruct Licit to fix those files by prepending the licensing text, run:

    bundle exec licit fix

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
