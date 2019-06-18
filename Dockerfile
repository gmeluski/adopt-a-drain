FROM ruby:2.3.5

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install -j 20

EXPOSE 3000

COPY . .

ENV RAILS_ENV=production \
    RACK_ENV=production \
    PORT=3000

RUN rake assets:precompile

CMD bundle exec puma -b tcp://0.0.0.0:$PORT

