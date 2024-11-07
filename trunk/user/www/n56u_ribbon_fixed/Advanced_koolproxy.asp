<!DOCTYPE html>
<html>
<head>
<title><#Web_Title#> - koolproxy</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Expires" content="-1">

<link rel="shortcut icon" href="images/favicon.ico">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/main.css">
<link rel="stylesheet" type="text/css" href="/bootstrap/css/engage.itoggle.css">

<script type="text/javascript" src="/jquery.js"></script>
<script type="text/javascript" src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/bootstrap/js/engage.itoggle.min.js"></script>
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/itoggle.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script>
var $j = jQuery.noConflict();

$j(document).ready(function() {
	init_itoggle('koolproxy_enable',change_koolproxy_enable);
	init_itoggle('koolproxy_cpu');
	init_itoggle('hosts_ad');
	init_itoggle('tv_hosts');
	init_itoggle('koolproxy_https');
	init_itoggle('koolproxy_video');
	init_itoggle('koolproxy_prot');
	init_itoggle('rules_list',change_rules_list);
	init_itoggle('ss_DNS_Redirect',change_ss_DNS_Redirect);
});

</script>
<script>
<% koolproxy_status(); %>
<% login_state_hook(); %>

function initial(){
	show_banner(2);
	show_menu(5,15);
	showmenu();
	show_footer();
	fill_koolproxy_status(koolproxy_status());
	change_koolproxy_enable();
	change_rules_list();
	change_ss_DNS_Redirect();
	if (!login_safe())
		textarea_scripts_enabled(0);
}

function showmenu(){
showhide_div('adlink', found_app_adbyby());
}

function textarea_scripts_enabled(v){
	inputCtrl(document.form['scripts.koolproxy_rules_list.sh'], v);
	inputCtrl(document.form['scripts.koolproxy_rules_script.sh'], v);
	inputCtrl(document.form['scripts.ad_config_script.sh'], v);
}

function applyRule(){
//	if(validForm()){
		showLoading();
		
		document.form.action_mode.value = " Apply ";
		document.form.current_page.value = "/Advanced_koolproxy.asp";
		document.form.next_page.value = "";
		
		document.form.submit();
//	}
}

function submitInternet(v){
	showLoading();
	document.koolproxy_action.action = "Kp_action.asp";
	document.koolproxy_action.connect_action.value = v;
	document.koolproxy_action.submit();
}

function change_koolproxy_enable(){
	var m = document.form.koolproxy_enable[0].checked;
	showhide_div('kp_update_b', m);
}

function change_rules_list(){
if(document.form.rules_list_3.checked==true){
	var m = document.form.rules_list_3.checked;
	showhide_div('koolproxy_txt', m);
	showhide_div('daily_txt', m);
	showhide_div('kp_dat', m);
	}else{
	showhide_div('koolproxy_txt', false);
	showhide_div('daily_txt', false);
	showhide_div('kp_dat', false);
}
}
function fill_koolproxy_status(status_code){
	var stext = "Unknown";
	if (status_code == 0)
		stext = "<#Stopped#>";
	else if (status_code == 1)
		stext = "<#Running#>";
	$("koolproxy_status").innerHTML = '<span class="label label-' + (status_code != 0 ? 'success' : 'warning') + '">' + stext + '</span>';
}
function change_ss_DNS_Redirect(){
	var m = document.form.ss_DNS_Redirect[0].checked;
	var is_ss_DNS_Redirect = (m == "1") ? 1 : 0;
	showhide_div("ss_DNS_Redirect_IP_tr", is_ss_DNS_Redirect);
}

function button_updatead(){
	var $j = jQuery.noConflict();
	$j.post('/apply.cgi',
	{
		'action_mode': ' updatekp ',
	});
}

</script>
</head>

<body onload="initial();" onunLoad="return unload_body();">

