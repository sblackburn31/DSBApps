/// <project>Production Timer App</project>
/// <version>1.0.0</version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// This is the Production Timer Web API controller
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using DSBApps.Models;
using DSBApps.Models.ViewModels;

namespace DSBApps.Controllers
{
    public class ProductionTimerController : ApiController
    {
        ProdTmrDataRepository dataRepo = null;

        /// <summary>
        /// This is how the datarepository is injected into the controller object.
        /// </summary>
        public ProductionTimerController()
            : this(new ProdTmrDataRepository())
        {

        }
        public ProductionTimerController(ProdTmrDataRepository dr)
        {
            this.dataRepo = dr;
        }

        // GET api/ProductionTimer/WorkCells
        /// <summary>
        /// Process GET api/ProductionTimer/WorkCells
        /// This call requires no parameter data
        /// It returns List or String that represents the list of work cells available.
        /// </summary>
        [HttpGet]
        [ActionName("WorkCells")]
        public IEnumerable<string> GetWorkCells()
        {
            // Return a list of WorkCells
            List<WorkCell> wcl = dataRepo.WorkCellRepository.GetAllWorkCells();
            List<string> tmp = new List<string>();
            foreach (WorkCell wc in wcl) { tmp.Add(wc.name); };

            return tmp.ToArray();
        }

        // POST api/ProductionTimer/Get
        /// <summary>
        /// Process POST api/ProductionTimer/Get
        /// This call requires that the Production Order Id 
        /// Returns retrieved ProductionOrder object
        /// </summary>
        [HttpPost]
        [ActionName("Get")]
        public ProductionOrder GetProdOrd([FromBody]ReqSet theValue)
        {
            ProductionOrder retVal = dataRepo.ProductionOrder.GetProductionOrder(theValue.Id);
            return retVal;
        }


        // POST api/ProductionTimer/Set
        /// <summary>
        /// The rest of the Post request take a specific Request Object and
        /// return
        /// </summary>
        [HttpPost]
        [ActionName("Set")]
        public ResProductionInfo PostSetProductionNumber([FromBody]ReqSet theValue)
        {
            // Process the post
            ResProductionInfo retVal = dataRepo.ProductionOrder.SetProductionId(theValue);

            return retVal;
        }


        // POST api/ProductionTimer/Clear
        [HttpPost]
        [ActionName("Clear")]
        public ResGeneral PostClearProductionNumber([FromBody]ReqClear theValue)
        {
            // Process the post
            ResGeneral retVal = dataRepo.ProductionOrder.ClearProductionId(theValue);

            return retVal;
        }

        // POST api/ProductionTimer/StartTimer
        [HttpPost]
        [ActionName("StartTimer")]
        public ResGeneral PostStartTimer([FromBody]ReqStart theValue)
        {
            // Process the post
            ResGeneral retVal = dataRepo.ProductionOrder.StartTimer(theValue);

            return retVal;
        }

        // POST api/ProductionTimer/EndTimer
        [HttpPost]
        [ActionName("EndTimer")]
        public ResGeneral PostEndTimer([FromBody] ReqEnd theValue)
        {
            // Process the post
            ResGeneral retVal = dataRepo.ProductionOrder.EndTimer(theValue);

            return retVal;
        }

        // POST api/ProductionTimer/PauseStart
        [HttpPost]
        [ActionName("PauseStart")]
        public ResGeneral PostPauseStart([FromBody]ReqStartPause theValue)
        {
            // Process the post
            ResGeneral retVal = dataRepo.ProductionOrder.PauseStart(theValue);

            return retVal;
        }

        // POST api/ProductionTimer/PauseEnd
        [HttpPost]
        [ActionName("PauseEnd")]
        public ResGeneral PostPauseEnd([FromBody]ReqEndPause theValue)
        {
            // Process the post
            ResGeneral retVal = dataRepo.ProductionOrder.PauseEnd(theValue);

            return retVal;
        }

        // POST api/ProductionTimer/SeedData
        [HttpPost]
        [ActionName("SeedData")]
        public int SeedData()
        {
            dataRepo.DSBBurnGeneral.SeedData();
            return 0;
        }

        // POST api/ProductionTimer/Track
        [HttpPost]
        [ActionName("Track")]
        public int PostAddTrackingInfo([FromBody]ReqTrackingInfo theValue)
        {
            dataRepo.DSBBurnGeneral.AddTrackingInfo(theValue);
            return 0;
        }

    }
}
