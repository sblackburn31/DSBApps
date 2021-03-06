﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace DSBApps.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class ProdTimerEntities : DbContext
    {
        public ProdTimerEntities()
            : base("name=ProdTimerEntities")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<WorkCell> WorkCells { get; set; }
        public virtual DbSet<vProdOrdInfo> vProdOrdInfoes { get; set; }
        public virtual DbSet<Note> Notes { get; set; }
        public virtual DbSet<NoteBook> NoteBooks { get; set; }
    
        public virtual ObjectResult<clearProductionData_Result> clearProductionData(Nullable<long> productionId, string wSId)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            var wSIdParameter = wSId != null ?
                new ObjectParameter("WSId", wSId) :
                new ObjectParameter("WSId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<clearProductionData_Result>("clearProductionData", productionIdParameter, wSIdParameter);
        }
    
        public virtual ObjectResult<endProductionTimer_Result> endProductionTimer(Nullable<long> productionId, Nullable<System.DateTime> endTime, string workCell, Nullable<int> numEmpl)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            var endTimeParameter = endTime.HasValue ?
                new ObjectParameter("EndTime", endTime) :
                new ObjectParameter("EndTime", typeof(System.DateTime));
    
            var workCellParameter = workCell != null ?
                new ObjectParameter("WorkCell", workCell) :
                new ObjectParameter("WorkCell", typeof(string));
    
            var numEmplParameter = numEmpl.HasValue ?
                new ObjectParameter("NumEmpl", numEmpl) :
                new ObjectParameter("NumEmpl", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<endProductionTimer_Result>("endProductionTimer", productionIdParameter, endTimeParameter, workCellParameter, numEmplParameter);
        }
    
        public virtual ObjectResult<vProdOrdInfo> getProductionData(Nullable<long> productionId)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<vProdOrdInfo>("getProductionData", productionIdParameter);
        }
    
        public virtual ObjectResult<vProdOrdInfo> getProductionData(Nullable<long> productionId, MergeOption mergeOption)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<vProdOrdInfo>("getProductionData", mergeOption, productionIdParameter);
        }
    
        public virtual ObjectResult<pauseEnd_Result> pauseEnd(Nullable<long> productionId, Nullable<System.DateTime> endTime, string workstationId)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            var endTimeParameter = endTime.HasValue ?
                new ObjectParameter("EndTime", endTime) :
                new ObjectParameter("EndTime", typeof(System.DateTime));
    
            var workstationIdParameter = workstationId != null ?
                new ObjectParameter("WorkstationId", workstationId) :
                new ObjectParameter("WorkstationId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<pauseEnd_Result>("pauseEnd", productionIdParameter, endTimeParameter, workstationIdParameter);
        }
    
        public virtual ObjectResult<pauseStart_Result> pauseStart(Nullable<long> productionId, Nullable<System.DateTime> startTime, string reason, string workstationId)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            var startTimeParameter = startTime.HasValue ?
                new ObjectParameter("StartTime", startTime) :
                new ObjectParameter("StartTime", typeof(System.DateTime));
    
            var reasonParameter = reason != null ?
                new ObjectParameter("Reason", reason) :
                new ObjectParameter("Reason", typeof(string));
    
            var workstationIdParameter = workstationId != null ?
                new ObjectParameter("WorkstationId", workstationId) :
                new ObjectParameter("WorkstationId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<pauseStart_Result>("pauseStart", productionIdParameter, startTimeParameter, reasonParameter, workstationIdParameter);
        }
    
        public virtual int seedProductionData()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("seedProductionData");
        }
    
        public virtual ObjectResult<setProductionOrder_Result> setProductionOrder(Nullable<long> productionId, string wSId)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            var wSIdParameter = wSId != null ?
                new ObjectParameter("WSId", wSId) :
                new ObjectParameter("WSId", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<setProductionOrder_Result>("setProductionOrder", productionIdParameter, wSIdParameter);
        }
    
        public virtual ObjectResult<startProductionTimer_Result> startProductionTimer(Nullable<long> productionId, Nullable<System.DateTime> startTime, string workCell, Nullable<int> numEmpl)
        {
            var productionIdParameter = productionId.HasValue ?
                new ObjectParameter("ProductionId", productionId) :
                new ObjectParameter("ProductionId", typeof(long));
    
            var startTimeParameter = startTime.HasValue ?
                new ObjectParameter("StartTime", startTime) :
                new ObjectParameter("StartTime", typeof(System.DateTime));
    
            var workCellParameter = workCell != null ?
                new ObjectParameter("WorkCell", workCell) :
                new ObjectParameter("WorkCell", typeof(string));
    
            var numEmplParameter = numEmpl.HasValue ?
                new ObjectParameter("NumEmpl", numEmpl) :
                new ObjectParameter("NumEmpl", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<startProductionTimer_Result>("startProductionTimer", productionIdParameter, startTimeParameter, workCellParameter, numEmplParameter);
        }
    
        public virtual int addTrackingInfo(string place, string who, string when)
        {
            var placeParameter = place != null ?
                new ObjectParameter("place", place) :
                new ObjectParameter("place", typeof(string));
    
            var whoParameter = who != null ?
                new ObjectParameter("who", who) :
                new ObjectParameter("who", typeof(string));
    
            var whenParameter = when != null ?
                new ObjectParameter("when", when) :
                new ObjectParameter("when", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addTrackingInfo", placeParameter, whoParameter, whenParameter);
        }
    
        public virtual int addContactInfo(string pname, string pemail, string pcomment, string pvisitorType, string pwho, Nullable<short> prating)
        {
            var pnameParameter = pname != null ?
                new ObjectParameter("Pname", pname) :
                new ObjectParameter("Pname", typeof(string));
    
            var pemailParameter = pemail != null ?
                new ObjectParameter("Pemail", pemail) :
                new ObjectParameter("Pemail", typeof(string));
    
            var pcommentParameter = pcomment != null ?
                new ObjectParameter("Pcomment", pcomment) :
                new ObjectParameter("Pcomment", typeof(string));
    
            var pvisitorTypeParameter = pvisitorType != null ?
                new ObjectParameter("PvisitorType", pvisitorType) :
                new ObjectParameter("PvisitorType", typeof(string));
    
            var pwhoParameter = pwho != null ?
                new ObjectParameter("Pwho", pwho) :
                new ObjectParameter("Pwho", typeof(string));
    
            var pratingParameter = prating.HasValue ?
                new ObjectParameter("Prating", prating) :
                new ObjectParameter("Prating", typeof(short));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("addContactInfo", pnameParameter, pemailParameter, pcommentParameter, pvisitorTypeParameter, pwhoParameter, pratingParameter);
        }
    }
}
