module MobileViewsController
  
  module ClassMethods
  
    def has_mobile_views(args={})
      before_filter :has_mobile_views
    end
  
  end

  module InstanceMethods

    def mobile_device?
      if session[MobileViews.mobile_mode_session_var]
        session[MobileViews.mobile_mode_session_var] == "1"
      else
        request.user_agent =~ /Mobile|webOS/
      end
    end

    def on_mobile_host?
      request.subdomain == MobileViews.mobile_subdomain
    end

    def has_mobile_views
      if !on_mobile_host? && mobile_device?
        if request.host =~ /\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b|localhost/
          raise Exception, "Can't redirect to subdomain 'm.#{request.host}'! Please use e.g. lvh.me"
        else
          redirect_to "#{request.protocol}#{MobileViews.mobile_subdomain}.#{request.host_with_port}#{request.fullpath}"
        end
      end
      session[MobileViews.mobile_mode_session_var] = params[:mobile] if params[MobileViews.mobile_mode_session_var]
      request.format = :mobile if mobile_device?
    end
  
  end
  
end