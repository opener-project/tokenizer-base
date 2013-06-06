Feature: Using a english file as input and other file as an output
  In order to tokenize the file
  Using a file as an input
  Using a file as an output

  Scenario Outline: tokenize english input file.
    If "<filename>" is empty it will not appear at KAF header.

    Given input file's language "<language>"
    Given the file name "<filename>"
    Given the fixture file "<input_file>"
    And I put them through the kernel
    Then the output should match the fixture "<output_file>"
  Examples:
    | language | filename    | input_file  | output_file                  |
    | en       |             | english.txt | english_tokenized_noname.kaf |
    | en       | english.txt | english.txt | english_tokenized.kaf        |
    | es       |             | spanish.txt | spanish_tokenized_noname.kaf |
    | es       | spanish.txt | spanish.txt | spanish_tokenized.kaf        |
    | nl       |             | dutch.txt   | dutch_tokenized_noname.kaf   |
    | nl       | dutch.txt   | dutch.txt   | dutch_tokenized.kaf          |
    | de       |             | german.txt  | german_tokenized_noname.kaf  |
    | de       | german.txt  | german.txt  | german_tokenized.kaf         |
    | it       |             | italian.txt | italian_tokenized_noname.kaf |
    | it       | italian.txt | italian.txt | italian_tokenized.kaf        |
