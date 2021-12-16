class AccessPolicy
  include AccessGranted::Policy

  def configure
    role :admin, proc { |a| a.admin? } do
      can :manage, Essay
      can :manage, Category
      can :manage, ReferencingStyle
      can :manage, Admin
      can :manage, Seller
      can :manage, Purchase
      can :manage, Transaction
      can :manage, Withdrawal
      can :manage, Comment
      can :manage, Page
      can :manage, Post
      can :manage, Student
      can :manage, Order
      can :manage, Message
      can :manage, Invoice
      can :manage, Question
      can :manage, Writer
      can :manage, Faq
      can :manage, Coupon
      can :manage, Redemption
      can :take_ownership, Seller
      can :refresh_thumbnails, Essay
      can :view_dashboard
    end

    role :moderator, proc { |a| a.moderator? } do
      can [:create, :update], Category
      can [:create, :update], ReferencingStyle
      can [:read, :create], Admin
      can :read, Seller
      can :read, Student
      can :read, Purchase
      can :read, Transaction
      can :read, Withdrawal
      can :read, Comment
      can :read, Order
      can :read, Message
      can :read, Invoice
      can :read, Faq
      can :manage, Page
      can :manage, Post
      can [:create, :read, :update], Question
      can [:read, :create], Essay
      can :update, Essay do |essay,owner|
        essay.owner == owner
      end
      can :update, Admin do |admin,owner|
        admin == owner
      end
    end

    role :clerk, proc { |a| a.clerk? } do
      can [:read, :create, :update], Essay
      can [:read, :create, :update], Question
    end

    role :guest do
      can :read, Category
      can :read, ReferencingStyle
      can :read, Page
      can :read, Post
      can :read, Question
    end
  end
end
