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
using DSBApps.Models.ViewModels;
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

        public ActionResult About()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("DSBBurnAbout");

            return View();
        }


        public ActionResult Contact()
        {
            const string whoCoookieId = "visitName";
            const string timestampFormat = "yyyy-MM-dd HH:mm:ss.ffff";
            string whoId;

            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("DSBBurnContact");

            ViewBag.Message = "The contact page.";

            HttpCookie whoCookie;
            // this cookie should have been just set, unless the client has shut off cookie usage on their
            // device.
            if (Request.Cookies[whoCoookieId] != null)
            {
                whoCookie = Request.Cookies[whoCoookieId];
                whoId = whoCookie.Value;
            }
            else
            {
                whoId = DateTime.Now.ToString(timestampFormat);
            }

            ReqContactInfo req = new ReqContactInfo();
            req.Who = whoId;
            return View("Contact", req);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Contact([Bind(Include = "Name,Email,Comment,Who,VistorType,Rating")] ReqContactInfo req)
        {
            ContactInformation contactInfo = new ContactInformation();
            contactInfo.addContactInformation(req);

            return RedirectToAction("Index");
        }



        public ActionResult LaunchProjectTimer()
        {
            // Change spot
            return Redirect("http://localhost:53915/ProductionTimer/ProjectTimer.html");
            //return Redirect("http://www.dsbburn.com/ProductionTimer/ProjectTimer.html");
        } 

        public ActionResult Profiles()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("Profiles");

            return View();
        }

        public ActionResult Gallery()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("Gallery");

            return View();
        }

        public ActionResult Documents()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("Documents");

            return View();
        }

        public ActionResult InteractiveResume()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("InteractiveResume");

            return View();
        }

        public FileResult GetResume()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("InteractiveResume");

            string path = AppDomain.CurrentDomain.BaseDirectory + "Documents/";
            string file = path + "ResumeBlackburn.pdf";

            string mimeType = "application/pdf";
            Response.AppendHeader("Content-Disposition", "inline; filename=" + "ResumeBlackburn.pdf");
            return File(file, mimeType);
        }


        public FileResult DownloadResume()
        {
            Tracker tracker = new Tracker(Request, Response);
            tracker.addUsage("DownloadResume");

            string path = AppDomain.CurrentDomain.BaseDirectory + "Documents/";
            byte[] fileBytes = System.IO.File.ReadAllBytes(path + "ResumeBlackburn.pdf");

            string fileName = "ResumeBlackburn.pdf";

            return File(fileBytes, System.Net.Mime.MediaTypeNames.Application.Octet, fileName);
        }




    }
}