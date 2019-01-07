﻿/// <project>Production Timer App</project>
/// <Version>1.0.0</Version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DSBApps.Models.ViewModels
{
    public class ReqSet
    {
        public long Id { get; set; }
        public string WorkstationId { get; set; }
    }

    public class ReqClear
    {
        public long Id { get; set; }
        public string WorkstationId { get; set; }
    }

    public class ReqStart
    {
        public long Id { get; set; }
        public string StartTimeString { get; set; }
        public string WorkCell { get; set; }
        public int NumEmployee { get; set; }
    }

    public class ReqEnd
    {
        public long Id { get; set; }
        public string EndTimeString { get; set; }
        public string WorkCell { get; set; }
        public int NumEmployee { get; set; }
    }

    public class ReqStartPause
    {
        public long Id { get; set; }
        public string StartPauseString { get; set; }
        public string Reason { get; set; }
        public string WorkstationId { get; set; }
    }

    public class ReqEndPause
    {
        public long Id { get; set; }
        public string EndPauseString { get; set; }
        public string WorkstationId { get; set; }
    }
}