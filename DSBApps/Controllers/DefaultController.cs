/// <project>Demo App</project>
/// <version>2.0.0</version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// This is the base controller of the Demo Application Page.  It controls the landing page.
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net.Http;
using DSBApps.Models;
using DSBApps.Content;

namespace DSBApps.Controllers
{
    public class DefaultController : Controller
    {
        // GET: Default
        public ActionResult Index()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("DSBburn");

            return View();
        }

        public ActionResult LaunchProjectTimer()
        {
            //return Redirect("http://localhost:53915/ProductionTimer/ProjectTimer.html");
            return Redirect("http://www.dsbburn.com/ProductionTimer/ProjectTimer.html");
        } 
    }
}