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
            DSBBurnGeneral = new DSBBurnGeneralRepository(entities);
        }


        // This is used by test programs to emulate the database
        public ProdTmrDataRepository(IProductionOrder po,
                                        IWorkCell wc,
                                        IDSBBurnGeneral dsbBurn)
        {
            ProductionOrder = po;
            WorkCellRepository = wc;
            DSBBurnGeneral = dsbBurn;
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

        public IDSBBurnGeneral DSBBurnGeneral
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