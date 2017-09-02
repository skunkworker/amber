module Amber::Router::Session
  class Store
    getter session_config : Hash(Symbol, Symbol | Int32 | String) = Amber::Server.session
    getter cookies : Cookies::Store

    def initialize(@cookies)
    end

    def build : Session::AbstractStore
      return RedisStore.build(redis_store, cookies, session_config) if redis?
      CookieStore.build(cookie_store, session_config)
    end

    private def cookie_store
      if store == :encrypted_cookie
        cookies.encrypted
      else
        cookies.signed
      end
    end

    private def redis_store
      Redis.new(url: session_config[:redis_url].to_s)
    end

    private def redis?
      store == :redis
    end

    private def store
      session_config[:store]
    end
  end
end