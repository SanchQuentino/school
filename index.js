const express = require('express') /*Bien thu vien Express*/
const { Pool } = require('pg')  /*Bien thu vien Postgre*/
const pool = new Pool({
      host: 'localhost',
    port: 5432,
    database: 'school',
    user: 'mac'
}) /*Ket noi Database cua DBeaver*/

const app = express()   /*Tao express de khai bao route,server*/
app.get('/teacher', async (req,res) => {
    const result = await pool.query('SELECT id, name, username FROM teacher') /*Bang SQL*/
    res.json(result.rows)/*Gui ve dang JSON*/
})
app.post('/teacher', async (req,res)=>{
    
})
app.listen(3001, () => console.log('Server chạy ở cổng 3001'))/*Bat Server*/