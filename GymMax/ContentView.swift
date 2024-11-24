import SwiftUI
import PhotosUI

// MARK: - Models and Helpers
struct ProgressPhoto: Identifiable {
    let id = UUID()
    let image: UIImage
    let date: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct WorkoutDay: Identifiable {
    let id = UUID()
    let name: String
    let focus: String
    let exercises: [Exercise]
}

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: String
    let notes: String
}

struct BodyAnalysis {
    let muscleMass: String
    let bodyFat: String
    let bmi: String
    let suggestions: [String]
}

// MARK: - Color Extensions
extension Color {
    static let gymMaxPrimary = Color(hex: "6C63FF")    // Modern indigo
    static let gymMaxSecondary = Color(hex: "4834D4")  // Deep purple
    static let gymMaxAccent = Color(hex: "00F5FF")     // Electric blue
    static let gymMaxGradientStart = Color(hex: "0B0B1F") // Very dark blue
    static let gymMaxGradientEnd = Color(hex: "2C2C54")   // Dark purple-blue
    static let gymMaxBackground = Color(hex: "070714")    // Nearly black
    static let gymMaxCardBackground = Color(hex: "1A1A2E").opacity(0.9) // Semi-transparent dark blue
    static let gymMaxSuccess = Color(hex: "00B894")    // Mint green
    static let gymMaxWarning = Color(hex: "FFB142")    // Warm orange
    static let gymMaxError = Color(hex: "FF6B6B")      // Soft red
    static let gymMaxText = Color.white
    static let gymMaxSubtext = Color.white.opacity(0.7)
    static let gymMaxGlow = Color(hex: "00F5FF").opacity(0.15) // Neon glow effect
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Main ContentView with TabView
struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.gymMaxGradientStart, .gymMaxGradientEnd]),
                          startPoint: .top,
                          endPoint: .bottom)
                .ignoresSafeArea()
            
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                ProgressViewSection()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Progress")
                    }
                    .tag(1)
                
                TransformView()
                    .tabItem {
                        Image(systemName: "sparkles.rectangle.stack.fill")
                        Text("AI Coach")
                    }
                    .tag(2)
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
                    .tag(3)
            }
            .tint(.gymMaxAccent)
            .preferredColorScheme(.dark)
        }
    }
}

// MARK: - HomeView
struct HomeView: View {
    @State private var selectedWorkout: WorkoutDay?
    @State private var showingWorkoutDetail = false
    @State private var dailyMotivation: String = "Loading your personalized motivation..."
    @State private var workoutStreak: Int = 0
    @State private var showingAICoach = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Hero Section with Streak
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.gymMaxSecondary, .gymMaxPrimary]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.gymMaxAccent.opacity(0.3), lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("🔥 \(workoutStreak) Day Streak")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text(dailyMotivation)
                                    .font(.subheadline)
                                    .foregroundColor(.gymMaxSubtext)
                            }
                            Spacer()
                        }
                        
                        Button(action: { showingAICoach = true }) {
                            HStack {
                                Text("Get AI Workout")
                                    .fontWeight(.semibold)
                                Image(systemName: "sparkles")
                            }
                            .foregroundColor(.gymMaxBackground)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.gymMaxAccent)
                                    .shadow(color: Color.gymMaxAccent.opacity(0.3), radius: 5, x: 0, y: 2)
                            )
                        }
                    }
                    .padding(25)
                }
                .frame(height: 180)
                .padding(.horizontal)
                
                // Quick Actions Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 15),
                    GridItem(.flexible(), spacing: 15)
                ], spacing: 15) {
                    QuickActionCard(
                        icon: "camera.fill",
                        title: "Progress Pic",
                        subtitle: "Track your transformation",
                        action: { /* Navigate to progress pics */ }
                    )
                    
                    QuickActionCard(
                        icon: "chart.bar.fill",
                        title: "Stats",
                        subtitle: "View your progress",
                        action: { /* Navigate to stats */ }
                    )
                    
                    QuickActionCard(
                        icon: "figure.walk",
                        title: "Workouts",
                        subtitle: "Your personalized plan",
                        action: { /* Navigate to workouts */ }
                    )
                    
                    QuickActionCard(
                        icon: "person.fill.viewfinder",
                        title: "Body Goals",
                        subtitle: "Update your targets",
                        action: { /* Navigate to goals */ }
                    )
                }
                .padding(.horizontal)
                
                // Today's Workout Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Today's Workout")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.gymMaxText)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(generateSampleWorkouts()) { workout in
                                WorkoutDayCard(day: workout) {
                                    selectedWorkout = workout
                                    showingWorkoutDetail = true
                                }
                                .frame(width: 280)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color.gymMaxBackground)
        .sheet(isPresented: $showingWorkoutDetail) {
            if let workout = selectedWorkout {
                WorkoutDetailView(workout: workout)
            }
        }
    }
    
    private func generateSampleWorkouts() -> [WorkoutDay] {
        [
            WorkoutDay(name: "Upper Body Power", focus: "Chest & Back", exercises: [
                Exercise(name: "Bench Press", sets: 4, reps: "8-10", notes: "Focus on form"),
                Exercise(name: "Pull-ups", sets: 3, reps: "Max", notes: "Use assistance if needed"),
                Exercise(name: "Shoulder Press", sets: 3, reps: "12", notes: "Control the weight")
            ]),
            WorkoutDay(name: "Core Crusher", focus: "Abs & Lower Back", exercises: [
                Exercise(name: "Planks", sets: 3, reps: "60 sec", notes: "Keep body straight"),
                Exercise(name: "Russian Twists", sets: 3, reps: "20 each side", notes: "Use weight if ready"),
                Exercise(name: "Dead Bug", sets: 3, reps: "12 each side", notes: "Focus on breathing")
            ])
        ]
    }
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.gymMaxAccent)
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.gymMaxGlow)
                    )
                
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.gymMaxText)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gymMaxSubtext)
                    .lineLimit(2)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gymMaxCardBackground)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
        }
    }
}

