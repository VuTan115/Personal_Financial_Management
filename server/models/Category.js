import mongoose from 'mongoose'

const { Schema } = mongoose
const { ObjectId } = Schema

const CategoryModel = new Schema({
  is_output: {
    type: Boolean,
    default: true,
  },
  name: {
    type: String,
    required: true,
    unique: true,
  },
  user_id: {
    type: String,
    default: null
  },
  limits_per_month: [{
    amount: {
      type: Number,
      required: true
    },
    month: {
      type: Date,
      default: Date.now(),
    },
    user_id: {
      type: String,
      required: true,
    }
  }]

}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
})

const Category = mongoose.model('Category', CategoryModel)

export default Category
