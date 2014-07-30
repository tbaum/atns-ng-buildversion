module = angular.module 'atns.ng.buildversion', ['build-version', 'atns.ng.messages']

module.config ($httpProvider)->
    $httpProvider.interceptors.push ($q, $rootScope)->
        response: (response)->
            version = response.headers 'X-Application-Version'
            $rootScope.ServerVersion = version if version
            response or $q.when response

module.run ($rootScope, BuildVersion)->
    $rootScope.BuildVersion = BuildVersion

    reload = ->
        window.location.reload true

    $rootScope.showVersionDialog = ->
        $rootScope.confirmDialog 'Veraltete Webversion', 'Ihr Webversion ist veraltet und muss aktualisiert werden. Drücken Sie dazu auf "Neu Laden".', 'Neu Laden', reload

    $rootScope.$watch 'ServerVersion', (serverVersion)->
        return unless serverVersion
        return if BuildVersion.indexOf('dirty') > -1

        if serverVersion isnt BuildVersion and $rootScope.showVersionWarning isnt serverVersion
            $rootScope.showVersionWarning = serverVersion
            do $rootScope.showVersionDialog
