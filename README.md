# Kafka::Retryable

Consumer failures are common for Kafka consumers, and if these are left unhandled, it can lead to data loss. There are many ways to buffer messages that cause failures and then retry them again. The aim of `kafka-retryable` is to provide multiple failure handling policies that can be used depending on the need.   

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kafka-retryable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kafka-retryable

## Usage

1. Start with declaring configuration parameters for your class using the following syntax:

```
failure_handler buffer: :kafka, 
                        dead_letter_queue: :topic_t1, 
                        exception_blacklist: [Karafka::InvalidMessageError]
```

- `dead_letter_queue`: Topic where the consumer should enqueue the failure message.
- `exception_blacklist`: List of exception classes for which the error handling logic does not apply
- `exception_blacklist`: List of exception classes for which the error handling logic should apply

If `exception_blacklist` and `exception_whitelist` are both missing, then the error handling logic will apply for all exception classes.   

`kafka_retryable` currently only supports failure buffers via `kafka`, and will soon support failure handling policies using other queueing systems for buffers and retry mechanism.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kafka-retryable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kafka::Retryable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kafka-retryable/blob/master/CODE_OF_CONDUCT.md).
