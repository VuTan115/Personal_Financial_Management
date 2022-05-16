import Category from '../models/Category.js'

const createCategory = async (req, res) => {
  const {
    is_output, name, user_id
  } = req.body
  let newTransaction = new Category({
    is_output, name, user_id
  })
  try {
    newTransaction = await newTransaction.save()
    return res.status(200).json(newTransaction)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}

const CategoryController = {
  createCategory
}

export default CategoryController