// MARK: - Supporting Views
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.gymMaxPrimary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gymMaxCardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
}

struct WorkoutCard: View {
    let title: String
    let duration: String
    let intensity: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            HStack {
                Image(systemName: "clock.fill")
                Text(duration)
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Text(intensity)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gymMaxAccent.opacity(0.2))
                .foregroundColor(.gymMaxAccent)
                .cornerRadius(8)
        }
        .padding()
        .frame(width: 160)
        .background(Color.gymMaxCardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
}

struct QuoteCard: View {
    let quote: String
    let author: String
    
    var body: some View {
        VStack(spacing: 10) {
            Text("""
                 \(quote)
                 """)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("- \(author)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gymMaxCardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
}

// MARK: - TransformView
struct TransformView: View {
    @State private var selectedImage: UIImage?
    @State private var transformedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var bodyAnalysis: BodyAnalysis?
    
    var body: some View {
        NavigationView {
            ZStack {
                // Blue Gradient background
                LinearGradient(gradient: Gradient(colors: [Color.gymMaxGradientStart, Color.gymMaxGradientEnd]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Display Selected Image
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .cornerRadius(25)
                                .shadow(radius: 10)
                                .transition(.scale)
                        } else {
                            PlaceholderImageView()
                        }
                        
                        // Select Photo Button
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            ButtonView(title: "Select Photo", icon: "photo.on.rectangle.angled")
                        }
                        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                            ImagePicker(image: $inputImage)
                        }
                        
                        // Analyze Body Button
                        if selectedImage != nil {
                            Button(action: analyzeBody) {
                                ButtonView(title: "Analyze Body", icon: "wand.and.stars")
                            }
                        }
                        
                        // Display Transformed Image and Analysis
                        if let transformedImage = transformedImage, let analysis = bodyAnalysis {
                            VStack(spacing: 20) {
                                Image(uiImage: transformedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 300)
                                    .cornerRadius(25)
                                    .shadow(radius: 10)
                                    .transition(.scale)
                                
                                // Body Analysis Results
                                BodyAnalysisView(analysis: analysis)
                            }
                            .padding()
                            .background(Color.gymMaxCardBackground)
                            .cornerRadius(20)
                            .shadow(radius: 5)
                            .transition(.opacity)
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Transform", displayMode: .inline)
        }
    }
    
    // Load the selected image
    func loadImage() {
        guard let inputImage = inputImage else { return }
        selectedImage = inputImage
    }
    
    // Simulate Body Analysis
    func analyzeBody() {
        // Simulate AI processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.transformedImage = self.selectedImage // Placeholder for AI-transformed image
            self.bodyAnalysis = BodyAnalysis(
                muscleMass: "75%",
                bodyFat: "18%",
                bmi: "23.5",
                suggestions: [
                    "Increase protein intake",
                    "Incorporate strength training",
                    "Maintain regular cardio sessions"
                ]
            )
        }
    }
}

// MARK: - ProgressViewSection
struct ProgressViewSection: View {
    @State private var progressPhotos: [ProgressPhoto] = []
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var selectedPhoto: ProgressPhoto?
    @State private var showingPhotoDetail = false
    @State private var selectedTimeRange = 1 // 1 month
    
    let timeRanges = [1, 3, 6, 12] // months
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Progress Header
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.gymMaxPrimary, Color.gymMaxSecondary]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 200)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            
                            Text("Your Progress Journey")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Track your transformation over time")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    // Time Range Selector
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Time Range")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(timeRanges, id: \.self) { months in
                                    TimeRangeButton(months: months, 
                                                  isSelected: months == selectedTimeRange,
                                                  action: { selectedTimeRange = months })
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Progress Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        // Add Photo Button
                        Button(action: { showingImagePicker = true }) {
                            AddPhotoCard()
                        }
                        
                        // Progress Photos
                        ForEach(progressPhotos) { photo in
                            ProgressPhotoCard(photo: photo) {
                                selectedPhoto = photo
                                showingPhotoDetail = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.gymMaxBackground)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .sheet(isPresented: $showingPhotoDetail) {
                if let photo = selectedPhoto {
                    PhotoDetailView(photo: photo)
                }
            }
            .onChange(of: inputImage) { newImage in
                if let image = newImage {
                    let newPhoto = ProgressPhoto(image: image, date: Date())
                    progressPhotos.insert(newPhoto, at: 0)
                    inputImage = nil
                }
            }
        }
    }
}

