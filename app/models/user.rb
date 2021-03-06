class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :uid, :name, :provider, :firstname, :email, :password, :password_confirmation, :remember_me

  has_many :registrations
  has_many :programs, through: :registrations
  has_many :games, through: :programs
  has_many :tournaments, through: :programs

  geocoded_by :full_address, latitude: :lat, longitude: :lon
  after_validation :geocode, if: ->(obj){ obj.full_address.present? }

  def full_address
    if self.adress || self.zip_code || self.city || self.country
      self.adress + " " + self.zip_code.to_s + " " + self.city + " " + self.country
    end
  end

  def age
    now = Time.now.utc.to_date
    now.year - self.birthdate.year - ((now.month > self.birthdate.month || (now.month == self.birthdate.month && now.day >= self.birthdate.day)) ? 0 : 1)
  end

  def is_admin
    if self.role == 1
      true
    else
      false
    end
  end

  has_attached_file :image, styles: { medium: "300x300", thumb: "50x50" }, :default_url => "/images/:style/unknown.jpg"
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
            name: auth.info.last_name,
            firstname: auth.info.first_name,
            #username: auth.info.nickname || auth.uid,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: Devise.friendly_token[0,20],
            provider: auth.provider,
            uid: auth.uid
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def calculate_points
    points = 0
    victory = 0
    defeat = 0
    mp1 = Match.where("player1_id = ?", self.id)
    mp1.each do |m|
      if m.player1_score && m.player2_score
        if m.player1_score > m.player2_score
          points += 3
          victory += 1
        else
          if m.player1_score == m.player2_score
            points += 1
          else
            defeat += 1
          end
        end
      end
    end
    mp2 = Match.where("player2_id = ?", self.id)
    mp2.each do |m|
      if m.player1_score && m.player2_score
        if m.player1_score < m.player2_score
          points += 3
          victory += 1
        else
          if m.player1_score == m.player2_score
            points += 1
          else
            defeat += 1
          end
        end
      end
    end
    self.points = points
    self.nb_defeat = defeat
    self.nb_victory = victory
    self.save
  end
  def make_admin
    self.role = 1
    self.save
  end
end
