class User < ActiveRecord::Base
  has_many :contacts, dependent: :destroy
  
  has_many :friendships
  has_many :friends, through: :friendships
  
  def not_friends_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1
  end
  
  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Anonymous"
  end

  def except_current_user(users)
    users.reject {|user| user.id == self.id}
  end
  
  def self.search(param)
    return User.none if param.blank?
    param.strip!
    param.downcase!
    (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
  end
  
  def self.first_name_matches(param)
    matches('first_name', param)
  end
  
  def self.last_name_matches(param)
    matches('last_name', param)
  end
  
  def self.email_matches(param)
    matches('email', param)
  end
  
  def self.matches(field_name, param)
    where("lower(#{field_name}) like ?", "%#{param}%")
  end
  
  before_save { self.email = email.downcase }
  
  validates :username, presence: true, 
  uniqueness: {case_sensitive: false}, 
  length: {minimum: 5, maximum: 25}
  
  validates :first_name, presence: true, 
  length: {minimum: 3, maximum: 25}
  
  validates :last_name, presence: true,
  length: {minimum: 3, maximum: 25}
  
  validates :email, presence: true, length: { maximum: 105 },
  uniqueness: { case_sensitive: false }
  validates_format_of :email, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  
end