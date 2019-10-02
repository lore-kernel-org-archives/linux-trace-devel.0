Return-Path: <SRS0=PpJY=X3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5773DC4360C
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 23:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31A52222BE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 23:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfJBXtU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 19:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbfJBXtT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 19:49:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D205021A4C;
        Wed,  2 Oct 2019 23:49:18 +0000 (UTC)
Date:   Wed, 2 Oct 2019 19:49:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] trace-cmd: Load libtraceevent plugins from build
 folder, if exists.
Message-ID: <20191002194917.7563c386@gandalf.local.home>
In-Reply-To: <20191002114152.30048-4-tz.stoyanov@gmail.com>
References: <20191002114152.30048-1-tz.stoyanov@gmail.com>
        <20191002114152.30048-4-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed,  2 Oct 2019 14:41:50 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When a development version of trace-cmd is built and run on the machine,
> by default it loads only installed plugins, from system drierctories.
> Thus, the development plugins will not be loaded. To simplify the development
> process, a new logic is added:
>   At plugins load time, check the location of trace-cmd application and look
>   for "plugins" directory around it. If found, load plugins from it. Those
>   pluigins will be loaded last, so in case of duplication the "development"
>   plugins win.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/traceevent/event-plugin.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/lib/traceevent/event-plugin.c b/lib/traceevent/event-plugin.c
> index bc10205..4fc4ee3 100644
> --- a/lib/traceevent/event-plugin.c
> +++ b/lib/traceevent/event-plugin.c
> @@ -14,6 +14,7 @@
>  #include <unistd.h>
>  #include <dirent.h>
>  #include <errno.h>
> +#include <libgen.h>
>  #include "event-parse.h"
>  #include "event-parse-local.h"
>  #include "event-utils.h"
> @@ -538,6 +539,27 @@ load_plugins_dir(struct tep_handle *tep, const char *suffix,
>  	closedir(dir);
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

Hmm, this is in the lib/libtraceevent directory. We shouldn't be
referencing trace-cmd code here. We should have a way to override the
plugins from the trace-cmd side, perhaps after tep_load_plugins_hook()
gets called?

-- Steve


> +		return NULL;
> +
> +	strcpy(p, "/lib/traceevent/plugins");
> +	return strdup(path);
> +}
> +
>  void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
>  			   void (*load_plugin)(struct tep_handle *tep,
>  					       const char *path,
> @@ -588,6 +610,12 @@ void tep_load_plugins_hook(struct tep_handle *tep, const char *suffix,
>  	load_plugins_dir(tep, suffix, path, load_plugin, data);
>  
>  	free(path);
> +
> +	path = get_source_plugins_dir();
> +	if (path) {
> +		load_plugins_dir(tep, suffix, path, load_plugin, data);
> +		free(path);
> +	}
>  }
>  
>  struct tep_plugin_list*

