require_relative 'questionsdb.rb'
require_relative 'question.rb'
require_relative 'user.rb'
require_relative 'save.rb'

class Reply
  include Save
  def self.all
    query = <<-SQL
      SELECT
        *
      FROM
        replies
    SQL

    replies = QuestionsDB.instance.execute(query)
    replies.map { |reply| Reply.new reply }
  end

  attr_accessor :body
  attr_reader :id, :author_reply_id, :parent_reply_id, :question_replied_id

  def initialize(options = {})
    @body = options['body']
    @id = options['id']
    @question_replied_id = options['question_replied_id']
    @parent_reply_id = options['parent_reply_id']
    @author_reply_id = options['author_reply_id']
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Reply.new(QuestionsDB.instance.execute(query, id).first)
  end

  def self.find_by_question_id(question_id)
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        question_replied_id = ?
    SQL
    replies = QuestionsDB.instance.execute(query, question_id)
    replies.map { |reply| Reply.new reply }
  end

  def self.find_by_user_id(user_id)
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        author_reply_id = ?
    SQL
    replies = QuestionsDB.instance.execute(query, user_id)
    replies.map { |reply| Reply.new reply }
  end

  def author
    query = <<-SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    User.new(QuestionsDB.instance.execute(query, author_reply_id).first)
  end

  def question
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    Question.new(QuestionsDB.instance.execute(query, question_replied_id).first)
  end

  def parent_reply
    unless parent_reply_id.nil?
      query = <<-SQL
        SELECT
          *
        FROM
          replies
        WHERE
          id = ?
      SQL
      Reply.new(QuestionsDB.instance.execute(query, parent_reply_id).first)
    end
  end

  def child_replies
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
    replies = QuestionsDB.instance.execute(query, id)
    replies.map {|reply| Reply.new(reply)}
  end
end
