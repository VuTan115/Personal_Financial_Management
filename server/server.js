import express, { application } from 'express'
import dotenv from 'dotenv'
import helmet from 'helmet'
import mongoose from 'mongoose'
import cors from 'cors'
import admin from 'firebase-admin'
import routes from './routes/index.js'
import isAuth from './middlewares/AuthMiddleware.js'
import serviceAccount from './serviceAccountKey.json' assert { type: 'json' }
import def from './middlewares/DefaultMiddleware.js'

const app = express()
dotenv.config()

const { PORT } = process.env

// middleware
app.use(express.json({ limit: '3mb' }))
app.use(express.urlencoded({ extended: true, limit: '30mb' }))
app.use(cors())
app.use(helmet())

mongoose
  .connect(process.env.DATABASE_URI)
  .then(() => {
    console.log('Connect to database successfully!')
  })
  .catch((e) => {
    console.log(e)
  })

// firebase auth

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://personal-financel-app-default-rtdb.firebaseio.com',
})
app.use(def)
app.use('/api/transaction', routes.transactionRouter)
app.use('/api/category', routes.categoryRouter)
app.use('/api/budget', routes.budgetRouter)
app.use('/api/wallet', routes.walletRouter)

app.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`)
})
