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
    static let gymMaxPrimary = Color(hex: "6C63FF")    // Modern purple
    static let gymMaxSecondary = Color(hex: "FF6B6B")  // Energetic coral
    static let gymMaxAccent = Color(hex: "4ECDC4")     // Fresh mint
    static let gymMaxGradientStart = Color(hex: "6C63FF")
    static let gymMaxGradientEnd = Color(hex: "FF6B6B")
    static let gymMaxBackground = Color(hex: "F8F9FA")
    
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
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            TransformView()
                .tabItem {
                    Image(systemName: "sparkles.rectangle.stack.fill")
                    Text("AI Coach")
                }
                .tag(1)
            
            ProgressViewSection()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Progress")
                }
                .tag(2)
            
            WorkoutPlanView()
                .tabItem {
                    Image(systemName: "figure.run")
                    Text("Workouts")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("You")
                }
                .tag(4)
        }
        .accentColor(Color.gymMaxPrimary)
    }
}

// MARK: - HomeView
struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Hero Section
                    ZStack {
                        LinearGradient(gradient: Gradient(colors: [Color.gymMaxGradientStart, Color.gymMaxGradientEnd]),
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing)
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .padding(.horizontal)
                    
                        VStack(spacing: 15) {
                            Text("💪 Welcome Back!")
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Ready to crush your goals?")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    // Quick Stats
                    HStack(spacing: 15) {
                        StatCard(title: "Streak", value: "5 days", icon: "flame.fill")
                        StatCard(title: "Progress", value: "+2.5 lbs", icon: "chart.line.uptrend.xyaxis")
                    }
                    .padding(.horizontal)
                    
                    // Today's Workout
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Today's Workout")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                WorkoutCard(title: "Upper Body", duration: "45 min", intensity: "Medium")
                                WorkoutCard(title: "Core Focus", duration: "30 min", intensity: "High")
                                WorkoutCard(title: "Cardio Blast", duration: "20 min", intensity: "High")
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // Motivation Quote
                    QuoteCard(quote: "The only bad workout is the one that didn't happen.", author: "Unknown")
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.gymMaxBackground)
            .navigationBarHidden(true)
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
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
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
        .background(Color.white)
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
        .background(Color.white)
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
                            .background(Color.white.opacity(0.1))
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
                            Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
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
        .background(Color.white)
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
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 10)
        }
    }
}

struct PhotoDetailView: View {
    let photo: ProgressPhoto
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Image(uiImage: photo.image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        DetailRow(title: "Date", value: photo.formattedDate)
                        DetailRow(title: "Time", value: photo.formattedTime)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                }
                .padding()
            }
            .background(Color.gymMaxBackground)
            .navigationBarTitle("Photo Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
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
                                .background(Color.white)
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
            .background(Color.white)
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
        .background(Color.white)
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
        .background(Color.white.opacity(0.2))
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
