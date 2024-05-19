import express from 'express'

const app = express()

app.get("/", (req, res) => {
    return res.status(200).json("hello internal service")
})

app.get("/health", (req, res) => {
    return res.status(200).send("success")
})

app.post("/destination", (req, res) => {
    console.log("body >> ", req.body)

    return res.status(200).send("destination")
})

app.listen(process.env.PORT, () => {
    console.log(`Hello Blue Service to : ${process.env.PORT}`)
})