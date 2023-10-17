using Microsoft.AspNetCore.Mvc;
using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using co.app.api.Models;
using co.app.common.WebApi;
using co.app.common.WebApi.AccessMatrix.Upsert;
using co.app.common;
using co.app.common.WebApi.AccessMatrix.Delete;
using co.app.common.WebApi.AccessMatrix.Get;
using co.app.api.Filters;

namespace app.api.Controllers
{
    [Route("api/[controller]")]
    public class AccessMatrixController : ControllerBase
    {
        private readonly co.app.api.Models.MainContext _context;

        public AccessMatrixController(co.app.api.Models.MainContext context)
        {
            _context = context;
        }

        [HttpPost]
        [Route("UpsertAccessMatrix")]
        public ResponseModel UpsertAccessMatrix([FromBody] UserAccessMatrix requestModel)
        {
            try
            {
                var responseModel = new ResponseModel();

                if (requestModel == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorId = 1;
                    responseModel.ErrorMessage = "User Access Matrix Data is null, please check your request";
                    responseModel.ValidateResponse = "User Access Matrix object is empty";

                    return responseModel;
                }

                DataTable table = CreateUserAccessMatrixDataTable(requestModel.UserAttributeIds, requestModel.RoleId);

                var parameter = new SqlParameter("UserAttributeData", SqlDbType.Structured);
                parameter.Value = table;
                parameter.TypeName = "[dbo].[udtUserAccessMatrixFieldvalues]";

                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(
                    Constants.app_SP_UpsertAccessMatrix,
                        requestModel.UserAccessMatrixId, requestModel.IsActive, requestModel.UserAccessDescription,
                        requestModel.RoleId, requestModel.CreatedById, parameter).ToList()[0];

                return new ResponseModel
                {
                    IsError = false,
                    ErrorId = 0,
                    ErrorMessage = result.ErrorMessage,
                    ValidateResponse = result.ValidateResponse
                };

            }
            catch (Exception ex){

                return new ResponseModel
                {
                    IsError = true,
                    ErrorId = 1,
                    ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString()),
                    ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString())
                };

            }


        }

        [HttpDelete]
        public ResponseModel DeleteAccessMatrix([FromBody] AccessMatrixDeleteRequestModel requestModel) 
        {
            try
            {
                var responseModel = new ResponseModel();

                if (requestModel.UserAccessMatrixId == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorMessage = "User Matrix Id is null, please check your request";
                    responseModel.ValidateResponse = "User Matrix Id is not valid";

                    return responseModel;
                }
                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(
                    Constants.app_SP_DeleteAccessMatrix,
                    requestModel.UserAccessMatrixId, requestModel.DeletedById).ToList()[0];

                return new ResponseModel
                {
                    IsError = true,
                    ErrorId = 1,
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
        [Route("GetAccessMatrix")]
        public ResponseModelWith<AccessMatrixListModel> getArrayOfUserAccessMatrix()
        {
            try
            {

                var arrayOfItems = _context.AccessMatrixListModels.FromSqlRaw(
                    Constants.app_SP_GetAccessMatrix).ToList();

                return new ResponseModelWith<AccessMatrixListModel>
                {
                    IsError = false,
                    ErrorMessage = "",
                    ValidateResponse = "Your Operation Is Done.",
                    arrayOfItems = arrayOfItems
                };

            }
            catch (Exception ex)
            {
                return new ResponseModelWith<AccessMatrixListModel> { IsError = true, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), arrayOfItems = null };
            }

        }


        public static DataTable CreateUserAccessMatrixDataTable(List<Guid> userAttributeIds, Guid RoleId)
        {
            var dataTable = new DataTable();
            dataTable.Columns.Add("RoleId", typeof(Guid));
            dataTable.Columns.Add("UserAttributeId", typeof(Guid));

            foreach (var userAccessMatrixFieldValue in userAttributeIds)
            {
                var row = dataTable.NewRow();
                row["RoleId"] = RoleId;
                row["UserAttributeId"] = userAccessMatrixFieldValue;

                dataTable.Rows.Add(row);
            }

            return dataTable;
        }
    }
}