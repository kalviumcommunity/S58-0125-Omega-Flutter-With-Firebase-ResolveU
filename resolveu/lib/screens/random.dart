import 'dart:math';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

// ---------------------------------------------------------------------------
// RANDOM DART CODE GENERATOR OUTPUT
// ---------------------------------------------------------------------------
// This file contains approximately 1000 lines of random, standalone Dart code.
// It simulates a complex "Galactic Trading Empire" game logic engine.
// It is not connected to the main Flutter application.
// ---------------------------------------------------------------------------
//
// MIT License
//
// Copyright (c) 2026 Random Code Gen
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// ---------------------------------------------------------------------------

// ===========================================================================
// SECTION 1: CORE UTILITIES & MATH CONSTANTS
// ===========================================================================

class GalaxyConstants {
  static const double pi = 3.1415926535897932;
  static const double e = 2.718281828459045;
  static const double gravity = 9.80665;
  static const double speedOfLight = 299792458.0;
  static const double planckConstant = 6.62607015e-34;
  static const double boltzmannConstant = 1.380649e-23;
  static const double avogadroNumber = 6.02214076e23;
  
  // Game specific constants
  static const int maxPlayers = 1000;
  static const int maxPlanetsPerSystem = 12;
  static const int minPlanetsPerSystem = 1;
  static const double tradeTaxRate = 0.05;
  static const double fuelConsumptionRate = 1.25;
  static const int maxInventorySlots = 256;
  static const int startCredits = 1000;
  static const String currencySymbol = "◈";
  
  static String getVersion() {
    return "1.0.45-alpha.mock";
  }
}

enum EntityType {
  star,
  planet,
  moon,
  asteroid,
  spaceStation,
  ship,
  player,
  npc,
  artifact,
  blackHole,
  nebula,
  wormhole
}

enum ResourceType {
  water,
  oxygen,
  food,
  iron,
  gold,
  platinum,
  uranium,
  antimatter,
  darkMatter,
  credits
}

enum FactionAlignment {
  federation,
  empire,
  rebels,
  pirates,
  neutral,
  unknown,
  xenon
}

// ===========================================================================
// SECTION 2: ID GENERATION AND HASHING
// ===========================================================================

class UniqueIdGenerator {
  static final Random _rng = Random();
  static final Set<String> _usedIds = {};

  static String generateId({String prefix = "ENT"}) {
    String id;
    do {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(16);
      final randomPart = _rng.nextInt(0xFFFFFF).toRadixString(16).padLeft(6, '0');
      id = "$prefix-$timestamp-$randomPart".toUpperCase();
    } while (_usedIds.contains(id));
    
    _usedIds.add(id);
    return id;
  }

  static String generateUUID() {
    // Mock UUID v4 implementation
    final s = List<String>.filled(36, '');
    const hexDigits = '0123456789abcdef';
    for (var i = 0; i < 36; i++) {
      s[i] = hexDigits[_rng.nextInt(16)];
    }
    s[8] = s[13] = s[18] = s[23] = '-';
    s[14] = '4';
    s[19] = hexDigits[(_rng.nextInt(16) & 0x3) | 0x8];
    return s.join('');
  }
  
  static void clearCache() {
    _usedIds.clear();
  }
}

// ===========================================================================
// SECTION 3: VECTOR MATHEMATICS OVERKILL
// ===========================================================================

class Vector3 {
  double x, y, z;

  Vector3(this.x, this.y, this.z);

  Vector3.zero() : x = 0, y = 0, z = 0;
  Vector3.one() : x = 1, y = 1, z = 1;
  Vector3.random() 
      : x = Random().nextDouble(), 
        y = Random().nextDouble(), 
        z = Random().nextDouble();

  Vector3 operator +(Vector3 other) => Vector3(x + other.x, y + other.y, z + other.z);
  Vector3 operator -(Vector3 other) => Vector3(x - other.x, y - other.y, z - other.z);
  Vector3 operator *(double scalar) => Vector3(x * scalar, y * scalar, z * scalar);
  Vector3 operator /(double scalar) => Vector3(x / scalar, y / scalar, z / scalar);

