FROM ruby:3.4-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libssl-dev \
  pkg-config \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY app.rb ./
EXPOSE 4181
CMD ["bundle", "exec", "ruby", "app.rb"]
