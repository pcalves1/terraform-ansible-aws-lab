const fs = require('fs')

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
} = process.env

const host = HOST_FILE ? fs.readFileSync(HOST_FILE) : HOST
const user = USER_FILE ? fs.readFileSync(USER_FILE) : USER
const passwordRoot = PASSWORD_FILE ? fs.readFileSync(PASSWORD_FILE) : ROOT_PASSWORD
const passwordUser = PASSWORD_FILE ? fs.readFileSync(PASSWORD_FILE) : USER_PASSWORD
const database = DB_FILE ? fs.readFileSync(DB_FILE) : DB

let dbOpts = {
  host,
  user,
  password: passwordRoot,
  database,
  port: 3306,
};

module.exports = dbOpts