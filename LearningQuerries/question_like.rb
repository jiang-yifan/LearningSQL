require_relative 'questionsdb.rb'
require_relative 'user.rb'
class QuestionLike
  def self.all
    query = <<-SQL
    SELECT
    *
    FROM
    question_likes
    SQL

    likes = QuestionsDB.instance.execute(query)
    likes.map { |like| QuestionLike.new like }
  end

  attr_reader :id, :liked_question_id, :liker_id

  def initialize(options = {})
    @liked_question_id = options['liked_question_id']
    @liker_id = options['liker_id']
  end

  def self.likers_for_questions_id(question_id)
    query = <<-SQL
      SELECT
        *
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.liker_id
      WHERE
        question_likes.liked_question_id = ?
    SQL
    users = QuestionsDB.instance.execute(query, question_id)
    users.map {|user| User.new(user)}
  end

  def self.num_likes_for_questions_id(question_id)
    query = <<-SQL
      SELECT
        COUNT(*) number_of_likes
      FROM
        users
      JOIN
        question_likes ON users.id = question_likes.liker_id
      WHERE
        question_likes.liked_question_id = ?
      GROUP BY
        liked_question_id
    SQL
    result = QuestionsDB.instance.execute(query, question_id)
    return 0 if result.empty?
    result.first.values.first
  end

  def self.liked_questions_for_user_id(user_id)
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      JOIN
        question_likes ON questions.id = question_likes.liked_question_id
      WHERE
      question_likes.liker_id = ?
    SQL
    questions = QuestionsDB.instance.execute(query, user_id)
    questions.map {|question| Question.new(question)}
  end

  def self.most_liked_questions(n)
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      LEFT JOIN
        question_likes ON questions.id = question_likes.liked_question_id
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
