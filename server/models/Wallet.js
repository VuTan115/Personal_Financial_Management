import mongoose from 'mongoose'

const { Schema } = mongoose
const { ObjectId } = Schema

const WalletModel = new Schema(
  {
    amount: {
      type: Number,
      required: true,
    },
    name: {
      type: String,
      required: true,
      unique: true
    },
    type: {
      type: String,
      default: 'bank'
    },
    user_id: {
      type: String,
      required: true
    },
    description: {
      type: String
    }
  },
  {
    timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
  }
)

const Wallet = mongoose.model('Wallet', WalletModel)

export default Wallet