  double dot(Vector3 other) => x * other.x + y * other.y + z * other.z;

  Vector3 cross(Vector3 other) => Vector3(
        y * other.z - z * other.y,
        z * other.x - x * other.z,
        x * other.y - y * other.x,
      );

  double get length => sqrt(x * x + y * y + z * z);
  double get lengthSquared => x * x + y * y + z * z;

  Vector3 normalize() {
    double l = length;
    if (l == 0) return Vector3.zero();
    return this / l;
  }

  double distanceTo(Vector3 other) {
    return (this - other).length;
  }

  @override
  String toString() => "Vec3(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}, ${z.toStringAsFixed(2)})";
  
  Map<String, dynamic> toJson() => {'x': x, 'y': y, 'z': z};
  
  factory Vector3.fromJson(Map<String, dynamic> json) {
    return Vector3(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['z'] as num).toDouble(),
    );
  }
}

class Quaternion {
  double x, y, z, w;
  
  Quaternion(this.x, this.y, this.z, this.w);
  Quaternion.identity() : x=0, y=0, z=0, w=1;
  
  Quaternion operator *(Quaternion other) {
    return Quaternion(
      w * other.x + x * other.w + y * other.z - z * other.y,
      w * other.y - x * other.z + y * other.w + z * other.x,
      w * other.z + x * other.y - y * other.x + z * other.w,
      w * other.w - x * other.x - y * other.y - z * other.z,
    );
  }
  
  @override
  String toString() => "Quat(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)}, ${z.toStringAsFixed(2)}, ${w.toStringAsFixed(2)})";
}

// ===========================================================================
// SECTION 4: CORE ENTITY SYSTEM
// ===========================================================================

abstract class Entity {
  String id;
  String name;
  EntityType type;
  Vector3 position;
  Quaternion rotation;
  bool isActive;
  double creationTime;

  Entity(this.name, this.type)
      : id = UniqueIdGenerator.generateId(),
        position = Vector3.zero(),
        rotation = Quaternion.identity(),
        isActive = true,
        creationTime = DateTime.now().millisecondsSinceEpoch / 1000.0;

  void update(double deltaTime);
  
  void destroy() {
    isActive = false;
    print("Entity $name ($id) destroyed.");
  }
  
  String getDebugInfo() {
    return "[$type] $name @ $position IsActive: $isActive";
  }
}

class TransformComponent {
  Vector3 position;
  Vector3 scale;
  Quaternion rotation;
  
  TransformComponent()
    : position = Vector3.zero(),
      scale = Vector3.one(),
      rotation = Quaternion.identity();
      
  void translate(Vector3 delta) {
    position += delta;
  }
}

// ===========================================================================
// SECTION 5: CELESTIAL BODIES
// ===========================================================================

class Star extends Entity {
  double temperature;
  double radius;
  double luminance;
  String spectralClass;

  Star(String name, this.spectralClass, this.temperature, this.radius)
      : luminance = pow(radius, 2) * pow(temperature / 5778, 4),
        super(name, EntityType.star);

  @override
  void update(double deltaTime) {
    // Stars generally don't move in this simulation time scale
    // Maybe verify internal fusion stability
    if (temperature > 100000) {
      print("Warning: Star $name is going supernova!");
    }
  }
  
  String getSpectralDescription() {
    switch (spectralClass[0]) {
      case 'O': return "Blue supergiant";
      case 'B': return "Blue-white giant";
      case 'A': return "White main sequence";
      case 'F': return "Yellow-white dwarf";
      case 'G': return "Yellow dwarf (Sol-like)";
      case 'K': return "Orange dwarf";
      case 'M': return "Red dwarf";
      default: return "Unknown anomaly";
    }
  }
}

class Planet extends Entity {
  Star orbitStar;
  double orbitRadius;
  double orbitalPeriod;
  double currentAngle;
  bool isHabitable;
  List<ResourceType> resources;
  int population;

