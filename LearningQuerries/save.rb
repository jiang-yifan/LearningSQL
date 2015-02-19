require_relative "question.rb"

module Save

  def save
    if @id
      update
    else
      create
    end
  end

  def class_name
      if self.class.to_s.downcase == "reply"
        "replie"
      else
        self.class.to_s.downcase
      end
  end

  def variable_arrays
    #don't want ID
    variables = self.instance_variables.reject {|var| var == :@id}
    variable_values = variables.map do |variable|
      instance_variable_get(variable)
    end
    #to string and remove @ symbol
    variables.map! {|variable| variable.to_s.delete('@')}
    [variables, variable_values]
  end

  def create
    vars, vals = variable_arrays
    update_string = vars.map do |name|
      "#{name}"
    end.join(', ')

    value_string = vals.map {|val| "?"}.join(', ')

    sql_string = <<-SQL
      INSERT INTO
        #{class_name}s(#{update_string})
      VALUES
        (#{value_string})
    SQL

    QuestionsDB.instance.execute(sql_string, *(vals ))
    @id = QuestionsDB.instance.last_insert_row_id
  end

  def update

    vars, vals = variable_arrays
    update_string = vars.map do |name|
      "#{name} = ?"
    end.join(', ')

    sql_string = <<-SQL
      UPDATE
        #{class_name}s
      SET
        #{update_string}
      WHERE
        id = ?
    SQL

    QuestionsDB.instance.execute(sql_string, *(vals + [id]))
  end
end
#