struct TimeRangeButton: View {
    let months: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(months) \(months == 1 ? "Month" : "Months")")
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.gymMaxPrimary : Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
    }
}

struct AddPhotoCard: View {
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.gymMaxPrimary)
            
            Text("Add Progress Photo")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color.gymMaxCardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
}

struct ProgressPhotoCard: View {
    let photo: ProgressPhoto
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(uiImage: photo.image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipped()
                
                Text(photo.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            .background(Color.gymMaxCardBackground)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 10)
        }
    }
}

struct PhotoDetailView: View {
    let photo: ProgressPhoto
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAIAnalysis = false
    @State private var analysis: BodyAnalysis?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Photo Display
                    Image(uiImage: photo.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gymMaxAccent.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    // Date and Time
                    VStack(spacing: 8) {
                        Text(photo.formattedDate)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.gymMaxText)
                        
                        Text(photo.formattedTime)
                            .font(.subheadline)
                            .foregroundColor(.gymMaxSubtext)
                    }
                    
                    // AI Analysis Button
                    if analysis == nil {
                        Button(action: {
                            showingAIAnalysis = true
                            // Simulate AI analysis
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                analysis = BodyAnalysis(
                                    muscleMass: "32.5%",
                                    bodyFat: "18.2%",
                                    bmi: "23.4",
                                    suggestions: [
                                        "Great progress on upper body definition",
                                        "Consider focusing on core exercises",
                                        "Maintain current protein intake"
                                    ]
                                )
                            }
                        }) {
                            HStack {
                                Image(systemName: "sparkles")
                                Text("Analyze Photo")
                                Image(systemName: "chevron.right")
                            }
                            .font(.headline)
                            .foregroundColor(.gymMaxAccent)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.gymMaxCardBackground)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gymMaxAccent.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Analysis Results
                    if let analysis = analysis {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("AI Analysis")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.gymMaxText)
                            
