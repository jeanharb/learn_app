class NumberUsers < ActiveRecord::Base
  attr_accessible :date, :num_users

  def self.add_number
  	@numb = User.all.count
  	@newnum = NumberUsers.new
  	@newnum.date = Time.now.strftime("%d/%m/%y")
  	@newnum.num_users = @numb
  	@newnum.save
  end
end
