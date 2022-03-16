const mysql = require('mysql');
const dbConfig = require('./dbConfig.json');
const con = mysql.createPool(dbConfig);

module.exports = con;