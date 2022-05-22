import Category from '../models/Category.js'
import Transaction from '../models/Transaction.js'
import LimitsPerMonth from '../models/LimitsPerMonth.js'

const getMonthlyBudget = async (req, res) => {
  const {
    timestamp
  } = req.query
  const reqTimestamp = new Date(timestamp)
  try {
    const totalBudget = await LimitsPerMonth.aggregate([
      {
        $match: {
          $and: [
            {
              $expr: {
                $eq: [
                  {
                    $month: '$month'
                  }, reqTimestamp.getUTCMonth() + 1
                ]
              }
            }, {
              $expr: {
                $eq: [
                  {
                    $year: '$month'
                  }, reqTimestamp.getUTCFullYear()
                ]
              }
            }, {
              $expr: {
                $eq: [
                  '$user_id', req.body.user.uid
                ]
              }
            }
          ]
        }
      }
    ]).limit(1)
    const spent = await Transaction.aggregate(
      [
        {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: [
                    {
                      $month: '$created_at'
                    }, reqTimestamp.getUTCMonth() + 1
                  ]
                }
              }, {
                $expr: {
                  $eq: [
                    {
                      $year: '$created_at'
                    }, reqTimestamp.getUTCFullYear()
                  ]
                }
              }, {
                $expr: {
                  $eq: [
                    '$user_id', req.body.user.uid
                  ]
                }
              }, {
                $expr: {
                  $eq: [
                    '$is_output', true
                  ]
                }
              }
            ]
          }
        }, {
          $group: {
            _id: null,
            spent: {
              $sum: '$amount'
            }
          }
        }
      ]
    )
    console.log(spent)
    return res.status(200).json({
      totalBudget: totalBudget.length !== 0 ? totalBudget[0].amount : 0,
      spent: spent.length !== 0 ? spent[0].spent : 0
    })
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}

const BudgetController = {
  getMonthlyBudget
}

export default BudgetController
