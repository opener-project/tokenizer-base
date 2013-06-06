# Opener::Tokenizer::EN

Tokenizer for English. Give it any english text, and you'll get a nice KAF
output.

## Installation

Add this line to your application's Gemfile:

    gem 'opener-tokenizer-en', :git=>"git@github.com:opener-project/tokenizer-en.git"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem specific_install opener-tokenizer-en -l https://github.com/opener-project/tokenizer-en.git

If you dont have specific\_install already:

    $ gem install specific_install

## Usage

Once installed as a gem you can access the gem from anywhere:

This aplication reads a text from standard input in order to tokenize.
Aplication arguments:

```bash
-l, --lib       sentence detection and tokenization model's directory path.
-f, --filename  (optional) file's name.
-t,             (optional) o use static timestamp at KAF header.
--help,         outputs aplication help.
```

For example:

    $ cat english.txt | tokenizer-en -f english.txt

Will output:

```xml
<KAF xml:lang="en" version="v1.opener">
  <kafHeader>
    <fileDesc filename="english" filetype="TXT" />
    <linguisticProcessors layer="text">
      <lp name="openlp-en-sent" version="1" timestamp="2013-02-05T13:35:22Z"/>
      <lp name="openlp-en-tok" version="1" timestamp="2013-02-05T13:35:22Z"/>
    </linguisticProcessors>
  </kafHeader>
  <text>
    <wf wid="w1" page="1" sent="1" para="1" offset="1">
      In
    </wf>
    <wf wid="w2" page="1" sent="1" para="1" offset="4">
      1995
    </wf>
      ...
    <wf wid="w196" page="1" sent="7" para="5" offset="1037">were</wf>
  </text>
</KAF>

```

## Contributing

1. Pull it
2. Create your feature branch (`git checkout -b features/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin features/my-new-feature`)
5. If you're confident, merge your changes into master.
