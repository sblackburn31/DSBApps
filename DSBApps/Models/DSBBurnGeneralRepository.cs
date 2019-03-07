/// <project>Production Timer App</project>
/// <Version>1.0.0</Version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// This contains misc interface implentations that are not tied to a single application 
/// or is not an intergal part of a particular application.
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSBApps.Models.ViewModels;

namespace DSBApps.Models
{
    public class DSBBurnGeneralRepository : IDSBBurnGeneral
    {
        ProdTimerEntities entities = null;

        public DSBBurnGeneralRepository(ProdTimerEntities entities)
        {
            this.entities = entities;
        }

        public void SeedData()
        {
            entities.seedProductionData();
        }

        public void AddTrackingInfo(ReqTrackingInfo trackingData)
        {
            entities.addTrackingInfo(trackingData.Place, trackingData.Who, trackingData.WhenTS);
        }
    }
}