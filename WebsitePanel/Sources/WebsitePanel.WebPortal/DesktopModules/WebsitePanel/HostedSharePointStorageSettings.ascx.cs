// Copyright (c) 2011, Outercurve Foundation.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// - Redistributions of source code must  retain  the  above copyright notice, this
//   list of conditions and the following disclaimer.
//
// - Redistributions in binary form  must  reproduce the  above  copyright  notice,
//   this list of conditions  and  the  following  disclaimer in  the documentation
//   and/or other materials provided with the distribution.
//
// - Neither  the  name  of  the  Outercurve Foundation  nor   the   names  of  its
//   contributors may be used to endorse or  promote  products  derived  from  this
//   software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,  BUT  NOT  LIMITED TO, THE IMPLIED
// WARRANTIES  OF  MERCHANTABILITY   AND  FITNESS  FOR  A  PARTICULAR  PURPOSE  ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO,  PROCUREMENT  OF  SUBSTITUTE  GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER  CAUSED AND ON
// ANY  THEORY  OF  LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY,  OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE)  ARISING  IN  ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

using System;
using WebsitePanel.EnterpriseServer;
using WebsitePanel.Providers.HostedSolution;

namespace WebsitePanel.Portal
{
    public partial class HostedSharePointStorageSettings : WebsitePanelModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            warningValue.UnlimitedText = GetLocalizedString("WarningUnlimitedValue");
            
            
            if (!IsPostBack)
            {
                Organization org = ES.Services.Organizations.GetOrganization(PanelRequest.ItemID);

                PackageContext cntx = ES.Services.Packages.GetPackageContext(PanelSecurity.PackageId);
                foreach(QuotaValueInfo quota in cntx.QuotasArray)
                {
                    if (quota.QuotaId == 208 /*Max storage quota*/)
                    {
                        maxStorageSettingsValue.ParentQuotaValue = quota.QuotaAllocatedValue;
                        warningValue.ParentQuotaValue = quota.QuotaAllocatedValue;
                    }
                }
                
                maxStorageSettingsValue.QuotaValue = org.MaxSharePointStorage;
                warningValue.QuotaValue = org.WarningSharePointStorage;
                
            }
        }

        private void Save(bool apply)
        {            
            try
            {                
                int res = ES.Services.HostedSharePointServers.SetStorageSettings(PanelRequest.ItemID, maxStorageSettingsValue.QuotaValue,
                                                                   warningValue.QuotaValue,
                                                                       apply);
                if (res < 0)
                {
                    messageBox.ShowResultMessage(res);
                    return;
                }            
                messageBox.ShowSuccessMessage("HOSTED_SHAREPOINT_UPDATE_QUOTAS");
            }
            catch (Exception)
            {
                messageBox.ShowErrorMessage("HOSTED_SHAREPOINT_UPDATE_QUOTAS");
            }

        }
        
        protected void btnSave_Click(object sender, EventArgs e)
        {
            Save(false);            
        }

        protected void btnSaveApply_Click(object sender, EventArgs e)
        {
            Save(true);
        }
    }
}