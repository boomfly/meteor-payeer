export default
  siteUrl: 'example.com'
  merchantId: '1234567890'
  secretKey: process.env.PAYEER_SECRET_KEY
  callbackScriptName: 'payeer'
  callbackMethod: process.env.PAYEER_CALLBACK_METHOD or 'get'
  currency: 'USD'
  language: 'RU'
  successUrl: null
