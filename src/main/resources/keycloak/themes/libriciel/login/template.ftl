<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayWide=false>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html class="${properties.kcHtmlClass!}" lang="${locale.currentLanguageTag!"fr"}"
    xml:lang="${locale.currentLanguageTag!"fr"}" xmlns="http://www.w3.org/1999/xhtml">

<head>
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta name="robots" content="noindex, nofollow">

    <#if properties.meta?has_content>
        <#list properties.meta?split(' ') as meta>
            <meta name="${meta?split('==')[0]}" content="${meta?split('==')[1]}"/>
        </#list>
    </#if>
    <title>${msg("loginTitle",(realm.displayName!''))}</title>
    <link rel="icon" href="${url.resourcesPath}/img/favicon.ico"/>
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Ubuntu">
    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${url.resourcesPath}/${style}" rel="stylesheet"/>
        </#list>
    </#if>
    <#if properties.scripts?has_content>
        <#list properties.scripts?split(' ') as script>
            <script src="${url.resourcesPath}/${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <#if scripts??>
        <#list scripts as script>
            <script src="${script}" type="text/javascript"></script>
        </#list>
    </#if>
    <script src="${url.resourcesPath}/js/login.js" type="text/javascript"></script>
    <script src="${url.resourcesPath}/js/ls-elements.js" type="text/javascript"></script>
</head>

<body class="grid-container">

<main class="main">
    <div class="left-panel">
        <img src="${url.resourcesPath}/images/${properties.logoImage}" alt="${properties.productName}"/>
        <p>${properties.logoMessage}</p>
    </div>
    <div class="right-panel">
        <#if properties.infoMessage?has_content>
            <div class="alert alert-info fixed-message">
                <i class="fa fa-info-circle"></i>
                <span>
                    ${properties.infoMessage}
                </span>
            </div>
        </#if>
        <div class="content">
            <div class="logo-grid">
                <img src="${url.resourcesPath}/images/${properties.productImage}" alt="Logo du produit"/>
            </div>

            <div class="info-grid">
                <#if realm.internationalizationEnabled  && locale.supported?size gt 1>
                    <div id="kc-locale">
                        <div id="kc-locale-wrapper" class="${properties.kcLocaleWrapperClass!}">
                            <div class="kc-dropdown" id="kc-locale-dropdown">
                                <a href="#" id="kc-current-locale-link">${locale.current}</a>
                                <ul>
                                    <#list locale.supported as l>
                                        <li class="kc-dropdown-item"><a href="${l.url}">${l.label}</a></li>
                                    </#list>
                                </ul>
                            </div>
                        </div>
                    </div>
                </#if>
                <p><#nested "header"></p>
            </div>

            <div class="content-form-grid">
                    <#if displayMessage && message?has_content>
                        <span class="alert alert-${message.type}">${kcSanitize(message.summary)?no_esc}</span>
                    </#if>

                    <#nested "form">

              <#if displayInfo>
                  <div id="kc-info" class="${properties.kcSignUpClass!}">
                      <div id="kc-info-wrapper" class="${properties.kcInfoAreaWrapperClass!}">
                          <#nested "info">
                      </div>
                  </div>
              </#if>
            </div>

        </div>
    </div>
</main>
<ls-footer class="ls-login-footer" application_name="${properties.productName} ${properties.productVersion!}" active="${properties.productActiveFooter!}"></ls-footer>
<#--<footer class="footer">-->
        <#--<#include "footer.ftl">-->
<#--</footer>-->
</body>
<!-- Load this after body because of the size of this JS script -->
<script type="text/javascript" src="${url.resourcesPath}/js/zxcvbn.js"></script>
</html>
</#macro>
