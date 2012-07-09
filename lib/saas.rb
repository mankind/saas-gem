require "saas/version"
require 'rails'

module Saas

   require 'saas/engine' if defined?(RAils)
   require 'saas/account_base'
   require 'saas/account_scope'
   require 'saas/controller_extensions'

   require 'saas/adapters/mongoid_adapter' if defined?(Mongoid) && defined?(Mongoid::Document)
   require 'saas/adapters/active_record_adapter' if defined? ActiveRecord
end
