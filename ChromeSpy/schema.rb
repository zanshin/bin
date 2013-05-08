ActiveRecord::Schema.define(:version => 0) do

  create_table "downloads", :force => true do |t|
    t.string  "full_path",      :limit => nil, :null => false
    t.string  "url",            :limit => nil, :null => false
    t.integer "start_time",                    :null => false
    t.integer "received_bytes",                :null => false
    t.integer "total_bytes",                   :null => false
    t.integer "state",                         :null => false
  end

  create_table "keyword_search_terms", :id => false, :force => true do |t|
    t.integer "keyword_id",                :null => false
    t.integer "url_id",                    :null => false
    t.string  "lower_term", :limit => nil, :null => false
    t.string  "term",       :limit => nil, :null => false
  end

  add_index "keyword_search_terms", ["keyword_id", "lower_term"], :name => "keyword_search_terms_index1"
  add_index "keyword_search_terms", ["url_id"], :name => "keyword_search_terms_index2"

  create_table "meta", :primary_key => "key", :force => true do |t|
    t.string "value", :limit => nil
  end

  add_index "meta", ["key"], :name => "sqlite_autoindex_meta_1", :unique => true

  create_table "presentation", :primary_key => "url_id", :force => true do |t|
    t.integer "pres_index", :null => false
  end

  create_table "segment_usage", :force => true do |t|
    t.integer "segment_id",                 :null => false
    t.integer "time_slot",                  :null => false
    t.integer "visit_count", :default => 0, :null => false
  end

  add_index "segment_usage", ["segment_id"], :name => "segments_usage_seg_id"
  add_index "segment_usage", ["time_slot", "segment_id"], :name => "segment_usage_time_slot_segment_id"

create_table "segments", :force => true do |t|
    t.string  "name",       :limit => nil
    t.integer "url_id"
    t.integer "pres_index",                :default => -1, :null => false
  end

  add_index "segments", ["name"], :name => "segments_name"
  add_index "segments", ["url_id"], :name => "segments_url_id"

  create_table "urls", :force => true do |t|
    t.string  "url",             :limit => nil
    t.string  "title",           :limit => nil
    t.integer "visit_count",                    :default => 0, :null => false
    t.integer "typed_count",                    :default => 0, :null => false
    t.integer "last_visit_time",                               :null => false
    t.integer "hidden",                         :default => 0, :null => false
    t.integer "favicon_id",                     :default => 0, :null => false
  end

  add_index "urls", ["favicon_id"], :name => "urls_favicon_id_INDEX"
  add_index "urls", ["url"], :name => "urls_url_index"

  create_table "visit_source", :force => true do |t|
    t.integer "source", :null => false
  end

  create_table "visits", :force => true do |t|
    t.integer "url",                       :null => false
    t.integer "visit_time",                :null => false
    t.integer "from_visit"
    t.integer "transition", :default => 0, :null => false
    t.integer "segment_id"
    t.boolean "is_indexed"
  end

  add_index "visits", ["from_visit"], :name => "visits_from_index"
  add_index "visits", ["url"], :name => "visits_url_index"
  add_index "visits", ["visit_time"], :name => "visits_time_index"

end
