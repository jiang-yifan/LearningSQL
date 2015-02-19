require_relative 'questionsdb.rb'
require_relative 'question.rb'
require_relative 'reply.rb'
require_relative 'question_follower.rb'
require_relative 'save.rb'

require 'sqlite3'
class User
  include Save
  def self.all
    query = <<-SQL
      SELECT
        *
      FROM
        users
    SQL

    users = QuestionsDB.instance.execute(query)
    users.map{|user| User.new user}
  end

    attr_accessor :fname, :lname
    attr_reader :id

  def initialize(options = {})
    @fname = options['fname']
    @lname = options['lname']
    @id = options['id']
  end

  def self.find_by_id(id)
    query = <<-SQL
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    User.new(QuestionsDB.instance.execute(query, id).first)
  end

  def self.find_by_name(fname, lname)
    query = <<-SQL
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND lname = ?
    SQL
    names = QuestionsDB.instance.execute(query, fname, lname)
    names.map {|name| User.new name }
  end

  def authored_question
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    query = <<-SQL
      SELECT
        *
      FROM
        replies
      WHERE
        author_reply_id = ?
    SQL
    replies = QuestionsDB.instance.execute(query, self.id)
    replies.map {|reply| Reply.new reply }
  end

  def followed_questions
    QuestionFollower.followed_questions_for_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    query = <<-SQL
      SELECT
        CAST(COUNT(question_likes.liker_id) AS FLOAT) / COUNT(DISTINCT(questions.id))

      FROM
        questions
      LEFT JOIN
        question_likes ON question_likes.liked_question_id = questions.id
      WHERE
        questions.author_id = ?
    SQL
    average_karma = QuestionsDB.instance.execute(query, self.id)
    return 0 if average_karma.empty?
    average_karma.first.values.first
  end
end
