require 'deferred_loader/executable'
require 'active_support/concern'
require 'q'
module JbuilderDeferredRender
  module JbuilderExt
    extend ActiveSupport::Concern

    def self.when(json, promise)
      deferred_attrs = get_attributes(json)

      Q.defer do |defer|
        promises = *promise
        results = []
        resolved = 0

        promises.each_with_index do |p, i|
          p.then do|result|
            results[i] = result
            resolved = resolved + 1;
            if resolved == promises.length then
              current_attrs = get_attributes(json)
              begin 
                set_attributes(json, deferred_attrs)
                defer.resolve(*results)
              ensure
                set_attributes(json, current_attrs)
              end
            end
          end
        end
      end
    end

    def self.get_attributes(json)
      json.instance_eval do
        @attributes 
      end
    end

    def self.set_attributes(json, attrs)
      json.instance_eval do
        @attributes  = attrs
      end
    end

    included do 
      def when(promise)
        # Avoid executing in jbuilder's scope because, it aliases method not found to set!
        return JbuilderDeferredRender::JbuilderExt.when(self, promise)  
      end
    end
  end
end
