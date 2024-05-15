import express from 'express'

const app = express()

app.get("/", (req, res) => {
    return res.status(200).json("hello world")
})

app.get("/health", (req, res) => {
    return res.status(200).send("success")
})

app.listen(process.env.PORT, () => {
    console.log(`Hello Green Service to : ${process.env.PORT}`)
})