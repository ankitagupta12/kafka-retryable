# Kafka::Retryable

Consumer failures are common for Kafka consumers, and if these are left unhandled, it can lead to data losses. There are many ways to buffer and retry messages that encounter failures. The aim of `kafka-retryable` is to provide multiple types of failure handling policies that can be used depending on the need.   

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

`kafka_retryable` allows failed messages to be buffered into a `dead_letter_queue` inside Kafka. In the future, it will provision for retry mechanisms and the ability to buffer in other messaging systems. 


1. Setup the gem by setting configuration parameters. In a rails project, this can be done inside `config/initializers/kafka_retryable.rb` for instance:

```
 Kafka::Retryable.setup do |config|
   config.failure_handling.enabled = true
   config.buffer.kafka.seed_brokers = ['kafka://localhost:9092']
 end
```

These are the available configurations:

| Option                        | Value type    | Description                      | Default |                      
|-------------------------------|---------------|----------------------------------|---------|
| failure_handling.enabled     | Boolean        | Set if buffering failed messages to a topic in Kafka is enabled | true |
| buffer.kafka.seedbrokers    | Array        | Kafka broker URL. Example: kafka://127.0.0.1:9092 or kafka+ssl://127.0.0.1:909 | nil |


2. Start with declaring configuration parameters for your class using the following syntax:

```
Class KafkaConsumer
  include Kafka::Retryable::HandleFailure
    
  failure_handler buffer: :kafka, 
                  dead_letter_queue: :topic_t1, 
                  exception_blacklist: [Karafka::InvalidMessageError],
                  after_failure: ->(error, message) { Bugsnag.notify("#{error}-#{message}") }
                 
  def consume
    # Message consumption logic goes here
  end
end
```

- `dead_letter_queue`: Topic where the consumer should enqueue the failure message.
- `exception_blacklist`: List of exception classes for which the error handling logic does not apply
- `exception_whitelist`: List of exception classes for which the error handling logic should apply
- `after_failure`: Accepts a proc that is executed after failure handling is completed

If `exception_blacklist` and `exception_whitelist` are both missing, then the error handling logic will apply for all exception classes.   

3. Enclose message processing logic inside `handle_failure(message)` helper method provided by `kafka-retryable`

```
handle_failure(message) do
  MessageProcessor.new(message).perform
end
```

Overall, this is how Kafka Consumers using `kafka-retryable` will look like:

```
Class KafkaConsumer
  include Kafka::Retryable::HandleFailure
    
  failure_handler buffer: :kafka, 
                           dead_letter_queue: :topic_t1, 
                           exception_blacklist: [Karafka::InvalidMessageError],
                           after_failure: ->(error, message) { Bugsnag.notify("#{error}-#{message}") }
    
  def consume
    handle_failure(message)
      # Message consumption logic goes here
    end
  end
end
```

`kafka-retryable` will make sure any exceptions outside the `exception_blacklist` will cause the message to be enqueued into the `dead_letter_queue` specified in the `failure_handler` configuration.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/kafka-retryable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kafka::Retryable project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kafka-retryable/blob/master/CODE_OF_CONDUCT.md).
