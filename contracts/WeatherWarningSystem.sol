// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { FHE, euint8, euint16, ebool } from "@fhevm/solidity/lib/FHE.sol";
import { SepoliaConfig } from "@fhevm/solidity/config/ZamaConfig.sol";

contract WeatherWarningSystem is SepoliaConfig {

    address public owner;
    uint16 public totalAlerts;
    uint256 public lastUpdateTime;

    // Weather parameter thresholds
    struct WeatherThresholds {
        euint8 maxTemperature;      // °C (encrypted)
        euint8 minTemperature;      // °C (encrypted)
        euint8 maxHumidity;         // % (encrypted)
        euint8 minHumidity;         // % (encrypted)
        euint8 maxWindSpeed;        // km/h (encrypted)
        euint16 minSoilMoisture;    // % (encrypted)
        euint8 maxRainfall;         // mm (encrypted)
    }

    struct WeatherData {
        euint8 temperature;         // Current temperature (encrypted)
        euint8 humidity;            // Current humidity (encrypted)
        euint8 windSpeed;           // Current wind speed (encrypted)
        euint16 soilMoisture;       // Current soil moisture (encrypted)
        euint8 rainfall;            // Current rainfall (encrypted)
        uint256 timestamp;          // Data collection time
        bool isValidData;           // Data validity flag
    }

    struct AlertStatus {
        ebool temperatureAlert;     // Temperature warning (encrypted)
        ebool humidityAlert;        // Humidity warning (encrypted)
        ebool windAlert;            // Wind warning (encrypted)
        ebool droughtAlert;         // Drought warning (encrypted)
        ebool floodAlert;           // Flood warning (encrypted)
        uint256 lastAlertTime;      // Last alert timestamp
        bool hasActiveAlert;        // Active alert flag
    }

    struct FarmProfile {
        string farmName;            // Farm identifier
        euint8 cropType;            // Crop type code (encrypted)
        euint8 farmSize;            // Farm size category (encrypted)
        WeatherThresholds thresholds; // Farm-specific thresholds
        bool isRegistered;          // Registration status
        uint256 registrationTime;  // Registration timestamp
    }

    // Mappings
    mapping(address => FarmProfile) public farmProfiles;
    mapping(address => WeatherData) public currentWeatherData;
    mapping(address => AlertStatus) public alertStatuses;
    mapping(uint256 => address[]) public dailyDataProviders;

    // Arrays
    address[] public registeredFarms;

    // Events
    event FarmRegistered(address indexed farmer, string farmName);
    event WeatherDataUpdated(address indexed farm, uint256 timestamp);
    event WeatherAlert(address indexed farm, uint8 alertType, uint256 timestamp);
    event ThresholdsUpdated(address indexed farm, uint256 timestamp);
    event AlertResolved(address indexed farm, uint8 alertType, uint256 timestamp);

    // Alert type constants
    uint8 constant TEMPERATURE_ALERT = 1;
    uint8 constant HUMIDITY_ALERT = 2;
    uint8 constant WIND_ALERT = 3;
    uint8 constant DROUGHT_ALERT = 4;
    uint8 constant FLOOD_ALERT = 5;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    modifier onlyRegisteredFarm() {
        require(farmProfiles[msg.sender].isRegistered, "Farm not registered");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalAlerts = 0;
        lastUpdateTime = block.timestamp;
    }

    // Register a new farm with encrypted crop and size data
    function registerFarm(
        string memory _farmName,
        uint8 _cropType,
        uint8 _farmSize,
        uint8 _maxTemp,
        uint8 _minTemp,
        uint8 _maxHumidity,
        uint8 _minHumidity,
        uint8 _maxWindSpeed,
        uint16 _minSoilMoisture,
        uint8 _maxRainfall
    ) external {
        require(!farmProfiles[msg.sender].isRegistered, "Farm already registered");
        require(bytes(_farmName).length > 0, "Farm name required");

        // Encrypt sensitive farm data
        euint8 encryptedCropType = FHE.asEuint8(_cropType);
        euint8 encryptedFarmSize = FHE.asEuint8(_farmSize);

        // Encrypt weather thresholds
        WeatherThresholds memory thresholds = WeatherThresholds({
            maxTemperature: FHE.asEuint8(_maxTemp),
            minTemperature: FHE.asEuint8(_minTemp),
            maxHumidity: FHE.asEuint8(_maxHumidity),
            minHumidity: FHE.asEuint8(_minHumidity),
            maxWindSpeed: FHE.asEuint8(_maxWindSpeed),
            minSoilMoisture: FHE.asEuint16(_minSoilMoisture),
            maxRainfall: FHE.asEuint8(_maxRainfall)
        });

        farmProfiles[msg.sender] = FarmProfile({
            farmName: _farmName,
            cropType: encryptedCropType,
            farmSize: encryptedFarmSize,
            thresholds: thresholds,
            isRegistered: true,
            registrationTime: block.timestamp
        });

        // Set up ACL permissions
        FHE.allowThis(encryptedCropType);
        FHE.allowThis(encryptedFarmSize);
        FHE.allowThis(thresholds.maxTemperature);
        FHE.allowThis(thresholds.minTemperature);
        FHE.allowThis(thresholds.maxHumidity);
        FHE.allowThis(thresholds.minHumidity);
        FHE.allowThis(thresholds.maxWindSpeed);
        FHE.allowThis(thresholds.minSoilMoisture);
        FHE.allowThis(thresholds.maxRainfall);

        FHE.allow(encryptedCropType, msg.sender);
        FHE.allow(encryptedFarmSize, msg.sender);

        registeredFarms.push(msg.sender);

        emit FarmRegistered(msg.sender, _farmName);
    }

    // Submit encrypted weather data
    function submitWeatherData(
        uint8 _temperature,
        uint8 _humidity,
        uint8 _windSpeed,
        uint16 _soilMoisture,
        uint8 _rainfall
    ) external onlyRegisteredFarm {
        // Encrypt weather data
        euint8 encryptedTemp = FHE.asEuint8(_temperature);
        euint8 encryptedHumidity = FHE.asEuint8(_humidity);
        euint8 encryptedWindSpeed = FHE.asEuint8(_windSpeed);
        euint16 encryptedSoilMoisture = FHE.asEuint16(_soilMoisture);
        euint8 encryptedRainfall = FHE.asEuint8(_rainfall);

        currentWeatherData[msg.sender] = WeatherData({
            temperature: encryptedTemp,
            humidity: encryptedHumidity,
            windSpeed: encryptedWindSpeed,
            soilMoisture: encryptedSoilMoisture,
            rainfall: encryptedRainfall,
            timestamp: block.timestamp,
            isValidData: true
        });

        // Set up ACL permissions
        FHE.allowThis(encryptedTemp);
        FHE.allowThis(encryptedHumidity);
        FHE.allowThis(encryptedWindSpeed);
        FHE.allowThis(encryptedSoilMoisture);
        FHE.allowThis(encryptedRainfall);

        FHE.allow(encryptedTemp, msg.sender);
        FHE.allow(encryptedHumidity, msg.sender);
        FHE.allow(encryptedWindSpeed, msg.sender);
        FHE.allow(encryptedSoilMoisture, msg.sender);
        FHE.allow(encryptedRainfall, msg.sender);

        // Add to daily providers
        uint256 today = block.timestamp / 86400;
        dailyDataProviders[today].push(msg.sender);

        lastUpdateTime = block.timestamp;

        emit WeatherDataUpdated(msg.sender, block.timestamp);

        // Check for alerts automatically
        _checkWeatherAlerts(msg.sender);
    }

    // Private function to check weather alerts using FHE comparisons
    function _checkWeatherAlerts(address farm) private {
        FarmProfile storage profile = farmProfiles[farm];
        WeatherData storage data = currentWeatherData[farm];

        if (!data.isValidData) return;

        // Check temperature alerts (both high and low)
        ebool tempHigh = FHE.gt(data.temperature, profile.thresholds.maxTemperature);
        ebool tempLow = FHE.lt(data.temperature, profile.thresholds.minTemperature);
        ebool temperatureAlert = FHE.or(tempHigh, tempLow);

        // Check humidity alerts (both high and low)
        ebool humidHigh = FHE.gt(data.humidity, profile.thresholds.maxHumidity);
        ebool humidLow = FHE.lt(data.humidity, profile.thresholds.minHumidity);
        ebool humidityAlert = FHE.or(humidHigh, humidLow);

        // Check wind speed alert
        ebool windAlert = FHE.gt(data.windSpeed, profile.thresholds.maxWindSpeed);

        // Check drought alert (low soil moisture)
        ebool droughtAlert = FHE.lt(data.soilMoisture, profile.thresholds.minSoilMoisture);

        // Check flood alert (high rainfall)
        ebool floodAlert = FHE.gt(data.rainfall, profile.thresholds.maxRainfall);

        // Update alert status
        alertStatuses[farm] = AlertStatus({
            temperatureAlert: temperatureAlert,
            humidityAlert: humidityAlert,
            windAlert: windAlert,
            droughtAlert: droughtAlert,
            floodAlert: floodAlert,
            lastAlertTime: block.timestamp,
            hasActiveAlert: true
        });

        // Set up ACL permissions for alerts
        FHE.allowThis(temperatureAlert);
        FHE.allowThis(humidityAlert);
        FHE.allowThis(windAlert);
        FHE.allowThis(droughtAlert);
        FHE.allowThis(floodAlert);

        FHE.allow(temperatureAlert, farm);
        FHE.allow(humidityAlert, farm);
        FHE.allow(windAlert, farm);
        FHE.allow(droughtAlert, farm);
        FHE.allow(floodAlert, farm);

        totalAlerts++;
    }

    // Update weather thresholds for a farm
    function updateThresholds(
        uint8 _maxTemp,
        uint8 _minTemp,
        uint8 _maxHumidity,
        uint8 _minHumidity,
        uint8 _maxWindSpeed,
        uint16 _minSoilMoisture,
        uint8 _maxRainfall
    ) external onlyRegisteredFarm {
        FarmProfile storage profile = farmProfiles[msg.sender];

        // Update with new encrypted values
        profile.thresholds.maxTemperature = FHE.asEuint8(_maxTemp);
        profile.thresholds.minTemperature = FHE.asEuint8(_minTemp);
        profile.thresholds.maxHumidity = FHE.asEuint8(_maxHumidity);
        profile.thresholds.minHumidity = FHE.asEuint8(_minHumidity);
        profile.thresholds.maxWindSpeed = FHE.asEuint8(_maxWindSpeed);
        profile.thresholds.minSoilMoisture = FHE.asEuint16(_minSoilMoisture);
        profile.thresholds.maxRainfall = FHE.asEuint8(_maxRainfall);

        // Set up ACL permissions
        FHE.allowThis(profile.thresholds.maxTemperature);
        FHE.allowThis(profile.thresholds.minTemperature);
        FHE.allowThis(profile.thresholds.maxHumidity);
        FHE.allowThis(profile.thresholds.minHumidity);
        FHE.allowThis(profile.thresholds.maxWindSpeed);
        FHE.allowThis(profile.thresholds.minSoilMoisture);
        FHE.allowThis(profile.thresholds.maxRainfall);

        emit ThresholdsUpdated(msg.sender, block.timestamp);
    }

    // Get farm registration status
    function getFarmInfo(address farm) external view returns (
        string memory farmName,
        bool isRegistered,
        uint256 registrationTime,
        bool hasCurrentData
    ) {
        FarmProfile storage profile = farmProfiles[farm];
        return (
            profile.farmName,
            profile.isRegistered,
            profile.registrationTime,
            currentWeatherData[farm].isValidData
        );
    }

    // Get current weather data timestamp (non-encrypted data only)
    function getWeatherDataTimestamp(address farm) external view returns (
        uint256 timestamp,
        bool isValid
    ) {
        WeatherData storage data = currentWeatherData[farm];
        return (data.timestamp, data.isValidData);
    }

    // Get alert status timestamp (non-encrypted data only)
    function getAlertTimestamp(address farm) external view returns (
        uint256 lastAlertTime,
        bool hasActiveAlert
    ) {
        AlertStatus storage status = alertStatuses[farm];
        return (status.lastAlertTime, status.hasActiveAlert);
    }

    // Get total number of registered farms
    function getTotalFarms() external view returns (uint256) {
        return registeredFarms.length;
    }

    // Get daily data provider count
    function getDailyProviderCount(uint256 date) external view returns (uint256) {
        return dailyDataProviders[date].length;
    }

    // Emergency function to clear alert status
    function resolveAlerts() external onlyRegisteredFarm {
        alertStatuses[msg.sender].hasActiveAlert = false;
        emit AlertResolved(msg.sender, 0, block.timestamp);
    }

    // Owner function to get system statistics
    function getSystemStats() external view onlyOwner returns (
        uint256 totalFarms,
        uint16 totalAlertsIssued,
        uint256 lastUpdate
    ) {
        return (
            registeredFarms.length,
            totalAlerts,
            lastUpdateTime
        );
    }
}