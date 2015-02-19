require_relative 'questionsdb.rb'

class User

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

end


class Question
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
end

class Reply
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
end

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
end

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
end
