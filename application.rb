require 'lotus/router'

module Pinner
  class << self
    def application
      @application ||= Lotus::Router.new do
        get '/', to: -> (env) { [200, {}, ['Hello!']] }
      end
    end
  end
end
