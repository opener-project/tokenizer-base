[![Build Status](https://drone.io/github.com/opener-project/tokenizer-base/status.png)](https://drone.io/github.com/opener-project/tokenizer-base/latest)
# Opener::Tokenizer::Base

Base tokenizer for various languages such as English, German and Italian. Keep
in mind that this tokenizer supports multiple languages and as such requires
you to specify said language in a commandline option. The language is specified
using the `-l` option. The following languages are supported:

* en
* es
* it
* nl
* de
* fr

More languages may be supported in the future.

## Quick Use Overview

Install the Gem using Specific Install

    gem specific_install opener-tokenizer-base \
        -l https://github.com/opener-project/tokenizer-base.git

If you dont have specific\_install already, install it first:

    gem intall specific_install

You should now be able to call the tokenizer as a regular shell command, by its
name. Once installed as a gem you can access the gem from anywhere. This aplication
reads a text from standard input in order to tokenize.

    echo "This is an English text." | tokenizer-base -l en

For more information about the available CLI options run the following:

    tokenizer-base --help

## Requirements

* Perl 5.14.2 or newer.
* Ruby 1.9.3 or newer (1.9.2 should work too but 1.9.3. is recommended). Ruby
  2 is supported.

## Installation

To set up the project run the following commands:

    bundle install
    bundle exec rake compile

This will install all the dependencies and generate the Java files. To run all
the tests (including the process of building the files first) you can run the
following:

    bundle exec rake

or:

    bundle exec rake test

Building a new Gem can be done as following:

    bundle exec rake build

For more information invoke `rake -T` or take a look at the Rakefile.


## Gem Installation

Add the following to your Gemfile (use Git for now):

    gem 'opener-tokenizer-base',
      :git=>"git@github.com:opener-project/tokenizer-base.git"


## Usage

Once installed, the tokenizer can be called as a shell command. It reads the
standard input, and writes to standard output.

It is mandatory to set the language as a parameter (there is no default
language nor automatic detection inside). Providing no language parameter will
raise an error.  To set a language, it has to be preceded by -l

    echo "Tokenizer example." | tokenizer-base -l en

or you can use the convenience option

    echo "Tokenizer example." | tokenizer-it

The output should be:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<KAF version="v1.opener" xml:lang="en">
  <kafHeader>
    <linguisticProcessors layer="text">
      <lp name="opener-sentence-splitter-en" timestamp="2013-05-31T11:39:31Z" version="0.0.1"/>
      <lp name="opener-tokenizer-en" timestamp="2013-05-31T11:39:32Z" version="1.0.1"/>
    </linguisticProcessors>
  </kafHeader>
  <text>
    <wf length="9" offset="0" para="1" sent="1" wid="w1">Tokenizer</wf>
    <wf length="7" offset="10" para="1" sent="1" wid="w2">example</wf>
    <wf length="1" offset="17" para="1" sent="1" wid="w3">.</wf>
  </text>
</KAF>
```

If you need a static timestamp you can use the -t param.

    echo "Tokenizer example." | tokenizer-base -l en -t

The output will be something along the lines of the following:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<KAF version="v1.opener" xml:lang="en">
  <kafHeader>
    <linguisticProcessors layer="text">
      <lp name="opener-sentence-splitter-en" timestamp="0000-00-00T00:00:00Z" version="0.0.1"/>
      <lp name="opener-tokenizer-en" timestamp="0000-00-00T00:00:00Z" version="1.0.1"/>
    </linguisticProcessors>
  </kafHeader>
  <text>
    <wf length="9" offset="0" para="1" sent="1" wid="w1">Tokenizer</wf>
    <wf length="7" offset="10" para="1" sent="1" wid="w2">example</wf>
    <wf length="1" offset="17" para="1" sent="1" wid="w3">.</wf>
  </text>
</KAF>
```

## Possible bugs

The merging of all tokenizers in one has been done quite quickly. It seems to
work so far, but there can be bugs, or lack of some functionality. As the
tokenizer is the first step of the chain, any error will affect to the analysis
of the rest of the layers.


## Contributing

1. Pull it
2. Create your feature branch (`git checkout -b features/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin features/my-new-feature`)
5. If you're confident, merge your changes into master.
