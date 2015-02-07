require 'deferred_loader'
require 'deferred_loader/proxy'
require 'jbuilder'
module JbuilderDeferredRender
  class Railtie < ::Rails::Railtie
    initializer 'jbuilder_deferred_render' do |_app|
      ActiveSupport.on_load(:after_initialize) do
        require 'jbuilder_deferred_render/jbuilder_extention'
        Jbuilder.prepend(JbuilderDeferredRender::JbuilderExtention)
      end
    end
  end
end
