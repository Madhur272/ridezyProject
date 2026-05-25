# Ridezy Project - Agent Guidelines

## Basic Guideline
You are operating as a senior-level AI collaborator, not a generic assistant. Before responding to anything, internalize the following operating parameters for this session
Treat me as a professional in my domain. Calibrate your language, depth and assumptions accordingly. Do not over-explain fundamentals unless I ask. Skip preamble, filler affirmations ("Great question!"), and unnecessary caveats. 
If a request in ambiguous, make a reasonable assumption, state it briefly, and proceed. Do no ask multiple clarifying questions. 
Think before you answer on complex tasks. Show your reasoning only if I ask, or if the answer is genuinly non-obvious. 
Flag genuine errors or risks directly. Do not soften warnings to the point of uselessness. 
If my request has better framing, tell me once - then do what I asked.
technical tasks - working output first, explanation after if needed

## Skill Use
Whenever a skill is called in the front of the prompt, use the information of that skill, e.g /frontend-design should add the frontend-design to my prompt. 
### frontend-design
Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.
This skill guides creation of distinctive, production-grade frontend interfaces that avoid generic "AI slop" aesthetics. Implement real working code with exceptional attention to aesthetic details and creative choices.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.
#### Design Thinking
Before coding, understand the context and commit to a BOLD aesthetic direction:
 - Purpose: What problem does this interface solve? Who uses it?
 - Tone: Pick an extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, etc. There are so many flavors to choose from. Use these for inspiration but design one that is true to the aesthetic direction.
 - Constraints: Technical requirements (framework, performance, accessibility).
 - Differentiation: What makes this UNFORGETTABLE? What's the one thing someone will remember?
CRITICAL: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work - the key is intentionality, not intensity.

Then implement working code (HTML/CSS/JS, React, Vue, etc.) that is:
 - Production-grade and functional
 - Visually striking and memorable
 - Cohesive with a clear aesthetic point-of-view
 - Meticulously refined in every detail

#### Frontend Aesthetics Guidelines
Focus on:
 - Typography: Choose fonts that are beautiful, unique, and interesting. Avoid generic fonts like Arial and Inter; opt instead for distinctive choices that elevate the frontend's aesthetics; unexpected, characterful font choices. Pair a distinctive display font with a refined body font.
 - Color & Theme: Commit to a cohesive aesthetic. Use CSS variables for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes.
 - Motion: Use animations for effects and micro-interactions. Prioritize CSS-only solutions for HTML. Use Motion library for React when available. Focus on high-impact moments: one well-orchestrated page load with staggered reveals (animation-delay) creates more delight than scattered micro-interactions. Use scroll-triggering and hover states that surprise.
 - Spatial Composition: Unexpected layouts. Asymmetry. Overlap. Diagonal flow. Grid-breaking elements. Generous negative space OR controlled density.
 - Backgrounds & Visual Details: Create atmosphere and depth rather than defaulting to solid colors. Add contextual effects and textures that match the overall aesthetic. Apply creative forms like gradient meshes, noise textures, geometric patterns, layered transparencies, dramatic shadows, decorative borders, custom cursors, and grain overlays.

NEVER use generic AI-generated aesthetics like overused font families (Inter, Roboto, Arial, system fonts), cliched color schemes (particularly purple gradients on white backgrounds), predictable layouts and component patterns, and cookie-cutter design that lacks context-specific character.

Interpret creatively and make unexpected choices that feel genuinely designed for the context. No design should be the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices (Space Grotesk, for example) across generations.

IMPORTANT: Match implementation complexity to the aesthetic vision. Maximalist designs need elaborate code with extensive animations and effects. Minimalist or refined designs need restraint, precision, and careful attention to spacing, typography, and subtle details. Elegance comes from executing the vision well.

Remember: OpenCode is capable of extraordinary creative work. Don't hold back, show what can truly be created when thinking outside the box and committing fully to a distinctive vision.


