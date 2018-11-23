

function render(data,user_options) {
    fix_nodes(data.nodes)
    console.log('running render')
    //data = { nodes:nodes , edges: edges},
    options = default_options()
    window.data    = data
    window.network = new vis.Network(container, data, options);

    setup_lines_drawing()
}
function default_options(){
    return {
        "nodes" : {
                    mass : 3,
                    shape : "dot"   ,
                    size  : 10      ,
                    color:  { "background" : "white" ,'border': 'black'} ,
                    font: { size : 30 }

                    },
        edges: {
                    arrows:'to',
                    smooth:false
                 }
        ,
        physics: {
            //minVelocity: 10,
            stabilization: {
                enabled: true,
                iterations: 1000,
                updateInterval: 10 ,
                onlyDynamicEdges: false,
                fit: true
            }
        },
    }
}

function fix_nodes(nodes) {
    nodes.forEach(function(node) {
        node['fixed'] = { x: true }
        if (node['col'])  node['x'] = node['col'] * 200 -100
        else              node['x'] = 100

        if (node['row'] == 0) { node['y'] = -350; node['fixed'] = true }
        else if (node['row'])  node['y'] = node['row'] * 50
        else              node['y'] = -50

        //console.log (node)
    })
}

setup_lines_drawing = function() {

    // network.on('startStabilizing', function (data) {
    //     console.log('startStabilizing',data)
    // })
    // network.on('stabilizationProgress', function (data) {
    //     console.log('stabilizationProgress',data)
    // })
    // network.on('stabilizationIterationsDone', function (data) {
    //     console.log('stabilizationIterationsDone',data)
    // })
    // network.on('stabilized', function (data) {
    //     console.log('stabilized',data)
    // })



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
