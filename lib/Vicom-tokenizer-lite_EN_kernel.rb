require 'tempfile'

module Opener
  module Kernel
    module Vicom
      module Tokenizer
        module Lite
          class EN
            VERSION = "0.0.2"

            attr_reader :kernel, :lib

            def initialize
              core_dir    = File.expand_path("../core", File.dirname(__FILE__))

              @kernel      = core_dir+'/tokenizer_english.jar'
              @lib         = core_dir+'/lib/'
            end

            def command(opts={})
              arguments = opts[:arguments] || []
              arguments << "-n" if opts[:test]

              "java -jar #{kernel} #{lib} #{opts[:input]} #{arguments.join(' ')}"

            end

          end
        end
      end
    end
  end
end


