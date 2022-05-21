import Wallet from '../models/Wallet.js'

const createWallet = async (req, res) => {
  const {
    amount, name, type, description
  } = req.body
  let newWallet = new Wallet({
    amount, name, type, user_id: req.body.user.uid, description
  })
  try {
    newWallet = await newWallet.save()
    return res.status(201).json(newWallet)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}
const getUserWallet = async (req, res) => {
  try {
    const wallets = await Wallet.find({ user_id: req.body.user.uid })
    // const response = {
    //   bank: [],
    //   credit: [],
    //   e_wallet: [],
    //   stock: [],
    //   cash: []
    // }
    // wallets.forEach((el) => {
    //   response[el.type] = [...response[el.type], el]
    // })
    return res.status(200).json(wallets)
  } catch (error) {
    console.log(error)
    return res.status(500).json(error)
  }
}

const deleteWallet = async (req, res) => {
  try {
    const wallet = await Wallet.find({ _id: req.params.id })
    if (wallet.user_id !== req.body.user.uid) {
      return res.status(403).json('Not authorized')
    }
    Wallet.deleteOne({ _id: wallet._id })
    return res.status(200).json('ok')
  } catch (error) {
    console.log(error)
    return res.status(500).json(error)
  }
}

const updateWallet = async (req, res) => {
  const {
    amount, name, type, description
  } = req.body

  try {
    const response = await Wallet.findOneAndUpdate({ _id: req.params.id }, {
      amount,
      name,
      type,
      description
    }, {
      new: true
    })
    return res.status(200).json(response)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}
const WalletController = {
  createWallet,
  getUserWallet,
  updateWallet,
  deleteWallet
}

export default WalletController
