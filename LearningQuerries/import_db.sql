CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(20) NOT NULL,
  lname VARCHAR(20) NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(50) NOT NULL,
  body VARCHAR(500) NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers(
  followed_question_id INTEGER NOT NULL,
  following_user_id INTEGER NOT NULL,
  FOREIGN KEY(followed_question_id) REFERENCES questions(id)
  FOREIGN KEY(following_user_id) REFERENCES users(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  body VARCHAR(500) NOT NULL,
  question_replied_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  author_reply_id INTEGER NOT NULL,
  FOREIGN KEY(author_reply_id) REFERENCES users(id)
  FOREIGN KEY(parent_reply_id) REFERENCES replies(id)
  FOREIGN KEY(question_replied_id) REFERENCES questions(id)
);

CREATE TABLE question_likes(
  liked_question_id INTEGER NOT NULL,
  liker_id INTEGER NOT NULL,
  FOREIGN KEY (liked_question_id) REFERENCES questions(id)
  FOREIGN KEY (liker_id) REFERENCES users(id)
);


INSERT INTO
  users(fname, lname)
VALUES
  ('Yifan', 'Jiang'), ('Connor', 'Young');

INSERT INTO
  questions(title, body, author_id)
VALUES
  ('What is SQL?', 'How do we use the HAVING operator?', 2);

INSERT INTO
  question_followers(followed_question_id, following_user_id)
VALUES
  (1, 1);

INSERT INTO
  replies(body, question_replied_id, parent_reply_id, author_reply_id)
VALUES
  ('Check Google. It is the best!', 1, NULL, 2);


INSERT INTO
  question_likes(liked_question_id, liker_id)
VALUES
  (1, 1);
