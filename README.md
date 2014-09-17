# CatTree

CatTree monitors ActiveRecord objects in development environment the number of objects, the number of same objects, un-used objects etc.
It helps you decrease waste of memory and increase application performance.

![CatTree](http://s3-ap-northeast-1.amazonaws.com/kaeruspoon/images/110/large.JPG?1328342672)


## Usage

You can be used by simply installing.
CatTree notifies the result analyzing ActiveRecord objects. Look at the Rails log when Rails action finished.

```
Started GET "/top" for xxx.xxx.xxx.xxx at yyyy
Processing by TopController#index as HTML
  Parameters: {}
  ....

[CatTree]
  ActiveRecord::Base:     1023
  ActiveRecord::Relation: 2345
  Un-used ActiveRecord::Relation: 45
  Same objects:
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


## Test

I'm glad that you would do test!
To run the test suite, you need mysql installed.
How to setup your test environment.


```bash
bundle install --path bundle
GEM_HOME=bundle/ruby/(your ruby version) gem install bundler --pre
bundle exec appraisal install
```

This command run the spec suite for all rails versions supported.

```base
bundle exec appraisal rake spec
```
