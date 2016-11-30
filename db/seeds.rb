# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
[
  { role_name: "ADMIN" },
  { role_name: "N_USER" }
].each { |role_attributes| Role.create(role_attributes) }

[
  {
    first_name: "Admin",
    last_name: "Admin",
    email: "admin@admin.co",
    password: "admin",
    role_id: "1"
  },
  {
    first_name: "Mary",
    last_name: "Littel",
    email: "flavie@schmitt.co",
    password: "anewpassword",
    role_id: "2"
  }
].each { |user_attributes| User.create(user_attributes) }
