class User < ActiveRecord::Base

  attr_accessor :password

  has_many  :products,  dependent:  :destroy, foreign_key: "seller_id"
  has_many  :sales,     dependent:  :destroy, foreign_key: "buyer_id"

  email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i

  validates :first_name,  :presence => true,
            :length                 => { maximum: 50 }
  validates :last_name,   :presence => true,
            :length                 => { maximum: 50 }
  validates :email,   :presence     => true,
            :format                 => { with: email_regex },
            :uniqueness             => { case_sensitive: false }

  validates :password,  :presence   => true,
            :confirmation           => true,
            :length                 => { within: 6..40 }

  before_save :encrypt_password

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end


  # class method that checks whether the user's email and submitted_password are valid
  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end


  private
    def encrypt_password
      # generate a unique salt if it's a new user
      self.salt = Digest::SHA2.hexdigest("#{Time.now.utc}--#{password}") if self.new_record?
    
      # encrypt the password and store that in the encrypted_password field
      self.encrypted_password = encrypt(password)
    end

    # encrypt the password using both the salt and the passed password
    def encrypt(pass)
      Digest::SHA2.hexdigest("#{self.salt}--#{pass}")
    end

end
