module Saas
 module MongoidAdapter

  extend ActiveSupport::Concern
  include Saas::AccountScope

  included do
    default_scope({lambda {:where => {:account_id = Account.current.id}}})
  end

  module ClassMethods 
    def default_scope
      # Just calls the activerecord implementation but allows each adapter to have their individual default_scope
      super
    end
  end

  end
end
