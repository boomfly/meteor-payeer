export default
  siteUrl: 'example.com'
  merchantId: process.env.PAYEER_MERCHANT_ID
  secretKey: process.env.PAYEER_SECRET_KEY
  callbackScriptName: 'payeer'
  callbackMethod: process.env.PAYEER_CALLBACK_METHOD or 'get'
  currency: 'USD'
  language: 'EN'
  successUrl: null
