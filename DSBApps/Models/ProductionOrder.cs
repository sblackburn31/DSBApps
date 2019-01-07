/// <project>Production Timer App</project>
/// <Version>1.0.0</Version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DSBApps.Models
{
    public enum ProductionOrderProcessStatus
    {
        unset,
        Ready,
        Set,
        Started,
        Completed
    }

    public class ProductionOrder
    {
        public ProductionOrder()
        {
            Pauses = new List<Paused>();
        }

        public long Id { get; set; }
        public ProductionOrderProcessStatus Status { get; set; }
        public String ProductNumber { get; set; }
        public String Description { get; set; }
        public int Quantity { get; set; }
        public string WorkStationId { get; set; }
        public string WorkCell { get; set; }
        public int NumEmployee { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public List<Paused> Pauses { get; set; }
       

    }
}