//
//  PhotoViewController.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import UIKit
import AVFoundation

class PhotoViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var previewView: PreviewView!
    
    // MARK: Properties
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue") // Communicate with the session and other session objects on this queue.
    private let photoOutput = AVCapturePhotoOutput()
    private var photoData: Data?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up the video preview view.
        previewView.session = session
        
        sessionQueue.async { [weak self] in
            self?.configureSession()
            self?.session.startRunning()
        }
    }
    
    private func configureSession() {
        session.beginConfiguration()
        // Add video input.
        do {
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice!)
            session.addInput(videoDeviceInput)
        }
        catch {
            print("Couldn't create video device input: \(error)")
            session.commitConfiguration()
            return
        }
        // Add photo output.
        session.addOutput(photoOutput)
        session.commitConfiguration()
    }
    
    // MARK: Actions
    @IBAction func captureButtonPressed(_ sender: UIButton) {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.photoOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        }
    }
}

// MARK: - Navigation
extension PhotoViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? PhotoPreviewViewController {
            controller.imageData = photoData
            controller.delegate = self
        }
    }
}

extension PhotoViewController: PhotoPreviewViewControllerDelegate {
    func didConfirmPhoto() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension PhotoViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
        // Flash the screen to signal that the camera took a photo.
        previewView.videoPreviewLayer.opacity = 0
        UIView.animate(withDuration: 0.25) {
            self.previewView.videoPreviewLayer.opacity = 1
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            photoData = photo.fileDataRepresentation()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let photoData = photoData else {
            print("No photo data resource")
            return
        }
        
        performSegue(withIdentifier: "presentPhotoPreview", sender: nil)
    }
}
