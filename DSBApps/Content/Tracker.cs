using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using DSBApps.Models.ViewModels;

namespace DSBApps.Content
{ 
    /// <summary>
    /// Class used to track application usage.  Inserts data into Tracking table.
    /// </summary>
    /// <remarks>
    /// 
    /// 
    /// trackIt
    /// This part of the code is used to track the usage of a web page.For this web page, it is known that the
    /// usage will be very low, however, it is still important that the web owener know how often the web page
    /// is visited and what they are doing while visiting the web page.
    ///  
    /// This function takes advantage of the general system's Web Api that has a REST POST function that will
    /// store tracking information fed to it.  The tacking system only requires 3 bits of information....
    /// Where, What, or the name of the place that is visited.In other words, the item that is being tracked.
    /// Who is visiting.This is some type of unique identifier of the user.  This does not have to be the
    ///  same id used on multiple visits, but it would be nice.
    /// When did the visit take place.
    /// 
    /// Where is a String value and is passed into the function as the placeName variable.
    /// 
    /// Who is a generated value.It defaults to the timestamp of when the trackIt funciton is first called.   Timestamp
    /// is used because it uniquly identifies the user, does require too much space, is easily generated.
    ///  
    /// When is a timestamp of when the trackit function is called.\
    /// 
    ///  In order to prevent over reporting, a particular place is only recorded once every 10 minutes.
    /// 
    /// Cookies are used to keep track of the who and the last when values.
    /// </remarks>
    public class Tracker
    {
        // development value
        //const string baseuri = "'http://localhost:53915/api/ProductionTimer/";

        // Production value
        const string baseuri = "http://www.dsbburn.com/api/ProductionTimer/";

        const string timestampFormat = "yyyy-MM-dd HH:mm:ss.ffff";
        const string whoCoookieId = "visitName";
        HttpRequestBase Request;
        HttpResponseBase Response;
        string placeId;
        string whoId;
        string whenTS;
        HttpClient client = new HttpClient();

        public Tracker(HttpRequestBase req, HttpResponseBase res)
        {
            Request = req;
            Response = res;
        }


        public void addUsage (string appName)
        {
            const double initOffset = -11;
            const double ltOffset = 10;
            DateTime lastTracked;
            DateTime curTime = DateTime.Now;

            HttpCookie lastTrackedCookie;
            if (Request.Cookies[appName] != null)
            {
                lastTrackedCookie = Request.Cookies[appName];
                if (!DateTime.TryParse(lastTrackedCookie.Value, out lastTracked))
                {
                    // the cookie value is not valid then re-initialize the time
                    lastTracked = DateTime.Now.AddMinutes(initOffset);
                }
            }
            else
            {
                // seed the cookie value, this is used to set the expiration date
                lastTracked = DateTime.Now.AddMinutes(initOffset);
                lastTrackedCookie = new HttpCookie(appName, lastTracked.ToString(timestampFormat));
                lastTrackedCookie.Expires = DateTime.Now.AddYears(1);
                Response.Cookies.Add(lastTrackedCookie);
            }
            if (lastTracked.AddMinutes(ltOffset) < curTime)
            {
                HttpCookie whoCookie;
                if (Request.Cookies[whoCoookieId] != null)
                {
                    whoCookie = Request.Cookies[whoCoookieId];
                    whoId = whoCookie.Value;
                }
                else
                {
                    whoId = SetWhoIdentifier();
                    whoCookie = new HttpCookie(whoCoookieId, whoId);
                    whoCookie.Expires = DateTime.Now.AddYears(1);
                    Response.AppendCookie(whoCookie);
                }
                lastTrackedCookie.Value = curTime.ToString(timestampFormat);
                Response.SetCookie(lastTrackedCookie);

                // we now have where, who and when; ready now to store these values
                // set the when cookie first
                whenTS = curTime.ToString(timestampFormat);
                Response.Cookies[appName].Value = whenTS;
                placeId = appName;

                // Set the Requesting structure to the Tracking data
                ReqTrackingInfo trackingInfo = new ReqTrackingInfo();
                trackingInfo.Place = placeId;
                trackingInfo.Who = whoId;
                trackingInfo.WhenTS = whenTS;

                // Make the POST REST call to add tracking data to the database
                WriteDataDirect(trackingInfo);
            }
        }

        string SetWhoIdentifier()
        {
            // This function returns a unique identifier.  Since this is a rarely visited site, 
            // a timestamp is perfect way to unquely identifiy the user.
            // Other values are TCP/IP address, a generated GUID, Computer MAC address, etc
            // The timestamp is a good choice because it does not require extra software, 
            // does not take up too nmuch spacem, and does not invade privicy.
            string whoId = DateTime.Now.ToString(timestampFormat);
            return whoId;
        }

        /// <summary>
        /// POST REST call to Track.  This adds trackingInfo to the Tracking table.
        /// </summary>
        /// <param name="trackingInfo">This is Request data structure that is passed to the Track POST REST call</param>
        void WriteDataDirect(ReqTrackingInfo trackingInfo)
        {
            using (var client = new HttpClient())
            {
                // This is where the Web API is located.
                client.BaseAddress = new Uri(baseuri);

                //HTTP Make the POST REST call, this is equivalate to an AJAX call
                var postTask = client.PostAsJsonAsync<ReqTrackingInfo>("Track", trackingInfo);
                postTask.Wait();

                var result = postTask.Result;
                if (result.IsSuccessStatusCode)
                {
                    // Normally here is where the result is processed
                }
            }
        } 
    }
}