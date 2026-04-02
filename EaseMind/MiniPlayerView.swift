import UIKit

class MiniPlayerView: UIView {

    private let playPauseButton = UIButton(type: .system)
    private let volumeSlider = UISlider()
    private let trackLabel = UILabel()

    var currentTrack: String? {
        didSet {
            trackLabel.text = currentTrack ?? "No Track"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        // Track Label
        trackLabel.text = "No Track"
        trackLabel.font = UIFont(name: "GreatVibes-Regular", size: 25.0)
        trackLabel.textColor = UIColor.black
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trackLabel)
        
        // Play/Pause Button
        playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playPauseButton.tintColor = .black
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        addSubview(playPauseButton)
        
        // Volume Slider
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 1
        volumeSlider.value = 0.5
        volumeSlider.translatesAutoresizingMaskIntoConstraints = false
        volumeSlider.addTarget(self, action: #selector(volumeChanged(_:)), for: .valueChanged)
        volumeSlider.tintColor = .black
        addSubview(volumeSlider)
        
        // Constraints
        NSLayoutConstraint.activate([
            playPauseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            playPauseButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playPauseButton.widthAnchor.constraint(equalToConstant: 40),
            playPauseButton.heightAnchor.constraint(equalToConstant: 40),
            
            trackLabel.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 12),
            trackLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            volumeSlider.leadingAnchor.constraint(equalTo: trackLabel.trailingAnchor, constant: 12),
            volumeSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            volumeSlider.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc public func playPauseTapped() {
        guard let player = AudioManagerList.shared.player else { return }
        if player.isPlaying {
            AudioManagerList.shared.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            AudioManagerList.shared.resume()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc private func volumeChanged(_ sender: UISlider) {
        AudioManagerList.shared.setVolume(sender.value)
    }
}
