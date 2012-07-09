module Saas
  module AccountBase
    extend ActiveSupport::Concern

    #The block passed to 'included' gets class evaled in any class object that this
    # module with declaration of ActiveSuppoert::Concern is included into.

    included do
      
      validates_presence_of :name
      validates_uniqueness_of :subdomain

      validates_format_of :subdomain, :with => /^[A-zA-Z0-9-]+$/,
       :MESSAGE => 'The subdomain can only contain alphanumeric characters and dashes.', :allow_blank => true
   #Note with ruby 1.9.2 the hash can be written as #allow_blank: "true" #
      
      validates_exclusion_of :subdomain, :in => %w(support supports blog blogs  www billing billings  help  helps api apis integration integrations partner partners admin admins), :message => "This subdomain <strong> {{value}}</strong> is resrved and unavailable."

      before_validation :downcase_subdomain

    end
  
     protected
     def downcase_subdomain
       self.subdomain.downcase! if attribute_present?("subdomain")
     end

   # Extends or creates class methods in whatever class object they are 'include
    module ClassMethods
        attr_accessor :current
    end
  end

end
