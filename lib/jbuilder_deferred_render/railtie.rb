require 'deferred_loader'
require 'deferred_loader/proxy'
require 'jbuilder'
module JbuilderDeferredRender
  class Railtie < ::Rails::Railtie
    initializer 'jbuilder_deferred_render' do |_app|
      ActiveSupport.on_load(:after_initialize) do
        require 'jbuilder_deferred_render/jbuilder_ext'
        require 'jbuilder_deferred_render/jbuilder_prepend'
        Jbuilder.prepend(JbuilderDeferredRender::JbuilderPrepend)
        ::Jbuilder.send(:include, JbuilderDeferredRender::JbuilderExt)
      end
    end
  end
end
