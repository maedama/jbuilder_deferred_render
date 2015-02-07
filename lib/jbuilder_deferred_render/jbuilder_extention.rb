require 'deferred_loader/executable'
module JbuilderDeferredRender
  module JbuilderExtention
    
    def target!(*args) 
      wrap_with_deferred_subscription do
        DeferredLoader::Executable.execute_all
        super(*args)
      end
    end

    def initialize  
      @restorables = {}
      wrap_with_deferred_subscription do
        super(*args)
      end
    end

    
    private
      
      def wrap_with_subscription(&block)
        deferred_subscriber = ActiveSupport::Notifications.subscribe('defered_loader.deferred') do |payload| 
          prepare_deferred(payload[:block].object_id)
        end
        
        execute_subscriber = ActiveSupport::Notifications.subscribe('defered_loader.execute') do |payload|
          restore_deferred(payload[:block].object_id)
        end

        begin
          block.call
        ensure
          ActiveSupport::Notifications.unsubscribe(deferred_subscriber)
          ActiveSupport::Notifications.unsubscribe(execute_subscriber)
        end      
      end
      
      def prepare_deferred(block_object_id)
        hash = @restorables[block_object_id] = {}
        set! "__deferred:#{block_object_id}", hash
      end

      def restore_defferd(block_object_id)
        set_instance_variable(@restorables[block_object_id])
      end

  end
end
