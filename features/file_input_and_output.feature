Feature: Using a english file as input and other file as an output
  In order to tokenize the file
  Using a file as an input
  Using a file as an output

  Scenario Outline: tokenize english input file.
    Given the fixture file "<input_file>"
    And I put them through the kernel
    Then the output should match the fixture "<output_file>"
  Examples:
    | language	| input_file	| output_file		|
    | en	| english.txt	| english_tokenized.kaf	|
