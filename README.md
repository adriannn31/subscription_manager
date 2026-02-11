# Subscription Manager Web App

A beautiful and detailed subscription management web application built with Flutter.

## Features

### 📊 Dashboard Overview
- **Monthly Spending**: Track total monthly subscription costs
- **Yearly Spending**: Calculate annual subscription expenses
- **Active Subscriptions**: View count of all active subscriptions
- Real-time statistics with visual indicators

### 💳 Subscription Management
- **Add Subscriptions**: Detailed form with all necessary fields
  - Service name
  - Category (Entertainment, Software, Music, etc.)
  - Amount
  - Billing cycle (Monthly/Yearly)
  - Next billing date
  - Custom color picker (8 colors)
  - Icon picker (10+ icons)
  - Optional notes
  
- **View Subscriptions**: Beautiful card-based layout showing:
  - Service name and category
  - Amount and billing frequency
  - Days until next billing (with color-coded alerts)
  - Custom icon and color
  
- **Filter by Category**: Quick filter chips to view subscriptions by category

- **Subscription Details**: Click any subscription to view:
  - Full details
  - Days until billing
  - Notes
  - Edit and delete options

### 🎨 Design Features
- Clean, modern UI with custom color scheme
- Responsive layout that works on all screen sizes
- Smooth animations and transitions
- Color-coded billing alerts (yellow for <7 days, green otherwise)
- Professional card-based design
- Custom icons and colors for each subscription

### 🔔 Smart Notifications
- Visual indicators for upcoming billing dates
- Color-coded urgency (due in 7 days or less shows warning color)

## Setup Instructions

### Prerequisites
- Flutter SDK installed
- Web support enabled: `flutter config --enable-web`
- VS Code with Flutter extension

### Installation

1. **Create the project structure:**
```bash
mkdir subscription_manager
cd subscription_manager
```

2. **Copy the files:**
   - Copy `lib/main.dart` to `lib/main.dart`
   - Copy `pubspec.yaml` to `pubspec.yaml`

3. **Install dependencies:**
```bash
flutter pub get
```

4. **Run the web app:**
```bash
flutter run -d chrome
```

Or select Chrome as device in VS Code and press F5.

### Build for Production

```bash
flutter build web
```

The production build will be in `build/web/` directory.

## Usage Guide

### Adding a Subscription
1. Click the "Add Subscription" floating button (bottom right)
2. Fill in the details:
   - Enter service name (e.g., "Netflix")
   - Enter category (e.g., "Entertainment")
   - Enter amount (e.g., "15.99")
   - Select billing cycle (Monthly or Yearly)
   - Choose next billing date
   - Pick a color
   - Pick an icon
   - Add notes (optional)
3. Click "Add Subscription"

### Viewing Subscription Details
1. Click on any subscription card
2. View all details including days until billing
3. Options to Edit or Delete

### Filtering Subscriptions
- Click on category chips at the top to filter
- Click "All" to view all subscriptions

### Understanding the Dashboard
- **Monthly Spending**: Shows total monthly cost (converts yearly to monthly)
- **Yearly Spending**: Shows total annual cost
- **Active Subscriptions**: Total count of subscriptions

## Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **UI**: Material Design 3
- **State Management**: StatefulWidget (simple and effective)
- **Date Handling**: intl package
- **Platform**: Web (Chrome, Edge, Safari, Firefox)

## Project Structure

```
subscription_manager/
├── lib/
│   └── main.dart          # Main application code
├── web/                   # Web-specific files
├── pubspec.yaml          # Dependencies
└── README.md             # This file
```

## Features Breakdown

### Models
- `Subscription`: Main data model with all subscription properties
- `BillingCycle`: Enum for monthly/yearly billing
- Immutable design with copyWith method

### Widgets
- `SubscriptionHomePage`: Main page with dashboard
- `AddSubscriptionDialog`: Full-featured add form
- `SubscriptionDetailsDialog`: Detailed view with actions

### Calculations
- Automatic monthly/yearly cost conversion
- Days until billing calculation
- Category-based filtering
- Real-time stats updates

## Customization

### Adding More Colors
Edit the `_colors` list in `AddSubscriptionDialog`:
```dart
final List<Color> _colors = [
  const Color(0xFF6366F1),
  const Color(0xFFEC4899),
  // Add more colors here
];
```

### Adding More Icons
Edit the `_icons` list in `AddSubscriptionDialog`:
```dart
final List<IconData> _icons = [
  Icons.subscriptions,
  Icons.movie,
  // Add more icons here
];
```

### Changing Theme Colors
Edit the theme in `SubscriptionManagerApp`:
```dart
primaryColor: const Color(0xFF6366F1),  // Change this
```

## Deployment

### Firebase Hosting
```bash
flutter build web
firebase init hosting
firebase deploy
```

### Netlify
1. Build: `flutter build web`
2. Drag and drop `build/web` folder to Netlify

### GitHub Pages
1. Build: `flutter build web --base-href "/REPO-NAME/"`
2. Push `build/web` to gh-pages branch

## Future Enhancements

Potential features to add:
- [ ] Data persistence (local storage or backend)
- [ ] Export to CSV/PDF
- [ ] Recurring notification reminders
- [ ] Payment history tracking
- [ ] Budget limits and alerts
- [ ] Multi-currency support
- [ ] Dark mode
- [ ] Sharing subscriptions with family
- [ ] Auto-import from email
- [ ] Analytics and charts
- [ ] Subscription recommendations

## Contributing

Feel free to fork and customize this project for your needs!

## License

MIT License - feel free to use this code for personal or commercial projects.

## Support

For issues or questions:
1. Check the code comments
2. Review Flutter documentation: https://flutter.dev
3. Check Material Design guidelines: https://m3.material.io

---

Built with ❤️ using Flutter