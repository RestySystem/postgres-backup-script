FROM node:22

WORKDIR /app

RUN apt update && apt install postgresql-client-16 curl telnet zip unzip -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"\
  && unzip awscliv2.zip && ./aws/install

RUN npm install aws-sdk @aws-sdk/client-rds @aws-sdk/client-s3 -g

COPY . .

RUN chmod +x -R /app/bin
RUN chmod +x /app/s3-backup/update-s3-bucket

ENV PATH=$PATH:/app/bin

CMD ["start-backup"]
