# CatTree

CatTree monitors ActiveRecord objects in development environment the number of objects, the number of same objects, un-used objects etc.
It helps you decrease waste of memory and increase application performance.

## Usage

You can be used by simply installing.
CatTree notifies the result analyzing ActiveRecord objects. Look at the Rails log when Rails action finished.

```
Started GET "/top" for xxx.xxx.xxx.xxx at yyyy
Processing by TopController#index as HTML
  Parameters: {}
  ....

[CatTree]
  ActiveRecord::Base objects:  1023
  ActiveRecord::Relation object: 2345
  Un-used ActiveRecord::Relation object: 45
  Same object:
    User(id:12):  13

Completed 200 OK in 1121.8ms (Views: 899.0ms | ActiveRecord: 222.8ms)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cat_tree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cat_tree


## Contributing

1. Fork it ( https://github.com/[my-github-username]/cat_tree/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
