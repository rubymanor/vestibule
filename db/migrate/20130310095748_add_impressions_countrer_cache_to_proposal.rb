class AddImpressionsCountrerCacheToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :impressions_counter_cache, :integer
  end
end
