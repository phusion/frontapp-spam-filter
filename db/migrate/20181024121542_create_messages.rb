class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string  :front_id, null: false
      t.text    :body
      t.text    :stripped_body
      t.boolean :spam

      t.timestamps
    end
  end
end
