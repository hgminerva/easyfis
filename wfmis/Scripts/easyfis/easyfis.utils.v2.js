﻿// Compiled utilities for easyfis.com
// By: Harold Glenn Minerva 

var easyFIS = (function () {
    return {
        // Get URL Parameter Name
        getParameterByName: function (name) {
            name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        },

        // Format Number
        formatNumber: function (num, dec, thou, pnt, curr1, curr2, n1, n2) {
            var x = Math.round(num * Math.pow(10, dec));
            if (x >= 0) n1 = n2 = '';
            var y = ('' + Math.abs(x)).split('');
            var z = y.length - dec;
            if (z < 0) z--;
            for (var i = z; i < 0; i++) y.unshift('0');
            if (z < 0) z = 1; y.splice(z, 0, pnt);
            if (y[0] == pnt) y.unshift('0');
            while (z > 3) {
                z -= 3;
                y.splice(z, 0, thou);
            }
            var r = curr1 + n1 + y.join('') + n2 + curr2;
            return r;
        },

        // Get Table (Jquery.datatables) Data by row and column - By: HGM
        getTableData: function (table, id, columnName) {
            var data = table.dataTable().fnGetData();

            var d = "";
            for (i = 0; i < 10; i++) {
                if (data[i]["Id"] == id) {
                    d = data[i][columnName];
                    break;
                }
            }
            return d;
        },

        // Get Current Date MM/DD/YYYY
        getCurrentDate: function () {
            var currentDate = new Date()
            var day = currentDate.getDate()
            var month = currentDate.getMonth() + 1
            var year = currentDate.getFullYear()

            return month + "/" + day + "/" + year;
        },

        // Return a link from a data
        returnLink: function (data) {
            var n = data.indexOf(")");
            var Link = data.substring(1, n);
            var String = data.substring(n + 1, data.length);
            return '<a href="' + Link + '">' + String + '</a>'
        }
    };
}());