class AddCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :email, index: { unique: true }
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :title
      t.string :role
      t.boolean :verified
      t.integer :score
    end
  end
end
