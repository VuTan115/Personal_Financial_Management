import express from 'express'
import BudgetController from '../controllers/BudgetController.js'

const budgetRouter = express.Router()

budgetRouter.get('/', BudgetController.getMonthlyBudget)
budgetRouter.get('/detail', BudgetController.getMonthlyDetailBudget)
budgetRouter.post('/', BudgetController.createBudget)
budgetRouter.post('/category', BudgetController.createCategoryBudget)

export default budgetRouter