## Memory System
When I correct you or you learn something new, update the relevant section in AGENTS.md:
Voice - tone, phrasing, writing corrections
Process - how I want tasks done
People - who people are, relationships
Projects - active work, current tasks, status
Output - formats, naming, delivery preferences
Tools-which tools to use and how

All the phases of development are characterized as Completed, Ongoin, Need to Work on, Require Update. Keep a track of this and update this as per progress.
Do not remove any step from the project phase only change it from class to other - e.g, build ride-service move from ongoing to completed.
Keep AGENTS.md current. When something changes, update it in place - replace outdated info, don't just append below it. The file should always reflect the latest state.


## Project Overview
Ridezy is a decentralized AI-enabled mobility platform that combines blockchain, IoT, and real-time computer vision to create a transparent, low-cost, and trust-driven ride-sharing ecosystem. The system uses a hybrid architecture where operational services such as ride matching, live tracking, and analytics are handled off-chain using MongoDB, Redis, and Node.js, while critical components including payments, identity verification, credibility scoring, and governance are secured on-chain through Polygon-based smart contracts. AI-powered edge devices integrated with cameras, GPS, IMU, and vehicle sensors continuously monitor driving behavior using lane detection, traffic sign recognition, and anomaly detection models to generate automated sensor-verified credibility scores. The platform is designed with a modular 7-smart-contract architecture supporting escrow payments, DAO governance, vehicle NFTs, and decentralized reputation management, while future phases extend toward V2V/V2I communication, autonomous fleet coordination, and smart city integration using Hedera. The ultimate goal of Ridezy is to build a scalable, privacy-first, and autonomous-ready mobility infrastructure that eliminates centralized intermediaries and redefines the future of global transportation.

## Project Structure
Microservices architecture with:
- **Backend**: Node.js services in `/backend` (auth, api-gateway, ride-service, etc.)
- **Frontend**: React app in `/frontend/react-app`, admin dashboard in `/frontend/admin-dashboard`
- **Blockchain**: Smart contracts in `/blockchain`
- **Mobile App**: React Native in `/mobile-app`
- **IoT**: Infrastructure in `/iot`
- **Shared**: Common utilities in `/backend/shared` (web3, redisClient)

## Development Commands
### Backend Services
Each service in `/backend/*` has:
- `npm run dev` - Start with nodemon (development)
- `npm start` - Start with node (production)
- **No test scripts defined** - implement your own testing

Example:
```bash
cd backend/auth-service
npm run dev
```

### Blockchain
```bash
cd blockchain
npx hardhat node          # Start local blockchain
npx hardhat run scripts/deploy.js --network localhost  # Deploy contracts
```

### Docker
```bash
docker-compose up         # Start all services
docker-compose down       # Stop all services
```

## Service Ports
From docker-compose.yml:
- API Gateway: 4000
- Auth Service: 4001
- Blockchain Service: 4002
- Vehicle Service: 4003
- Payment Service: 4004
- Reputation Service: 4007
- Ride Matching Service: 4008
- Ride Service: 4009
- Analytics Service: 4010
- Realtime Service: 4011
- IoT Service: 4012

## Environment Setup
1. Each service requires its own `.env` file (see existing ones for reference)
2. Minimum variables per service: PORT, SERVICE_NAME
3. Common variables: MONGO_URI, REDIS_HOST, BLOCKCHAIN_RPC_URL
4. Shared `.env` in `/backend/shared` contains PRIVATE_KEY for blockchain
5. Docker Compose provides MongoDB, Redis, InfluxDB, MQTT

## Testing
Currently no test scripts defined in any service. Services should implement their own testing strategies.

## Code Conventions
- JavaScript/Node.js backend services
- React frontend applications
- Solidity smart contracts (blockchain)
- Follow existing code style in each service


## Project Progress
### COMPLETED
#### System Architecture
 - Microservice-based backend architecture initialized
 - Independent backend services separated successfully
 - Service-oriented communication model established
 - Shared contract ABI architecture designed
 - Event-driven architecture introduced using Redis Pub/Sub

