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

namespace DSBApps.Models
{
    public interface IWorkCell
    {
        List<WorkCell> GetAllWorkCells();
    }
}
