<%--
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
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

<%@ include file="/html/portlet/wiki/init.jsp" %>

<%
WikiNode node = (WikiNode)request.getAttribute(WebKeys.WIKI_NODE);
WikiPage wikiPage = (WikiPage)request.getAttribute(WebKeys.WIKI_PAGE);

String redirect = ParamUtil.getString(request, "redirect");

boolean viewTrashAttachments = ParamUtil.getBoolean(request, "viewTrashAttachments");

String[] attachments = null;

if (viewTrashAttachments) {
	attachments = wikiPage.getDeletedAttachmentsFiles();
}
else {
	attachments = wikiPage.getAttachmentsFiles();
}

PortletURL portletURL = renderResponse.createActionURL();

portletURL.setParameter("nodeId", String.valueOf(node.getNodeId()));
portletURL.setParameter("title", wikiPage.getTitle());

portletURL.setParameter("struts_action", "/wiki/view");

PortalUtil.addPortletBreadcrumbEntry(request, wikiPage.getTitle(), portletURL.toString());

portletURL.setParameter("struts_action", "/wiki/view_page_attachments");

PortalUtil.addPortletBreadcrumbEntry(request, LanguageUtil.get(pageContext, "attachments"), portletURL.toString());
%>

<liferay-util:include page="/html/portlet/wiki/top_links.jsp" />

<liferay-util:include page="/html/portlet/wiki/page_tabs.jsp">
	<liferay-util:param name="tabs1" value="attachments" />
</liferay-util:include>

<c:if test="<%= viewTrashAttachments %>">
	<liferay-ui:header
		backURL="<%= redirect %>"
		title="deleted-attachments"
	/>
</c:if>

<%
List<String> headerNames = new ArrayList<String>();

headerNames.add("file-name");
headerNames.add("size");
headerNames.add(StringPool.BLANK);

String emptyMessage = null;

if (viewTrashAttachments) {
	emptyMessage = "this-page-does-not-have-any-file-attachments-in-the-recycle-bin";
}
else {
	emptyMessage = "this-page-does-not-have-any-file-attachments";
}

SearchContainer searchContainer = new SearchContainer(renderRequest, null, null, SearchContainer.DEFAULT_CUR_PARAM, SearchContainer.DEFAULT_DELTA, currentURLObj, headerNames, emptyMessage);

int total = attachments.length;

searchContainer.setTotal(total);

List results = ListUtil.fromArray(attachments);

results = ListUtil.subList(results, searchContainer.getStart(), searchContainer.getEnd());

searchContainer.setResults(results);

List resultRows = searchContainer.getResultRows();

for (int i = 0; i < results.size(); i++) {
	String fileName = (String)results.get(i);

	String shortFileName = FileUtil.getShortFileName(fileName);

	long fileSize = DLStoreUtil.getFileSize(company.getCompanyId(), CompanyConstants.SYSTEM, fileName);

	ResultRow row = new ResultRow(new Object[] {node, wikiPage, fileName}, fileName, i);

	PortletURL rowURL = renderResponse.createActionURL();

	rowURL.setWindowState(LiferayWindowState.EXCLUSIVE);

	rowURL.setParameter("struts_action", "/wiki/get_page_attachment");
	rowURL.setParameter("nodeId", String.valueOf(node.getNodeId()));
	rowURL.setParameter("title", wikiPage.getTitle());
	rowURL.setParameter("fileName", shortFileName);

	// File name

	StringBundler sb = new StringBundler(6);

	sb.append("<img align=\"left\" border=\"0\" src=\"");
	sb.append(themeDisplay.getPathThemeImages());
	sb.append("/file_system/small/");
	sb.append(DLUtil.getFileIcon(shortFileName));
	sb.append(".png\">&nbsp;");
	sb.append(shortFileName);

	row.addText(sb.toString(), rowURL);

	// Size

	row.addText(TextFormatter.formatStorageSize(fileSize, locale), rowURL);

	// Action

	row.addJSP("right", SearchEntry.DEFAULT_VALIGN, "/html/portlet/wiki/page_attachment_action.jsp");

	// Add result row

	resultRows.add(row);
}
%>

<c:if test="<%= WikiNodePermission.contains(permissionChecker, node.getNodeId(), ActionKeys.ADD_ATTACHMENT) %>">
	<c:if test="<%= !viewTrashAttachments %>">
		<portlet:renderURL var="viewTrashAttachmentsURL">
			<portlet:param name="struts_action" value="/wiki/view_page_attachments" />
			<portlet:param name="redirect" value="<%= currentURL %>" />
			<portlet:param name="nodeId" value="<%= String.valueOf(node.getNodeId()) %>" />
			<portlet:param name="title" value="<%= wikiPage.getTitle() %>" />
			<portlet:param name="tabs1" value="attachments" />
			<portlet:param name="viewTrashAttachments" value="<%= Boolean.TRUE.toString() %>" />
		</portlet:renderURL>

		<%
		String[] deletedAttachments = wikiPage.getDeletedAttachmentsFiles();
		%>

		<c:if test="<%= deletedAttachments.length > 0 %>">
			<liferay-ui:icon
				cssClass="trash-attachments"
				image="delete"
				label="<%= true %>"
				message='<%= LanguageUtil.format(pageContext, "x-attachments-in-the-recycle-bin", deletedAttachments.length) %>'
				url="<%= viewTrashAttachmentsURL %>"
			/>
		</c:if>

		<div>
			<input type="button" value="<liferay-ui:message key="add-attachments" />" onClick="location.href = '<portlet:renderURL><portlet:param name="struts_action" value="/wiki/edit_page_attachment" /><portlet:param name="nodeId" value="<%= String.valueOf(node.getNodeId()) %>" /><portlet:param name="title" value="<%= wikiPage.getTitle() %>" /><portlet:param name="redirect" value="<%= currentURL %>" /></portlet:renderURL>';" />
		</div>
	</c:if>

	<br />
</c:if>

<liferay-ui:search-iterator searchContainer="<%= searchContainer %>" />