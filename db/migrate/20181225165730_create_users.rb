class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :pwd
      t.string :usertype

      t.timestamps
    end
  end
end
