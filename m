Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CFCC43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 20:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE912213A2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 20:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfCMU17 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 16:27:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726638AbfCMU17 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 16:27:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE47C20854;
        Wed, 13 Mar 2019 20:27:57 +0000 (UTC)
Date:   Wed, 13 Mar 2019 16:27:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Patrick McLean <chutzpah@gentoo.org>
Subject: Re: [PATCH v4 39/46] tools/lib/traceevent: Man pages for
 tep_load_plugins() and tep_unload_plugin()
Message-ID: <20190313162756.336b8b24@gandalf.local.home>
In-Reply-To: <20190308133654.21264-40-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-40-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:47 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_load_plugins() and tep_unload_plugin()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../Documentation/libtraceevent-plugins.txt   | 98 +++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> new file mode 100644
> index 000000000000..0f40d14944c0
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
> @@ -0,0 +1,98 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_load_plugins,tep_unload_plugins - Load  / unload traceevent plugins
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +struct tep_plugin_list pass:[*]*tep_load_plugins*(struct tep_handle pass:[*]_tep_);
> +void *tep_unload_plugins*(struct tep_plugin_list pass:[*]_plugin_list_, struct tep_handle pass:[*]_tep_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_load_plugins()_ function loads all plugins, located in the plugin
> +directories. The _tep_ argument is trace event parser context.
> +The plugin directories are :
> +[verse]
> +--
> +	- System's plugin directory, defined at the library compile time. It
> +	  depends on the library installation prefix and usually is
> +	  _(install_preffix)/lib/traceevent/plugins_
> +	- Directory, defined by the environment variable _TRACEEVENT_PLUGIN_DIR_
> +	- User's plugin directory, located at _~/.traceevent/plugins_

We are going to need to modify this to be more compliant with today's
desktops.

Patrick, where's the place to put customized plugins that should
overwrite the system ones?

-- Steve

> +--
> +Loading of plugins can be controlled by the _tep_flags_, using the
> +_tep_set_flag()_ API:
> +[verse]
> +--
> +	_TEP_DISABLE_SYS_PLUGINS_	- do not load plugins, located in
> +					the system's plugin directory.
> +	_TEP_DISABLE_PLUGINS_		- do not load any plugins.
> +--
> +The _tep_set_flag()_ API must be called before _tep_load_plugins()_.
> +
> +The _tep_unload_plugins()_ function unloads the plugins, previously loaded by
> +_tep_load_plugins()_. The _tep_ argument is trace event parser context. The
> +_plugin_list_ is the list of loaded plugins, returned by the _tep_load_plugins()_
> +function.
> +
> +RETURN VALUE
> +------------
> +The _tep_load_plugins()_ function returns a list of successfully loaded plugins,
> +or NULL in case no plugins are loaded.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +struct tep_plugin_list *plugins = tep_load_plugins(tep);
> +if (plugins == NULL) {
> +	/* no plugins are loaded */
> +}
> +...
> +tep_unload_plugins(plugins, tep);
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_, _tep_set_flag(3)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

