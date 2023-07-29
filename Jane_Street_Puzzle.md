# Jane Street Grid Puzzle
## Choco Banana

I randomly came across [this puzzle](https://www.janestreet.com/puzzles/current-puzzle/) yesterday, and I got stuck in. So far, I have been unable to solve it.

at first, I thought, "Oh, I could write a script to brute force this." I was wrong. Very wrong. There are $2^{240}$ possible states of the grid. To randomly shade cells, it would take several times the universe's lifespan on a supercomputer to find a solution without first reducing the search space. So, I guess I need to find a more intelligent way to solve the puzzle.

Moving forward, I put together an interactive version of the puzzle to let me play around with grid states and help me think about potential solutions to the problem. Hopefully, I can reduce the search space to something more manageable, or possibly find an analytical solution.

I'll keep this post updated with my ongoing progress on this puzzle. If you have any ideas, or if you find this interactive version of the puzzle helpful, let me know.

## Grid Puzzle Instructions

If we shade a subset of the cells in the above grid, we partition the cells into orthogonally connected regions of shaded and unshaded cells. The goal of this puzzle is to shade the cells so that:

- All regions of shaded cells are rectangular,
- All regions of unshaded cells are not rectangular, and
- All number clues in the grid give the size of the region (shaded or unshaded) that the clue is in.

The answer to this puzzle is the product of the number of unshaded cells in each row {cite}`Jane_Street_Puzzle`

## Puzzle

<div class="app">
    <div id="grid" class="grid"></div>
    <button id="clear">Clear</button>
</div>

- <div id="blackCount">Black cells: 0</div>
- <div id="whiteCount">White cells: 240</div>
- <div id="oddCount">Odd numbers: 0</div>
- <div id="evenCount">Even numbers: 0</div>

<style>
.grid {
    user-select: none;
    color: black;
    display: grid;
    grid-template-columns: repeat(20, 1fr);
    grid-gap: 1px;
    width: 100%;
}

.cell {
    box-sizing: border-box;
    background-color: white;
    border: 1px solid #ddd;
    text-align: center;
    line-height: 1;
    font-size: 1em;
    display: flex;
    align-items: center;
    justify-content: center;
    aspect-ratio: 1 / 1;
}

    .black {
        background-color: black;
        color: white;
    }
    #clear {
        display: block;
        width: 100px;
        height: 30px;
        margin: 20px auto;
        background-color: #579aca;
        border: none;
        color: white;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 16px;
        transition-duration: 0.4s;
        cursor: pointer;
        border-radius: 20px; /* Rounded corners */
    }
    #clear:hover {
    background-color: #4088a6; /* Darker shade of blue when hovered over */
    }
</style>

 <script>
        var isMouseDown = false;
        var newColor = "";
        var blackCount = 0;
        var whiteCount = 240;
        var oddCount = 0;
        var evenCount = 0;

        // Data from the CSV file
        var data = [[6.0,6.0,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,6.0,6.0],
                    [6.0,null,null,null,null,null,null,null,null,8.0,12.0,null,null,null,null,null,null,null,null,6.0],
                    [null,null,null,10.0,10.0,null,null,null,null,null,null,null,null,null,null,12.0,12.0,null,null,null],
                    [null,null,null,10.0,null,null,10.0,10.0,null,null,null,null,11.0,11.0,null,null,4.0,null,null,null],
                    [null,null,null,null,null,null,10.0,null,null,null,null,null,null,11.0,null,null,null,null,null,null],
                    [null,15,null,null,null,null,null,null,null,3.0,4.0,null,null,null,null,null,null,null,3.0,null],
                    [null,3,null,null,null,null,null,null,null,6.0,5.0,null,null,null,null,null,null,null,12.0,null],
                    [null,null,null,null,null,null,9.0,null,null,null,null,null,null,8.0,null,null,null,null,null,null],
                    [null,null,null,15.0,null,null,9.0,9.0,null,null,null,null,8.0,8.0,null,null,8.0,null,null,null],
                    [null,null,null,1.0,9.0,null,null,null,null,null,null,null,null,null,null,1.0,7.0,null,null,null],
                    [4.0,null,null,null,null,null,null,null,null,12.0,8.0,null,null,null,null,null,null,null,null,4.0],
                    [4.0,4.0,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,4.0,4.0]]
for (let i = 0; i < 240; i++) {
    let cell = document.createElement('div');
    cell.className = 'cell';
    let savedState = JSON.parse(localStorage.getItem('gridState'));
    if(savedState && savedState[i] === 'black') {
        cell.classList.add('black');
        blackCount++;
        whiteCount--;
    }
    let row = Math.floor(i / 20);
    let col = i % 20;
    if(data[row][col] !== null) {
        cell.textContent = data[row][col];
        if(data[row][col] % 2 === 0) {
            evenCount++;
        } else {
            oddCount++;
        }
    }
    document.getElementById('grid').appendChild(cell);
}
document.getElementById('oddCount').textContent = "Odd numbers: " + oddCount;
document.getElementById('evenCount').textContent = "Even numbers: " + evenCount;

document.querySelectorAll('.cell').forEach((cell, i) => {
    cell.addEventListener('mousedown', function(e) {
        isMouseDown = true;
        newColor = e.target.classList.contains('black') ? "" : "black";
        cell.classList.toggle('black');
        if(newColor === "black") {
            blackCount++;
            whiteCount--;
        } else {
            blackCount--;
            whiteCount++;
        }
        document.getElementById('blackCount').textContent = "Black cells: " + blackCount;
        document.getElementById('whiteCount').textContent = "White cells: " + whiteCount;
        let state = Array.from(document.querySelectorAll('.cell')).map(cell => cell.classList.contains('black') ? 'black' : 'white');
        localStorage.setItem('gridState', JSON.stringify(state));
    });

    cell.addEventListener('mouseover', function() {
        if(isMouseDown) {
            var wasBlack = cell.classList.contains('black');
            cell.className = 'cell ' + newColor;
            var isBlack = cell.classList.contains('black');
            if(wasBlack != isBlack) {
                if(isBlack) {
                    blackCount++;
                    whiteCount--;
                } else {
                    blackCount--;
                    whiteCount++;
                }
                document.getElementById('blackCount').textContent = "Black cells: " + blackCount;
                document.getElementById('whiteCount').textContent = "White cells: " + whiteCount;
                let state = Array.from(document.querySelectorAll('.cell')).map(cell => cell.classList.contains('black') ? 'black' : 'white');
                localStorage.setItem('gridState', JSON.stringify(state));
            }
        }
    });
    cell.addEventListener('mouseup', function() {
        isMouseDown = false;
    });
});

document.addEventListener('mouseup', function() {
    isMouseDown = false;
});
        document.getElementById('clear').addEventListener('click', function() {
            document.querySelectorAll('.cell').forEach((cell, i) => {
                cell.className = 'cell';
            });

            localStorage.removeItem('gridState');

            blackCount = 0;
            whiteCount = 240;
            document.getElementById('blackCount').textContent = "Black cells: " + blackCount;
            document.getElementById('whiteCount').textContent = "White cells: " + whiteCount;
        });
    </script>


<br> The state of the grid is saved in the browser's local storage, so your progress will be waiting for you when you come back.

```{bibliography}
:style: unsrt
```