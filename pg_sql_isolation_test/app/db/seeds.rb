# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Book.destroy_all
User.destroy_all

User.create([{name: 'Alex', money: 0}, {name: 'Bob', money: 0}])

alex = User.find_by_name('Alex')
alex.books.create([{name: 'Book 1'}, {name: 'Book 2'}])
