class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.integer :street_number
      t.string :street_name
      t.string :address2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.string :home_phone
      t.string :mobile_phone
      
      t.timestamps
    end
  end
end
