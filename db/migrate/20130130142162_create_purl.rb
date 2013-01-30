# Copyright © 2012 The Pennsylvania State University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class CreatePurl < ActiveRecord::Migration
  def self.up
    create_table	:repo_object, {:primary_key => :repo_object_id, :force => true} do |t|
      t.integer 	:repo_object_id
      t.string 		:filename
      t.string 		:url
      t.datetime 	:date_added
      t.string 		:add_source_ip
      t.datetime 	:date_modified
      t.string 		:information
    end

    create_table	:purl, {:primary_key => :purl_id, :force => true} do |t|
      t.integer 	:purl_id
      t.integer 	:repo_object_id
      t.string 		:access_count
      t.datetime 	:last_accessed
      t.string 		:source_app
      t.datetime 	:date_created
    end

    create_table	:object_access, {:primary_key => :access_id, :force => true} do |t|
      t.integer 	:access_id
      t.datetime 	:date_accessed
      t.string 		:ip_address
      t.string 		:host_name
      t.string 		:user_agent
      t.string 		:request_method
      t.string 		:path_info
      t.integer 	:repo_object_id
      t.integer 	:purl_id
    end

  end

  def self.down
    drop_table :repo_object
    drop_table :purl
    drop_table :object_access
  end
end