#### Backend Infrastructure
 - Services Created
 - api-gateway
 - auth-service
 - ride-service
 - ride-matching-service
 - payment-service
 - vehicle-service
 - reputation-service
 - blockchain-service
 - analytics-service
 - iot-service
 - realtime-service

#### Database Layer
 - MongoDB 
    - MongoDB integration completed
    - Geospatial indexing implemented
    - Driver schema created
    - Ride schema created
    - Vehicle schema initialized
 - Redis
    - Redis configured
    - Active driver cache working
    - TTL-based live location tracking working
    - Redis Pub/Sub implemented
    - Driver event notifications functioning
 - InfluxDB
    - Infrastructure planned
    - Container configuration prepared

#### Ride Matching Engine
 - Ride request flow working
 - Driver proximity matching implemented
 - Haversine distance ranking working
 - Driver notification pipeline working
 - Driver assignment fallback logic working
 - Driver timeout retry mechanism implemented

#### Blockchain Layer
 - Hardhat Setup
 - Hardhat configured
 - Local blockchain node working
 - Polygon-compatible architecture prepared
 - Smart Contracts Built
 - RidePaymentEscrow
 - CredibilityScoring
 - RidezyToken
 - VehicleWallet
 - Smart Contract Features
 - Escrow locking working
 - Contract deployment working
 - ABI generation working
 - Ethers.js integration working
 - Nonce management fixed
 - Backend-to-contract communication working

#### Backend ↔ Blockchain Integration
 - Ride booking triggers escrow
 - Blockchain transaction hashes returned
 - Smart contract events functioning
 - Backend transaction listeners working

#### Real-Time Infrastructure
 - Socket.IO
    - Real-time service initialized
    - Driver socket connection working
    - Driver notification emission working
    - Ride assignment event broadcasting working

#### Flutter Application
 - Application Structure
    - Rider flow initialized
    - Driver flow initialized
    - Role selection architecture working
    - Navigation architecture completed
 - UI/UX
    - Premium neo-futuristic theme created
    - Splash screen implemented
    - Onboarding system implemented
    - Rider dashboard redesigned
    - Driver dashboard direction defined
    - CRO-focused visual design introduced
 - Assets
    - Premium visual asset pack created
    - AI onboarding artwork completed
    - Blockchain onboarding artwork completed
    - Smart mobility onboarding artwork completed
    - Futuristic map preview created
    - Driver avatar created
    - Vehicle showcase asset created
    - Cyber city background created

#### DevOps Foundations
 - Docker
    - Dockerfiles created
    - Docker Compose architecture created
    - Shared volume issue resolved
    - Multi-container orchestration prepared
 - Kubernetes
    - Minikube cluster initialized
    - Kubernetes deployment manifests created
    - Kubernetes service manifests created

#### AI Architecture Planning
 - YOLOv8 pipeline architecture planned
 - OpenCV monitoring architecture planned
 - Safety scoring flow designed
 - Driver behavior monitoring architecture planned

### ONGOING
#### Flutter Frontend Completion
 - Currently In Progress
    - Premium UI implementation
    - Full rider flow polishing
    - Driver dashboard redesign
    - Mock ride lifecycle animations
    - Lottie animation integration
    - Bottom navigation redesign
    - Tracking screen implementation
    - Wallet screen implementation
    - AI analytics screen implementation

#### Container Orchestration
 - Currently In Progress
    - Kubernetes deployment testing
    - Service exposure configuration
    - Container networking stabilization
    - Environment variable management
#### Event-Driven Infrastructure
 - Currently In Progress
 - Redis event scaling
 - Multi-service event orchestration
 - Event consistency optimization

#### Backend API Standardization
 - Currently In Progress
 - REST route normalization
 - API response standardization
 - Gateway routing cleanup

### LEFT TO BUILD

