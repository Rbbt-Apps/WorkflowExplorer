require 'rbbt/entity/study'

require 'kramdown'


def user_studies
  @user_studies = Hash.new{ Sample.all_studies.sort }
end


require 'rbbt'

#path = Path.setup('', nil, nil, :_local => Sample.study_repo.find["{PATH}"], :global => ICGC.root.find["{PATH}"]) 
#

module Sinatra
  module RbbtAuth
    module Helpers
      def user
        session[:user] || 'guest'
      end
    end
  end
end


require 'rbbt/entity'
require 'rbbt/sources/organism'
module Object::Gene
  extend Entity
  add_identifiers Organism.identifiers("NAMESPACE"), "Ensembl Gene ID", "Associated Gene Name"
end
