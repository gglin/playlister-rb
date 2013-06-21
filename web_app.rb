require 'rack'

require_relative 'environment'

module WebApp

  class Index
    def initialize(app)
      @app = app
    end

    def call(env)
    end
  end

  class Artists
    def initialize(app)
      @app = app
    end

    def call(env)
      @artists = Artist.all

      b = bind
      html = template.result(b)
    end
  end

  class Songs
    def initialize(app)
      @app = app
    end

    def call(env)
    end
  end

  class Genres
    def initialize(app)
      @app = app
    end

    def call(env)
    end
  end

end
