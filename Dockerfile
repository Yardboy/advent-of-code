FROM aptible/ruby:2.5-ubuntu-16.04

RUN apt-get update -qq && \
    apt-get install -y \
      vim

# Set an environment variable to avoid repetition
ENV APP_HOME /var/www/app
ENV HOME /root

# Set the working directory
WORKDIR $APP_HOME

# Install gems
ADD Gemfile* $APP_HOME/
RUN bundle install

# COPY app to container
ADD . $APP_HOME
