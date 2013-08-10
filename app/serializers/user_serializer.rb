class UserSerializer < ActiveModel::Serializer

  attributes :name, :email, :auth_key

end
