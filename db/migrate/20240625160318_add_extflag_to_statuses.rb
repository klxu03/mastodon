class AddExtflagToStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :statuses, :ext_flag, :string, null: true, default: nil
  end
end
