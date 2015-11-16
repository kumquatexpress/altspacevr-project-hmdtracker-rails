module AuditedState
  extend ActiveSupport::Concern

  class ValidationException < Exception
  end

  module ClassMethods
    attr_reader :state_model, :states, :state_model_name
    private
    def has_audited_state_through(state_model, states)
      has_many state_model
      validates :state, inclusion: {in: states}
      after_save :create_inner_state

      @states = states
      @state_model = state_model.to_s.classify.constantize
      @state_model_name = state_model.to_sym
    end

    def is_audited_state_for(state_model)
      class_attribute :model_class
      self.model_class = state_model
      belongs_to state_model
    end

  end

  def state
    if self.class.states
      s ||= self.send(self.class.state_model_name).order(updated_at: :desc).pluck(:state).first
      s ||= self.class.states.first
      s.to_sym
    else
      super
    end
  end

  def state=(s)
    @temp_state = s.to_sym
    if self.class.state_model
      # This checks whether we have an existing HmdState or if the next state is the same as current
      # and we bypass the create if so, to increase performance.
      if(self.send(self.class.state_model_name).count < 1 || state != @temp_state)
        unless self.class.states.include? @temp_state
          raise ValidationException.new("state is not in approved states")
        end
        # This won't work if we create a brand new hmd model since the parent won't save before the inner state
        # So try/rescue/rely on the after_save and validation
        begin
          set_and_create_inner_state
        rescue ActiveRecord::RecordNotSaved => ex
          @inner_state = nil
        end
      else
        return
      end
    else
      super
    end
  end

  def set_and_create_inner_state
    @inner_state = self.send(self.class.state_model_name).create({
      state: @temp_state
    }).state
  end

  def create_inner_state
    if !@inner_state
      set_and_create_inner_state
    end
  end
end
