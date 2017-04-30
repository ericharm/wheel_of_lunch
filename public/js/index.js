var app = angular.module('wheel', []);

app.controller('AppCtrl', function($scope, $http) {

    $scope.wheel = {
        labels: [],
        setLabels: function (options) {
            for (var i = 0; i < options.length; i++) {
                if (options[i].on) {
                    this.labels.push(options[i].name);
                }
            }
        },
        addLabel: function (label) {
            this.labels.push(label);
            this.start();
        },
        removeLabel: function (label) {
            this.labels.splice(this.labels.indexOf(label), 1);
            this.start();
        },
        start: function () {
            function rand(min, max) {
                return Math.random() * (max - min) + min;
            }

            var label = this.labels;
            var color = ['#f00','#0f0','#00f','#f0f','#ff0','#0ff', "#808", "#000",
                        '#f00','#0f0','#00f','#f0f','#ff0','#0ff', "#808", "#000"];

            var slices = label.length;
            var sliceDeg = 360/slices;
            var deg = rand(0, 360);
            var speed = 0;
            var slowDownRand = 0;
            var ctx = canvas.getContext('2d');
            var width = canvas.width; // size
            var center = width/2;      // center
            var isStopped = false;
            var lock = false;

            function deg2rad(deg) {
                return deg * Math.PI/180;
            }

            function drawSlice(deg, color) {
                ctx.beginPath();
                ctx.fillStyle = color;
                ctx.moveTo(center, center);
                ctx.arc(center, center, width/2, deg2rad(deg), deg2rad(deg+sliceDeg));
                ctx.lineTo(center, center);
                ctx.fill();
            }

            function drawText(deg, text) {
                ctx.save();
                ctx.translate(center, center);
                ctx.rotate(deg2rad(deg));
                ctx.textAlign = "center";
                ctx.fillStyle = "#fff";
                ctx.font = 'bold 30px sans-serif';
                ctx.fillText(text, 130, 10);
                ctx.restore();
            }

            function drawImg() {
                ctx.clearRect(0, 0, width, width);
                for(var i=0; i<slices; i++){
                    drawSlice(deg, color[i]);
                    drawText(deg+sliceDeg/2, label[i]);
                    deg += sliceDeg;
                }
            }

            (function anim() {
                deg += speed;
                deg %= 360;

                // Increment speed
                if(!isStopped && speed<3){
                    speed = speed+1 * 0.1;
                }
                // Decrement Speed
                if(isStopped){
                    if(!lock){
                        lock = true;
                        slowDownRand = rand(0.994, 0.998);
                    } 
                    speed = speed>0.2 ? speed*=slowDownRand : 0;
                }
                // Stopped!
                if(lock && !speed){
                    var ai = Math.floor(((360 - deg - 90) % 360) / sliceDeg); // deg 2 Array Index
                    ai = (slices+ai)%slices; // Fix negative index
                    return alert("You got:\n"+ label[ai] ); // Get Array Item from end Degree
                }

                drawImg();
                window.requestAnimationFrame( anim );
            }());

            document.getElementById("spin").addEventListener("mousedown", function(){
                isStopped = true;
            }, false);

        }
    };

    $scope.getOptions = function (url) {
        $scope.baseUri = url;
        $http.get($scope.baseUri + "/options").then(function successCallback(response) {
            $scope.options = response.data;

            for (var i = 0; i < $scope.options.length; i++) {
                $scope.options[i].on = $scope.options[i].default_on;
            }

            $scope.wheel.setLabels($scope.options);
            $scope.wheel.start();
        }, function errorCallback(response) {
            console.log("Unable to retrieve list of options");
        });
    };

    $scope.createOption = function () {
        $http({
            url: $scope.baseUri + "/option",
            method: "POST",
            data: { "name": $scope.name }
        }).then(function successCallback(response) {
            var data = JSON.parse(response.data.data);
            data.on = data.default_on;
            $scope.options.push(data);
            $scope.wheel.addLabel($scope.name);
            $scope.name = null;
        }, function errorCallback(response) {
            console.log("Unable to retrieve list of options");
        });
    };

    $scope.toggleOption = function (option) {
        //option.on = !option.on;
        if (option.on) $scope.wheel.addLabel(option.name);
        else $scope.wheel.removeLabel(option.name);
    };

    $scope.chevronDirection = function (show) {
        if (show) return "fa-chevron-up";
        else return "fa-chevron-down";
    };

});

