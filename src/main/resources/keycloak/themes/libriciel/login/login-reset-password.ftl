<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "header">
        ${msg("emailForgotTitle")}
    <#elseif section = "form">
        <form class="forgot-password-grid" action="${url.loginAction}" method="post">


            <label for="username" class="message-grid">
                ${msg("forgotPasswordInstruction")}
            </label>

            <input class="user-or-mail-grid" type="text" tabindex="1" id="username" name="username" autofocus placeholder="Nom d'utilisateur ou adresse mail"/>

            <span class="alert alert-info alert-left-align content-info-grid">
                <i class="fa fa-info-circle"></i>
                ${msg("emailInstruction")?no_esc}
            </span>

            <div class="form-confirm-grid">
                <a href="${url.loginUrl}">
                    <i class="fa fa-arrow-left"></i>
                    ${kcSanitize(msg("backToLogin"))?no_esc}
                </a>
                <button  tabindex="2" class="btn-default" name="login">
                    <i class="fa fa-paper-plane fa-fw"></i>
                    ${msg("doSubmit")}
                </button>
            </div>
        </form>
    <#elseif section = "info" >
    </#if>
</@layout.registrationLayout>
