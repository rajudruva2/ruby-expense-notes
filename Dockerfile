FROM ruby:3.3-slim
WORKDIR /app
COPY Gemfile ./
RUN bundle install
COPY . .
ENV RACK_ENV=production
EXPOSE 4571
CMD ["bundle", "exec", "ruby", "app.rb"]
