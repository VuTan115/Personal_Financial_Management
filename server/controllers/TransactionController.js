import Transaction from '../models/Transaction.js'
import getWeekDay from '../helpers/getWeekDay.js'

const createTransaction = async (req, res) => {
  const {
    amount, is_output, user_id, category, wallet
  } = req.body
  let newTransaction = new Transaction({
    amount, is_output, user_id, category, wallet
  })
  try {
    newTransaction = await newTransaction.save()
    return res.status(200).json(newTransaction)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}

const getFilteredTransaction = async (req, res) => {
  const { filter, timestamp } = req.query
  try {
    let transactions
    const reqTimestamp = new Date(timestamp)
    if (filter === 'TransactionFilter.month') {
      transactions = await Transaction.aggregate([
        {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: [
                    {
                      $month: '$created_at',
                    },
                    reqTimestamp.getUTCMonth() + 1,
                  ],
                },
              },
              {
                $expr: {
                  $eq: [
                    {
                      $year: '$created_at',
                    },
                    reqTimestamp.getUTCFullYear(),
                  ],
                },
              },
              {
                $expr: {
                  $eq: ['$user_id', req.body.user.uid],
                },
              },
            ],
          },
        },
        {
          $lookup: {
            from: 'categories',
            localField: 'category',
            foreignField: '_id',
            as: 'category',
          },
        },
        {
          $project: {
            'category.limits_per_month': 0,
          },
        },
      ])
    } else if (filter === 'TransactionFilter.day') {
      transactions = await Transaction.aggregate([
        {
          $addFields: {
            creationDate: {
              $dateToString: {
                format: '%Y-%m-%d',
                date: '$created_at',
              },
            },
          },
        },
        {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: ['$creationDate', reqTimestamp.toISOString().split('T')[0]],
                },
              },
              {
                $expr: {
                  $eq: ['$user_id', req.body.user.uid],
                },
              },
            ],
          },
        },
        {
          $lookup: {
            from: 'categories',
            localField: 'category',
            foreignField: '_id',
            as: 'category',
          },
        },
        {
          $project: {
            'category.limits_per_month': 0,
          },
        },
      ])
    } else {
      // console.log(reqTimestamp)
      // console.log(getWeekDay.getSunday(reqTimestamp))
      // console.log(getWeekDay.getMonday(reqTimestamp))
      transactions = await Transaction.aggregate([
        {
          $match: {
            $and: [
              {
                $expr: {
                  $lte: ['$created_at', getWeekDay.getSunday(reqTimestamp)],
                },
              },
              {
                $expr: {
                  $gte: ['$created_at', getWeekDay.getMonday(reqTimestamp)],
                },
              },
              {
                $expr: {
                  $eq: ['$user_id', req.body.user.uid],
                },
              },
            ],
          },
        },
        {
          $lookup: {
            from: 'categories',
            localField: 'category',
            foreignField: '_id',
            as: 'category',
          },
        },
        {
          $project: {
            'category.limits_per_month': 0,
          },
        },
      ])
    }
    return res.status(200).json(transactions)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}
const getUserTransaction = async (req, res) => {
  try {
    const transactions = await Transaction.aggregate([
      {
        $match: {
          $and: [
            {
              $expr: {
                $eq: ['$user_id', req.body.user.uid],
              },
            },
          ],
        },
      },
      {
        $lookup: {
          from: 'categories',
          localField: 'category',
          foreignField: '_id',
          as: 'category',
        },
      },
      {
        $project: {
          'category.limits_per_month': 0,
        },
      },
    ])

    return res.status(200).json(transactions)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}

const TransactionController = {
  createTransaction,
  getFilteredTransaction,
  getUserTransaction,
}

export default TransactionController
