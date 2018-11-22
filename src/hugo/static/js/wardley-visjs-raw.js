
// var data = {
//     nodes: new vis.DataSet({}),
//     edges: new vis.DataSet({})
// };

//var options = {}



// function graph(nodes, edges, options)
// {
//     var data = {
//         nodes: new vis.DataSet(nodes),
//         edges: new vis.DataSet(edges)
//     };
//     options = options ? options : {}
//     network.setData(data, options)
// }

function render(options) {
    console.log('running render in raw')
    data = { nodes:nodes , edges: edges},
    window.network = new vis.Network(container, data, options);
    setup_lines_drawing()
    //network.setData({ nodes:nodes , edges: edges}, options)
}

function options_for_map()
{
    width = 800;
    height = 800;
    return {
                //width: width + 'px',
                //height: height + 'px',

                nodes: {
                    shape: 'dot'
                },
                edges: {
                    arrows: { to: {enabled: true}},
                    smooth: { enabled: false}
                },
                physics: false,
                interaction: {
                    dragNodes: false,// do not allow dragging nodes
                    zoomView: false, // do not allow zooming
                    dragView: false  // do not allow dragging
                }
          };
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
