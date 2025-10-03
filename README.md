# Agricultural Weather Warning System

A privacy-protected agricultural weather monitoring platform built with Zama FHEVM technology, providing confidential weather services for farmers while maintaining complete data privacy through Fully Homomorphic Encryption (FHE).

## 🌾 Overview

The Agricultural Weather Warning System is a decentralized application that enables farmers to monitor weather conditions, receive automated alerts, and protect sensitive agricultural data through advanced cryptographic techniques. By leveraging Zama's FHEVM technology, all sensitive information remains encrypted even during computation, ensuring unprecedented privacy for agricultural operations.

## 🔐 Core Concepts

### Fully Homomorphic Encryption (FHE)
This platform utilizes Zama's FHEVM technology to perform computations on encrypted data without ever decrypting it. This means:
- Crop types remain confidential
- Farm sizes stay private
- Weather measurements are encrypted
- Alert thresholds are processed without exposing raw data
- Only authorized parties can decrypt specific information

### Confidential Agricultural Weather Intelligence
Traditional weather monitoring systems expose sensitive farm data, potentially revealing business strategies, crop choices, and operational details. Our FHE-powered solution ensures:
- **Data Privacy**: All agricultural metrics are encrypted end-to-end
- **Competitive Advantage**: Farm information cannot be accessed by competitors
- **Regulatory Compliance**: Meets strict data protection requirements
- **Trustless Computation**: Smart contracts process encrypted data autonomously

### Privacy-Preserving Weather Services
The system provides real-time weather monitoring and alerting while maintaining complete confidentiality:
- Encrypted weather data submission
- Private threshold configuration
- Confidential alert generation
- Anonymous farm registration

## 📊 Features

- **Encrypted Farm Registration**: Register farms with confidential crop types and size parameters
- **Private Weather Data Submission**: Submit temperature, humidity, wind speed, soil moisture, and rainfall data with FHE encryption
- **Customizable Alert Thresholds**: Configure personalized warning parameters for different weather conditions
- **Automated Alert System**: Receive real-time notifications when weather conditions exceed safe thresholds
- **Privacy-First Dashboard**: Monitor system status without exposing sensitive information
- **Blockchain Transparency**: Verifiable operations with encrypted data integrity

## 🎯 Smart Contract Functions

### Farm Management
- `registerFarm()`: Register a new farm with encrypted parameters (crop type, farm size, thresholds)
- `getFarmInfo()`: Retrieve public farm information (registration status, timestamps)

### Weather Data Operations
- `submitWeatherData()`: Submit encrypted weather measurements (temperature, humidity, wind, soil moisture, rainfall)
- `getWeatherDataTimestamp()`: Query data submission timestamps

### Alert Management
- `updateThresholds()`: Modify warning threshold values for weather parameters
- `getAlertTimestamp()`: Check alert status and timing
- `resolveAlerts()`: Clear active weather alerts

### System Statistics
- `getSystemStats()`: Retrieve overall system metrics (total farms, alert count, last update)
- `getTotalFarms()`: Query registered farm count

## 🌐 Live Application

**Website**: [https://weather-warning-system.vercel.app/](https://weather-warning-system.vercel.app/)

**GitHub Repository**: [https://github.com/VadaHansen/WeatherWarningSystem](https://github.com/VadaHansen/WeatherWarningSystem)

**Smart Contract Address**: `0x34946fD1aBD6406AA502F377f84A3b85613767a0`

## 🎥 Demonstration

A comprehensive demonstration video (`WeatherWarningSystem.mp4`) is included in the repository, showcasing:
- Wallet connection process
- Farm registration workflow
- Weather data submission
- Alert threshold configuration
- Real-time alert monitoring
- Privacy features in action

## 🛠️ Technology Stack

- **Frontend**: Pure HTML/CSS/JavaScript with responsive design
- **Blockchain**: Ethereum-compatible networks
- **Privacy Layer**: Zama FHEVM for Fully Homomorphic Encryption
- **Web3 Integration**: Ethers.js for blockchain interaction
- **Smart Contracts**: Solidity with FHEVM extensions

## 🚀 Usage Guide

### Getting Started

1. **Connect Wallet**: Click "Connect Wallet" to link your MetaMask or compatible Web3 wallet
2. **Register Farm**: Enter farm details including name, crop type, and size (encrypted automatically)
3. **Configure Thresholds**: Set personalized warning thresholds for temperature, humidity, wind, moisture, and rainfall
4. **Submit Weather Data**: Input current weather measurements from your farm sensors or observations
5. **Monitor Alerts**: Check the alert dashboard for any active weather warnings
6. **Resolve Alerts**: Clear alerts once appropriate actions have been taken

### Weather Parameters

The system monitors five critical weather parameters:

- **Temperature**: High/low temperature alerts (°C)
- **Humidity**: Excessive or insufficient humidity warnings (%)
- **Wind Speed**: Strong wind alerts (km/h)
- **Soil Moisture**: Drought monitoring (%)
- **Rainfall**: Flood risk assessment (mm)

## 🔒 Privacy Guarantees

### What Remains Encrypted
- Individual crop types and varieties
- Exact farm sizes and locations
- Specific weather measurements
- Custom threshold configurations
- Historical weather patterns

### What Is Public
- Total number of registered farms
- Aggregate alert statistics
- Transaction timestamps
- Contract deployment information

## 🌟 Use Cases

1. **Precision Agriculture**: Monitor microclimates without revealing farm locations
2. **Crop Protection**: Receive timely alerts for adverse weather conditions
3. **Insurance Claims**: Maintain verifiable weather records with privacy
4. **Cooperative Networks**: Share anonymized data across farming communities
5. **Research & Development**: Contribute to agricultural studies without data exposure

## 🏆 Benefits

- **Enhanced Privacy**: Complete confidentiality of agricultural operations
- **Competitive Protection**: Safeguard business strategies and crop selections
- **Risk Mitigation**: Proactive weather monitoring and alerting
- **Data Ownership**: Farmers retain control over their information
- **Regulatory Compliance**: Meet data protection and privacy regulations
- **Interoperability**: Compatible with existing Web3 infrastructure

## 📈 Future Enhancements

- Multi-language support for global accessibility
- Integration with IoT weather sensors
- Advanced analytics and prediction models
- Cooperative data sharing protocols
- Mobile application development
- Integration with agricultural insurance platforms
- Weather-based smart contract automation

## 🤝 Contributing

We welcome contributions from the community! Whether you're interested in improving the smart contracts, enhancing the user interface, or expanding privacy features, your input is valuable.

## 📞 Contact & Support

For questions, suggestions, or collaboration opportunities, please visit our GitHub repository and open an issue or discussion.

---

**Built with ❤️ for the farming community using cutting-edge privacy technology**
