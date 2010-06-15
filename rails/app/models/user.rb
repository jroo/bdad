class User < ActiveRecord::Base
  
  has_many :sketches
  
  def self.create_random!
    User.create!(:name => random_name)
  end
  
  protected
  
  def self.random_name
    "anonymous-%03i" % rand(1_000)
  end
end
