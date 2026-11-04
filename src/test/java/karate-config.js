function fn() {
  var config = {
    base_url: 'http://134.209.211.10:5173',
    authService: 'http://134.209.211.10:4001',
    walletService: 'http://134.209.211.10:4002',
    transactionService: 'http://134.209.211.10:4003',
    adminService: 'http://134.209.211.10:4004'
  };

  karate.configure('headers', {
    'Content-Type': 'application/json',
    'x-channel': 'WEB'
  });

  return config;
}