# Opener::Kernel::Vicom::Tokenizer::Lite::EN

## Description

NOTE: The name can be confusing because it still seems to be only for English, but it is multilanguage. The name has to be changed.
This branch combines all tokenizers (except the one for French) in one.
It also fixes some important problems whith character scaping.
Finally the core code has been refactored use Maven to compile/package the Java code.



The Rakefile file has been edited to issue the Maven packaging automatically when installing the gem.
So you just need to issue:  (with sudo if you need permissions on the folder the gem is going to be installed)

	$ rake install

And everything should be automatic (i.e. the gem packaged and installed ready to use).

Be aware that as this module is multilanguage, it needs a mandatory parameter, the language (en, es, it, nl, de)
See usage below.

## Editing the code

Edit de code is as easy as issuing:

	$ cd core
	$ mvn eclipse:eclipse

Then you can import the Java project to Eclipse (don't check the "Copy project content" checkbox to edit the actual code).
One you finish editing the code (and hopefully after some testing) you can commit your changes to git directly (no more copy-paste)

## Installation

Clone the repository:

	$ git clone git@github.com:opener-project/Vicom-tokenizer-lite_EN_kernel.git


Go to the repository root folder

	$ cd Vicom-tokenizer-lite_EN_kernel.git

Issue the following command:

	$ sudo rake install

You should now be able to call the tokenizer as a regular shell command, by its name.

## Usage

Once installed, the tokenizer can be called as a shell command.
It reads the standard input, and writes to standard output.

It is mandatory to set the language as a parameter (there is no default language nor automatic detection inside).
Providing no language parameter will raise an error.
To set a language, it has to be preceded by -l

	$ echo "Tokenizer example." | Vicom-tokenizer-lite_EN_kernel -l en

The output should be:

	<?xml version="1.0" encoding="UTF-8" standalone="no"?>
	<KAF version="v1.opener" xml:lang="en">
	<kafHeader>
	<linguisticProcessors layer="text">
	<lp name="opennlp-en-tok" timestamp="2013-05-31T11:39:31Z" version="1.0"/>
	<lp name="opennlp-en-sent" timestamp="2013-05-31T11:39:32Z" version="1.0"/>
	</linguisticProcessors>
	</kafHeader>
	<text>
	<wf length="9" offset="0" para="1" sent="1" wid="w1">Tokenizer</wf>
	<wf length="7" offset="10" para="1" sent="1" wid="w2">example</wf>
	<wf length="1" offset="17" para="1" sent="1" wid="w3">.</wf>
	</text>
	</KAF>


If you need a static timestamp you can use the -t param.

	$ echo "Tokenizer example." | Vicom-tokenizer-lite_EN_kernel -l en -t

	<?xml version="1.0" encoding="UTF-8" standalone="no"?>
	<KAF version="v1.opener" xml:lang="en">
	<kafHeader>
	<linguisticProcessors layer="text">
	<lp name="opennlp-en-tok" timestamp="0000-00-00T00:00:00Z" version="1.0"/>
	<lp name="opennlp-en-sent" timestamp="0000-00-00T00:00:00Z" version="1.0"/>
	</linguisticProcessors>
	</kafHeader>
	<text>
	<wf length="9" offset="0" para="1" sent="1" wid="w1">Tokenizer</wf>
	<wf length="7" offset="10" para="1" sent="1" wid="w2">example</wf>
	<wf length="1" offset="17" para="1" sent="1" wid="w3">.</wf>
	</text>
	</KAF>

## Possible bugs

The merging of all tokenizers in one has been done quite quickly. It seems to work so far, but there can be bugs, or lack of some functionality.
As the tokenizer is the first step of the chain, any error will affect to the analysis of the rest of the layers.
Now that the Java code has been "Mavenized" it is much more easy to edit a fix bugs, so if you find something wrong or with any misbehaving, please teel us (Vicomtech) :-)


## Contributing

1. Pull it
2. Create your feature branch (`git checkout -b features/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin features/my-new-feature`)
5. If you're confident, merge your changes into master.
