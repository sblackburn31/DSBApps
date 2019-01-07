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
    public class ProdTmrDataRepository : IDisposable
    {
        private ProdTimerEntities entities = null;

        public ProdTmrDataRepository()
        {
            entities = new ProdTimerEntities(); 
            WorkCellRepository = new WorkCellRepository(entities);
            ProductionOrder = new ProductionOrderRepository(entities);
        }


        // This is used by test programs to emulate the database
        public ProdTmrDataRepository(IProductionOrder po, IWorkCell wc)
        {
            ProductionOrder = po;
            WorkCellRepository = wc;
        }

        public IWorkCell WorkCellRepository 
        {
            get;
            private set;
        }

        public IProductionOrder ProductionOrder
        {
            get;
            private set;
        }

        #region IDisposable Members

        public void Dispose()
        {
            Dispose(true);

            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing == true)
            {
                entities = null;
            }
        }

        ~ProdTmrDataRepository()
        {
            Dispose(false);
        }

        #endregion
    }

}