# ZephyrRuby

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add zephyr_ruby

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install zephyr_ruby

## Usage

To get started all you need to do is set your zephyr API access token and instantiate the client.

For API endpoint usage see the official REST API documentation [here](https://support.smartbear.com/zephyr-scale-cloud/api-docs/#section/Introduction).

```ruby
require 'zephyr_ruby'

@client = ZephyrRuby::Client.new('YOUR_API_KEY')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/zephyr_ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
