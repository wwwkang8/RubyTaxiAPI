class User < ApplicationRecord

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false},
            format: {with: VALID_EMAIL_REGEX}, length: {minimum:3, maximum:50}

  validates :pwd, presence: true, length: {minimum:3, maximum:25}

  has_many :bookings
end
