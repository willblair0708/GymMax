import SwiftUI
import PhotosUI

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
                    Image(systemName: "camera.fill")
                    Text("Transform")
                }
                .tag(1)
            
            ProgressViewSection()
                .tabItem {
                    Image(systemName: "photo.on.rectangle")
                    Text("Progress")
                }
                .tag(2)
            
            WorkoutPlanView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Plan")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(4)
        }
        .accentColor(Color.blue) // Updated Accent color for selected tab
    }
}

// MARK: - HomeView
struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Blue Gradient background
                LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // Logo
                    Image(systemName: "figure.strengthtraining.traditional")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .transition(.scale)
                    
                    // App Title
                    Text("GymMax")
                        .font(.system(size: 50, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .transition(.opacity)
                    
                    // Subtitle
                    Text("Transform your body and reach your fitness goals!")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 50)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                        .transition(.opacity)
                    
                    Spacer()
                    
                    // Get Started Button
                    NavigationLink(destination: TransformView()) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .cornerRadius(15)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
                .padding()
                .animation(.easeInOut(duration: 1.0), value: UUID())
            }
            .navigationBarHidden(true)
        }
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
                LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
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
    @State private var showingDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Blue Gradient background
                LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    Text("Your Progress")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    // Add Photo Button
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        ButtonView(title: "Add Progress Photo", icon: "plus.photo.on.rectangle")
                    }
                    .padding()
                    .sheet(isPresented: $showingImagePicker, onDismiss: addProgressPhoto) {
                        ImagePicker(image: $inputImage)
                    }
                    
                    // Progress Photos Grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(progressPhotos.sorted(by: { $0.date > $1.date })) { photo in
                                Image(uiImage: photo.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                    .onTapGesture {
                                        selectedPhoto = photo
                                        showingDetail = true
                                    }
                            }
                        }
                        .padding()
                    }
                }
                .sheet(isPresented: $showingDetail) {
                    if let selectedPhoto = selectedPhoto {
                        ProgressPhotoDetailView(photo: selectedPhoto)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // Add a new progress photo
    func addProgressPhoto() {
        guard let inputImage = inputImage else { return }
        let newPhoto = ProgressPhoto(id: UUID(), image: inputImage, date: Date())
        progressPhotos.append(newPhoto)
    }
}

// MARK: - WorkoutPlanView
struct WorkoutPlanView: View {
    @State private var workoutPlan: [WorkoutDay] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Blue Gradient background
                LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Text("Your Workout Plan")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                        .padding(.top, 20)
                    
                    if isLoading {
                        ProgressView("Generating Plan...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                            .padding()
                    } else if workoutPlan.isEmpty {
                        Text("No Workout Plan Available")
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(workoutPlan) { day in
                                    WorkoutCardView(workoutDay: day)
                                }
                            }
                            .padding()
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .padding()
                    }
                    
                    // Generate Plan Button
                    Button(action: generateWorkoutPlan) {
                        ButtonView(title: "Generate New Plan", icon: "arrow.clockwise.circle")
                    }
                    .padding(.bottom, 20)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    // Generate a personalized workout plan (Simulated AI)
    func generateWorkoutPlan() {
        isLoading = true
        // Simulate AI processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Example of generating a new workout plan
            self.workoutPlan = [
                WorkoutDay(day: "Monday", workout: "Chest and Triceps"),
                WorkoutDay(day: "Tuesday", workout: "Back and Biceps"),
                WorkoutDay(day: "Wednesday", workout: "Legs and Shoulders"),
                WorkoutDay(day: "Thursday", workout: "Core and Cardio"),
                WorkoutDay(day: "Friday", workout: "Full Body Workout"),
                WorkoutDay(day: "Saturday", workout: "Yoga and Flexibility"),
                WorkoutDay(day: "Sunday", workout: "Rest Day")
            ]
            isLoading = false
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
                LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
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
                Color("BlueGradientEnd").ignoresSafeArea()
                
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
                                LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
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
            LinearGradient(gradient: Gradient(colors: [Color("BlueGradientStart"), Color("BlueGradientEnd")]),
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
                Text(workoutDay.day)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(workoutDay.workout)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding(.horizontal)
        .transition(.slide)
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

// WorkoutDay Model
struct WorkoutDay: Identifiable {
    let id = UUID()
    let day: String
    let workout: String
}

// BodyAnalysis Model
struct BodyAnalysis {
    let muscleMass: String
    let bodyFat: String
    let bmi: String
    let suggestions: [String]
}

// ProgressPhoto Model
struct ProgressPhoto: Identifiable {
    let id: UUID
    let image: UIImage
    let date: Date
}

// ImagePicker using PHPickerViewController
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

// MARK: - Color Extension for Hex Colors
extension Color {
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

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark) // Preview in dark mode
    }
}
