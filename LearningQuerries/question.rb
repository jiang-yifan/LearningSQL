require_relative 'questionsdb.rb'
require_relative 'user.rb'
require_relative 'question_follower.rb'
require_relative 'reply.rb'
require_relative 'save.rb'

class Question
  include Save
  
  def self.all
    query = <<-SQL
      SELECT
        *
      FROM
        questions
    SQL

    questions = QuestionsDB.instance.execute(query)
    questions.map { |question| Question.new question }
  end

  attr_accessor :title, :body
  attr_reader :id, :author_id

  def initialize(options = {})
    @title = options['title']
    @body = options['body']
    @id = options['id']
    @author_id = options['author_id']
  end

  def self.find_by_id(id)
      query = <<-SQL
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
      SQL
      Question.new(QuestionsDB.instance.execute(query, id).first)
  end

  def self.find_by_author_id(author_id)
    query = <<-SQL
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL
    questions= QuestionsDB.instance.execute(query, author_id)
    questions.map {|question| Question.new question}
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
    User.new(QuestionsDB.instance.execute(query, self.author_id).first)
  end

  def replies
    query = <<-SQL
    SELECT
      *
    FROM
      replies
    WHERE
      question_replied_id = ?
    SQL
      Reply.new(QuestionsDB.instance.execute(query, self.id).first)
  end

  def followers
    QuestionFollower.followed_for_question_id(self.id)
  end

  def self.most_followed(n)
    QuestionFollower.most_followed_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_question(n)
  end
end
