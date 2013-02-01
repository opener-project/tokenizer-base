# Opener::Kernel::Vicom::Tokenizer::Lite::EN

## Initial Version

Tokenizer kernel for English lite version.

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'Vicom-tokenizer-lite_EN_kernel', :git=>"git@github.com/opener-project/Vicom-tokenizer-lite_EN_kernel.git"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem specific_install Vicom-tokenizer-lite_EN_kernel -l https://github.com/opener-project/Vicom-tokenizer-lite_EN_kernel.git


If you dont have specifi_install already:

    $ gem install specific_install

## Usage

Once installed as a gem you can access the gem from anywhere:

Vicom-tokenizer-lite_EN_kernel needs 2 arguments:

1. Sentence detection and tokenization model's directory path.
2. File's path.


For example:

$ Vicom-tokenizer-lite_EN_kernel ./ english.txt

Will output:

01. `<kaf xml:lang="en" doc="english.txt">`
02. `  <text>`
03. `    <wf wid="w1" page="1" sent="1" para="1">`
04. `      In`
05. `    </wf>`
06. `    <wf wid="w2" page="1" sent="1" para="1">`
07. `      1995`
08. `    </wf>`
09. `      ...`
10. `    <wf wid="w196" page="1" sent="7" para="5">`
11. `      were`
12. `    </wf>`
13. `  </text>`
14. `</kaf>`


## Contributing

1. Pull it
2. Create your feature branch (`git checkout -b features/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin features/my-new-feature`)
5. If you're confident, merge your changes into master.
