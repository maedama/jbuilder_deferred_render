# JbuilderDeferredRender

This is a gem that allows to avoid n+1 problem in view layer by introducing defered loading resource syntaxes.

THIS GEM IS CURRENTLY ALPHA QUALITY. IT IS USED ALREADY IN PRODUCTION BUT IT HAS SOME ISSUES

## Motivation

Jbuilder deferred render allows you to avoid n+1 problem directly by template.

Jbuilder is awesome module, but people are suffered with well known n+1 problem.
The problem of n+1 problems is as follows.

##### logical correctness
It is the View layer who knows which attributes they need to render result, and accesing model attributes in view layer is logically correct.

##### Practical issue on performance.
But, accessing model attributes that requires accessing outer resource (like RDBS) usually becomes very slow, when  accessed one by one.
And can become much faster when accessed in bulk manner.

##### Depth first rendering strategy

Typically rendering engine supports depth first rendering. 
Depth first rendering in above senario causes problem, because it would access to attribute from the same resource(i.e same table in RDBS) one by one, which has performance issue stated above


##### How to avoid n+1 problem.

Common ways to avoid n+1 problem is pre loading items we need in controllers. 

```
@users = User.include(:books).take(10)
```
This approach works,  but is not an ideal approach because controller shold know much about views. 
And it gets too complicated, when we have deeply nested json object which is quite a common case when implementing RESTFul APIs

Instead of above approach, this gems allows to avoid n+1 problem in view layer by allowing breadth first rendering in views as follows. 

```
  @users = User.take(10)
  @jbuilder = Jbuilder.new do |json|
  json.array! @users do |user|
    json.name user.name
    json.when(
      user.deferred_load.favorite_book
    ).then do |book|
      json.favorite_book do
        json.title book.title
        json.when(
          book.deferred_load.author
        ).then do |author|
          json.author author.name
        end
      end
    end
  end
```

Which would render json like
```
[
  {
    "name": "foo",
    "favorite_book": {
      "name": "var",
      "author": "hoge"
    }
  },
  ...
]
```

With only  3 queries like bellow

```
SELECT * FROM users ORDER BY id DESC LIMIT 10;
SELECT * FROM books where user_id in (?, ?, ?, ?, ?, ?, ?, ?, ?)
SELECT * FROM authors where author_id in (?, ?, ?, ?, ?, ?, ?, ?, ?)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jbuilder_deferred_render'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jbuilder_deferred_render

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/maedama/jbuilder_deferred_render/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
