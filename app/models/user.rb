class User < ActiveRecord::Base

  has_many :microposts, :dependent => :destroy

  has_many :relationships, :foreign_key => "follower_id",
                           :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed

  has_many :reverse_relationships, :foreign_key => "followed_id",
                                   :class_name => "Relationship",
                                   :dependent => :destroy
  has_many :followers, :through => :reverse_relationships, :source => :follower

  attr_accessor :password
  attr_accessible :name, :email, :password, :password_confirmation
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  :presence => true, :length => {:maximum => 50}
  validates :email, :presence => true, :format => { :with => email_regex }, :uniqueness => true
  validates :password, :presence => true, :confirmation => true, :length => { :within => 6..40 }

  scope :admin, where(:admin => true)
  # Return microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  before_save :encrypt_password
  

  def feed
    Micropost.from_users_followed_by(self)
  end

  def has_password?(submitted_password)
    encryped_password == encrypt(submitted_password) 
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end

  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end
  

  

private
  def encrypt_password
    self.salt = make_salt unless has_password?(password)
    self.encryped_password = encrypt(password)
  end
 
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  # Return an SQL condition for users followed by the given user.
  # We include the user's own id as well.
  def self.followed_by(user)
    following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
    where("user_id IN (#{following_ids}) OR user_id = :user_id",
          { :user_id => user })
  end
end
