/// <project>Production Timer App</project>
/// <Version>1.0.0</Version>
/// <author>David Scott Blackburn</author>
/// <summary>
/// </summary>
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DSBApps.Models.ViewModels;

namespace DSBApps.Models
{
    public class ProductionOrderRepository : IProductionOrder
    {
        ProdTimerEntities entities = null;

        public ProductionOrderRepository(ProdTimerEntities entities)
        {
            this.entities = entities;
        }
        #region IProductionOrderRepository
        public ProductionOrder GetProductionOrder(long id)
        {
            ProductionOrder productionOrder = new ProductionOrder();
            var rc = entities.getProductionData(id);
            vProdOrdInfo ord = rc.FirstOrDefault();

            productionOrder.Description = ord.description;
            productionOrder.EndTime = ord.endTime;
            productionOrder.StartTime = ord.startTime;
            productionOrder.Id = ord.productionId;
            productionOrder.NumEmployee = ord.numberEmployees ?? 0;
            productionOrder.ProductNumber = ord.productNumber;
            productionOrder.Quantity = ord.quantity;
            productionOrder.StadardAsyTime = 0;  // public int StadardAsyTime { get; set; }
            productionOrder.Status = (ProductionOrderProcessStatus)Enum.Parse(typeof(ProductionOrderProcessStatus), ord.status);  
            productionOrder.WorkCell = ord.workCell;
            productionOrder.WorkStationId = ord.workstationId;
            return productionOrder;
             
        }

        public ResProductionInfo SetProductionId(ReqSet setData)
        {
            ResProductionInfo retData = new ResProductionInfo();
            var rc = entities.setProductionOrder(setData.Id, setData.WorkstationId);

            setProductionOrder_Result ord = new setProductionOrder_Result();
            ord = rc.FirstOrDefault();
            retData.ReturnStatus = (ResponseStatus)ord.ReturnCode;
            retData.StatusText = ord.ReturnMessage;
            if (retData.ReturnStatus == ResponseStatus.OK)
            {
                retData.Description = ord.Description;
                retData.ProductNumber = ord.ProductNumber;
                retData.Quantity = ord.Quantity;
                retData.StadardAsyTime = ord.StadardAsyTime;
            }
            return retData;
        }


        public ResGeneral ClearProductionId(ReqClear clearData)
        {
            ResGeneral retData = new ResGeneral();
            var rc = entities.clearProductionData(clearData.Id, clearData.WorkstationId);
            clearProductionData_Result tmp = new clearProductionData_Result();
            tmp = rc.FirstOrDefault();
            retData.ReturnStatus = tmp.ReturnCode > (int)ResponseStatus.Error ? ResponseStatus.Error : (ResponseStatus)tmp.ReturnCode;
            retData.StatusText = tmp.ReturnMessage;
            return retData;
        }


        public ResGeneral StartTimer(ReqStart startData)
        {
            ResGeneral retData = new ResGeneral();
            var rc = entities.startProductionTimer(startData.Id, 
                                                    DateTime.Parse(startData.StartTimeString ), 
                                                    startData.WorkCell, 
                                                    startData.NumEmployee);
            startProductionTimer_Result tmp = new startProductionTimer_Result();
            tmp = rc.FirstOrDefault();
            retData.ReturnStatus = tmp.ReturnCode > (int)ResponseStatus.Error ? ResponseStatus.Error : (ResponseStatus)tmp.ReturnCode;
            retData.StatusText = tmp.ReturnMessage;

            return retData;
        }



        public ResGeneral EndTimer(ReqEnd endData)
        {
            ResGeneral retData = new ResGeneral();
            var rc = entities.endProductionTimer(endData.Id,
                                                    DateTime.Parse(endData.EndTimeString), 
                                                    endData.WorkCell, 
                                                    endData.NumEmployee);
            endProductionTimer_Result tmp = new endProductionTimer_Result();
            tmp = rc.FirstOrDefault();
            retData.ReturnStatus = tmp.ReturnCode > (int)ResponseStatus.Error ? ResponseStatus.Error : (ResponseStatus)tmp.ReturnCode;
            retData.StatusText = tmp.ReturnMessage;
            return retData;
        }
        public ResGeneral PauseStart(ReqStartPause startPauseData)
        {
            ResGeneral retData = new ResGeneral();
            var rc = entities.pauseStart(startPauseData.Id, 
                                        DateTime.Parse(startPauseData.StartPauseString), 
                                        startPauseData.Reason,
                                        startPauseData.WorkstationId);
            pauseStart_Result tmp = new pauseStart_Result();
            tmp = rc.FirstOrDefault();
            retData.ReturnStatus = tmp.ReturnCode > (int)ResponseStatus.Error ? ResponseStatus.Error : (ResponseStatus)tmp.ReturnCode;
            retData.StatusText = tmp.ReturnMessage;
            return retData;
        }
        public ResGeneral PauseEnd(ReqEndPause endPauseData)
        {
            ResGeneral retData = new ResGeneral();
            var rc = entities.pauseEnd(endPauseData.Id,
                                        DateTime.Parse(endPauseData.EndPauseString), 
                                        endPauseData.WorkstationId);
            pauseEnd_Result tmp = new pauseEnd_Result();
            tmp = rc.FirstOrDefault();
            retData.ReturnStatus = tmp.ReturnCode > (int)ResponseStatus.Error ? ResponseStatus.Error : (ResponseStatus)tmp.ReturnCode;
            retData.StatusText = tmp.ReturnMessage;
            return retData;
        }

        #endregion
    }
}