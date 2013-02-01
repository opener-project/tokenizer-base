module Opener
   module Kernel
     module Vicom
       module Tokenizer
    	 module Lite
    	   module EN
      		VERSION = "0.0.1"

      		class Configuration
        		CORE_DIR    = File.expand_path("../core", File.dirname(__FILE__))
        		KERNEL_CORE = CORE_DIR+'/tokenizer_english.jar'
      		end

    	  end
    	end
      end
    end
  end
end

KERNEL_CORE=Opener::Kernel::Vicom::Tokenizer::Lite::EN::Configuration::KERNEL_CORE
