class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.belongs_to :user, foreign_key: true
      t.string :currency
      t.string :wallet_priv
      t.string :wallet_pub
      t.string :wallet_addr
      t.string :wallet_wif
      t.timestamps
    end
  end
end
