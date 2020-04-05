module V1
  # ActiveModel::SerializerはRailsなどで簡単で素早くjsonを作れるgem(jbuilderより記法が直感的)
  class SessionSerializer < ActiveModel::Serializer

    attributes :email, :token_type, :user_id, :access_token

    def user_id
      object.id
    end

    def token_type
      'Bearer'
    end

  end
end