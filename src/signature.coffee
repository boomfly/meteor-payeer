import { URL } from 'url'
import path from 'path'
import crypto from 'crypto'
import {sprintf} from 'sprintf-js'

export default class Signature
  @sign: (params, secretKey) ->
    {
      m_operation_id
      m_operation_ps
      m_operation_date
      m_operation_pay_date

      m_shop
      m_orderid
      m_amount
      m_curr
      m_desc
      m_params

      m_status
    } = params

    if not m_operation_id
      paramsArray = [
        m_shop
        m_orderid
        m_amount
        m_curr
        m_desc
      ]
    else
      paramsArray = [
        m_operation_id
        m_operation_ps
        m_operation_date
        m_operation_pay_date
        m_shop
        m_orderid
        m_amount
        m_curr
        m_desc
        m_status
      ]
    paramsArray.push(m_params) if m_params
    paramsArray.push secretKey
    sign = crypto.createHash('sha256').update(paramsArray.join(':'), 'utf-8').digest('hex').toUpperCase()
