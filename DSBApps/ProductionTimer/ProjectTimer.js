/***********************
 * This is the Project Timer JavaScript source file
 * Cookies used:
 *     selWorkCell  - use getSelWorkCell and setSelWorkCell to modifiy
 *     selNumEmpl   - use getNumEmpl and setNumEmpl to modify
 * ********************/
var uVar;
var debugging;
debugging = true;

var elapsedTime = 0;
var startTime = new Date();
var theTimer;
var isPaused = false;
var pausedId = "";
var cookieList = {};
var isStarted = false;

function extractCookies() {
    cookieList = {};
    var cra = document.cookie.split(";");
    for (var i = 0, len = cra.length; i < len; i++) {
        var c = cra[i];
        while (c.charAt(0) === " ") {
            c = c.substring(1, c.length);
        }
        var cookiePieces = c.split("=");
        var n = cookiePieces[0];
        var v = cookiePieces[1];
        cookieList[n] = unescape(v);
    }
}

function setCookieValue(name, val, useBasePath) {
    var dt = new Date();
    var y = dt.getFullYear();
    y = y + 1;
    dt.setYear(y);
    var extraPart = "; expires=" + dt.toGMTString() + (useBasePath ? "; path=/" : "");
    document.cookie = name + "=" + val + extraPart;
    extractCookies();
}
function dateToTSString(dt) {
    var h = dt.getHours();
    var m = dt.getMinutes();
    var s = dt.getSeconds() + dt.getMilliseconds() / 1000;
    var ts = (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
    ts = ts.toString().substring(0, 12);
    var y = dt.getFullYear();
    var mm = dt.getMonth() + 1;
    var dd = dt.getDate();
    var tt = y + '-' + (mm < 10 ? "0" + mm : mm) + '-' + (dd < 10 ? "0" + dd : dd) + ' ' + ts;
    return tt;
}

function toUTCTimeString(tmpTime) {
    var s = tmpTime.getSeconds();
    var m = tmpTime.getMinutes();
    var h = tmpTime.getUTCHours();
    var ts = (h < 10 ? "0" + h : h) + ":" + (m < 10 ? "0" + m : m) + ":" + (s < 10 ? "0" + s : s);
    return ts;
}


function initWorkstationId() {
    document.getElementById("lblWorkStationId").innerHTML = "ABCD-EF01-2345-6789";
}

function recievedWorkCells(cellList) {
    /*
     * Reset the option list of work cell select 
     * Look in the cookies for a previous work cell selection and set the selWorkCell to that value if it exists
     */
    var selList = document.getElementById("selWorkCell");
    var selectedValue = cookieList["workCell"];
    var selecdValueIndex = 0;
    if (selList.length < 2 && cellList.length > 0) {
        // add new list
        for (var i = 0; i < cellList.length; i++) {
            var newOption = document.createElement("option");
            newOption.text = cellList[i];
            selList.add(newOption);
            if (cellList[i] === selectedValue) {
                selList.selectedIndex = i + 1;
            }
        }
    }
    selWorkCellChanged();
}

function initWorkCells() {
    /* the list of work cells must be retrieved from the data repository
     * an ajax call is made.  The resulting async function that processes the
     * data will be called RecivedWorkCells(listOfRetrievedWorkCells)
     * */
    /* Call on function to make call to web api to retieve work cells */
    /* the ajax function sets up a reciever function that handles the result */
    sendGetRequest('WorkCells', 'GetWorkCells');
}



function selWorkCellChanged() {
    var selList = document.getElementById("selWorkCell");
    if (selList.selectedIndex === 0) {
        setCookieValue("workCell", "", false);
    }
    else {
        setCookieValue("workCell", selList.value, false);
    }
    if (selList.selectedIndex === 0 && !selList.classList.contains("bg-danger")) {
        selList.classList.add("bg-danger");
    }
    else {
        if (selList.classList.contains("bg-danger")) {
            selList.classList.remove("bg-danger");
        }
    }
    setProdNumAccess();
}



function initNumEmpl() {
    var selectedValue = cookieList["numEmpl"];
    if (selectedValue >= "1" && selectedValue <= "9") {
        setNumEmpl(selectedValue);
    }
    else {
        setNumEmpl("0");
        setCookieValue("numEmpl", "", false);
    }
}


function initProdNum() {
    var v = document.getElementById("txtProductionNumber");
    v.value = "Enter Product #";
    updClassValue(v, "bg-danger", "");
    startButtonStatus(false);
    endButtonStatus(false);
    activatePause(2);
    showElapsedTime(false);
    document.getElementById("selWorkCell").removeAttribute("disabled");
    setProdNumAccess();
    document.getElementById("PartNumber").innerHTML = "";
    document.getElementById("PartDescription").innerHTML = "";
    document.getElementById("BuildQuantity").innerHTML = "";
    document.getElementById("lblStdAsyTime").innerHTML = "";
    document.getElementById("lblStandardTime").innerHTML = "";
}

function initializeForm() {

    extractCookies();
    trackIt("ProductionTimer");
    initWorkstationId();
    initWorkCells();
    initNumEmpl();
    initProdNum();
}

function initializeAbout() {

    extractCookies();
    trackIt("TimerAbout");

}


function initializeContact() {

    extractCookies();
    trackIt("TimerContact");
}

function setProdNumAccess() {
    var selectedValue = cookieList["numEmpl"];
    if (selectedValue >= "1" && selectedValue <= "9"
        && document.getElementById("selWorkCell").selectedIndex > 0) {
        document.getElementById("txtProductionNumber").removeAttribute("disabled");
        document.getElementById("lblProdNumberError").style.visibility = "hidden";
    }
    else {
        document.getElementById("txtProductionNumber").setAttribute("disabled", "");
        setErrMsg("Set Work Cell & Employee #");
    }

}


function debugMsg(msg) {
    if (debugging) {
        document.getElementById("DebugMsg").innerHTML = msg;
    }
}

function validProdNum(val) {
    var p = /^[0-9]+$/;
    return p.test(val);
}

function setErrMsg(msg) {
    var errMsg = document.getElementById("lblProdNumberError");
    errMsg.innerHTML = msg;
    errMsg.style.visibility = "visible";

}

function setProdInfo(prodInfo) {
    // process data returned by call to web api
    document.getElementById("PartNumber").innerHTML = prodInfo.ProductNumber;
    document.getElementById("PartDescription").innerHTML = prodInfo.Description;
    document.getElementById("BuildQuantity").innerHTML = prodInfo.Quantity;
    var x;
    x = Math.ceil(prodInfo.StadardAsyTime / 60000) * prodInfo.Quantity;
    document.getElementById("lblStdAsyTime").innerHTML = x;
    document.getElementById("lblStandardTime").innerHTML = "Standard Assembly Time(Minutes)";
}


function getProdInfo(prodNumber) {
    // make ajax call to web api to retrieve data for prodNumber
    // set recieved data to process the returned data

}

function  recievedProductionNumber(setResponse){
    /* 
     * Enable StartTime Button
     * Remove the Red color of the enter production number
     * Disable the End Button
     * Disable the during pauses
     * enable between pauses.
     * Process return value from AJAX CE
     * */
    if (setResponse.ReturnStatus !== 1) // Return Status != OK i.e. not valid return
    {
        setErrMsg(setResponse.StatusText);
        return;
    }
    else // Return status is OK
    {
        var v = document.getElementById("txtProductionNumber");
        if (v.classList.contains("bg-danger")) {
            v.classList.remove("bg-danger");
        }
        startButtonStatus(true);
        setProdInfo(setResponse);
    }
}

function prodNumEntered() {
    var v = document.getElementById("txtProductionNumber");
    errMsg = document.getElementById("lblProdNumberError").style.visibility = "hidden";
    if (!validProdNum(v.value)) {
        setErrMsg("Enter only numbers!");
        return false;
    }
    else {
        // see if the production number exist
        // if it does then retrieve the production information via an AJAX
        // for now its valid if the number is not 0
        var ws = document.getElementById("lblWorkStationId").innerHTML;
        var reqSet = { id: v.value, workstationId: ws };
        // POST reqSet to the web api
        // In the response check for the return status and set error messages as required
        // if OK then process the good return value and set the product information
        sendPostRequest("Set", "Set", reqSet);
        return true;
    }
}


function processClear(res) {
    if (res.ReturnStatus !== 1) {
        setErrMsg(res.StatusText);
    }
    else {
        initProdNum();
    }
}

function clearProdNum() {
    var ws = document.getElementById("lblWorkStationId").innerHTML;
    var i = document.getElementById("txtProductionNumber").value;
    var reqClear = { id: i, workstationId: ws };
    sendPostRequest("Clear", "Clear", reqClear);
}


function prodNumGotFocus() {
    var v = document.getElementById("txtProductionNumber");
    if (v.value === "Enter Product #") {
        v.value = "";
    }
}

function updClassValue(obj, newValue, oldValue) {
    if (oldValue.length > 0) {
        if (obj.classList.contains(oldValue)) {
            obj.classList.remove(oldValue);
        }
    }
    if (newValue.length > 0) {
        if (!obj.classList.contains(newValue)) {
            obj.classList.add(newValue);
        }
    }
}

function startButtonStatus(isActive) {
    var obj = document.getElementById("btnStart");
    if (isActive) {
        updClassValue(obj, "btn-success", "");
        obj.removeAttribute("disabled");
    }
    else {

        updClassValue(obj, "", "btn-success");
        obj.setAttribute("disabled", "");
    }
}

function endButtonStatus(isActive) {
    var obj = document.getElementById("btnEnd");
    if (isActive) {
        updClassValue(obj, "btn-warning", "");
        obj.removeAttribute("disabled");
    }
    else {

        updClassValue(obj, "", "btn-warning");
        obj.setAttribute("disabled", "");
    }
}

function setNumEmpl(numEmpVal) {
    var obj = document.getElementById("tblNumEmplId");
    if (numEmpVal !== "0") {
        setCookieValue("numEmpl", numEmpVal, false);
        /* change the button's color */
        updClassValue(obj, "", "bg-danger");
        var btnLst = document.getElementsByClassName("btnNumEmp");
        for (i = 0; i < 9; i++) {
            if (btnLst[i].name !== "btnNumEmpl" + numEmpVal) {
                updClassValue(btnLst[i], "", "btn-secondary");
            }
            else {
                updClassValue(btnLst[i], "btn-secondary", "");
            }
        }
    }
    else {
        updClassValue(obj, "bg-danger", "");
        var allBtnLst = document.getElementsByClassName("btnNumEmp");
        for (i = 0; i < 9; i++) {
            updClassValue(allBtnLst[i], "", "btn-secondary");
        }
    }
    setProdNumAccess();
}


function processPauseStart(res) {
    if (res.ReturnStatus !== 1) {
        setErrMsg(res.StatusText);
    }
}

function processPauseEnd(res) {
    if (res.ReturnStatus !== 1) {
        setErrMsg(res.StatusText);
    }
}

function processPauseLink(res) {
    if (res.ReturnStatus !== 1) {
        setErrMsg(res.StatusText);
    }
    else {
        pauseStart(pausedId, isStarted);
    }
}

function pauseStart(reason, isDuringProd) {
    var i = isDuringProd ? document.getElementById("txtProductionNumber").value : 0;
    var startOfTime = new Date();
    var sps = startOfTime.toUTCString();
    var ws = document.getElementById("lblWorkStationId").innerHTML;
    var reqStartPause = { id: i, StartPauseString: sps, Reason: convertReasonId(reason), WorkstationId: ws };
    sendPostRequest("PauseStart", "PauseStart", reqStartPause);
}


function pauseEnd(isDuringProd, isLinked) {
    var i = isDuringProd ? document.getElementById("txtProductionNumber").value : 0;
    var endOfTime = new Date();
    var eps = endOfTime.toUTCString();
    var ws = document.getElementById("lblWorkStationId").innerHTML;
    var reqEndPause = { id: i, EndPauseString: eps, WorkstationId: ws };
    sendPostRequest("PauseEnd", (isLinked ? "PauseLink" : "PauseEnd"), reqEndPause);
}


function setPause(newReasonId, duringProdOrd) {
    // * save stop/start of pause
    // toggle selected pause button to warning or info
    // stop/start the timer
    var curPauseBtn;
    if (newReasonId === pausedId) {
        var objPauseBtn = document.getElementById(newReasonId);
        updClassValue(objPauseBtn, "btn-primary", "btn-warning");
        isPaused = false;
        pausedId = "";
        pauseEnd(duringProdOrd, false);
    }
    else {
        if (pausedId.length > 0)
        {
            var prevPauseBtn = document.getElementById(pausedId);
            updClassValue(prevPauseBtn, "btn-primary", "btn-warning");

            curPauseBtn = document.getElementById(newReasonId);
            updClassValue(curPauseBtn, "btn-warning", "btn-primary");
            isPaused = true;
            pausedId = newReasonId;
            pauseEnd(duringProdOrd, true); 
        }
        else
        {
            curPauseBtn = document.getElementById(newReasonId);
            isPaused = true;
            updClassValue(curPauseBtn, "btn-warning", "btn-primary");
            pausedId = newReasonId;
            pauseStart(newReasonId, duringProdOrd);
        }
    }
}

function activatePause(pauseGroup) {
    /*
     * activated pause group, enable the pause buttons
     * set group area to white
     * deactivate other pause group buttons
     * set other pause group area to gray
     * */
    var objGrp;
    var areaObj;
    var i;
    if (pauseGroup === 1) {
        areaObj = document.getElementById("divDuringDowntime");
        updClassValue(areaObj, "bg-light","bg-secondary");
        areaObj = document.getElementById("divBetweenDowntime");
        updClassValue(areaObj, "bg-secondary", "bg-light");
        objGrp = document.getElementsByClassName("psDuring");
        for (i = 0; i < objGrp.length; i++) {
            objGrp[i].removeAttribute("disabled");
        }
        objGrp = document.getElementsByClassName("psBetween");
        for (i = 0; i < objGrp.length; i++) {
            objGrp[i].setAttribute("disabled","");
        }
    }
    else {
        areaObj = document.getElementById("divBetweenDowntime");
        updClassValue(areaObj, "bg-light", "bg-secondary");
        areaObj = document.getElementById("divDuringDowntime");
        updClassValue(areaObj, "bg-secondary", "bg-light");
        objGrp = document.getElementsByClassName("psBetween");
        for (i = 0; i < objGrp.length; i++) {
            objGrp[i].removeAttribute("disabled");
        }
        objGrp = document.getElementsByClassName("psDuring");
        for (i = 0; i < objGrp.length; i++) {
            objGrp[i].setAttribute("disabled", "");
        }

    }
}


function processStart(res) {
    if (res.ReturnStatus !== 1) {
        setErrMsg(res.StatusText);
    }
    else
    {
        showElapsedTime(true);
        endButtonStatus(true);
        document.getElementById("btnClear").setAttribute("disabled", "");
        document.getElementById("txtProductionNumber").setAttribute("disabled", "");
        activatePause(1);
        startButtonStatus(false);

    }
}


function convertReasonId(reasonId) {
    var reasonString = document.getElementById(reasonId).value;
    return reasonString;
}

function startTimer() {

    // start the elapsed timer
    // ** save the start time
    // show the elapse time *
    // dsiable the start button *
    // disable the work cell selection
    // enable the end button *
    // switch pa
    //use button group to while processing group
    if (isPaused) {
        setPause(pausedId, false);
    }
    startTime = new Date();
    elapsedTime = 0;
    theTimer = setInterval(updateElapsedTime, 1000);
    var reqStart = {
        id: document.getElementById("txtProductionNumber").value,
        startTimeString: startTime.toUTCString(),
        workCell: cookieList["workCell"],
        numEmployee: cookieList["numEmpl"]
    };
    isStarted = true;
    sendPostRequest("StartTimer", "StartTimer", reqStart);
}

function processEnd(res) {
    if (res.ReturnStatus !== 1) {
        setErrMsg(res.StatusText);
    }
}

function checkProcessing() {
    if (isStarted) {
        /*if (isPaused) {
            setPause(pausedId, true);
        }*/
        var endOfTime = new Date();
        var reqEnd = {
            id: document.getElementById("txtProductionNumber").value,
            endTimeString: endOfTime.toUTCString(),
            workCell: cookieList["workCell"],
            numEmployee: cookieList["numEmpl"]
        };
        sendPostRequest("EndTimer", "EndTimer", reqEnd);
        isStarted = false;
    }
    return true;
}


function endTimer() {
    // **set end time
    // **save elapsed time and end time
    // initialize prod num
    if (isPaused) {
        setPause(pausedId, true);
    }
    var endOfTime = new Date();
    var reqEnd = {
        id: document.getElementById("txtProductionNumber").value,
        endTimeString: endOfTime.toUTCString(),
        workCell: cookieList["workCell"],
        numEmployee: cookieList["numEmpl"]
    };
    isStarted = false;
    sendPostRequest("EndTimer", "EndTimer", reqEnd);
    clearInterval(theTimer);
    endButtonStatus(true);
    document.getElementById("btnClear").removeAttribute("disabled");
    document.getElementById("txtProductionNumber").removeAttribute("disabled");
    var tmpTime = new Date(elapsedTime);
    var ts = toUTCTimeString(tmpTime);
    alert("Final elapsed time for the production: " + ts);
    showElapsedTime(false);
    initProdNum();
    elapsedTime = 0;
}


function getProdOrder() {
    var ordid = document.getElementById("txtid").value;
    var reqSet = { id: ordid, workstationId: "" };
    // POST reqSet to the web api
    // In the response check for the return status and set error messages as required
    // if OK then process the good return value and set the product information
    sendPostRequest("Get", "GetDebug", reqSet);
}



function seedData() {
    sendPostRequest("SeedData", "SeedData", null);
}


function processSeedData() {
    //document.getElementById("place2").innerHTML = "Seeddata completed";
}


function showElapsedTime(activate) {
    var lblTmr = document.getElementById("lblElapsedTime");
    if (activate) {
        lblTmr.style.visibility = "visible";
    }
    else {
        lblTmr.style.visibility = "hidden";
    }

}

function updateElapsedTime() {
    if (!isPaused) {
        elapsedTime = elapsedTime + 1000;
        var tmpTime = new Date(elapsedTime);
        var ts = toUTCTimeString(tmpTime);
        document.getElementById("lblElapsedTime").innerHTML = ts;
    }
}


/*************************************************************************************
 * 
 * AJAX Funciton Area
 * 
 **************************************************************************************/

var uri = 'http://www.dsbburn.com/api/ProductionTimer/';
//var uri = 'http://localhost:53915/api/ProductionTimer/';

function createXHR() {
    return new XMLHttpRequest();
}

function sendPostRequest(actionSubPath, responseOpt, payLoad) {
    // Note:
    //  Post calls must : 
    //      have the POST type
    //      include the correct Path
    //      the JSON data load must match the JSON structure used by the Web Api
    // Initialize the XHR
    var xhr = createXHR();
    var localURL = uri + actionSubPath;

    // Prepare the data to be sent to the Web API by stringify the JSON structure
    var pl = JSON.stringify(payLoad);

    // show development information, unused in production
    //document.getElementById("place1").innerHTML = "POST" + " " + localURL + " Payload:" + pl;

    // make the REST Post
    if (xhr) {
        xhr.open("POST", localURL, true);
        xhr.setRequestHeader("Content-type", "application/json");
        xhr.onreadystatechange = function () { handleResponse(xhr, responseOpt); };

        xhr.send(pl);
    }
}


function sendGetRequest(getRequest, responseOpt) {
    // Initialize the XHR() 
    xhr = createXHR();
    var localURL = uri + getRequest;

    // Debug info, unused for production
    //document.getElementById("place1").innerHTML = localURL;
    //document.getElementById("place2").innerHTML = "waiting for response";

    // Make the REST Get call
    if (xhr) {
        xhr.open("GET", localURL, true);
        xhr.onreadystatechange = function () { handleResponse(xhr, responseOpt); };
        xhr.send(null);
    }
}


function handleResponse(xhr, responseOpt) {
    // handle the response from the Web API
    if (xhr.readyState === 4 && xhr.status === 200) {
        // show development info, unused during production
        //document.getElementById("place2").innerHTML = xhr.responseText;

        // based on the request, handle the appriopriate response
        switch (responseOpt) {
            case "GetWorkCells":
                recievedWorkCells(JSON.parse(xhr.responseText));
                break;
            case "Set":
                recievedProductionNumber(JSON.parse(xhr.responseText));
                break;
            case "Clear":
                processClear(JSON.parse(xhr.responseText));
                break;
            case "StartTimer":
                processStart(JSON.parse(xhr.responseText));
                break;
            case "EndTimer":
                processEnd(JSON.parse(xhr.responseText));
                break;
            case "PauseStart":
                processPauseStart(JSON.parse(xhr.responseText));
                break;
            case "PauseEnd":
                processPauseEnd(JSON.parse(xhr.responseText));
                break;
            case "PauseLink":
                processPauseLink(JSON.parse(xhr.responseText));
                break;
            case "SeedData":
                processSeedData();
                break;
            case "Track":
                processTrack();
                break;
            case "Get":
                processProdOrd(JSON.parse(xhr.responseText));
                break;
            default:
                var x = 1;
                //document.getElementById("place2").innerHTML = xhr.responseText;                
        }
    }
    else {
        //document.getElementById("place2").innerHTML = "Ready state = " + xhr.readyState + "   and status = " + xhr.status;
    }
}



/*
 * trackIt
 * This part of the code is used to track the usage of a web page.  For this web page, it is known that the
 * usage will be very low, however, it is still important that the web owener know how often the web page
 * is visited and what they are doing while visiting the web page.
 * 
 * This function takes advantage of the general system's Web Api that has a REST POST function that will
 * store tracking information fed to it.  The tacking system only requires 3 bits of information....
 * Where, What, or the name of the place that is visited.  In other words, the item that is being tracked.
 * Who is visiting.  This is some type of unique identifier of the user.  This does not have to be the
 * same id used on multiple visits, but it would be nice.
 * When did the visit take place.
 * 
 * Where is a String value and is passed into the function as the placeName variable.
 * 
 * Who is a generated value.  It defaults to the timestamp of when the trackIt funciton is first called.   Timestamp
 * is used because it uniquly identifies the user, does require too much space, is easily generated.
 * 
 * When is a timestamp of when the trackit function is called.\
 * 
 * In order to prevent over reporting, a particular place is only recorded once every 10 minutes. 
 * 
 * Cookies are used to keep track of the who and the last when values.
 * 
 * */

function trackIt(placeName) {
    // retrieve the When Last used cookie, which is stored as the placeName
    var whenTSCookie = cookieList[placeName];
    // check time is the time that will be compared to the current time to determine if a new tracking information
    // is to be generated and stored.
    var checkTime;

    // see if the cookie has been set
    if (!whenTSCookie) {
        // if it hasn't then set the checkTime value to a value that will force a new tracking record to be created
        whenTSCookie = Date.now(); 
        checkTime = whenTSCookie - 11 * 60 * 1000;
    }
    else {
        // if the cookie does exist, then set the check time to the cookies value plus 10 minutes.
        whenTSCookie = new Date(whenTSCookie);
        checkTime = new Date(whenTSCookie.setMinutes(whenTSCookie.getMinutes() + 10));
    }
    var curTime = new Date();
    // see if the last visited time is less than the current time, if it has been visited within the last 10 minutes
    // then do not continue.
    if (checkTime < curTime) {

        //  see if the WHO cookie has been previously set
        var whoCookie = cookieList["visitName"];
        if (!whoCookie) {
            // if it hasn't then set the WHO value
            whoCookie = createTrackVisitor();
        }

        // save the last visited and the who cookies
        var tsv = curTime.toString();
        setCookieValue(placeName, tsv, false);
        setCookieValue("visitName", whoCookie, true);

        // Set the Tracking information data structure
        var reqTrackingInfo = {
            place: placeName,
            who: whoCookie,
            whenTS: dateToTSString(curTime)
        };
        // Post the tracking information to the REST/Web API
        sendPostRequest("Track", "Track", reqTrackingInfo);
    }

    function processTrack() {
        // Nothing is returned by this call, this function is used only as a a
        //document.getElementById("place2").innerHTML = "Track data set";
    }


    function createTrackVisitor() {
        // This function returns a unique identifier.  Since this is a rarely visited site, 
        // a timestamp is perfect way to unquely identifiy the user.
        // Other values are TCP/IP address, a generated GUID, Computer MAC address, etc
        // The timestamp is a good choice because it does not require extra software, 
        // does not take up too nmuch spacem, and does not invade privicy.
        var dt = new Date();
        return dateToTSString(dt);
    }



}
