using System.Web.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using DSBApps;
using DSBApps.Controllers;

namespace DSBApps.Tests.Controllers
{
    [TestClass]
    public class HomeControllerTest
    {
        [TestMethod]
        public void Index()
        {
            // Arrange
            DefaultController controller = new DefaultController();

            // Act
            ViewResult result = controller.Index() as ViewResult;

            // Assert
            Assert.IsNotNull(result);
            Assert.AreEqual("Home Page", result.ViewBag.Title);
        }
    }
}
