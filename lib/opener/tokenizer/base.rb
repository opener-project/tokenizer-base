require_relative 'base/version'

module Opener
  module Tokenizer
    class Base
      attr_reader :language

      def initialize(opts={})
        @language = opts[:language]
      end

      def command(opts=[])
        "java -jar #{kernel} #{language} #{opts.join(' ')}"
      end

      def run(opts=ARGV)
        `#{command(opts)}`
      end

      protected

      def core_dir
        File.expand_path("../../../../core/target", __FILE__)
      end

      def kernel
        File.join(core_dir,'vicom-tokenizer-all-1.0.jar')
      end

      def lib
        File.join(core_dir,'lib/') # Trailing / is required
      end

      def language
        return @language.nil? ? nil : "-l #{@language}"
      end

    end

  end
end
