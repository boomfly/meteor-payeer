import { Meteor } from 'meteor/meteor'
import { Random } from 'meteor/random'
import { check, Match } from 'meteor/check'
import { HTTP } from 'meteor/http'

import { sprintf } from 'sprintf-js'
import convert from 'xml-js'
import { Js2Xml } from 'js2xml'
import requestIp from 'request-ip'

import PGSignature from './signature'
import config from './config'

export default class Payeer
  @debug: true

  @config: (cfg) -> if cfg then _.extend(config, cfg) else _.extend({}, config)
  @onResult: (cb) -> @_onResult = cb
  @onCheck: (cb) -> @_onCheck = cb
  @onFailure: (cb) -> @_onFailure = cb

  @call: (params, cb) ->
    # console.log config
    params.m_shop = config.merchantId
    params.m_curr = config.currency unless params.m_curr
    params.m_sign = PGSignature.sign(params, config.secretKey)
    return cb?(null, params)

  @initPayment: (params, cb) ->
    _.extend params,
      m_amount: sprintf("%01.2f", params.m_amount)
      m_desc: new Buffer(params.m_desc).toString('base64')

    if @_onResult
      params.m_result_url = "#{config.siteUrl}/api/#{config.callbackScriptName}?action=result&secret=#{config.secretKey}"

    if @_onCheck
      params.m_check_url = "#{config.siteUrl}/api/#{config.callbackScriptName}?action=check&secret=#{config.secretKey}"

    if @_onFailure
      params.m_failure_url = "#{config.siteUrl}/api/#{config.callbackScriptName}?action=failure&secret=#{config.secretKey}"

    if config.successUrl
      params.m_success_url = config.successUrl

    @call params, cb

  ###
  Синхронная версия метода initPayment
  ###
  @initPaymentSync: Meteor.wrapAsync @initPayment, @

  @paymentSystemList: (params, cb) ->
    @call 'ps_list.php', params, cb

# Маршруты для обработки REST запросов от Payeer

Rest = new Restivus
  useDefaultAuth: true
  prettyJson: true

responseXml = (params, context) ->
  params.pg_sig = PGSignature.make(config.callbackScriptName, params, config.secretKey)
  if context
    context.writeHead 200,
      'Content-Type': 'application/xml'
    context.write(new Js2Xml('request', params).toString())
    context.done()
    return undefined
  else
    headers:
      'Content-Type': 'application/xml'
    body: new Js2Xml('request', params).toString()

# http://localhost:3200/api/paybox?action=result&amount=50&order_id=vYyioup4zJG9Tk5vd
Meteor.startup ->
  Rest.addRoute config.callbackScriptName, {authRequired: false},
    "#{config.callbackMethod}": ->
      if config.debug
        console.log 'Payeer.restRoute', @queryParams, @bodyParams

      if not config.debug
        clientIp = requestIp.getClientIp(@request)
        if clientIp not in ['185.71.65.92', '185.71.65.189', '149.202.17.210']
          return
            statusCode: 403
            body: 'Access restricted 403'

      if @queryParams?.m_operation_id? or @queryParams?.m_orderid?
        params = _.omit @queryParams, ['__proto__']
      else if @bodyParams?.m_operation_id? or @bodyParams?.m_orderid?
        params = _.omit @bodyParams, ['__proto__']
      else
        params = {}

      { action, m_status, m_sign } = params

      if action is 'fail'
        if config.debug
          console.log 'Payeer.restRoute.fail'
        return response = Payeer._onFailure?(params)

      if m_sign isnt PGSignature.sign(params, config.secretKey)
        return
          statusCode: 403
          body: 'Sign isnt correct'

      { m_operation_id, m_operation_ps, m_operation_date, m_operation_pay_date } = params

      switch action
        when 'check'
          response = Payeer._onCheck?(params)
        when 'success'
          response = Payeer._onResult?(params)
        else
          if config.debug
            console.log 'Unknown action', action, params
          response =
            statusCode: 400
            body: "#{params.m_orderid}.|error"

      if response?.error
        console.log 'Payeer.restRoute.error', response
        response =
          statusCode: 500
          body: "#{params.m_orderid}.|error"

      if config.debug
        console.log 'Payeer.restRoute.response', response

      response