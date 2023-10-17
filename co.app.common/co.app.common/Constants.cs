using System;
using System.Collections.Generic;
using System.Text;

namespace co.app.common
{
    public static class Constants
    {
        public static readonly int maxUnsuccessfullLoginAttempts = 5;
        public static readonly string app_SP_InsertEnquiryData = "spInsertEnquiryData {0}, {1}, {2}, {3}, {4}, {5}";

        public static readonly string app_SP_CheckUser = "spCheckUser {0}, {1}";
        public static readonly string app_SP_GetUserDetails = "spGetUserDetails {0}, {1}";
        public static readonly string app_SP_CreateTokenInDB = "spCreateTokenInDB {0}, {1}, {2}, {3}, {4}, {5}";

        public static readonly string app_SP_UpsertAccessMatrix = "spUpsertUserAccessMatrix {0}, {1}, {2}, {3}, {4}, {5}";
        public static readonly string app_SP_DeleteAccessMatrix = "spDeleteUserAccessMatrix {0}, {1}";
        public static readonly string app_SP_GetAccessMatrix = "spGetUserAccessMatrix";

        public static readonly string app_SP_UpsertAttribute = "spUpsertAttributes {0}, {1}, {2}, {3}, {4}";
        public static readonly string app_SP_DeleteAttribute = "spDeleteAttribute {0}, {1}";
        public static readonly string app_SP_GetAttributes = "spGetAttributes";

        public static readonly string app_SP_UpsertRole = "spUpsertRole {0}, {1}, {2}, {3}, {4}";
        public static readonly string app_SP_GetAllRoles = "spGetAllRoles {0}";
        public static readonly string app_SP_DeleteRole = "spDeleteRole {0}, {1}";

        public static readonly string app_SP_UpsertUserAttribute = "spUpsertUserAttribute {0}, {1}, {2}, {3}, {4}, {5}";
        public static readonly string app_SP_DeleteUserAttribute = "spDeleteUserAttribute {0}, {1}";
        public static readonly string app_SP_GetUserAttributes = "spGetUserAttrributes";

        public static readonly string app_SP_DeleteUser = "spDeleteUser {0}, {1}";
        public static readonly string app_SP_GetAllUsers = "spGetAllUsers {0}";
        public static readonly string app_SP_UpsertUser = "spUpsertUser {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}, {9}, {10}, {11}, {12}, {13}";

        public static readonly string app_SP_LogOff = "spLogOff {0}, {1}, {2}";

        public static readonly string app_SP_GetTokenByTokenID = "spGetTokenByTokenID {0}";

        public static readonly string app_SP_GetUserNameByUserGuid = "spGetUserNameByUserGuid {0}";

        public static readonly string app_SP_CheckUserAccess = "spCheckUserAccess {0}, {1}, {2}";

        public static readonly string app_SP_UpdateExceptionlog = "spUpdateExceptionLog {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}";

        public static readonly string app_SP_UpdateUserAuditLog = "spUpdateUserAuditLog {0}, {1}, {2}, {3}, {4}, {5}, {6}, {7}, {8}";

        public static readonly string app_SP_UpdateUserLoginStatus = "spUpdateUserLoginStatus {0}, {1}";




    }
}
