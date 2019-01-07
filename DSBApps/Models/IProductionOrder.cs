/// <project>Production Timer App</project>
/// <Version>1.0.0</Version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DSBApps.Models.ViewModels;

namespace DSBApps.Models
{
    public interface IProductionOrder
    {
        ProductionOrder GetProductionOrder(long id);
        ResProductionInfo SetProductionId(ReqSet setData);
        ResGeneral ClearProductionId(ReqClear clearData);
        ResGeneral StartTimer(ReqStart startData);
        ResGeneral EndTimer(ReqEnd endData);
        ResGeneral PauseStart(ReqStartPause startPauseData);
        ResGeneral PauseEnd(ReqEndPause endPauseData);
        void SeedData();
    }
}
