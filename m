Return-Path: <SRS0=JRVv=X5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A940C47404
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 15:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4CC207FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  4 Oct 2019 15:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389451AbfJDPJQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 4 Oct 2019 11:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389165AbfJDPJQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 4 Oct 2019 11:09:16 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFD07207FF;
        Fri,  4 Oct 2019 15:09:15 +0000 (UTC)
Date:   Fri, 4 Oct 2019 11:09:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 3/5] trace-cmd: Load libtraceevent plugins from build
 folder, if exists.
Message-ID: <20191004110914.011edb67@gandalf.local.home>
In-Reply-To: <20191004133647.27759-4-tz.stoyanov@gmail.com>
References: <20191004133647.27759-1-tz.stoyanov@gmail.com>
        <20191004133647.27759-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  4 Oct 2019 16:36:45 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When a development version of trace-cmd is built and run on the machine,
> by default it loads only installed plugins, from system directories.
> Thus, the development plugins will not be loaded. To simplify the development
> process, a new logic is added:
>   At plugins load time, check the location of trace-cmd application and look
>   for "plugins" directory around it. If found, load plugins from it. Those
>   plugins will be loaded last, so in case of duplication the "development"
>   plugins win.
> A two new APIs are introduced to libtraceevent, in order to accomplish this
> logic:
>  tep_load_plugins_dir() - loads tep plugins from a specific directory.
>  tep_plugins_append() - Append two plugin lists.

We should probably break this patch up into two. One that adds the new
interface to libtraceevent (making it easier to send to upstream
libtraceevent), and then one that uses it in trace-cmd.

And we should probably update the man pages when adding the tep_*()
patches. That said, I have some comments about this.

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>


> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index b08e377..5a84fc3 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -884,6 +884,52 @@ void trace_util_free_plugin_files(char **files)
>  	free(files);
>  }
>  
> +static char *get_source_plugins_dir(void)
> +{
> +	char *p, path[PATH_MAX+1];
> +	int ret;
> +
> +	ret = readlink("/proc/self/exe", path, PATH_MAX);
> +	if (ret > PATH_MAX || ret < 0)
> +		return NULL;
> +
> +	dirname(path);
> +	p = strrchr(path, '/');
> +	if (!p)
> +		return NULL;
> +	/* Check if we are in the the source tree */
> +	if (strcmp(p, "/tracecmd") != 0)
> +		return NULL;
> +
> +	strcpy(p, "/lib/traceevent/plugins");
> +	return strdup(path);
> +}
> +
> +struct tep_plugin_list*
> +trace_load_tep_plugins(struct tep_handle *tep)
> +{
> +	struct tep_plugin_list *list_dev;
> +	struct tep_plugin_list *list;
> +	char *path;
> +
> +	if (tracecmd_disable_plugins)
> +		tep_set_flag(tep, TEP_DISABLE_PLUGINS);
> +	if (tracecmd_disable_sys_plugins)
> +		tep_set_flag(tep, TEP_DISABLE_SYS_PLUGINS);
> +
> +	list = tep_load_plugins(tep);
> +
> +	path = get_source_plugins_dir();
> +	if (path) {
> +		list_dev = tep_load_plugins_dir(tep, path);
> +		tep_plugins_append(list_dev, list);
> +		list = list_dev;
> +		free(path);

I think it would be better to be able to add paths to the tep, and then
call "tep_load_plugins()". That is:

	path = get_source_plugins_dir();
	if (path)
		tep_add_plugin_path(tep, path);

	list = tep_load_plugins(tep);

And have the tep_load_plugins() do all the work, and not have a
tep_plugins_append(). That append function is exposing too much of the
implementation of the tep code.

-- Steve

> +	}
> +
> +	return list;
> +}
> +
>  char *tracecmd_get_tracing_file(const char *name)
>  {
>  	static const char *tracing;
>
