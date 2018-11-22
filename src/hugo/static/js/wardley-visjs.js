
function render(options) {
    console.log('running render')
    data = { nodes:nodes , edges: edges},
    window.network = new vis.Network(container, data, options);
    setup_lines_drawing()
}

setup_lines_drawing = function() {
    network.on("afterDrawing", function (ctx) {
        window.ctx = ctx
        split = window.split_value  ? window.split_value : 6 //3.7
        x = ctx.canvas.width /  split
        ctx.strokeStyle = '#294475';
        ctx.beginPath();
        ctx.moveTo(x,-800);
        ctx.lineTo(x,800);
        ctx.stroke();

        ctx.strokeStyle = '#294475';
        ctx.beginPath();
        ctx.moveTo(x*2,-800);
        ctx.lineTo(x*2,800);
        ctx.stroke();

        ctx.strokeStyle = '#294475';
        ctx.beginPath();
        ctx.moveTo(x*3,-800);
        ctx.lineTo(x*3,800);
        ctx.stroke();
    });
}
