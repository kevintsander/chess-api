FROM ghcr.io/kevintsander/rails-free-tds-image:main
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

ADD . /usr/src/app
EXPOSE 3000

# Define build-time variable
ARG RAILS_ENV=development

# Set environment variable
ENV RAILS_ENV=${RAILS_ENV}

# Run the Rails app with the specified environment
CMD rails s -b 0.0.0.0 -e ${RAILS_ENV}
