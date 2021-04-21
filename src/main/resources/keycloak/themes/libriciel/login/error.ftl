<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false; section>
    <#if section = "header">
        ${msg("errorTitle")}
    <#elseif section = "form">
        <p class="alert alert-error">${message.summary}</p>
        <#if client?? && client.baseUrl?has_content>
            <a id="backToApplication" href="${client.baseUrl}">${kcSanitize(msg("backToApplication"))?no_esc}</a>
        </#if>
    </#if>
</@layout.registrationLayout>
