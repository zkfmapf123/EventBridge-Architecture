import express from 'express'
import AWS from 'aws-sdk'

const app = express()
AWS.config.update({ region: "ap-northeast-2" })
const sqs = new AWS.SQS({
    apiVersion: "2012-11-05",
    region: "ap-northeast-2"
})


app.get("/", (req, res) => {
    return res.status(200).json("hello purple world")
})

app.get("/health", (req, res) => {
    return res.status(200).send("success")
})

const sendMessageSQS = async (attr) => {

    var params = {
        DelaySeconds: 10,
        MessageAttributes: {
            Name: {
                DataType: "String",
                StringValue: attr.name,
            },
            Age: {
                DataType: "String",
                StringValue: attr.age,
            },
            Job: {
                DataType: "String",
                StringValue: attr.job,
            },
        },
        MessageBody:
            "Information about current NY Times fiction bestseller for week of 12/11/2016.",
        QueueUrl: process.env.BLUE_QUEUE_URL,
    };

    return sqs.sendMessage(params).promise()
}

app.get("/blue-send", async (req, res) => {
    try {
        await sendMessageSQS({
            name: "leedonggyu",
            age: "30",
            job: "devops engineer"
        })

    } catch (e) {
        console.error(e)
        return res.status(500).send("Error sending message to SQS")
    }

    return res.status(200).send("Success to SQS")
})

app.listen(process.env.PORT, () => {
    console.log(`BlueQUEUE : ${process.env.BLUE_QUEUE_URL}`)
    console.log(`Hello Purple Service to : ${process.env.PORT}`)
})