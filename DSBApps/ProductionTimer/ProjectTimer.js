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

function setCookieValue(name, val) {
    var dt = new Date();
    var y = dt.getFullYear();
    y = y + 1;
    dt.setYear(y);
    var datePart = "; expires=" + dt.toGMTString();
    document.cookie = name + "=" + val + datePart;
    extractCookies();
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
        setCookieValue("workCell", "");
    }
    else {
        setCookieValue("workCell", selList.value);
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
        setCookieValue("numEmpl", "");
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
}

function initializeForm() {

    extractCookies();

    initWorkstationId();
    initWorkCells();
    initNumEmpl();
    initProdNum();
    /*window.addEventListener('beforeunload', function (ev) {
        return ev.returnValue = checkProcessing();
    }); */
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
        setCookieValue("numEmpl", numEmpVal);
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

function startIt() {

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


function endIt() {
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

function seedData() {
    sendPostRequest("SeedData", "SeedData", null);
}


function processSeedData() {
    document.getElementById("place2").innerHTML = "Seeddata completed";
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
    var xhr = createXHR();
    var localURL = uri + actionSubPath;
    var pl = JSON.stringify(payLoad);
    document.getElementById("place1").innerHTML = "POST" + " " + localURL + " Payload:" + pl;
    if (xhr) {
        xhr.open("POST", localURL, true);
        xhr.setRequestHeader("Content-type", "application/json");
        xhr.onreadystatechange = function () { handleResponse(xhr, responseOpt); };

        xhr.send(pl);
    }
}


function sendPostRequest2(actionSubPath, responseOpt) {
    var xhr = createXHR();
    var localURL = uri + actionSubPath;
    document.getElementById("place1").innerHTML = "POST" + " " + localURL;
    if (xhr) {
        xhr.open("POST", localURL, true);
        xhr.setRequestHeader("Content-type", "application/json");
        xhr.onreadystatechange = function () { handleResponse(xhr, responseOpt); };

        xhr.send(null);
    }
}


function sendGetRequest(getRequest, responseOpt) {
    //var xhr = createXHR();
    xhr = createXHR();
    var localURL = uri + getRequest;
    var testFn = function () { handleResponse(xhr); };
    document.getElementById("place1").innerHTML = localURL;
    document.getElementById("place2").innerHTML = "waiting for response";
    if (xhr) {
        xhr.open("GET", localURL, true);
        xhr.onreadystatechange = function () { handleResponse(xhr, responseOpt); };
        xhr.send(null);
    }
}


function handleResponse(xhr, responseOpt) {
    if (xhr.readyState === 4 && xhr.status === 200) {
        document.getElementById("place2").innerHTML = xhr.responseText;
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
            case "Get":
                processProdOrd(JSON.parse(xhr.responseText));
                break;
            default:
                document.getElementById("place2").innerHTML = xhr.responseText;                
        }
    }
    else {
        document.getElementById("place2").innerHTML = "Ready state = " + xhr.readyState + "   and status = " + xhr.status;
    }
}

function getProdOrder() {
    var ordid = document.getElementById("txtid").value;
    var reqSet = { id: ordid, workstationId: "" };
    // POST reqSet to the web api
    // In the response check for the return status and set error messages as required
    // if OK then process the good return value and set the product information
    sendPostRequest("Get", "GetDebug", reqSet);
}



