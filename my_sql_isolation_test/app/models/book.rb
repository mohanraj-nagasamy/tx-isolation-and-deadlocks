class Book < ActiveRecord::Base
  belongs_to :user

  def trasnsfer_to(new_user, price)
    transaction do
      old_user = self.user
      update_attributes!(user: new_user)

      puts "Before sleep"
      sleep 5
      puts "After sleep"

      User.where(id: new_user.id).update_all(['money = money - ?', price])
      User.where(id: old_user.id).update_all(['money = money + ?', price])
    end
  end
end
