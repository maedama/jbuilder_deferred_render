class User < ActiveRecord::Base
  has_many :books
end
