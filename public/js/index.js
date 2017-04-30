var app = angular.module('wheel', []);

app.controller('AppCtrl', function($scope, $http) {

    // pass this from view somehow
    $scope.getOptions = function (url) {
        $scope.baseUri = url;
        $http.get($scope.baseUri + "/options").then(function successCallback(response) {
            $scope.options = response.data;
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
            $scope.options.push(data);
            $scope.name = null;
        }, function errorCallback(response) {
            console.log("Unable to retrieve list of options");
        });
    };

    $scope.chevronDirection = function (show) {
        if (show) return "fa-chevron-up";
        else return "fa-chevron-down";
    };

});

