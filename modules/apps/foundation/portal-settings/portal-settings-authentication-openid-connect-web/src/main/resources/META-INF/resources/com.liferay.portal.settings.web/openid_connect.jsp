<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/com.liferay.portal.settings.web/init.jsp" %>

<%
OpenIdConnectConfiguration openIdConnectConfiguration = ConfigurationProviderUtil.getConfiguration(OpenIdConnectConfiguration.class, new ParameterMapSettingsLocator(request.getParameterMap(), PortalSettingsOpenIdConnectConstants.FORM_PARAMETER_NAMESPACE, new CompanyServiceSettingsLocator(company.getCompanyId(), OpenIdConnectConstants.SERVICE_NAME)));
%>

<aui:input name="<%= ActionRequest.ACTION_NAME %>" type="hidden" value="/portal_settings/openid_connect" />

<aui:fieldset>
	<aui:input label="enabled" name='<%= PortalSettingsOpenIdConnectConstants.FORM_PARAMETER_NAMESPACE + "enabled" %>' type="checkbox" value="<%= openIdConnectConfiguration.enabled() %>" />
</aui:fieldset>