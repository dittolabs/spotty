# spotty
Ruby gem designed to poll for AWS EC2 spot termination notices

## Installation

```
gem install spotty
```

## Description

While Spotty allows the user to poll any url they want, it was specifically designed to poll for and handle AWS Spot Instance Termination Notices. [See Here](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/spot-interruptions.html).

The user passes a block of code that they want to run when a spot instance termination notice is received. This code block can be used to handle graceful shutdown of running processes and cleanup tasks.

## Usage
```ruby
require 'spotty'

Spotty.new.run do |foo|
  # code goes here...
  do_something
end
```

### Customization

There are two parameters that can be customized when created a Spotty instance: the url and the polling interval.

The url is defaulted to: ```http://169.254.169.254/latest/meta-data/spot/termination-time```

The polling interval is defaulted to ```5```.

```ruby
Spotty.new('http://example.com/custom_url', {:interval => 10}).run do |foo|
  # code goes here...
  do_something
end
```
