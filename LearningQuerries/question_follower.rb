require_relative 'questionsdb.rb'
require_relative 'user.rb'
require_relative 'question.rb'

class QuestionFollower
  def self.all
    query = <<-SQL
    SELECT
      *
    FROM
      question_followers
    SQL

    followers = QuestionsDB.instance.execute(query)
    followers.map { |follower| QuestionFollower.new follower }
  end

  attr_reader :id, :followed_question_id, :following_user_id

  def initialize(options = {})
    @followed_question_id = options['followed_question_id']
    @following_user_id = options['following_user_id']
  end

  def self.followers_for_question_id(question_id)
    query = <<-SQL
      SELECT
        *
      FROM
        users
      JOIN
        question_followers ON users.id = question_followers.following_user_id
      WHERE
        question_followers.followed_question_id = ?
    SQL
    users = QuestionsDB.instance.execute(query, question_id)
    users.map {|user| User.new(user)}
  end

  def self.followed_questions_for_user_id(user_id)
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      JOIN
        question_followers ON questions.id = question_followers.followed_question_id
      WHERE
        question_followers.following_user_id = ?
    SQL
    questions = QuestionsDB.instance.execute(query, user_id)
    questions.map {|question| Question.new(question)}
  end

  def self.most_followed_questions(n)
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      LEFT JOIN
        question_followers ON questions.id = question_followers.followed_question_id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
    SQL
    questions = QuestionsDB.instance.execute(query)
    results = questions.map {|question| Question.new(question)}
    results[0...n]
  end
end
