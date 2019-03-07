/// <project>Production Timer App</project>
/// <Version>1.0.0</Version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSBApps.Models;

namespace DSBApps.Models.ViewModels
{
    public enum ResponseStatus
    {
        Unset,
        OK,
        Held,
        Started,
        Completed,
        Invalid,
        Error
    }

    public class ResGeneral
    {
        public ResponseStatus ReturnStatus { get; set; }
        public string StatusText { get; set; }
    }

    public class ResProductionInfo
    {
        public ResponseStatus ReturnStatus { get; set; }
        public string StatusText { get; set; }
        public string ProductNumber { get; set; }
        public string Description { get; set; }
        public int Quantity { get; set; }
        public int StadardAsyTime { get; set; }
    }


}