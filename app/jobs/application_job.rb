class ApplicationJob < ActiveJob::Base
  # before_perform :wardenize
  
  # def render(options = nil, extra_options = {}, &block)
  #   @job_renderer.render(options, extra_options, &block)
  # end
  
  # private
  #   def wardenize
  #     @job_renderer = ::ApplicationController.renderer.new
  #     renderer_env = @job_renderer.instance_eval { @env }
  #     warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
  #     renderer_env["warden"] = warden
  #   end
end
