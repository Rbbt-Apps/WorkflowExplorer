require 'rbbt/entity/study'

require 'kramdown'

require 'rbbt'

module Sinatra
  module RbbtAuth
    module Helpers
      def user
        session[:user] || 'guest'
      end
    end
  end
end


#require 'rbbt/entity'
#require 'rbbt/sources/organism'
#module Object::Gene
#  extend Entity
#  add_identifiers Organism.identifiers("NAMESPACE"), "Ensembl Gene ID", "Associated Gene Name"
#end
