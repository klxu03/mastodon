class AddExtflagToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :ext_flag, :string, null: true, default: nil
  end
end
