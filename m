Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA5CC4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 21:56:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53A342083B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 21:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgI2V47 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 17:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728041AbgI2V46 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 17:56:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF78207F7;
        Tue, 29 Sep 2020 21:56:57 +0000 (UTC)
Date:   Tue, 29 Sep 2020 17:56:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     arnaldo.melo@gmail.com, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/2] tools lib traceevent: Man page for
 tep_add_plugin_path() API
Message-ID: <20200929175655.43c71137@gandalf.local.home>
In-Reply-To: <20200929173632.252076-1-tz.stoyanov@gmail.com>
References: <20200929173632.252076-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


[ Added Michael to the Cc ]

On Tue, 29 Sep 2020 20:36:32 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Add documentation of tep_add_plugin_path() API in the libtraceevent plugin man page.


Nit, but the above should be no more than 74 (I do 76) characters wide.

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  .../Documentation/libtraceevent-plugins.txt   | 22 +++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> index 4d6394397d92..e584b8c777ad 100644
> --- a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> @@ -3,7 +3,7 @@ libtraceevent(3)
>  
>  NAME
>  ----
> -tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook - Load / unload traceevent plugins.
> +tep_load_plugins, tep_unload_plugins, tep_load_plugins_hook, tep_add_plugin_path - Load / unload traceevent plugins.
>  
>  SYNOPSIS
>  --------
> @@ -19,6 +19,8 @@ void *tep_load_plugins_hook*(struct tep_handle pass:[*]_tep_, const char pass:[*
>  					       const char pass:[*]name,
>  					       void pass:[*]data),
>  			   void pass:[*]_data_);
> +int *tep_add_plugin_path*(struct tep_handle pass:[*]tep, char pass:[*]path,
> +			  enum tep_plugin_load_priority prio);
>  --
>  
>  DESCRIPTION
> @@ -52,16 +54,30 @@ _tep_load_plugins()_. The _tep_ argument is trace event parser context. The
>  _plugin_list_ is the list of loaded plugins, returned by
>  the _tep_load_plugins()_ function.
>  
> -The _tep_load_plugins_hook_ function walks through all directories with plugins
> +The _tep_load_plugins_hook()_ function walks through all directories with plugins
>  and calls user specified _load_plugin()_ hook for each plugin file. Only files
>  with given _suffix_ are considered to be plugins. The _data_ is a user specified
>  context, passed to _load_plugin()_. Directories and the walk order are the same
>  as in _tep_load_plugins()_ API.
>  
> +The _tep_add_plugin_path()_ functions adds additional directories with plugins in
> +the _tep_->plugins_dir list. It must be called before _tep_load_plugins()_ in order
> +the plugins from the new directories to be loaded. The _tep_ argument is trace event

"in order for the plugins" .. "is the trace event parser"


> +parser context. The _path_ is the full path to the new plugin directory. The _prio_
> +argument specifies the loading priority of plugins from the new directory. The loading

"specifies the loading priority order for the new directory of plugins"

> +priority is important in case of different versions of the same plugin located in
> +multiple plugin directories.The last loaded plugin wins. The priority can be:
> +[verse]
> +--
> +	_TEP_PLUGIN_FIRST_	- Load plugins from this directory first
> +	_TEP_PLUGIN_LAST_	- Load plugins from this directory last
> +--

"Where the plugins in TEP_PLUGIN_LAST" will take precedence over the
plugins in the other directories."

> +
>  RETURN VALUE
>  ------------
>  The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
>  or NULL in case no plugins are loaded.
> +The _tep_add_plugin_path()_ function returns -1 in case of an error, 0 otherwise.
>  

-- Steve

>  EXAMPLE
>  -------
> @@ -71,6 +87,8 @@ EXAMPLE
>  ...
>  struct tep_handle *tep = tep_alloc();
>  ...
> +tep_add_plugin_path(tep, "~/dev_plugins", TEP_PLUGIN_LAST);
> +...
>  struct tep_plugin_list *plugins = tep_load_plugins(tep);
>  if (plugins == NULL) {
>  	/* no plugins are loaded */

