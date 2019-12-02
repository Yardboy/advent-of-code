FROM ruby:2.6.5

LABEL app-name="advent"

RUN apt-get update -qq && \
    apt-get install -y \
      vim

# Create and set the working directory
ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# COPY app to container
COPY . $APP_HOME