#### Smart Contracts Remaining
 - Yet To Build
    - UserRegistry
    - VehicleNFT
    - DAOGovernance
    - Yet To Implement
    - NFT minting
    - DAO proposal system
    - Governance voting
    - Reputation staking
    - On-chain dispute resolution

#### AI / Computer Vision Layer
 - Yet To Build
    - YOLOv8 training pipeline
    - OpenCV integration
    - Real-time video stream processing
    - Violation detection engine
    - Lane detection
    - Traffic sign detection
    - Driver distraction detection
    - Drowsiness detection
    - AI credibility scoring
    - AI evidence storage

#### IoT Layer
 - Yet To Build
    - MQTT communication layer
    - ROS2 integration
    - Vehicle telemetry ingestion
    - GPS ingestion
    - IMU ingestion
    - Camera feed ingestion
    - Radar integration
    - Jetson Xavier deployment
    - Edge AI deployment

#### Payment Infrastructure
 - Yet To Build
    - Fiat payment integration
    - Wallet top-up system
    - Hybrid fiat + crypto payments
    - Automated payout system
    - Driver settlement engine
#### Security Layer
 - Yet To Build
    - JWT refresh system
    - API rate limiting
    - Request validation middleware
    - Smart contract auditing
    - Web3 signature verification
    - DDOS protection
    - Secure secret management

#### Analytics Layer
 - Yet To Build
    - Real-time dashboards
    - Grafana integration
    - Prometheus metrics
    - Ride analytics
    - AI analytics
    - Fleet monitoring
    - Operational observability

#### Production Infrastructure
 - Yet To Build
    - AWS/GCP deployment
    - CI/CD pipelines
    - GitHub Actions
    - Auto-scaling
    - Load balancing
    - CDN setup
    - TLS/SSL setup
    - Domain infrastructure
    - Monitoring alerts
    - Centralized logging

#### Frontend Features Left
 - Rider App
    - Live maps
    - Ride tracking
    - Wallet UI
    - Ride history
    - Rating system
    - Profile management
    - Emergency SOS
    - AI safety indicators
 - Driver App
    - Earnings dashboard
    - Ride acceptance flow
    - Online/offline state
    - Route navigation
    - Driver analytics
    - AI monitoring status

#### Testing Layer
 - Yet To Build
    - Unit testing
    - Integration testing
    - Smart contract testing
    - Load testing
    - Socket stress testing
    - Blockchain stress testing
    - Kubernetes resilience testing

### REQUIRE RE-MONITORING

#### Docker Architecture
 - Needs Review
    - Shared ABI volume strategy
    - Docker networking consistency
    - Image optimization
    - Multi-stage builds

#### Kubernetes Architecture
 - Needs Review
    - Internal service discovery
    - Persistent volumes
    - Redis persistence
    - MongoDB persistence
    - Secrets management
    - Horizontal scaling strategy

#### Redis Event System
 - Needs Review
    - Duplicate event handling
    - Event durability
    - Dead-letter queues
    - Event replay strategy

#### Blockchain Integration
 - Needs Review
    - Gas optimization
    - Polygon testnet deployment
    - Contract upgradability
    - Event indexing
    - Transaction retry logic

#### Socket.IO Infrastructure
 - Needs Review
    - Socket authentication
    - Reconnection strategy
    - Horizontal scaling
    - Multi-instance synchronization

#### Flutter Architecture
 - Needs Review
 - State management architecture
 - Responsiveness
 - Animation optimization
 - Folder scalability
 - Theme consistency

#### AI Pipeline
 - Needs Review Before Building
 - Model deployment strategy
 - Edge vs cloud inference
 - GPU requirements
 - Dataset preparation
 - Real-time latency targets

#### IoT Infrastructure
 - Needs Review Before Building
 - Sensor selection
 - ROS2 node architecture
 - Vehicle hardware requirements
 - Connectivity reliability
 - Edge processing constraints