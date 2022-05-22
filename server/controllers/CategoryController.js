import mongoose from 'mongoose'
import Category from '../models/Category.js'
import LimitsPerMonth from '../models/LimitsPerMonth.js'

const createCategory = async (req, res) => {
  const {
    is_output, name
  } = req.body
  let newTransaction = new Category({
    is_output, name, user_id: req.body.user.uid
  })
  try {
    newTransaction = await newTransaction.save()
    return res.status(200).json(newTransaction)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}
const createBudget = async (req, res) => {
  const {
    month, amount
  } = req.body
  let newBudget = new LimitsPerMonth({
    month, amount, user_id: req.body.user.uid
  })
  try {
    newBudget = await newBudget.save()
    return res.status(201).json(newBudget)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}

const getCategories = async (req, res) => {
  const { is_output } = req.query
  try {
    const categories = await Category.aggregate(
      [
        {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: [
                    '$is_output', is_output === 'output'
                  ]
                }
              },
              {
                $or: [
                  {
                    $expr: {
                      $eq: [
                        '$user_id', req.body.user.uid
                      ]
                    }
                  },
                  {
                    $expr: {
                      $eq: [
                        '$user_id', null
                      ]
                    }
                  }
                ]
              }
            ]
          }
        }, {
          $project: {
            _id: 0,
            name: 1
          }
        }
      ]
    )

    return res.status(200).json(categories.map((el) => el.name))
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}

const CategoryController = {
  createCategory,
  createBudget,
  getCategories
}

export default CategoryController
