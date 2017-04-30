class CreateOptions < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.boolean :default_on
      t.string :ip
      t.timestamps
    end
  end
end
