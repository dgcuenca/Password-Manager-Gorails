class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords

  encrypts :username, deterministic:true #allows to query agains the username since a url can have multiple username, like netflix with different users
  encrypts :password

  validates :url, presence: true
  validates :username, presence: true
  validates :password, presence: true

  def shareable_users
    User.excluding(users)
  end

  def editable_by?(user)
    #& used in case ask for edition permision for someone that dont exists
    user_passwords.find_by(user: user)&.editable?
  end

  def shareable_by?(user)
    user_passwords.find_by(user: user)&.shareable?
  end
  
  def deletable_by?
    user_passwords.find_by(user: user)&.deletable?
  end
end
