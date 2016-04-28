Book.destroy_all
User.destroy_all

User.create([{name: 'Alex', money: 0}, {name: 'Bob', money: 0}])

alex = User.find_by_name('Alex')
alex.books.create([{name: 'Book 1'}, {name: 'Book 2'}])