                            // Metrics Grid
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                MetricView(title: "Muscle Mass", value: analysis.muscleMass)
                                MetricView(title: "Body Fat", value: analysis.bodyFat)
                                MetricView(title: "BMI", value: analysis.bmi)
                            }
                            
                            // Suggestions
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Suggestions")
                                    .font(.headline)
                                    .foregroundColor(.gymMaxText)
                                
                                ForEach(analysis.suggestions, id: \.self) { suggestion in
                                    HStack(spacing: 12) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.gymMaxSuccess)
                                        
                                        Text(suggestion)
                                            .font(.subheadline)
                                            .foregroundColor(.gymMaxSubtext)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gymMaxCardBackground)
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.gymMaxBackground)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gymMaxSubtext)
                }
            )
        }
    }
}

struct MetricView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gymMaxAccent)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gymMaxSubtext)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - WorkoutPlanView
struct WorkoutPlanView: View {
    @State private var workoutPlan: [WorkoutDay] = []
    @State private var isLoading = false
    @State private var selectedDay: WorkoutDay?
    @State private var showingDayDetail = false
    @State private var showingCustomizeSheet = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Workout Plan Header
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.gymMaxPrimary, Color.gymMaxSecondary]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 200)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            Image(systemName: "figure.run.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                            
                            Text("Your Workout Plan")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("AI-powered personalized training")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else if workoutPlan.isEmpty {
                        // Empty State
                        VStack(spacing: 20) {
                            Button(action: generatePlan) {
                                VStack(spacing: 15) {
                                    Image(systemName: "wand.and.stars")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gymMaxPrimary)
                                    
                                    Text("Generate Your Plan")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Get an AI-powered workout plan tailored to your goals")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gymMaxCardBackground)
                                .cornerRadius(15)
                                .shadow(color: Color.black.opacity(0.05), radius: 10)
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        // Workout Days
                        VStack(spacing: 15) {
                            ForEach(workoutPlan) { day in
                                WorkoutDayCard(day: day) {
                                    selectedDay = day
                                    showingDayDetail = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Customize Button
                        Button(action: { showingCustomizeSheet = true }) {
                            HStack {
                                Image(systemName: "slider.horizontal.3")
                                Text("Customize Plan")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gymMaxPrimary)
                            .cornerRadius(15)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color.gymMaxBackground)
            .navigationBarHidden(true)
            .sheet(isPresented: $showingDayDetail) {
                if let day = selectedDay {
                    WorkoutDayDetailView(day: day)
                }
            }
            .sheet(isPresented: $showingCustomizeSheet) {
                CustomizePlanView(workoutPlan: $workoutPlan)
            }
        }
    }
    
    private func generatePlan() {
        isLoading = true
        // Simulate AI plan generation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            workoutPlan = [
                WorkoutDay(name: "Day 1", focus: "Upper Body", exercises: [
                    Exercise(name: "Push-ups", sets: 3, reps: "12-15", notes: "Focus on form"),
                    Exercise(name: "Dumbbell Rows", sets: 3, reps: "12", notes: "Control the movement"),
                    Exercise(name: "Shoulder Press", sets: 3, reps: "10-12", notes: "Maintain core stability")
                ]),
                WorkoutDay(name: "Day 2", focus: "Lower Body", exercises: [
                    Exercise(name: "Squats", sets: 4, reps: "12-15", notes: "Keep chest up"),
                    Exercise(name: "Lunges", sets: 3, reps: "12 each leg", notes: "Step forward with control"),
                    Exercise(name: "Calf Raises", sets: 3, reps: "15-20", notes: "Full range of motion")
                ]),
                WorkoutDay(name: "Day 3", focus: "Core & Cardio", exercises: [
                    Exercise(name: "Plank", sets: 3, reps: "30 seconds", notes: "Keep body straight"),
                    Exercise(name: "Mountain Climbers", sets: 3, reps: "20 each leg", notes: "Fast pace"),
                    Exercise(name: "Jump Rope", sets: 1, reps: "10 minutes", notes: "Maintain rhythm")
                ])
            ]
            isLoading = false
        }
    }
}

struct WorkoutDayCard: View {
    let day: WorkoutDay
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(day.name)
                            .font(.headline)
                        Text(day.focus)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gymMaxPrimary)
                }
                
                Divider()
                
                Text("\(day.exercises.count) exercises")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gymMaxCardBackground)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 10)
        }
    }
}

