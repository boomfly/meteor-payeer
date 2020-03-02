import { URL } from 'url'
import path from 'path'
import crypto from 'crypto'
import {sprintf} from 'sprintf-js'
import config from './config'
import { execSync } from 'child_process'

export default class Signature
  @encodeParams: (orderid, params) ->
    console.log orderid, params
    key = crypto.createHash('md5').update('123').digest('hex')
    # iv = Buffer.alloc(16, 0)
    iv = crypto.randomBytes 16
    iv = '0000000000000000'
    encryptor = crypto.createCipher('AES-256-CBC', key)
    m_params = encryptor.update(JSON.stringify(params), 'utf8', 'base64') + encryptor.final('base64')
    # m_params = encryptor.update(JSON.stringify(params)).toString('base64') + encryptor.final().toString('base64')
    # rijndael = new Cryptian.algorithm.Rijndael256()
    # rijndael.setKey(key)
    # rijndael.encrypt(JSON.stringify(params)).toString('base64')


    result = execSync "/usr/bin/php #{Assets.absoluteFilePath('src/php.php')} #{orderid} #{JSON.stringify(params)}"
    console.log result
    if result
      result.toString()


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

    if m_params
      paramsArray.push(m_params)
    paramsArray.push secretKey
    sign = crypto.createHash('sha256').update(paramsArray.join(':'), 'utf-8').digest('hex').toUpperCase()
