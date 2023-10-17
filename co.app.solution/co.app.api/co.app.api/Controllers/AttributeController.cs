using co.app.api.Filters;
using co.app.api.Models;
using co.app.common;
using co.app.common.WebApi;
using co.app.common.WebApi.Attribute.Get;
using co.app.common.WebApi.Attribute.Upsert;
using co.app.common.WebApi.Common;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace mss.api.Controllers
{
   // [ServiceFilter(typeof(TokenAuthorizationFilter))]
    [Route("api/[controller]")]
    public class AttributeController
    {
        private readonly MainContext _context;

        public AttributeController(MainContext context)
        {
            _context = context;
        }

        [HttpPost]
        [Route("upsert-attribute")]
        public ResponseModel UpsertAttributeType([FromBody] AttributeRequestModel requestModel)
        {

            try
            {
                var responseModel = new ResponseModel();

                if (requestModel == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorId = 1;
                    responseModel.ErrorMessage = "Attribute data is null, please check your request";
                    responseModel.ValidateResponse = "Attribute object is empty";
                    return responseModel;
                }


                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(
                    Constants.app_SP_UpsertAttribute,
                   requestModel.AttributeId, requestModel.AttributeName, requestModel.AttributePath,
                   requestModel.IsComponent, requestModel.UserGUID).ToList()[0];

                return new ResponseModel
                {
                    IsError = result.IsError,
                    ErrorId = result.ErrorId,
                    ErrorMessage = result.ErrorMessage,
                    ValidateResponse = result.ValidateResponse
                };

            }
            catch (Exception ex) 
            {
                return new ResponseModel
                {
                    IsError = true,
                    ErrorId = 1,
                    ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString()),
                    ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString())
                };
            }
        }

        [HttpGet]
        [Route("get-attributes")]
        public ResponseModelWith<AttributeListModel> GetAttributes()
        {

            try
            {

                var arrayOfItems = _context.AttributeListModels.FromSqlRaw(
                                  Constants.app_SP_GetAttributes).ToList();

                return new ResponseModelWith<AttributeListModel>
                {
                    IsError = false,
                    ErrorMessage = "",
                    ValidateResponse = "Your Operation Is Done.",
                    arrayOfItems = arrayOfItems
                };
            }
            catch (Exception ex)
            {
                return new ResponseModelWith<AttributeListModel> { IsError = true, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), arrayOfItems = null };

            }
        }




        [HttpDelete]
        [Route("delete-attribute")]
        public ResponseModel DeleteAttribute([FromBody] DeleteRequestModel requestModel)
        {

            try
            {
           

                var responseModel = new ResponseModel();

                if (requestModel == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorId = 1;
                    responseModel.ErrorMessage = "Please check your request";
                    responseModel.ValidateResponse = "Please check your request";

                    return responseModel;
                }

                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(
                    Constants.app_SP_DeleteAttribute, requestModel.Id, requestModel.DeletedById).ToList()[0];

                return new ResponseModel
                {
                    IsError = false,
                    ErrorId = 0,
                    ErrorMessage = result.ErrorMessage,
                    ValidateResponse = result.ValidateResponse
                };
            }
            catch (Exception ex)
            {

                return new ResponseModel
                {
                    IsError = true,
                    ErrorId = 1,
                    ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString()),
                    ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString())
                };
            }

        }

    }
}
