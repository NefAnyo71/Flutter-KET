import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:syncfusion_flutter_charts/charts.dart';

// Data model for the chart
class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double y;
}

class LiveMarketPage extends StatefulWidget {
  const LiveMarketPage({super.key});

  @override
  _LiveMarketPageState createState() => _LiveMarketPageState();
}

class _LiveMarketPageState extends State<LiveMarketPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late AnimationController _controller;
  late Animation<Color?> _iconGlow;
  List<dynamic> cryptoData = [];
  List<dynamic> stockData = [];
  bool isLoading = true;
  String errorMessage = '';
  final Map<String, bool> _expandedCards = {};
  final Map<String, bool> _favorites = {};
  String _searchQuery = '';

  // Timer for periodic refresh (This is now removed)
  // Timer? _timer;

  final Color _positiveColor = const Color(0xFF00E676);
  final Color _negativeColor = const Color(0xFFFF5252);
  final Color _backgroundColor = const Color(0xFF0A0E21);
  final Color _cardColor = const Color(0xFF1D1F33);
  final Color _accentColor = const Color(0xFF03DAC6);

  final Map<String, IconData> _cryptoIcons = {
    'bitcoin': Icons.currency_bitcoin,
    'ethereum': Icons.currency_exchange,
    'ripple': Icons.account_balance,
    'litecoin': Icons.money,
    'cardano': Icons.credit_card,
    'polkadot': Icons.circle,
    'bitcoin-cash': Icons.currency_bitcoin,
    'stellar': Icons.star,
    'chainlink': Icons.link,
    'binancecoin': Icons.account_balance_wallet,
    'monero': Icons.security,
    'dogecoin': Icons.pets,
    'picoin': Icons.currency_exchange,
  };

  final Map<String, IconData> _stockIcons = {
    'XU100': Icons.show_chart,
    'GARAN': Icons.account_balance,
    'AKBNK': Icons.account_balance,
    'THYAO': Icons.airplanemode_active,
    'ASELS': Icons.security,
    'KOZAA': Icons.landscape,
    'SASA': Icons.factory,
    'EREGL': Icons.build,
    'KCHOL': Icons.business,
    'TCELL': Icons.signal_cellular_alt,
    'AAPL': Icons.apple,
    'MSFT': Icons.laptop_mac,
    'GOOGL': Icons.language,
    'AMZN': Icons.local_shipping,
    'TSLA': Icons.electric_car,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _iconGlow = ColorTween(
      begin: Colors.white,
      end: _accentColor,
    ).animate(_controller);

    fetchMarketData();

    // Removed the periodic refresh timer
    // _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
    //   fetchMarketData();
    // });
  }

  Future<void> fetchMarketData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final cryptoResponse = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false'),
      );

      if (cryptoResponse.statusCode == 200) {
        cryptoData = json.decode(cryptoResponse.body);
      } else {
        throw Exception('Failed to load crypto data.');
      }

      // Simulate stock data
      await Future.delayed(const Duration(seconds: 1));
      stockData = [
        {'symbol': 'XU100', 'name': 'BIST 100', 'price': 8543.67, 'change': 1.23, 'volume': 23456789},
        {'symbol': 'GARAN', 'name': 'Garanti Bankası', 'price': 45.80, 'change': -0.65, 'volume': 12345678},
        {'symbol': 'AKBNK', 'name': 'Akbank', 'price': 38.45, 'change': 0.89, 'volume': 9876543},
        {'symbol': 'THYAO', 'name': 'Türk Hava Yolları', 'price': 215.60, 'change': 2.34, 'volume': 5678901},
        {'symbol': 'ASELS', 'name': 'Aselsan', 'price': 132.75, 'change': -1.12, 'volume': 3456789},
        {'symbol': 'KOZAA', 'name': 'Koza Anadolu Metal', 'price': 178.90, 'change': 3.21, 'volume': 2345678},
        {'symbol': 'SASA', 'name': 'Sasa Polyester', 'price': 67.45, 'change': -2.11, 'volume': 3456789},
        {'symbol': 'EREGL', 'name': 'Ereğli Demir Çelik', 'price': 42.30, 'change': 0.75, 'volume': 4567890},
        {'symbol': 'KCHOL', 'name': 'Koç Holding', 'price': 125.80, 'change': 1.45, 'volume': 5678901},
        {'symbol': 'TCELL', 'name': 'Turkcell', 'price': 38.90, 'change': -0.35, 'volume': 6789012},
        {'symbol': 'AAPL', 'name': 'Apple Inc.', 'price': 175.43, 'change': 1.23, 'volume': 98765432},
        {'symbol': 'MSFT', 'name': 'Microsoft', 'price': 338.11, 'change': 0.89, 'volume': 87654321},
        {'symbol': 'GOOGL', 'name': 'Alphabet (Google)', 'price': 138.25, 'change': -0.45, 'volume': 76543210},
        {'symbol': 'AMZN', 'name': 'Amazon', 'price': 145.18, 'change': 2.11, 'volume': 65432109},
        {'symbol': 'TSLA', 'name': 'Tesla', 'price': 245.60, 'change': -1.78, 'volume': 54321098},
      ];

      // Add Pi Coin to the crypto list
      final piCoinData = {
        'symbol': 'PI',
        'name': 'Pi Network',
        'current_price': 0.01567,
        'price_change_percentage_24h': 12.45,
        'total_volume': 1234567,
        'market_cap': 56789012,
        'id': 'picoin',
        'image': 'https://s2.coinmarketcap.com/static/img/coins/64x64/3336.png'
      };
      cryptoData.add(piCoinData);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data. Please try again later.';
      });
    }
  }

  String formatPrice(dynamic price) {
    double priceValue = price is int ? price.toDouble() : price;
    if (priceValue > 1) {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(priceValue);
    } else {
      return NumberFormat.currency(symbol: '\$', decimalDigits: 6).format(priceValue);
    }
  }

  String formatChange(dynamic change) {
    double changeValue = change is int ? change.toDouble() : change;
    return '${changeValue >= 0 ? '+' : ''}${changeValue.toStringAsFixed(2)}%';
  }

  Color getPriceColor(dynamic change) {
    double changeValue = change is int ? change.toDouble() : change;
    return changeValue >= 0 ? _positiveColor : _negativeColor;
  }

  IconData getTrendIcon(dynamic change) {
    double changeValue = change is int ? change.toDouble() : change;
    return changeValue >= 0 ? Icons.trending_up : Icons.trending_down;
  }

  Widget getAssetIcon(Map<String, dynamic> item, bool isCrypto) {
    if (isCrypto && item['image'] != null) {
      return Image.network(
        item['image'],
        width: 20,
        height: 20,
        errorBuilder: (context, error, stackTrace) => Icon(
          _cryptoIcons[item['id']] ?? Icons.currency_exchange,
          color: _accentColor,
          size: 20,
        ),
      );
    } else {
      String symbol = isCrypto ? (item['symbol'] ?? '').toLowerCase() : item['symbol'];
      IconData iconData = isCrypto ? _cryptoIcons[item['id']] ?? Icons.currency_exchange : _stockIcons[symbol.toUpperCase()] ?? Icons.business;
      return Icon(
        iconData,
        color: _accentColor,
        size: 20,
      );
    }
  }

  void _toggleExpand(String id) {
    setState(() {
      _expandedCards[id] = !(_expandedCards[id] ?? false);
    });
  }

  void _toggleFavorite(String id) {
    setState(() {
      _favorites[id] = !(_favorites[id] ?? false);
    });
  }

  List<dynamic> getFilteredData(List<dynamic> data, bool isCrypto) {
    if (_searchQuery.isEmpty) {
      List<dynamic> favorites = [];
      List<dynamic> others = [];
      for (var item in data) {
        final String id = isCrypto ? item['id'] : (item['id'] ?? item['symbol']);
        if (_favorites[id] ?? false) {
          favorites.add(item);
        } else {
          others.add(item);
        }
      }
      return favorites + others;
    }
    return data.where((item) {
      final String name = item['name']?.toString().toLowerCase() ?? '';
      final String symbol = isCrypto ? (item['symbol']?.toString().toLowerCase() ?? '') : (item['symbol']?.toString().toLowerCase() ?? '');
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || symbol.contains(query);
    }).toList();
  }

  void _navigateToChartPage(Map<String, dynamic> item, bool isCrypto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChartPage(item: item, isCrypto: isCrypto),
      ),
    );
  }

  Widget _buildMarketCard(Map<String, dynamic> item, bool isCrypto) {
    final String id = isCrypto ? item['id'] : (item['id'] ?? item['symbol']);
    final String name = item['name'] ?? '';
    final String symbol = isCrypto ? (item['symbol'] ?? '').toUpperCase() : item['symbol'];
    final dynamic price = isCrypto ? (item['current_price'] ?? 0) : (item['price'] ?? 0);
    final dynamic change = isCrypto ? (item['price_change_percentage_24h'] ?? 0) : (item['change'] ?? 0);
    final bool isExpanded = _expandedCards[id] ?? false;
    final bool isFavorite = _favorites[id] ?? false;
    final Widget iconWidget = getAssetIcon(item, isCrypto);

    return Card(
      color: _cardColor,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () => _navigateToChartPage(item, isCrypto),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _accentColor.withOpacity(0.2),
                          ),
                          child: Center(
                            child: iconWidget,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                symbol,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white70,
                    ),
                    onPressed: () => _toggleFavorite(id),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatPrice(price),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: getPriceColor(change).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          getTrendIcon(change),
                          color: getPriceColor(change),
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatChange(change),
                          style: TextStyle(
                            color: getPriceColor(change),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isExpanded) ...[
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildDetailItem('24h Volume',
                        isCrypto
                            ? '\$${NumberFormat.compact().format(item['total_volume'])}'
                            : '\$${NumberFormat.compact().format(item['volume'])}'
                    ),
                    _buildDetailItem('Market Cap',
                        isCrypto
                            ? '\$${NumberFormat.compact().format(item['market_cap'])}'
                            : '-'
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white70),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildContent(List<dynamic> data, bool isCrypto) {
    List<dynamic> sortedData = getFilteredData(data, isCrypto);

    if (sortedData.isEmpty) {
      return const Center(
        child: Text(
          'No market data found for your search.',
          style: TextStyle(color: Colors.white54, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      itemCount: sortedData.length,
      itemBuilder: (context, index) {
        return _buildMarketCard(sortedData[index] as Map<String, dynamic>, isCrypto);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController?.dispose();
    // Removed the timer cancellation
    // _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> displayedCryptoData = getFilteredData(cryptoData, true);
    final List<dynamic> displayedStockData = getFilteredData(stockData, false);

    if (isLoading || errorMessage.isNotEmpty || _tabController == null) {
      return Scaffold(
        backgroundColor: _backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                ),
              if (errorMessage.isNotEmpty) ...[
                const Icon(Icons.error_outline, color: Colors.white, size: 48),
                const SizedBox(height: 16),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: fetchMarketData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ] else
                const Text(
                  'Loading market data...',
                  style: TextStyle(color: Colors.white),
                ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, color: _accentColor),
            const SizedBox(width: 8),
            // Buradaki Text widget'ını Expanded ile sarıyoruz
            Expanded(
              child: Text(
                'Live Market Tracker',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                // Taşmayı önlemek için overflow ekliyoruz
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: _backgroundColor,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 18,
            ),
            color: _accentColor,
            onPressed: () {
              fetchMarketData();
            },
            tooltip: 'Refresh Data',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112.0),
          child: Column(
            children: [
              _buildSearchBar(),
              TabBar(
                controller: _tabController!,
                indicatorColor: _accentColor,
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Crypto'),
                  Tab(text: 'Stocks'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF121212),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: TabBarView(
          controller: _tabController!,
          children: [
            ListView(
              children: [
                if (displayedCryptoData.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Cryptocurrencies',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...displayedCryptoData.map((item) => _buildMarketCard(item as Map<String, dynamic>, true)).toList(),
                ],
                if (displayedStockData.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Stocks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...displayedStockData.map((item) => _buildMarketCard(item as Map<String, dynamic>, false)).toList(),
                ],
              ],
            ),
            _buildContent(displayedCryptoData, true),
            _buildContent(displayedStockData, false),
          ],
        ),
      ),
    );
  }
}

// New ChartPage widget
class ChartPage extends StatefulWidget {
  final Map<String, dynamic> item;
  final bool isCrypto;

  const ChartPage({super.key, required this.item, required this.isCrypto});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _timeFrames = ['15m', '1h', '4h', '1d'];
  final List<List<ChartData>> _chartData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _timeFrames.length, vsync: this);
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Simulate chart data
      _chartData.clear();
      for (var i = 0; i < _timeFrames.length; i++) {
        _chartData.add(_generateFakeData(i));
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load chart data.';
      });
    }
  }

  List<ChartData> _generateFakeData(int timeFrameIndex) {
    final List<ChartData> data = [];
    const int points = 50;
    double basePrice = widget.item['current_price'] ?? widget.item['price'] ?? 0;

    double fluctuation = 0.0;
    if (timeFrameIndex == 0) fluctuation = 0.005;
    if (timeFrameIndex == 1) fluctuation = 0.01;
    if (timeFrameIndex == 2) fluctuation = 0.02;
    if (timeFrameIndex == 3) fluctuation = 0.03;

    for (int i = 0; i < points; i++) {
      double y = basePrice + (i * fluctuation * (i % 2 == 0 ? 1 : -1));
      data.add(ChartData(i.toDouble(), y));
    }
    return data;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: Text(
          widget.item['name'] ?? widget.item['symbol'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
        child: Text(_errorMessage, style: const TextStyle(color: Colors.white)),
      )
          : Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              NumberFormat.currency(
                symbol: '\$',
                decimalDigits: (widget.item['current_price'] ?? widget.item['price']) > 1 ? 2 : 6,
              ).format(widget.item['current_price'] ?? widget.item['price']),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(widget.item['price_change_percentage_24h'] ?? widget.item['change']) >= 0 ? '+' : ''}${
                (widget.item['price_change_percentage_24h'] ?? widget.item['change'])?.toStringAsFixed(2)
            }%',
            style: TextStyle(
              color: (widget.item['price_change_percentage_24h'] ?? widget.item['change']) >= 0
                  ? const Color(0xFF00E676)
                  : const Color(0xFFFF5252),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF03DAC6),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: _timeFrames.map((e) => Tab(text: e)).toList(),
            onTap: (index) {
              // You can add logic here to fetch new data based on the selected time frame
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _timeFrames.map((timeFrame) {
                // The index is the same as the tab index
                int index = _timeFrames.indexOf(timeFrame);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildLineChart(_chartData[index]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<ChartData> data) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const NumericAxis(
        isVisible: false,
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
      ),
      series: <LineSeries<ChartData, double>>[
        LineSeries<ChartData, double>(
          dataSource: data,
          xValueMapper: (ChartData sales, _) => sales.x,
          yValueMapper: (ChartData sales, _) => sales.y,
          color: const Color(0xFF03DAC6),
          enableTooltip: true,
          markerSettings: const MarkerSettings(
            isVisible: false,
          ),
          width: 2,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
