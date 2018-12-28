class User < ApplicationRecord
  # attr_accessor :email, :pwd, :usertype

=begin
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable
=end

=begin
    def initialize(email, pwd, usertype)
      @email=email, @pwd=pwd, @usertype=usertype
    end
=end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false},
            format: {with: VALID_EMAIL_REGEX}, length: {minimum:3, maximum:50}

  validates :pwd, presence: true, length: {minimum:3, maximum:25}

  has_many :bookings

  #has_secure_password
=begin
  alias_method :authenticate, :valid_password?

  def self.from_token_payload(payload)
    self.find payload["sub"]
  end
=end

end
