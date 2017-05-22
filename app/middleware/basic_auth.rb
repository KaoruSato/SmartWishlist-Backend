class BasicAuth
  def initialize(app, secure_path)
    @app = app
    @secure_path = secure_path
  end

  def call(env)
    if env["PATH_INFO"].include?(@secure_path)
      auth = Rack::Auth::Basic.new(@app) do |u, p|
        u == username && p == password
      end
      auth.call env
    else
      @app.call env
    end
  end

  def username
    ENV.fetch("ADMIN_LOGIN")
  end

  def password
    ENV.fetch("ADMIN_PASSWORD")
  end
end
