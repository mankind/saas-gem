# Software as a service gem 
##saas-gem

The Saas-Gem provides multi-tenancy through scopes.

The saas-gem scopes query through the current_account in the controller. It also does not use default_scope in activerecord model.
However, the saas-subdomain branch allows you to scope query via the default_scope in the model. You can easily setup subdomain and scope all accounts to the subdomain.
The the saas-subdomain branch works with rails 3.x, and has adapters for activerecord and mongoid.


# Installation

This follow soon after i review the code and add some generators


