class ContributorAgreement
  attr_reader :curation_concern, :user
  def initialize(curation_concern, user)
    @curation_concern = curation_concern
    @user = user
  end

  def human_readable_text
    %(<p class="human_readable">place holder for human readable text</p>)
  end

  def legally_binding_text
    %(<p class="lawyer_readable">place holder for legally binding text</p>)
  end

  def acceptance_value
    'accept'
  end
end