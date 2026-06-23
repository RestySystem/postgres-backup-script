FROM node:24

WORKDIR /app

# Install PostgreSQL 16 client from official PostgreSQL repository
RUN apt update && apt install -y curl gnupg telnet zip unzip \
  && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-archive-keyring.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/postgresql-archive-keyring.gpg] http://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
  && apt update && apt install -y postgresql-client-16 \
  && rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"\
  && unzip awscliv2.zip && ./aws/install

RUN npm install aws-sdk @aws-sdk/client-rds @aws-sdk/client-s3 -g

COPY . .

RUN chmod +x -R /app/bin
RUN chmod +x /app/s3-backup/update-s3-bucket
RUN cd /app/s3-backup && npm install && cd /app/

ENV PATH=$PATH:/app/bin

CMD ["sleep", "infinity"]