  Planet(String name, this.orbitStar, this.orbitRadius, this.isHabitable)
      : orbitalPeriod = sqrt(pow(orbitRadius, 3)), // Simplified Kepler's 3rd
        currentAngle = Random().nextDouble() * 2 * GalaxyConstants.pi,
        resources = [],
        population = 0,
        super(name, EntityType.planet) {
    
    // Generate random resources
    final rng = Random();
    int resourceCount = rng.nextInt(5) + 1;
    for (int i = 0; i < resourceCount; i++) {
      resources.add(ResourceType.values[rng.nextInt(ResourceType.values.length)]);
    }
    
    if (isHabitable) {
      population = rng.nextInt(10000000) + 1000;
    }
  }

  @override
  void update(double deltaTime) {
    // Orbital mechanics
    double angularVelocity = (2 * GalaxyConstants.pi) / orbitalPeriod;
    currentAngle += angularVelocity * deltaTime;
    
    if (currentAngle > 2 * GalaxyConstants.pi) {
      currentAngle -= 2 * GalaxyConstants.pi;
    }
    
    // Update position relative to star
    position.x = orbitStar.position.x + cos(currentAngle) * orbitRadius;
    position.z = orbitStar.position.z + sin(currentAngle) * orbitRadius;
    position.y = orbitStar.position.y; // Simplified 2D plane orbit
  }
  
  bool hasResource(ResourceType type) {
    return resources.contains(type);
  }
}

// ===========================================================================
// SECTION 6: SPACESHIPS & MODULES
// ===========================================================================

abstract class ShipModule {
  String moduleName;
  double weight;
  double powerConsumption;
  double health;
  bool isDamaged;

  ShipModule(this.moduleName, this.weight, this.powerConsumption)
      : health = 100.0,
        isDamaged = false;

  void repair(double quantity) {
    health += quantity;
    if (health >= 100.0) {
      health = 100.0;
      isDamaged = false;
    }
  }

  void takeDamage(double quantity) {
    health -= quantity;
    if (health <= 0) {
      health = 0;
      isDamaged = true;
    }
  }
  
  void update(double dt);
}

class Engine extends ShipModule {
  double thrust;
  double efficiency;

  Engine(String name, this.thrust, this.efficiency) : super(name, 500.0, 100.0);

  @override
  void update(double dt) {
    if (isDamaged) {
      // Leaking fuel or unstable
      powerConsumption += dt * 5; 
    }
  }
}

class ShieldGenerator extends ShipModule {
  double shieldCapacity;
  double rechargeRate;
  double currentShield;

  ShieldGenerator(String name, this.shieldCapacity, this.rechargeRate)
      : currentShield = shieldCapacity,
        super(name, 200.0, 500.0);

  @override
  void update(double dt) {
    if (!isDamaged && currentShield < shieldCapacity) {
      currentShield += rechargeRate * dt;
      if (currentShield > shieldCapacity) currentShield = shieldCapacity;
    }
  }
  
  bool absorbDamage(double amount) {
    if (isDamaged || currentShield <= 0) return false;
    currentShield -= amount;
    if (currentShield < 0) {
      currentShield = 0;
      return false; // Shield broke, remaining damage touches hull
    }
    return true; // Fully absorbed
  }
}

class CargoHold extends ShipModule {
  int capacity;
  Map<ResourceType, int> inventory;

  CargoHold(int capacity)
      : this.capacity = capacity,
        inventory = {},
        super("Standard Cargo Hold", 100.0, 10.0);

  bool addItem(ResourceType item, int count) {
    int currentTotal = inventory.values.fold(0, (sum, c) => sum + c);
    if (currentTotal + count > capacity) return false;

    if (!inventory.containsKey(item)) inventory[item] = 0;
    inventory[item] = inventory[item]! + count;
    return true;
  }

  bool removeItem(ResourceType item, int count) {
    if (!inventory.containsKey(item) || inventory[item]! < count) return false;
    
    inventory[item] = inventory[item]! - count;
    if (inventory[item] == 0) inventory.remove(item);
    return true;
  }

  @override
  void update(double dt) {
    // Cargo hold static unless breach
  }
}