<div class="wrapper">
	<div class="container-fluid" style="padding-right: 0px">
		<div class="row-fluid">
			<div class="span3"><center><div id="logo"></div></center></div>
			<div class="span9" >
				<div id="TopBanner"></div>
			</div>
		</div>
	</div>

	<div id="Loading" class="popup_bg"></div>

	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>

	<form method="post" name="form" id="ruleForm" action="/start_apply.htm" target="hidden_frame">

	<input type="hidden" name="current_page" value="Advanced_koolproxy.asp">
	<input type="hidden" name="next_page" value="">
	<input type="hidden" name="next_host" value="">
	<input type="hidden" name="sid_list" value="KoolproxyConf;LANHostConfig;General;">
	<input type="hidden" name="group_id" value="">
	<input type="hidden" name="action_mode" value="">
	<input type="hidden" name="action_script" value="">
	<input type="hidden" name="wan_ipaddr" value="<% nvram_get_x("", "wan0_ipaddr"); %>" readonly="1">
	<input type="hidden" name="wan_netmask" value="<% nvram_get_x("", "wan0_netmask"); %>" readonly="1">
	<input type="hidden" name="dhcp_start" value="<% nvram_get_x("", "dhcp_start"); %>">
	<input type="hidden" name="dhcp_end" value="<% nvram_get_x("", "dhcp_end"); %>">

	<div class="container-fluid">
		<div class="row-fluid">
			<div class="span3">
				<!--Sidebar content-->
				<!--=====Beginning of Main Menu=====-->
				<div class="well sidebar-nav side_nav" style="padding: 0px;">
					<ul id="mainMenu" class="clearfix"></ul>
					<ul class="clearfix">
						<li>
							<div id="subMenu" class="accordion"></div>
						</li>
					</ul>
				</div>
			</div>

			<div class="span9">
				<!--Body content-->
				<div class="row-fluid">
					<div class="span12">
						<div class="box well grad_colour_dark_blue">
							<h2 class="box_head round_top"><#menu5_26_1#> - <#menu5_20#></h2>
							<div class="round_bottom">
							<div>
                            <ul class="nav nav-tabs" style="margin-bottom: 10px;">
								<li id="adlink" style="display:none">
                                    <a href="Advanced_adbyby.asp"><#menu5_20_1#></a>
                                </li>
								 <li class="active">
                                    <a href="Advanced_koolproxy.asp"><#menu5_26_1#></a>
                                </li>
                            </ul>
                        </div>
								<div class="row-fluid">
									<div id="tabMenu" class="submenuBlock"></div>
									<div class="alert alert-info" style="margin: 10px;">
									<p>组网服务器VPN<br>
									</p>
									</div>



									<table width="100%" align="center" cellpadding="4" cellspacing="0" class="table">


										<tr>
										<th width="30%" style="border-top: 0 none;">异地组网参数设置(点下面应用再重起生效)</th>
							
													
												</div>
												
											</td>

										</tr>

										<tr>
										<th>指定端口 </th>
				<td>
					<input type="text" class="input" name="koolproxy_enable" id="koolproxy_enable_fake" style="width: 200px" value="<% nvram_get_x("","koolproxy_enable"); %>" />
				</td>

										</tr>

										<tr>
										<th>网关（格式 20）</th>
				<td>
					<input type="text" class="input" name="koolproxy_https" id="koolproxy_https_fake" style="width: 200px" value="<% nvram_get_x("","koolproxy_https"); %>" />
				</td>

										</tr>
									
										<tr>
										<th>域名（格式 ） </th>
				<td>
					<input type="text" class="input" name="koolproxy_video" id="koolproxy_video_fake" style="width: 200px" value="<% nvram_get_x("","koolproxy_video"); %>" />
				</td>

										</tr>
										<tr>
										<th>host（格式 )</th>
				<td>
					<input type="text" class="input" name="koolproxy_cpu" id="koolproxy_cpu_fake" style="width: 200px" value="<% nvram_get_x("","koolproxy_cpu"); %>" />
				</td>

										</tr>
										<tr>
										<th>（token)</th>
				<td>
					<input type="text" class="input" name="koolproxy_prot" id="koolproxy_prot_fake" style="width: 200px" value="<% nvram_get_x("","ss_DNS_Redirect"); %>" />
				</td>

										</tr>
										<tr>
									
										<td colspan="4" style="border-top: 0 none;">
												<br />
												<center><input class="btn btn-primary" style="width: 219px" type="button" value="<#CTL_apply#>" onclick="applyRule()" /></center>
											</td>
										</tr>
</table>

										
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	</form>

	<div id="footer"></div>
</div>
</body>
</html>
