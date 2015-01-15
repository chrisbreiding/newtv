class SetNewShowNames < ActiveRecord::Migration
  def up
    Show.connection.execute("UPDATE shows SET search_name=display_name")
    Show.connection.execute("UPDATE shows SET file_name=display_name")
  end

  def down
  end
end
