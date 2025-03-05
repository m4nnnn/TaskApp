import SwiftUI


struct ContentView: View {
    @State private var taskList: [ToDoTask] = []
    @State private var newTaskTitle: String = ""
    @State private var showAddTaskView: Bool = false

    let sharedDefaults = UserDefaults(suiteName: "group.m4nn.TaskApp1")

    var body: some View {
        VStack {
            List {
                ForEach(taskList.sorted { !$0.completed && $1.completed }) { task in
                    HStack {
                        Text(task.title)
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .strikethrough(task.completed, color: .gray)
                        
                        Spacer()
                        
                        if task.completed {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(task.completed ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onTapGesture {
                        withAnimation {
                            toggleTaskCompletion(task: task)
                        }
                    }
                }
                .onDelete(perform: deleteTask)
            }

            if showAddTaskView {
                HStack {
                    TextField("Titre de la nouvelle tâche", text: $newTaskTitle)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                        
                    Button(action: addTask) {
                        Text("Ajouter")
                            .padding()
                            .background(Color.black.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
                .padding()
            }

            Spacer()

            Button(action: {
                showAddTaskView.toggle()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.1))
            }
            .padding()
        }
        .padding()
        .onAppear(perform: loadTasks)
    }

    func saveTasks() {
        if let encoded = try? JSONEncoder().encode(taskList) {
            sharedDefaults?.set(encoded, forKey: "tasks")
        }
    }

    func loadTasks() {
        if let savedData = sharedDefaults?.data(forKey: "tasks"),
           let decoded = try? JSONDecoder().decode([ToDoTask].self, from: savedData) {
            taskList = decoded
        }
    }

    func addTask() {
        guard !newTaskTitle.isEmpty else { return }
        let newTask = ToDoTask(id: (taskList.last?.id ?? 0) + 1, title: newTaskTitle, completed: false)
        taskList.append(newTask)
        saveTasks()
        newTaskTitle = ""
        showAddTaskView = false
    }

    func toggleTaskCompletion(task: ToDoTask) {
        if let index = taskList.firstIndex(where: { $0.id == task.id }) {
            taskList[index] = ToDoTask(
                id: taskList[index].id,
                title: taskList[index].title,
                completed: !taskList[index].completed // ✅ Modifier en recréant la structure
            )
            saveTasks()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        taskList.remove(atOffsets: offsets)
        saveTasks()
    }
}

#Preview {
    ContentView()
}