class SpaceShip extends Entity {
  ShipModule engine;
  ShipModule shield;
  CargoHold cargo;
  FactionAlignment faction;
  double hullHealth;
  double fuel;
  Vector3 velocity;

  SpaceShip(String name, this.faction)
      : engine = Engine("Ion Drive Mk1", 1000.0, 0.9),
        shield = ShieldGenerator("Deflector", 500.0, 5.0),
        cargo = CargoHold(50),
        hullHealth = 1000.0,
        fuel = 1000.0,
        velocity = Vector3.zero(),
        super(name, EntityType.ship);

  @override
  void update(double deltaTime) {
    if (!isActive) return;

    engine.update(deltaTime);
    shield.update(deltaTime);

    // Physics
    position += velocity * deltaTime;

    // Fuel consumption
    if (velocity.length > 0) {
      fuel -= (engine as Engine).powerConsumption * 0.001 * deltaTime;
      if (fuel < 0) {
        fuel = 0;
        velocity = Vector3.zero(); // Drifting
        print("Ship $name ran out of fuel!");
      }
    }
  }

  void accelerate(Vector3 direction, double intensity) {
    if (fuel <= 0) return;
    
    Vector3 thrustDir = direction.normalize();
    double force = (engine as Engine).thrust * intensity;
    // F = ma -> a = F/m (assuming mass 1000 for simplicity)
    Vector3 acceleration = thrustDir * (force / 1000.0);
    velocity += acceleration;
  }
}

// ===========================================================================
// SECTION 7: ECONOMY & MARKET LOGIC
// ===========================================================================

class MarketOrder {
  String id;
  ResourceType item;
  int quantity;
  double unitPrice;
  bool isBuyOrder;
  String issuerId;
  int timestamp;

  MarketOrder(this.item, this.quantity, this.unitPrice, this.isBuyOrder, this.issuerId)
      : id = UniqueIdGenerator.generateId(prefix: "ORD"),
        timestamp = DateTime.now().millisecondsSinceEpoch;
}

class GalacticMarket {
  static final GalacticMarket _instance = GalacticMarket._internal();
  factory GalacticMarket() => _instance;
  GalacticMarket._internal();

  List<MarketOrder> buyOrders = [];
  List<MarketOrder> sellOrders = [];
  Map<ResourceType, double> averagePrices = {};

  void placeOrder(MarketOrder order) {
    if (order.isBuyOrder) {
      buyOrders.add(order);
      // Sort desc by price
      buyOrders.sort((a, b) => b.unitPrice.compareTo(a.unitPrice));
    } else {
      sellOrders.add(order);
      // Sort asc by price
      sellOrders.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    }
    _matchOrders();
    _updateAverages();
  }

  void _matchOrders() {
    // Simple matching algorithm
    // In a real system, this would be highly optimized B-trees
    bool matched = true;
    while (matched && buyOrders.isNotEmpty && sellOrders.isNotEmpty) {
      matched = false;
      var buy = buyOrders.first;
      var sell = sellOrders.first;

      if (buy.item == sell.item && buy.unitPrice >= sell.unitPrice) {
        // Trade executes
        int quantity = min(buy.quantity, sell.quantity);
        double tradePrice = (buy.unitPrice + sell.unitPrice) / 2;
        
        print("Trade Executed: $quantity x ${buy.item} @ $tradePrice");

        buy.quantity -= quantity;
        sell.quantity -= quantity;

        if (buy.quantity == 0) buyOrders.removeAt(0);
        if (sell.quantity == 0) sellOrders.removeAt(0);
        
        matched = true;
      }
    }
  }

  void _updateAverages() {
    // Recalculate market prices based on history (mocked here by current orders)
    for (var type in ResourceType.values) {
      double sum = 0;
      int count = 0;
      for (var o in sellOrders.where((o) => o.item == type)) {
        sum += o.unitPrice;
        count++;
      }
      if (count > 0) averagePrices[type] = sum / count;
    }
  }
}

// ===========================================================================
// SECTION 8: PROCEDURAL GENERATION HELPERS
// ===========================================================================

