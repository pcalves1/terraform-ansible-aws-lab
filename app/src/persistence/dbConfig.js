const fs = require('fs');

const {
  MYSQL_HOST: HOST,
  MYSQL_HOST_FILE: HOST_FILE,
  MYSQL_USER: USER,
  MYSQL_PASSWORD: USER_PASSWORD,
  MYSQL_USER_FILE: USER_FILE,
  MYSQL_ROOT_PASSWORD: ROOT_PASSWORD,
  MYSQL_ROOT_PASSWORD_FILE: PASSWORD_FILE,
  MYSQL_DATABASE: DB,
  MYSQL_DATABASE_FILE: DB_FILE,
} = process.env;

const host = HOST_FILE ? fs.readFileSync(HOST_FILE, 'utf8').trim() : HOST;
const user = USER_FILE ? fs.readFileSync(USER_FILE, 'utf8').trim() : USER;
const passwordRoot = PASSWORD_FILE ? fs.readFileSync(PASSWORD_FILE, 'utf8').trim() : ROOT_PASSWORD;
const passwordUser = USER_PASSWORD ? USER_PASSWORD.trim() : passwordRoot;
const database = DB_FILE ? fs.readFileSync(DB_FILE, 'utf8').trim() : DB;

let dbOpts = {
  host,
  user,
  password: passwordUser,
  database,
  port: 3306,
};

module.exports = dbOpts;
