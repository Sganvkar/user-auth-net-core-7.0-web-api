using Microsoft.AspNetCore.Mvc;

namespace mss.api.Controllers
{   
    [Route("api/[controller]")]
    public class AppController : ControllerBase
    {
        public AppController()
        {
        }

        [Route("")]
        public string DisplayStartAPI()
        {
            return "API running!";
        }

    }

   
}
