<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=true; section>
    <#if section = "header">
        ${msg("updatePasswordTitle")}
    <#elseif section = "form">
        <form class="update-password-grid" action="${url.loginAction}" method="post">
            <input type="text" id="username" name="username" value="${username}" autocomplete="username" readonly="readonly" style="display:none;"/>
            <input type="password" id="password" name="password" autocomplete="current-password" style="display:none;"/>

            <div class="form-entry-grid password-new-grid">
                <label for="password-new">${msg("passwordNew")}</label>
                <div class="input-group input-grid">
                    <span>
                        <i class="fa fa-lock"></i>
                    </span>
                    <i class="fa fa-eye-slash visibility" onclick="switchInputType('password-new', this)"></i>
                    <input tabindex="1" id="password-new" name="password-new" type="password" autofocus autocomplete="new-password" />
                </div>
            </div>

            <div class="form-entry-grid password-confirm-grid">
                <label for="password-confirm">${msg("passwordConfirm")}</label>
                <div class="input-group input-grid">
                    <span>
                        <i class="fa fa-lock"></i>
                    </span>
                    <i class="fa fa-eye-slash visibility" onclick="switchInputType('password-confirm', this)"></i>
                    <input tabindex="2" id="password-confirm" name="password-confirm" type="password" autocomplete="new-password" />
                </div>
            </div>

            <div class="form-confirm-grid">
                <button tabindex="3" class="btn-default" name="login">
                    <i class="fa fa-paper-plane fa-fw"></i>
                    ${msg("doSubmit")}
                </button>
            </div>
        </form>
    </#if>
</@layout.registrationLayout>
