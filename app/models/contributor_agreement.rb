class ContributorAgreement
  attr_reader :curation_concern, :user
  def initialize(curation_concern, user, params)
    @curation_concern = curation_concern
    @user = user
    @param_value = params[param_key.to_sym] || params[param_key.to_s]
  end

  def legally_binding_text
    <<-HTML
    <p>
      I am submitting my work for inclusion in the CurateND repository maintained by the University Libraries of the University of Notre Dame.
      I acknowledge that publication of the work may implicate my legal rights with respect to the work and its contents, including my ability to publish the work in other venues.
      I UNDERSTAND AND AGREE THAT BY SUBMITTING MY CONTENT FOR INCLUSION IN THE CURATEND REPOSITORY, I AGREE TO THE FOLLOWING TERMS:
    </p>

    <p>
      I hereby grant the University of Notre Dame permission to reproduce, edit, publish, disseminate, publicly display, or publicly perform, in whole or in part, the work in any medium at the University&rsquo;s discretion (including but not limited to public websites).
      I understand that I may be allowed the opportunity to select the intended audience for the materials that I submit, and I agree that I am fully responsible for any claims and all responsibility for materials submitted.
      The CurateND service is offered as-is with no warranties, express or implied.
      The University may suspend or terminate CurateND at any time for any reason in the University&rsquo;s sole discretion.
    </p>

    <p>
      I warrant that the submitted material is original to me and that I have power to make this agreement.
      I also warrant that the work has not been previously published elsewhere in whole or in part, and that I do not have any other publication agreements that involve this material or substantial parts of it that conflict with my submission of materials for dissemination in CurateND.
    </p>

    <p>
      I understand that I may request the University to remove my submitted materials from the CurateND repository; however, I acknowledge that the University cannot control or retract works that may have been accessed by third parties prior to my request for removal.
    </p>
    HTML
  end

  def acceptance_value
    'accept'
  end

  def param_key
    :accept_contributor_agreement
  end
  attr_reader :param_value

  def is_being_accepted?
    param_value == acceptance_value
  end
end
