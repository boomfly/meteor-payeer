import React, { Component } from 'react'

export RenderPaymentForm = ({id, params}) ->
  { m_shop, m_orderid, m_amount, m_curr, m_desc, m_sign } = params if params
  <form id={id} name={id} method="GET" action='https://payeer.com/merchant/'>
    <input type="hidden" name="m_shop" value={m_shop} />
    <input type="hidden" name="m_orderid" value={m_orderid} />
    <input type="hidden" name="m_amount" value={m_amount} />
    <input type="hidden" name="m_curr" value={m_curr} />
    <input type="hidden" name="m_desc" value={m_desc} />
    <input type="hidden" name="m_sign" value={m_sign} />
  </form>
