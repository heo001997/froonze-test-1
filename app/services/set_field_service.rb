class SetFieldService
  ONLY_STRIPPED_ATTRS = %w(first_name last_name phone title role)
  ALLOWED_ATTRS = %w(email score) | ONLY_STRIPPED_ATTRS

  def call(customer:, field_name:, new_value:)
    ActiveRecord::Base.transaction do
      case field_name
      when 'email'
        return { error: 'You need to specify an email for this customer.' } if new_value.blank?

        new_value = new_value.strip.downcase

        return { error: "Can't save email. Invalid value: '#{new_value}'" } if EmailValidator.valid?(new_value) != true

        customer.email = new_value
        customer.verified = 0

        begin
          customer.save!
        rescue ActiveRecord::RecordNotUnique
          return { error: 'Email already exists.' }
        rescue StandardError => e
          return { error: e.to_s }
        end
        return {}

      when 'first_name'
        customer.first_name = new_value.strip
      when 'last_name'
        customer.last_name = new_value.strip
      when 'phone'
        customer.phone = new_value.strip
      when 'title'
        customer.title = new_value.strip
      when 'role'
        customer.role = new_value.strip
      when 'score'
        customer.score = new_value.to_i
      else
        return { error: "Unknown field: '#{field_name}'" }
      end
      customer.save!

      return {}
    end
  end

  def call_refactored(customer:, field_name:, new_value:)
    new_value = new_value&.strip
    return { error: "Unknown field: '#{field_name}'" } if ALLOWED_ATTRS.exclude?(field_name)

    case field_name
    when 'score'
      customer.score = new_value.to_i
    when 'email'
      new_value = new_value&.downcase
      return { error: 'You need to specify an email for this customer.' } if new_value.blank?
      return { error: "Can't save email. Invalid value: '#{new_value}'" } if EmailValidator.invalid?(new_value)
      customer.assign_attributes(email: new_value, verified: 0)
    else
      customer.send("#{field_name}=", new_value)
    end

    ActiveRecord::Base.transaction do
      customer.save!
    rescue ActiveRecord::RecordNotUnique
      return { error: 'Email already exists.' }
    rescue StandardError => e # Now it's catch and return exception for other fields too not just email
      return { error: e.to_s }
    end

    {}
  end
end
