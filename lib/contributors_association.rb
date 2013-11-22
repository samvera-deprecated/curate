class ContributorsAssociation #< ActiveFedora::Associations::Association TODO when AF 7 is out

  instance_methods.each { |m| undef_method m unless m.to_s =~ /^(?:nil\?|send|object_id|to_a|should)$|^__|^respond_to|proxy_/ }
  
  delegate :each, :size, :first, :last, :to_s, :blank?, :is_a?, :map, :==, :inspect, :pretty_print, to: :to_a
  attr_reader :owner

  def initialize(owner, reflection)
    @owner = owner
    @reflection = reflection
  end


  def loaded?
    @loaded
  end

  def <<(*records)
    result = true
    load_target unless loaded?
    records.flatten.each do |record|
      raise_on_type_mismatch(record)
      add_record_to_target_with_callbacks(record) do |r|
        result &&= insert_record(record)
      end
    end
    # return self so you can do method chaining (e.g. assoc << record1 << record2 )
    result && self
  end

  def to_ary
    load_target unless loaded?
    @target
  end

  alias to_a to_ary

  def build args={}
    p = klass.create!(args)
    insert_record(p)
  end


  def delete record
    owner.send(field_name).delete(record.as_rdf_object)
    load_target
  end

  protected

    def insert_record(record)
      predicate = owner.config_for_term_or_uri(field_name).predicate
      owner.graph.insert([owner.rdf_subject, predicate, record.as_rdf_object ])
      owner.reset_child_cache!
      @target << record
    end

    # TODO after upgrading to AF 7, we can extend ActiveFedora::Associations::Association and remove this method
    # Raises ActiveFedora::AssociationTypeMismatch unless +record+ is of
    # the kind of the class of the associated objects. Meant to be used as
    # a sanity check when you are about to assign an associated record.
    def raise_on_type_mismatch(record)
      unless record.is_a?(@reflection.klass) || record.is_a?(@reflection.class_name.constantize)
        message = "#{@reflection.class_name}(##{@reflection.klass.object_id}) expected, got #{record.class}(##{record.class.object_id})"
        raise ActiveFedora::AssociationTypeMismatch, message
      end
    end

    # TODO after upgrade to AF 7 we can remove this method
    def add_record_to_target_with_callbacks(record)
      #  callback(:before_add, record)
      yield(record) if block_given?
      @target ||= [] unless loaded?
      if index = @target.index(record)
        @target[index] = record
      else
         @target << record
      end
    #  callback(:after_add, record)
    #  set_inverse_instance(record, @owner)
      record
    end

    def load_target
      pids = ActiveFedora::Base.pids_from_uris(owner.send(field_name).map(&:to_s))
      @loaded = true
      @target = klass.find(pids)
    end

    def field_name
      :creator
    end

    def klass
      Person
    end

end
