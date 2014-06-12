
# Tokenizer core

Base tokenizer for various languages such as English, German and Italian. It is
based in the <a href="https://github.com/moses-smt/mosesdecoder/blob/master/scripts/tokenizer/tokenizer.perl">Moses SMT tokenizer</a>. Keep in mind that this tokenizer supports multiple 
languages and as such requires you to specify said language in a commandline option. 
The language is specified using the `-l` option. The following languages are supported:

* en
* es
* it
* nl
* de
* fr

More languages may be supported in the future.

## Quick Use Overview

This aplication reads a text from standard input in order to tokenize.

    echo "This is an English text." | perl tokenizer-cli.pl -l en

For more information about the available CLI options run the following:

    perl tokenizer-cli.pl --help

## Requirements

* Perl 5.14.2 or newer.


## Usage

The tokenizer can be called as a perl command. It reads the
standard input, and writes to standard output.

It is mandatory to set the language as a parameter (there is no default
language nor automatic detection inside). Providing no language parameter will
raise an error.  To set a language, it has to be preceded by -l

    echo "Tokenizer example." | perl tokenizer-cli.pl -l en

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

    echo "Tokenizer example." | perl tokenizer-cli.pl -l en -t

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

It is possible to provide the input filename. To set the filename, it has to be preceed by -f

    cat tokenizer_test.txt | perl tokenizer-cli.pl -l en -f tokenizer_test.txt
    
The output should be:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<KAF version="v1.opener" xml:lang="en">
  <kafHeader>
    <fileDesc filename="tokenizer_test" filetype="TXT" />
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



