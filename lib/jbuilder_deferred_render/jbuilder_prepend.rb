require 'deferred_loader/executable'
require 'pp'
module JbuilderDeferredRender
  module JbuilderPrepend 
    def target!(*args) 
      DeferredLoader::Executable.execute_all
      super(*args)
    end
  end
end
