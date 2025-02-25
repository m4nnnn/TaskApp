package com.m4nn.taskproject.service;

import com.m4nn.taskproject.model.Task;
import com.m4nn.taskproject.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    // Récupérer toutes les tâches
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    // Récupérer une tâche par son ID
    public Optional<Task> getTaskById(Long id) {
        return taskRepository.findById(id);
    }

    // Ajouter une nouvelle tâche
    public Task createTask(Task task) {
        return taskRepository.save(task);
    }

    // Modifier une tâche existante
    public Task updateTask(Long id, Task taskDetails) {
        return taskRepository.findById(id).map(task -> {
            task.setTitle(taskDetails.getTitle());
            task.setDescription(taskDetails.getDescription());
            task.setCompleted(taskDetails.isCompleted());
            return taskRepository.save(task);
        }).orElse(null);
    }

    // Supprimer une tâche
    public void deleteTask(Long id) {
        taskRepository.deleteById(id);
    }
}
