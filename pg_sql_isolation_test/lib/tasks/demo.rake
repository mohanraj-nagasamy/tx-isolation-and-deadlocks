namespace :demo do

  task :run1 => :environment do
    bob = User.find_by_name('Bob')

    book1 = Book.find_by_name('Book 1')
    book1.trasnsfer_to(bob, 1)
  end

  task :run2 => :environment do
    bob = User.find_by_name('Bob')

    book2 = Book.find_by_name('Book 2')
    book2.trasnsfer_to(bob, 1)
    # book2.trasnsfer_to_deadlock(bob, 1)
  end
end
