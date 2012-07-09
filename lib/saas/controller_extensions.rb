module Saas

  module ControllerExtensions
    extend ActiveSupport::Concern
    
    included do
      helper_method :current_account, :is_root_domain?
      before_filter :current_account
      before_filter :set_current_account
    end
  
  def is_root_domain?
    # return true if there is no subdomain
    result = (request.subdomains.first.present? && request.subdomains.first != "www") ? false : true
  end

  

  def current_account
    # If subdomain is present, returns the account, else nil
    if !is_root_domain?
      @current_account ||= Account.find_by_name(request.subdomains.first)
      if @current_account.nil?
        redirect_to root_url(:account => false, :alert => "Unknown Account/subdomain")
      end
    else 
      @current_account = nil
    end
    @current_account
  end    

  def set_current_account
    # set @curent_account from session data and allow curent account to be accessed from the Account model
    Account.current = current_account
  end 
  
  def is_account_resource?(account_id)
  	# call in controller before_filter to make sure the resource belongs to the account
  	# used to prevent url modification to resources that are not owned by account.
    if account_id != current_account.id
      redirect_to "/opps" , :alert => "Sorry, resource is not part of your account"
    end
  end
    
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    redirect_to "/opps" 
  end
  
  protected

  def authenticate_user!(opt={})
    logger.info "hugggggggggggggg #{opt}"
    # An override to devise to redirect to custom page if config 
    if Rails.application.config.authenticate_to_home
      unless user_signed_in?
        redirect_to root_url, :alert => "You must be logged in to access that page - #{params[:controller]}"
        return false
      end
    else
      super
    end
  end

  def authenticate_inviter!
  	# A hook to Devise_invitable that uses CanCan to see if a user is authorized 
  	# to invite another user.
    if cannot? :invite, User
      redirect_to "/opps", :alert => "Unauthorized action"
    end
  end

  def after_sign_in_path_for(resource_or_scope)
    # Modified to redirect user to their account root if login is at root domain
  	# User is signed out of that domain and signed in to their domain using a token.
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    account_name = current_user.account.name
    if current_account.nil? || (account_name != current_account.name)
      # logout of root domain and login by token to account
      token =  Devise.friendly_token
      current_user.loginable_token = token
      current_user.save
      sign_out(current_user)
      flash[:notice] = nil
      home_path = valid_user_url(token, :subdomain => account_name)
      return home_path 
    end
    super
  end
  
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    # Handles case if user is visiting another subdomain and tries to sign in.
  	# Also handles the redirect on sign up, sending them to their account root.    
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    if check_account_id
      redirect_to stored_location_for(scope) || after_sign_in_path_for(resource)
    else
      account_name = current_user.account.name
      token =  Devise.friendly_token
      current_user.loginable_token = token
      current_user.save
      sign_out(current_user)
      flash[:notice] = nil
      home_path = valid_user_url(token, :subdomain => account_name)
      redirect_to home_path
    end
  end  

  def check_account_id
    return current_account ? current_user.account.id == current_account.id : false
  end
 
  
end  

  end
end