struct WorkoutDayDetailView: View {
    let day: WorkoutDay
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 5) {
                        Text(day.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(day.focus)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Exercises
                    VStack(spacing: 15) {
                        ForEach(day.exercises) { exercise in
                            ExerciseCard(exercise: exercise)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.gymMaxBackground)
            .navigationBarTitle("Workout Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ExerciseCard: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.name)
                .font(.headline)
            
            HStack {
                Label("\(exercise.sets) sets", systemImage: "number.circle.fill")
                Spacer()
                Label(exercise.reps, systemImage: "repeat.circle.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            if !exercise.notes.isEmpty {
                Text(exercise.notes)
                    .font(.caption)
                    .foregroundColor(.gymMaxAccent)
                    .padding(.top, 5)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gymMaxCardBackground)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
}

struct CustomizePlanView: View {
    @Binding var workoutPlan: [WorkoutDay]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Customize options here
                    Text("Coming Soon!")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .background(Color.gymMaxBackground)
            .navigationBarTitle("Customize Plan", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @State private var username: String = "TeenFitnessUser"
    @State private var idealBodyImage: UIImage? = UIImage(systemName: "figure.stand")
    @State private var showingIdealBodyPicker = false
    @State private var inputImage: UIImage?
    @State private var showingEditUsername = false
    @State private var newUsername: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Blue Gradient background
                LinearGradient(gradient: Gradient(colors: [Color.gymMaxGradientStart, Color.gymMaxGradientEnd]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Profile Picture
                    if let image = idealBodyImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .onTapGesture {
                                showingIdealBodyPicker = true
                            }
                            .sheet(isPresented: $showingIdealBodyPicker, onDismiss: loadIdealBodyImage) {
                                ImagePicker(image: $inputImage)
                            }
                    } else {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.white)
                            .onTapGesture {
                                showingIdealBodyPicker = true
                            }
                            .sheet(isPresented: $showingIdealBodyPicker, onDismiss: loadIdealBodyImage) {
                                ImagePicker(image: $inputImage)
                            }
                    }
                    
                    // Username
                    Text(username)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    // Edit Username Button
                    Button(action: {
                        showingEditUsername = true
                    }) {
                        ButtonView(title: "Edit Profile", icon: "pencil.circle")
                    }
                    .sheet(isPresented: $showingEditUsername) {
                        EditUsernameView(username: $username)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    // Load the ideal body image
    func loadIdealBodyImage() {
        guard let inputImage = inputImage else { return }
        idealBodyImage = inputImage
    }
}

// MARK: - EditUsernameView
struct EditUsernameView: View {
    @Binding var username: String
    @Environment(\.presentationMode) var presentationMode
    @State private var tempUsername: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Color
                Color.gymMaxBackground.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Edit Username")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    TextField("Enter new username", text: $tempUsername)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    Button(action: {
                        if !tempUsername.isEmpty {
                            username = tempUsername
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.gymMaxPrimary, Color.gymMaxSecondary]),
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Supporting Views and Models

// Placeholder Image View
struct PlaceholderImageView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 200, height: 200)
            
            Image(systemName: "camera.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.white)
        }
        .shadow(radius: 10)
        .transition(.scale)
    }
}

// ButtonView Component
struct ButtonView: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
            Text(title)
                .font(.headline)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.gymMaxPrimary, Color.gymMaxSecondary]),
                           startPoint: .leading,
                           endPoint: .trailing)
        )
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

// WorkoutCardView Component
struct WorkoutCardView: View {
    let workoutDay: WorkoutDay
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(workoutDay.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(workoutDay.focus)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.gymMaxPrimary)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
}

// BodyAnalysisView Component
struct BodyAnalysisView: View {
    let analysis: BodyAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Body Analysis")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            HStack {
                Text("Muscle Mass:")
                    .fontWeight(.semibold)
                Spacer()
                Text(analysis.muscleMass)
                    .foregroundColor(.green)
            }
            
            HStack {
                Text("Body Fat:")
                    .fontWeight(.semibold)
                Spacer()
                Text(analysis.bodyFat)
                    .foregroundColor(.red)
            }
            
            HStack {
                Text("BMI:")
                    .fontWeight(.semibold)
                Spacer()
                Text(analysis.bmi)
                    .foregroundColor(.blue)
            }
            
            Text("Suggestions:")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.top, 10)
            
            ForEach(analysis.suggestions, id: \.self) { suggestion in
                HStack(alignment: .top) {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text(suggestion)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        .padding()
        .background(Color.gymMaxCardBackground)
        .cornerRadius(20)
    }
}

