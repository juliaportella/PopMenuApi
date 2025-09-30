FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /pop-menu-project

COPY Gemfile* ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bash", "-c", "bundle exec rails db:create db:migrate && bundle exec rails server -b 0.0.0.0 -p 3000"]
