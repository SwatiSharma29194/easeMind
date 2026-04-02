
import UIKit

class RandomImageSlidePuzzleViewController: UIViewController {

    private let gridSize = 3
    private var tileSize: CGFloat = 0
    private var tiles: [[UIButton?]] = []
    private var emptyPosition: (row: Int, col: Int)!

    private let possibleImages = ["collage1", "collage2", "collage3"]
    private var puzzleImageName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemMint.withAlphaComponent(0.15)
        puzzleImageName = possibleImages.randomElement()
        setupPuzzle()
        shufflePuzzle()
    }

    private func setupPuzzle() {
        let padding: CGFloat = 20
        let spacing: CGFloat = 5
        tileSize = (view.frame.width - padding*2 - CGFloat(gridSize-1)*spacing)/CGFloat(gridSize)
        tiles = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)

        guard let puzzleImage = UIImage(named: puzzleImageName) else { return }
        let imageSlices = sliceImage(image: puzzleImage, rows: gridSize, cols: gridSize)

        let totalWidth = CGFloat(gridSize) * tileSize + CGFloat(gridSize-1)*spacing
        let startX = (view.frame.width - totalWidth)/2
        let startY: CGFloat = 150

        var sliceIndex = 0
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let frame = CGRect(
                    x: startX + CGFloat(col)*(tileSize+spacing),
                    y: startY + CGFloat(row)*(tileSize+spacing),
                    width: tileSize,
                    height: tileSize
                )

                if row == gridSize-1 && col == gridSize-1 {
                    // Empty tile (hidden)
                    emptyPosition = (row, col)
                    continue
                }

                let button = UIButton(frame: frame)
                button.setBackgroundImage(imageSlices[sliceIndex], for: .normal)
                sliceIndex += 1
                button.layer.cornerRadius = 8
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.white.cgColor
                button.clipsToBounds = true
                button.tag = row*gridSize + col
                button.addTarget(self, action: #selector(tileTapped(_:)), for: .touchUpInside)

                view.addSubview(button)
                tiles[row][col] = button
            }
        }
    }

    @objc private func tileTapped(_ sender: UIButton) {
        guard let pos = positionOfTile(sender) else { return }
        if isAdjacentToEmpty(pos) {
            moveTile(from: pos, to: emptyPosition)
            if isSolved() {
                showCompletionAnimation()
                showCompletionAlert()
            }
        }
    }

    private func positionOfTile(_ tile: UIButton) -> (row: Int, col: Int)? {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if tiles[row][col] == tile { return (row, col) }
            }
        }
        return nil
    }

    private func isAdjacentToEmpty(_ pos: (row: Int, col: Int)) -> Bool {
        let dr = abs(pos.row - emptyPosition.row)
        let dc = abs(pos.col - emptyPosition.col)
        return (dr == 1 && dc == 0) || (dr == 0 && dc == 1)
    }

    private func moveTile(from: (row: Int, col: Int), to: (row: Int, col: Int)) {
        guard let tile = tiles[from.row][from.col] else { return }

        let spacing: CGFloat = 5
        let totalWidth = CGFloat(gridSize) * tileSize + CGFloat(gridSize-1)*spacing
        let startX = (view.frame.width - totalWidth)/2
        let startY: CGFloat = 150

        let newX = startX + CGFloat(to.col)*(tileSize+spacing)
        let newY = startY + CGFloat(to.row)*(tileSize+spacing)

        UIView.animate(withDuration: 0.2) {
            tile.frame.origin = CGPoint(x: newX, y: newY)
        }

        // Swap tiles in array
        tiles[to.row][to.col] = tile
        tiles[from.row][from.col] = nil

        // Update empty position to the tile's previous location
        emptyPosition = from
    }

    private func shufflePuzzle() {
        let moves = 50
        for _ in 0..<moves {
            let neighbors = adjacentPositions(to: emptyPosition)
            if let random = neighbors.randomElement() {
                moveTile(from: random, to: emptyPosition)
            }
        }
    }

    private func adjacentPositions(to pos: (row: Int, col: Int)) -> [(row: Int, col: Int)] {
        var positions: [(Int, Int)] = []
        if pos.row > 0 { positions.append((pos.row-1, pos.col)) }
        if pos.row < gridSize-1 { positions.append((pos.row+1, pos.col)) }
        if pos.col > 0 { positions.append((pos.row, pos.col-1)) }
        if pos.col < gridSize-1 { positions.append((pos.row, pos.col+1)) }
        return positions
    }

    private func isSolved() -> Bool {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                if row == gridSize-1 && col == gridSize-1 { continue }
                guard let tile = tiles[row][col] else { return false }
                if tile.tag != row*gridSize + col { return false }
            }
        }
        return true
    }

    private func showCompletionAnimation() {
        guard let puzzleImage = UIImage(named: puzzleImageName) else { return }

        let spacing: CGFloat = 5
        let totalWidth = CGFloat(gridSize) * tileSize + CGFloat(gridSize-1)*spacing
        let startX = (view.frame.width - totalWidth)/2
        let startY: CGFloat = 150

        let fullImageView = UIImageView(frame: CGRect(
            x: startX,
            y: startY,
            width: tileSize*CGFloat(gridSize) + spacing*CGFloat(gridSize-1),
            height: tileSize*CGFloat(gridSize) + spacing*CGFloat(gridSize-1)
        ))
        fullImageView.image = puzzleImage
        fullImageView.contentMode = .scaleAspectFill
        fullImageView.layer.cornerRadius = 8
        fullImageView.clipsToBounds = true
        fullImageView.alpha = 0
        view.addSubview(fullImageView)

        UIView.animate(withDuration: 0.5) {
            fullImageView.alpha = 1
        }
    }

    private func showCompletionAlert() {
        let alert = UIAlertController(title: "Well Done ",
                                      message: "You completed the puzzle!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Play Again", style: .default, handler: { _ in
            self.puzzleImageName = self.possibleImages.randomElement()
            self.resetPuzzle()
        }))
        alert.addAction(UIAlertAction(title: "Done", style: .cancel))
        present(alert, animated: true)
    }

    private func resetPuzzle() {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                tiles[row][col]?.removeFromSuperview()
            }
        }
        setupPuzzle()
        shufflePuzzle()
    }

    private func sliceImage(image: UIImage, rows: Int, cols: Int) -> [UIImage] {
        var slices: [UIImage] = []
        let imgWidth = image.size.width / CGFloat(cols)
        let imgHeight = image.size.height / CGFloat(rows)
        let scale = image.scale

        for row in 0..<rows {
            for col in 0..<cols {
                // Skip last tile (empty)
                if row == rows-1 && col == cols-1 { continue }
                let rect = CGRect(x: CGFloat(col)*imgWidth*scale,
                                  y: CGFloat(row)*imgHeight*scale,
                                  width: imgWidth*scale,
                                  height: imgHeight*scale)
                if let cgImage = image.cgImage?.cropping(to: rect) {
                    slices.append(UIImage(cgImage: cgImage, scale: scale, orientation: image.imageOrientation))
                }
            }
        }
        return slices
    }

    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
