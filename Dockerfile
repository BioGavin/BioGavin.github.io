FROM ruby:3.2-bookworm

WORKDIR /site

# Native deps for common Jekyll gems (nokogiri/ffi/listen, etc.)
RUN apt-get -o Acquire::Retries=5 -o Acquire::http::Timeout=30 update \
    && apt-get -o Acquire::Retries=5 -o Acquire::http::Timeout=30 install -y --no-install-recommends \
    build-essential \
    git \
    libffi-dev \
    libyaml-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle config set path vendor/bundle \
    && bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 4000

CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--livereload", "--force_polling"]
