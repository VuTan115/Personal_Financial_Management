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
const getMonthlyDetailBudget = async (req, res) => {
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
    let spent = await Category.aggregate(
      [
        {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: [
                    '$is_output', true
                  ]
                }
              }, {
                $or: [
                  {
                    $expr: {
                      $eq: [
                        '$user_id', req.body.user.uid
                      ]
                    }
                  }, {
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
          $unwind: {
            path: '$limits_per_month'
          }
        }, {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: [
                    {
                      $month: '$limits_per_month.month'
                    }, reqTimestamp.getUTCMonth() + 1
                  ]
                }
              }, {
                $expr: {
                  $eq: [
                    {
                      $year: '$limits_per_month.month'
                    }, reqTimestamp.getUTCFullYear()
                  ]
                }
              }
            ]
          }
        }, {
          $lookup: {
            from: 'transactions',
            localField: '_id',
            foreignField: 'category',
            as: 'transactions'
          }
        }, {
          $unwind: {
            path: '$transactions'
          }
        }, {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: [
                    {
                      $month: '$transactions.created_at'
                    }, reqTimestamp.getUTCMonth() + 1
                  ]
                }
              }, {
                $expr: {
                  $eq: [
                    {
                      $year: '$transactions.created_at'
                    }, reqTimestamp.getUTCFullYear()
                  ]
                }
              }, {
                $expr: {
                  $eq: [
                    '$transactions.user_id', req.body.user.uid
                  ]
                }
              }, {
                $expr: {
                  $eq: [
                    '$transactions.is_output', true
                  ]
                }
              }
            ]
          }
        }, {
          $group: {
            _id: {
              _id: '$_id',
              name: '$name',
              limits_per_month: '$limits_per_month.amount'
            },
            spent: {
              $sum: '$transactions.amount'
            }
          }
        }
      ]
    )
    let categories = await Category.aggregate(
      [
        {
          $match: {
            $and: [
              {
                $expr: {
                  $eq: [
                    '$is_output', true
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
        },
        {
          $project: {
            limits_per_month: 0
          }
        }
      ]
    )
    spent = spent.map((el) => ({ ...el._id, spent: el.spent }))
    console.log(spent)
    console.log(spent.findIndex((el) => el._id.toString() === '628127117ad0d1878fe1dc09'))
    categories = categories.map((element) => {
      const index = spent.findIndex((el) => el._id.toString() === element._id.toString())
      console.log(index)
      if (index !== -1) {
        return {
          ...element,
          limits_per_month: spent[index].limits_per_month,
          spent: spent[index].spent
        }
      }
      return { ...element, spent: -1, limits_per_month: -1 }
    })
    return res.status(200).json({
      totalBudget: totalBudget.length !== 0 ? totalBudget[0].amount : -1,
      categories: categories
    })
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}
const BudgetController = {
  getMonthlyBudget,
  getMonthlyDetailBudget
}

export default BudgetController
