import express from 'express'
import CategoryController from '../controllers/CategoryController.js'

const categoryRouter = express.Router()

categoryRouter.post('/', CategoryController.createCategory)
categoryRouter.post('/budget', CategoryController.createBudget)
categoryRouter.get('/', CategoryController.getCategories)

export default categoryRouter
