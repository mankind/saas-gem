module Saas
  module AccountScope
  extend ActiveSupport::Concern

    #The block passed to 'included' gets class evaled in any class object that this
    # module with declaration of ActiveSuppoert::Concern is included into.

    included do
      validates_presence_of :account
      belongs_to :account

   #Validation callback to check if current account exists and different from the 
   # existing one, before setting self.account on newly created objects to account.current.   
      before_validation {self.account = account.current unless self.account.include? Account.current}
    end

    # Extends or creates class methods in whatever class object they are 'included'
    module ClassMethods

      #Allows each adapter to have their individual default_scope defined in the adapters eg mongoid and activerecord
      def default_scope
        raise NotImplemented, "To tie all queries to current_account, implement this  in your adapter and call it in the ActiveSupport::Concern incuded block."
       end
    end
  end

end
