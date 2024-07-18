FROM ruby:3.1.2
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./

RUN

# Setup FreeTDS
RUN wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.4.19.tar.gz && \
		tar -xzf freetds-1.4.19.tar.gz && \
		cd freetds-1.4.19 && \
		./configure --prefix=/usr/local --with-tdsver=7.4 && \
		make && \
		make install
RUN bundle install
ADD . /usr/src/app
EXPOSE 3000
CMD rails s -b 0.0.0.0