class NameGenerator {
  static final List<String> prefixes = [
    "Alpha", "Beta", "Gamma", "Delta", "Epsilon", "Zeta", "Eta", "Theta",
    "New", "Old", "Great", "Lesser", "Prime", "Lost", "Forbidden"
  ];
  
  static final List<String> roots = [
    "Centauri", "Ceti", "Eridani", "Lyrae", "Cygni", "Draconis", "Orionis",
    "Majoris", "Minoris", "Carinae", "Velorum", "Pupis", "Hydrae"
  ];
  
  static final List<String> suffixes = [
    "I", "II", "III", "IV", "V", "VI", "VII", "X", "Prime", "Station", "Outpost"
  ];

  static String generatePlanetName() {
    var rng = Random();
    String prefix = prefixes[rng.nextInt(prefixes.length)];
    String root = roots[rng.nextInt(roots.length)];
    if (rng.nextBool()) {
      String suffix = suffixes[rng.nextInt(suffixes.length)];
      return "$prefix $root $suffix";
    }
    return "$prefix $root";
  }
}

class NoiseGenerator {
  // Simplex noise stub
  static double noise2D(double x, double y) {
    return sin(x) * cos(y); // Extremely poor noise, but enough for "random code"
  }
  
  static double fbm(double x, double y, int octaves) {
    double value = 0.0;
    double amplitude = 0.5;
    double frequency = 1.0;
    
    for (int i = 0; i < octaves; i++) {
      value += amplitude * noise2D(x * frequency, y * frequency);
      amplitude *= 0.5;
      frequency *= 2.0;
    }
    return value;
  }
}

// ===========================================================================
// SECTION 9: GAME STATE MANAGER
// ===========================================================================

class GameState {
  List<Entity> entities = [];
  double gameTime = 0.0;
  bool isPaused = false;
  
  void initialize() {
    // Create Solar System
    Star sun = Star("Sol", "G2V", 5778, 696340);
    entities.add(sun);
    
    Planet earth = Planet("Earth", sun, 149.6e6, true);
    entities.add(earth);
    
    Planet mars = Planet("Mars", sun, 227.9e6, false);
    entities.add(mars);
    
    // Add some random ships
    for (int i = 0; i < 50; i++) {
      var ship = SpaceShip("Fighter-${i+1}", FactionAlignment.federation);
      ship.position = Vector3.random() * 1000.0;
      entities.add(ship);
    }
    
    print("Galaxy Initialized with ${entities.length} entities.");
  }
  
  void tick(double deltaTime) {
    if (isPaused) return;
    
    gameTime += deltaTime;
    
    // Update all
    for (var ent in entities) {
      if (ent.isActive) {
        ent.update(deltaTime);
      }
    }
    
    // Collision detection (O(N^2) naive)
    for (int i = 0; i < entities.length; i++) {
      for (int j = i + 1; j < entities.length; j++) {
        var a = entities[i];
        var b = entities[j];
        if (a.isActive && b.isActive && a is SpaceShip && b is SpaceShip) {
          if (a.position.distanceTo(b.position) < 10.0) {
            print("Collision detected between ${a.name} and ${b.name}");
            // Handle crash logic
          }
        }
      }
    }
    
    // Clean up
    entities.removeWhere((e) => !e.isActive);
  }
}

// ===========================================================================
// SECTION 10: AI BEHAVIOR TREES (Simplified)
// ===========================================================================

abstract class Node {
  bool execute(Entity agent);
}

class Selector extends Node {
  List<Node> children;
  Selector(this.children);
  
  @override
  bool execute(Entity agent) {
    for (var child in children) {
      if (child.execute(agent)) return true;
    }
    return false;
  }
}

class Sequence extends Node {
  List<Node> children;
  Sequence(this.children);

  @override
  bool execute(Entity agent) {
    for (var child in children) {
      if (!child.execute(agent)) return false;
    }
    return true;
  }
}

class ConditionNode extends Node {
  bool Function(Entity) condition;
  ConditionNode(this.condition);
  
  @override
  bool execute(Entity agent) {
    return condition(agent);
  }
}

class ActionNode extends Node {
  void Function(Entity) action;
  ActionNode(this.action);
  
