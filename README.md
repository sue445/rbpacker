# Rbpacker
Bundles and minifies multiple Ruby scripts into a single file

[![test](https://github.com/sue445/rbpacker/actions/workflows/test.yml/badge.svg)](https://github.com/sue445/rbpacker/actions/workflows/test.yml)

## Example
```bash
$ cat /path/to/test.rb 
require_relative "a"
require_relative "dir/b"

$ cat /path/to/a.rb 
class A
end

$ cat /path/to/dir/b.rb 
class B
end

$ rbpacker --src-file /path/to/test.rb 
class A
end
class B
end

$ rbpacker --src-file /path/to/test.rb --dst-file /tmp/output.rb
/tmp/output.rb is created

$ rbpacker --src-file /path/to/test.rb --minify
class A;end;class B;end
```

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add rbpacker
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install rbpacker
```

## Usage
```bash
$ rbpacker --help
Usage: rbpacker [options]
        --src-file SRC_FILE          source file path
        --dst-file DST_FILE          destination file path (default: stdout)
        --minify                     whether to minify
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sue445/rbpacker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
