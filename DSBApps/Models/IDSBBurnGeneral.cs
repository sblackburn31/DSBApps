/// <project>Production Timer App</project>
/// <Version>1.0.0</Version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// This contains misc interfaces that are not tied to a single application or is not an intergal part of a 
/// particular application.
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSBApps.Models.ViewModels;

namespace DSBApps.Models
{
    public interface IDSBBurnGeneral
    {
        void SeedData();
        void AddTrackingInfo(ReqTrackingInfo trackingData);
    }
}