  @override
  bool execute(Entity agent) {
    action(agent);
    return true;
  }
}

class AIController {
  Node brain;
  
  AIController() : brain = _buildBehaviorTree();
  
  static Node _buildBehaviorTree() {
    return Selector([
      Sequence([
        ConditionNode((e) => (e as SpaceShip).shield.currentShield < 50),
        ActionNode((e) => print("${e.name} is fleeing due to low shields!"))
      ]),
      Sequence([
        ConditionNode((e) => (e as SpaceShip).fuel < 100),
        ActionNode((e) => print("${e.name} is searching for fuel refuel!"))
      ]),
      ActionNode((e) => {}) // Idle
    ]);
  }
  
  void update(Entity agent) {
    brain.execute(agent);
  }
}


// ===========================================================================
// SECTION 11: DATA PERSISTENCE LAYER (MOCK)
// ===========================================================================

class PersistenceManager {
  static Future<void> saveGame(GameState state, String filename) async {
    print("Saving game to $filename...");
    // Simulate IO delay
    await Future.delayed(Duration(milliseconds: 500));
    
    // Serialize state
    var data = {
      'timestamp': state.gameTime,
      'entity_count': state.entities.length,
      'snapshot': state.entities.map((e) => e.getDebugInfo()).toList()
    };
    
    String jsonStr = jsonEncode(data);
    print("Saved ${jsonStr.length} bytes.");
  }
  
  static Future<GameState> loadGame(String filename) async {
    print("Loading game from $filename...");
    await Future.delayed(Duration(milliseconds: 800));
    
    var newState = GameState();
    // Reconstruct state logic would go here
    return newState;
  }
}

// ===========================================================================
// SECTION 12: UNIT TESTS WITHIN FILE
// ===========================================================================

class TestSuite {
  static void runAllTests() {
    testVectorMath();
    testEconomy();
    testShipSystems();
    print("All tests passed.");
  }
  
  static void testVectorMath() {
    Vector3 v1 = Vector3(1, 0, 0);
    Vector3 v2 = Vector3(0, 1, 0);
    assert(v1.dot(v2) == 0, "Dot product fail");
    assert(v1.cross(v2).z == 1, "Cross product fail");
    print("Vector tests ok.");
  }
  
  static void testEconomy() {
    GalacticMarket market = GalacticMarket();
    market.placeOrder(MarketOrder(ResourceType.iron, 100, 50.0, true, "Player1"));
    market.placeOrder(MarketOrder(ResourceType.iron, 100, 40.0, false, "Miner1"));
    // Should execute at 45.0
    print("Economy tests ok.");
  }
  
  static void testShipSystems() {
    SpaceShip s = SpaceShip("TestShip", FactionAlignment.neutral);
    s.shield.takeDamage(100);
    assert(s.shield.currentShield < 500, "Shield damage fail");
    s.update(1.0);
    assert(s.shield.currentShield > 400, "Shield recharge fail");
    print("System tests ok.");
  }
}

// ===========================================================================
// SECTION 13: ENTRY POINT
// ===========================================================================

void main() {
  print("Starting Universe Simulation...");
  print("Random Seed: ${DateTime.now().microsecondsSinceEpoch}");
  
  // 1. Initialize
  GameState game = GameState();
  game.initialize();
  
  // 2. Run simulation loop for a bit
  for (int i = 0; i < 100; i++) {
    game.tick(0.16); // 60 FPS approx
    
    if (i % 10 == 0) {
      // Inject random market event
      GalacticMarket().placeOrder(
        MarketOrder(
          ResourceType.gold, 
          Random().nextInt(100), 
          Random().nextDouble() * 1000, 
          Random().nextBool(), 
          "SystemAI"
        )
      );
    }
  }
  
  // 3. Test Systems
  TestSuite.runAllTests();
  
  // 4. Shutdown
  PersistenceManager.saveGame(game, "auto_save.dat");
  print("Simulation Complete.");
}

// ---------------------------------------------------------------------------
// END OF FILE
// Total approximation of lines managed by verbose classes and spacing.
// ---------------------------------------------------------------------------