// ProgressPhotoDetailView Component
struct ProgressPhotoDetailView: View {
    let photo: ProgressPhoto
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack {
                Image(uiImage: photo.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(25)
                    .shadow(radius: 10)
                    .padding()
                
                Text("Date: \(formattedDate(photo.date))")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Spacer()
                
                Button(action: {
                    // Implement photo deletion
                }) {
                    Text("Delete Photo")
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(15)
                }
                .padding(.horizontal)
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark) // Preview in dark mode
    }
}

// MARK: - ImagePicker using PHPickerViewController
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    DispatchQueue.main.async {
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

struct WorkoutDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let workout: WorkoutDay
    @State private var selectedExercise: Exercise?
    @State private var showingExerciseDetail = false
    @State private var workoutProgress: Double = 0.0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Workout Header
                    VStack(spacing: 10) {
                        Text(workout.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gymMaxText)
                        
                        Text(workout.focus)
                            .font(.headline)
                            .foregroundColor(.gymMaxSecondary)
                        
                        // Progress Circle
                        ZStack {
                            Circle()
                                .stroke(Color.gymMaxCardBackground, lineWidth: 15)
                                .frame(width: 100, height: 100)
                            
                            Circle()
                                .trim(from: 0, to: workoutProgress)
                                .stroke(Color.gymMaxAccent, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                .frame(width: 100, height: 100)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: workoutProgress)
                            
                            Text("\(Int(workoutProgress * 100))%")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.gymMaxText)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color.gymMaxCardBackground)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Exercises List
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Exercises")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.gymMaxText)
                            .padding(.horizontal)
                        
                        ForEach(workout.exercises) { exercise in
                            Button(action: {
                                selectedExercise = exercise
                                showingExerciseDetail = true
                            }) {
                                ExerciseRow(exercise: exercise)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(Color.gymMaxBackground)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gymMaxText)
                        .font(.title2)
                }
            )
        }
        .sheet(isPresented: $showingExerciseDetail) {
            if let exercise = selectedExercise {
                ExerciseDetailView(exercise: exercise)
            }
        }
        .onAppear {
            // Simulate progress loading
            withAnimation(.easeInOut(duration: 1.0)) {
                workoutProgress = 0.3 // Example progress
            }
        }
    }
}

struct ExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(.gymMaxText)
                
                Text("\(exercise.sets) sets • \(exercise.reps)")
                    .font(.subheadline)
                    .foregroundColor(.gymMaxSubtext)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gymMaxAccent)
        }
        .padding()
        .background(Color.gymMaxCardBackground)
        .cornerRadius(15)
    }
}

struct ExerciseDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let exercise: Exercise
    @State private var currentSet = 1
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Exercise Header
                    VStack(spacing: 10) {
                        Text(exercise.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.gymMaxText)
                        
                        Text("Set \(currentSet) of \(exercise.sets)")
                            .font(.title3)
                            .foregroundColor(.gymMaxSecondary)
                    }
                    .padding()
                    
                    // Exercise Details
                    VStack(alignment: .leading, spacing: 20) {
                        DetailItem(title: "Reps", value: exercise.reps)
                        DetailItem(title: "Notes", value: exercise.notes)
                    }
                    .padding()
                    .background(Color.gymMaxCardBackground)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    // Set Controls
                    HStack(spacing: 30) {
                        Button(action: {
                            if currentSet > 1 {
                                currentSet -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.title)
                                .foregroundColor(currentSet > 1 ? .gymMaxSecondary : .gray)
                        }
                        
                        Button(action: {
                            if currentSet < exercise.sets {
                                currentSet += 1
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(currentSet < exercise.sets ? .gymMaxAccent : .gray)
                        }
                    }
                    .padding()
                }
                .padding(.vertical)
            }
            .background(Color.gymMaxBackground)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gymMaxText)
                        .font(.title2)
                }
            )
        }
    }
}

struct DetailItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gymMaxSubtext)
            
            Text(value)
                .font(.body)
                .foregroundColor(.gymMaxText)
        }
    }
}
