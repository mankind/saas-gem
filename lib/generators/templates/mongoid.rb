mondule Mongoid
  extend ActiveSupport::Concern

#Monkey patching mongoid's default scope and criteria
  module Classmethods
  
    def default_scope(conditions = {}, &block)
      self.default_scoping = Mongoid::Scope.new(conditions, &block)
    end

    def criteria(embedded = false, scoped = true)
      scope_stack.last || Mongoid::Criteria.new(self, embedded).tap do |crit|
        return crit.fuse(default_scoping.conditions.scoped) if default_scoping && scoped  
      end
     end

  end
end
   
