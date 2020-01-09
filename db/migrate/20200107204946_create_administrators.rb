class CreateAdministrators < ActiveRecord::Migration[6.0]
  def change
    create_table :administrators do |t|
      t.string :username
      t.string :password
      t.string :email_address

      t.timestamps
    end
  end
end