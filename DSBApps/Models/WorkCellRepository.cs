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
    public class WorkCellRepository : IWorkCell
    {
        ProdTimerEntities entities = null;

        public WorkCellRepository( ProdTimerEntities entities )
        {
            this.entities = entities;
        }

        public List<WorkCell> GetAllWorkCells()
        {
            return entities.WorkCells.ToList();
        }

    }
}