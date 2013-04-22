# Opener::Kernel::Vicom::Tokenizer::Lite::EN

## Initial Version

Tokenizer kernel for English lite version.

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'Vicom-tokenizer-lite_EN_kernel', :git=>"git@github.com:opener-project/Vicom-tokenizer-lite_EN_kernel.git"

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem specific_install Vicom-tokenizer-lite_EN_kernel -l https://github.com/opener-project/Vicom-tokenizer-lite_EN_kernel.git


If you dont have specifi_install already:

    $ gem install specific_install

## Usage

Once installed as a gem you can access the gem from anywhere:

This aplication reads a text from standard input in order to tokenize.
Aplication arguments:
-l, --lib       sentence detection and tokenization model's directory path.
-f, --filename  (optional) file's name.
-t,             (optional) o use static timestamp at KAF header.
--help,         outputs aplication help.


For example:

$ cat english.txt | Vicom-tokenizer-lite_EN_kernel -f english.txt

Will output:

01. `<KAF xml:lang="en" version="v1.opener">`
02. `  <kafHeader>`
03. `    <fileDesc filename="english" filetype="TXT" />`
04. `    <linguisticProcessors layer="text">`
05. `      <lp name="openlp-en-sent" version="1" timestamp="2013-02-05T13:35:22Z"/>`
06. `      <lp name="openlp-en-tok" version="1" timestamp="2013-02-05T13:35:22Z"/>`
07. `    </linguisticProcessors>`
08. `  </kafHeader>`
09. `  <text>`
10. `    <wf wid="w1" page="1" sent="1" para="1" offset="1">`
11. `      In`
12. `    </wf>`
13. `    <wf wid="w2" page="1" sent="1" para="1" offset="4">`
14. `      1995`
15. `    </wf>`
16. `      ...`
17. `    <wf wid="w196" page="1" sent="7" para="5" offset="1037">were</wf>`
18. `  </text>`
19. `</KAF>`


## Contributing

1. Pull it
2. Create your feature branch (`git checkout -b features/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin features/my-new-feature`)
5. If you're confident, merge your changes into master.
