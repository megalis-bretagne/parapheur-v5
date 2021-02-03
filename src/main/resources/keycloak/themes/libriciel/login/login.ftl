<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=social.displayInfo displayWide=(realm.password && social.providers??); section>
    <#if section = "header">
        ${msg("doLogInInfo")}
    <#elseif section = "form">
    <form class="login-form-grid" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post">
        <#-- USERNAME -->
        <div class="form-entry-grid username-grid">
            <label for="username"><#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if></label>
            <div class="input-group input-grid">
                <span>
                    <i class="fa fa-user"></i>
                </span>
                <#if usernameEditDisabled??>
                    <input tabindex="1" id="username" name="username" value="${(login.username!'')}" type="text" disabled />
                <#else>
                    <input tabindex="1" id="username" name="username" value="${(login.username!'')}"  type="text" autofocus autocomplete="off" />
                </#if>
            </div>
        </div>

        <#-- PASSWORD -->
        <div class="form-entry-grid password-grid">
            <label for="password">${msg("password")}</label>
            <div class="input-group input-grid">
                <span>
                    <i class="fa fa-lock"></i>
                </span>
                <i class="fa fa-eye-slash visibility" onclick="switchInputType('password', this)"></i>
                <input tabindex="2" id="password" name="password" type="password" autocomplete="off" />
            </div>
        </div>

        <#-- REMEMBER ME -->
        <div class="form-entry-grid remember-grid">
            <#if realm.rememberMe && !usernameEditDisabled??>
                <div class="input-grid">
                    <label class="input-grid">
                    <#if login.rememberMe??>
                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox" checked> ${msg("rememberMe")}
                    <#else>
                        <input tabindex="3" id="rememberMe" name="rememberMe" type="checkbox"> ${msg("rememberMe")}
                    </#if>
                    </label>
                </div>
            </#if>
        </div>

        <div class="form-confirm-grid">
        <#-- RESET PASSWORD -->
            <#if realm.resetPasswordAllowed>
                <a tabindex="5" class="forgot-password-grid" href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
            </#if>

        <#-- LOGIN BTN -->
            <button  tabindex="4" class="btn-default confirm-button-grid" name="login">
                <i class="fa fa-sign-in fa-fw"></i>
                ${msg("doLogIn")}
            </button>

        </div>
    </form>

    <#if realm.password && social.providers??>
        <div id="kc-social-providers" class="${properties.kcFormSocialAccountContentClass!} ${properties.kcFormSocialAccountClass!}">
            <ul class="${properties.kcFormSocialAccountListClass!} <#if social.providers?size gt 4>${properties.kcFormSocialAccountDoubleListClass!}</#if>">
                <#list social.providers as p>
                    <li class="${properties.kcFormSocialAccountListLinkClass!}"><a href="${p.loginUrl}" id="zocial-${p.alias}" class="zocial ${p.providerId}"> <span>${p.displayName}</span></a></li>
                </#list>
            </ul>
        </div>
    </#if>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !usernameEditDisabled??>
            <div id="kc-registration">
                <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
            </div>
        </#if>
    </#if>

</@layout.registrationLayout>
