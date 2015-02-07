require 'deferred_loader/executable'
module JbuilderDeferredRender
  module JbuilderExtention
    
    def proxy
      super(*args)
    end

    def initialize
      
      ActiveSupport::Notifications.subscribe('defered_loader.deferred') do |payload|
        key = payload[:block].object_id
        set "__deferred:#{key}__", nil
      end
      
      ActiveSupport::Notifications.subscribe('defered_loader.execute') do |payload|
        instance_variable_set(@attribute, {})
      end

      super(*args)
    end
  end
end
