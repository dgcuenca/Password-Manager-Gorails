class Password < ApplicationRecord
  has_many :user_passwords
  has_many :users, through: :user_passwords

  encrypts :username, deterministic:true #allows to query agains the username since a url can have multiple username, like netflix with different users
  encrypts :password
end
