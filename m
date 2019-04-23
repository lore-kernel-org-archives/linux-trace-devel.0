Return-Path: <SRS0=onCu=SZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15C2C282DD
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 14:58:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB9842175B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Apr 2019 14:58:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfDWO6u (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 10:58:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727740AbfDWO6u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 10:58:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A0FE20674;
        Tue, 23 Apr 2019 14:58:49 +0000 (UTC)
Date:   Tue, 23 Apr 2019 10:58:47 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3] trace-cmd: Load trace-cmd plugins from build folder,
 if exists
Message-ID: <20190423105847.73e033de@gandalf.local.home>
In-Reply-To: <20190423143344.30645-1-tstoyanov@vmware.com>
References: <20190423143344.30645-1-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 23 Apr 2019 17:33:44 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> [
>  v3 changes:
>   - Simplified the logic, using standard library functions.
>   - Added check to ensure the binary is inside the source tree.
>  v2 changes:
>   - Removed the logic looking for plugins in the build path.
>   - Added logic which gets the full path of the running trace-cmd
>     binary and loads plugins from "plugins" directory around it, if exist.
> ]

Hi Tzvetomir,

FYI, change versions should go below the three dashes "---" under the
Signed-off-by, as that will keep them from being added to the git logs.
Patch change versions are only for reviewers information not for git
history.

Other than that, the patch looks fine.

Thanks!

-- Steve

> 
> When a development version of trace-cmd is built and run on the machine,
> by default it loads all plugins from predefined drierctories :
>   (install_preffix)/lib/traceevent/plugins
>   ~/.traceevent/plugins
>   the path specified in TRACEEVENT_PLUGIN_DIR environment variable.
> Thus, the development plugins will not be loaded. To simplify the development
> process, a new logic is added:
>   At plugins load time, check the location of trace-cmd application and look
>   for "plugins" directory around it. If found, load plugins from it. Those
>   pluigins will be loaded last, so in case of duplication the "development"
>   plugins win.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  lib/trace-cmd/trace-util.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 8d21fb2..190cf74 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -14,6 +14,7 @@
>  #include <unistd.h>
>  #include <ctype.h>
>  #include <limits.h>
> +#include <libgen.h>
>  #include <sys/mount.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -1364,6 +1365,28 @@ static int add_plugin_file(struct tep_handle *pevent, const char *path,
>  	return -ENOMEM;
>  }
>  
> +static char *trace_util_get_source_plugins_dir(void)
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
> +	strcpy(p, "/plugins");
> +	return strdup(path);
> +}
> +
> +
>  int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
>  			    int (*load_plugin)(struct tep_handle *pevent,
>  					       const char *path,
> @@ -1404,6 +1427,12 @@ int trace_util_load_plugins(struct tep_handle *pevent, const char *suffix,
>  	trace_util_load_plugins_dir(pevent, suffix, path, load_plugin, data);
>  
>  	free(path);
> +
> +	path = trace_util_get_source_plugins_dir();
> +	if (path) {
> +		trace_util_load_plugins_dir(pevent, suffix, path, load_plugin, data);
> +		free(path);
> +	}
>  	return 0;
>  }
>  

