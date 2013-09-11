# Copyright © 2013 The Pennsylvania State University
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
class Collection < ActiveFedora::Base
  include Hydra::Collection

  has_many :associated_persons, property: :has_profile, class_name: 'Person'

  delegate_to :descMetadata, [:resource_type], :unique => true

  # Reads from resource_type attribute.
  # Defaults to "Collection", but can be set to something else.
  # Profiles are marked with resource_type of "Profile" when they're created by the associated Person object
  # This is used to populate the Object Type Facet
  def human_readable_type
    self.resource_type ||= "Collection"
  end

  def is_profile?
    !associated_persons.empty?
  end

  def to_s
    title
  end

  def to_solr(solr_doc={}, opts={})
    super
    solr_doc[Solrizer.solr_name("desc_metadata__archived_object_type", :facetable)] = human_readable_type
    solr_doc
  end
end
