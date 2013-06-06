require_relative 'en/version'

module Opener
  module Tokenizer
    class EN

      def command(opts=[])
        "java -jar #{kernel} #{opts.join(' ')}"
      end

      def run(opts=ARGV)
        `#{command(opts)}`
      end

      private

      def core_dir
        File.expand_path("../../../../core/target", __FILE__)
      end

      def kernel
        File.join(core_dir,'vicom-tokenizer-all-1.0.jar')
      end

      def lib
        File.join(core_dir,'lib/') # Trailing / is required
      end

    end
  end
end
