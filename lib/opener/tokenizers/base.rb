require_relative 'base/version'

module Opener
  module Tokenizers
    class Base
      attr_reader :language

      def initialize(opts={})
        @language ||= opts[:language] || lang
        @file ||= opts[:file] || file
      end

      def command(opts=[])
        "perl -I #{lib} #{kernel} #{language} #{file} #{opts.join(' ')}"
      end

      def run(opts=ARGV)
        puts "kakakkakakakkakaak**************************"
        `#{command(opts)}`
      end

      def set_language(language)
        @language = language
      end

      protected

      def core_dir
        File.expand_path("../../../../core", __FILE__)
      end

      def kernel
        File.join(core_dir,'tokenizer-cli.pl')
      end

      def lib
        File.join(core_dir,'lib/') # Trailing / is required
      end

      def language
        return @language.nil? ? nil : "-l #{@language}"
      end

      def file
        return @file.nil? ? nil : "-f #{@file}"
      end

      def lang
        'en'
      end

    end

    class EN < Base
      def lang
        'en'
      end
    end

    class DE < Base
      def lang
        'de'
      end
    end

    class NL < Base
      def lang
        'nl'
      end
    end

    class ES < Base
      def lang
        'es'
      end
    end

    class IT < Base
      def lang
        'it'
      end
    end

    class FR < Base
      def lang
        'fr'
      end
    end
  end
end
