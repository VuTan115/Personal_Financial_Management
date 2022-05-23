import mongoose from 'mongoose'
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
    const spent = await Category.aggregate(
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
        },
      ]
    )
    const categories = await Category.aggregate(
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
              user_id: '$user_id'
            },
            spent: {
              $sum: '$transactions.amount'
            }
          }
        }
      ]
    )
    let allCategories = await Category.aggregate(
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
    allCategories = allCategories.map((element) => {
      const temp = { ...element, limits_per_month: -1, spent: -1 }
      const indexSpent = spent.findIndex((el) => el._id.toString() === element._id.toString())
      const indexCategories = categories
        .findIndex((el) => el._id._id.toString() === element._id.toString())
      console.log(indexSpent)
      console.log(indexCategories)
      if (indexSpent !== -1) {
        temp.limits_per_month = spent[indexSpent].limits_per_month.amount
      }
      if (indexCategories !== -1) {
        temp.spent = categories[indexCategories].spent
      }
      return temp
    })
    return res.status(200).json({
      totalBudget: totalBudget.length !== 0 ? totalBudget[0].amount : -1,
      categories: allCategories
    })
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
    const reqTimestamp = new Date(month)
    const curBudget = await LimitsPerMonth.aggregate([
      {
        $match: {
          $and: [
            {
              $expr: {
                $eq: [
                  {
                    $month: '$month',
                  },
                  reqTimestamp.getUTCMonth() + 1,
                ],
              },
            },
            {
              $expr: {
                $eq: [
                  {
                    $year: '$month',
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
      }
    ])
    if (curBudget.length === 0) {
      newBudget = await newBudget.save()
    } else {
      newBudget = await LimitsPerMonth.findOneAndUpdate({ _id: curBudget[0]._id }, {
        amount
      }, {
        new: true
      })
    }
    return res.status(200).json(newBudget)
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}
const createCategoryBudget = async (req, res) => {
  const {
    month, amount, category_id
  } = req.body

  const reqTimestamp = new Date(month)
  const firstDay = new Date(reqTimestamp.getFullYear(), reqTimestamp.getMonth(), 1)
  firstDay.setHours(0, 0, 0, 0)
  const lastDay = new Date(reqTimestamp.getFullYear(), reqTimestamp.getMonth() + 1, 0)
  lastDay.setHours(23, 59, 59, 999)
  try {
    const update = {}
    update['limits_per_month.$.amount'] = amount
    let result = await Category.updateOne({
      _id: mongoose.Types.ObjectId(category_id),
      'limits_per_month.month': {
        $gte: firstDay,
        $lte: lastDay
      },
      'limits_per_month.user_id': req.body.user.uid
    }, update, {
      new: true
    })
    if (result.matchedCount === 0) {
      result = await Category.findOneAndUpdate({
        _id: mongoose.Types.ObjectId(category_id)
      }, {
        $push: {
          limits_per_month: {
            amount,
            user_id: req.body.user.uid,
            month: month
          }
        }
      }, {
        new: true
      })
    }
    return res.status(200).json('oke')
  } catch (error) {
    console.log(error)
    return res.status(500).json('server error')
  }
}
const BudgetController = {
  getMonthlyBudget,
  getMonthlyDetailBudget,
  createBudget,
  createCategoryBudget
}

export default BudgetController
