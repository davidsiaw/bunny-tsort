# Bunny::Tsort

A reinvented wheel. This gem provides a simple function to perform a topological sort that yields an array of arrays of things that can be done in parallel and in order. See usage below for more.

To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bunny-tsort'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bunny-tsort

## Usage

The function this gem provides is very simple. Simply call it with a hash of dependencies and it will give you an array of arrays.

You can have just one task:

```ruby
> require "bunny-tsort"
> Bunny::Tsort.tsort(wash_dishes: [])
 => [[:wash_dishes]] 
```
You can have multiple tasks:

```ruby
> Bunny::Tsort.tsort(wash_dishes: [:eat], eat: [:cook], cook: [:buy_food], buy_food: [])
 => [[:buy_food], [:cook], [:eat], [:wash_dishes]]
```

The returned array is in the order in which things have to be done. 

You can omit `:buy_food => []` here because it has no dependencies and is depended on by `:cook`:

```ruby
> Bunny::Tsort.tsort(wash_dishes: [:eat], eat: [:cook], cook: [:buy_food])
 => [[:buy_food], [:cook], [:eat], [:wash_dishes]]
```

The result will be the same.

You can have multiple tasks that depend on the same thing:

```ruby
> Bunny::Tsort.tsort(buy_food: [:go_out], talk_to_friend: [:go_out])
 => [[:go_out], [:buy_food, :talk_to_friend]] 
```

Notice the second element has 2 things. This means that since once you have done `:go_out` you can do both `:buy_food` and `:talk_to_friend` in parallel. The only hard constraint is you cannot do any of the second array until you complete the first.

This is useful to know if you can do a number of things at once and want to know when you will have free hands.

The function will throw an exception if you give it things which depend on each other:

```ruby
> Bunny::Tsort.tsort(lay_egg: [:hatch_chicken], hatch_chicken: [:lay_egg])
Bunny::Tsort::CyclicGraphException: Bunny::Tsort::CyclicGraphException
```

You are not constrained to using symbols as the above examples have, you can use any datatype that can be a Hash key:

```ruby
> Bunny::Tsort.tsort("funny" => [3], 1 => [2])
 => [[3, 2], ["funny", 1]] 
```

(that is to say, the data type must implement Object#hash and Object#eql? in the way you expect)

## Why no class

The problem is so stupidly simple to solve a class is overkill. It will also introduce additional complexity and additional things to test. This is very simple with clearly defined inputs and outputs, and you can use it immediately without studying the structure of the objects.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidsiaw/bunny-tsort. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

