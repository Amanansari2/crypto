class ApiUrls {

    // static const String baseUrl = "http://www.tradingfloors.shop/api";
  static const String baseUrl = "http://192.168.1.15:5001/api";
  static const String websocketUrl = "ws://192.168.1.15:5001/ws/trading";

  // https://www.tradingfloors.in/api

  static const allCoins = "/market/all";
  static const gainers = "/market/gainers";
  static const losers = "/market/losers";
  static const trending = "/market/trending";
  static const newCoins = "/market/new";

  //------------------------
  //Binance Url
  //------------------------

  static const getPairs = "/binance/pairs";
  static const getCandles = "/binance/candles";
  static const getContractInfo = "/binance/contract-info";

//------------------------
//Trading
//------------------------
  static const tradingAccount = "/trading/accounts";
  static const tradingPositions = "/trading/positions";

//Market Execution
  static const marketOrder = "/trading/orders/market";


//Limit Execution
  static const limitOrder = "/trading/orders/limit";

//Open Order
  static const String openLimitOrders = '/trading/orders/open';
//Modify Order
  static const String modifyLimitOrders = '/trading/orders';


  // Trading History
  static const String orderHistory = '/trading/orders/history';
  static const String tradingHistory = '/trading/orders/trading-history';
  static const String positionHistory = '/trading/orders/positions/history';

  //------------------------
// Wallet
//------------------------

  static const String walletOverview = '/wallet/overview';
  static const String walletTransactions = '/wallet/transactions';
  static const String walletTrades = '/wallet/trades';


}
