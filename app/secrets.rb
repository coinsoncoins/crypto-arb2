
require 'yaml'
class Secrets

  class << self
    def get
      @source ||= YAML::load_file('./secrets.yml')
    end
  end


end
