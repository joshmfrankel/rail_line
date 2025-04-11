# RailLine

_Get your code in line_

RailLine provides a simple interface for implementing Railway Oriented Programming adapted for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rail_line'
```

## Usage

In order to utilize RailLine, include the `RailLine::ResultDo` module in your class and utilize the `handle_result` method to wrap your business logic.

```ruby
class MyAwesomeService
  include RailLine::ResultDo

  def call
    handle_result do
      # Do something
      # Do something else
      # Return the result
    end
  end
end
```

Then within the calling object you receive a `RailLine::Success` or `RailLine::Failure` object with a clean interface for handling the result.

```ruby
result = MyAwesomeService.new.call

if result.success?
  # Do something with the result
  render json: {
    success: true,
    payload: result.payload,
    message: result.message
  }
elsif result.failure?
  # Do something with the failure
  render json: {
    success: false,
    payload: result.payload,
    message: result.message
  }
end
```

### Automatic RailLine

If you prefer RailLine to handle a specific method automatically, you can use the `include RailLine::ResultDo[:call]` module syntax. This is equivalent to the above example.

```ruby
class MyAwesomeService
  include RailLine::ResultDo[:call]

  def call
    # Automatically wrapped within handle_result
  end
end
```

## Features

- Exceptions halt execution and return a `RailLine::Failure` object with details.
- RailLine wrapped method calls always return a RailLine result object even when not explicitly returned.
- `RailLine::Failure` halts further execution of the calling method.

## FAQs

1. Will this implement fmap, bind, and other monad methods?

Likely not. There are other great gems out there which implement these methods. RailLine is meant to be a simple and clean way to manage business logic and flow.

2. How does this compare to other gems?

There are other gems out there which more fully implement traditional Railway Oriented Programming concepts. For example, [dry-monads](https://github.com/dry-rb/dry-monads) is a popular choice. RailLine was inspired by these great gems as a simple alternative.

3. How can I debug exceptions not explictly called via RailLine::Failure?

RailLine::Failure objects that originate from StandardError are hydrated with a `payload` attribute which contains the underlying `exception` and `backtrace`. You can use this to debug failures by introspecting the underlying exception.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/joshmfrankel/rail_line. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/joshmfrankel/rail_line/blob/main/CODE_OF_CONDUCT.md).

## Code of Conduct

Everyone interacting in the RailLine project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/joshmfrankel/rail_line/blob/main/CODE_OF_CONDUCT.md).
