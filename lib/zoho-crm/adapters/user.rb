module ZohoCrm::Adapters
  class User
    include ZohoCrm::Adapters::Api

    def initialize(module_name = 'Users')
      @module_name = module_name
    end

    def get_users(type)
      response = perform_get(get_users_url(@module_name, type: type))

      return response.dig('users', 'user')
    end
  end
end
