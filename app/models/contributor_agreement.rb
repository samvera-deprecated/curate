class ContributorAgreement
  attr_reader :curation_concern, :user
  def initialize(curation_concern, user, params)
    @curation_concern = curation_concern
    @user = user
    @param_value = params[param_key.to_sym] || params[param_key.to_s]
  end

  def human_readable_text
    <<-HTML
		<article class="human_readable contributor_agreement">
    <p>
      Sed mattis, nulla id pulvinar porttitor, nisi erat fermentum sem, ac tempus
      neque sem ut eros. Aliquam malesuada eros turpis, ut volutpat dolor. Nam vel
      lorem lacus. Pellentesque lacus metus, aliquam sit amet hendrerit at, laoreet ut
      lorem. Sed congue interdum faucibus. Nam interdum mi in sem imperdiet placerat.
      Sed hendrerit volutpat nisi eget ornare.
    </p>
		</article>
    HTML
  end


  def legally_binding_text
    <<-HTML
    <article class="lawyer_readable contributor_agreement">
			<p>
				Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin tempus volutpat
				nisl ut tincidunt. Cras quis nisl dui, in pharetra odio. Aenean turpis mauris,
				lobortis sed scelerisque sed, commodo quis mi. Aliquam et odio felis, eget
				dignissim velit. Quisque eu purus risus, at faucibus nulla. Nulla vitae
				scelerisque libero. Duis et porttitor ligula. In hac habitasse platea dictumst.
				Proin porta elementum nibh vel euismod. Nunc aliquam hendrerit ipsum, sed
				aliquet nisl varius eu. Etiam venenatis tortor in magna lobortis vehicula quis
				quis est. Maecenas aliquam nisi nec mi luctus quis viverra quam varius. Donec
				euismod mauris at odio iaculis dapibus.
      </p>
      <p>
				Donec vel nunc malesuada enim euismod dictum. Phasellus euismod ornare mattis.
				Praesent consequat sem id massa iaculis laoreet. Pellentesque ac sagittis risus.
				Ut neque diam, varius sed adipiscing in, ullamcorper a neque. Etiam porttitor
				laoreet euismod. Quisque viverra nunc eget eros venenatis vitae scelerisque eros
				placerat. Mauris placerat vulputate blandit. Morbi sodales orci in nibh posuere
				euismod. Vivamus dapibus ornare eros eget suscipit. Aliquam erat volutpat. Proin
				eu scelerisque sem. Pellentesque quis mauris est, quis porta quam. Suspendisse
				potenti. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur
				ridiculus mus.
      </p>
      <p>
				Aenean ullamcorper vulputate nibh, sed congue arcu interdum et. Pellentesque
				habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.
				Phasellus in sapien non ipsum tincidunt bibendum vitae eu orci. Nunc hendrerit
				euismod ipsum, ut egestas leo rutrum eu. Nulla fringilla gravida felis eget
				vestibulum. Vestibulum pretium, neque eget interdum congue, ante mauris
				tincidunt mi, eu vehicula neque dui vel urna. Ut tincidunt augue eget lorem
				ullamcorper pellentesque. Sed blandit velit lectus, ac rutrum leo. In est massa,
				mattis vitae dictum quis, varius vel tortor. Nullam interdum nulla eget felis
				laoreet non scelerisque justo varius.
      </p>
		</article>
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
