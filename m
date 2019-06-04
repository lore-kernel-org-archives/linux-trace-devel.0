Return-Path: <SRS0=dXNV=UD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6764FC282CE
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47F7223E96
	for <linux-trace-devel@archiver.kernel.org>; Tue,  4 Jun 2019 12:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfFDMYr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 08:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbfFDMYq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 08:24:46 -0400
Received: from oasis.local.home (unknown [146.247.46.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BDED20665;
        Tue,  4 Jun 2019 12:24:44 +0000 (UTC)
Date:   Tue, 4 Jun 2019 08:24:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Slavomir Kaslev <kaslevs@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, ykaradzhov@vmware.com,
        tstoyanov@vmware.com, slavomir.kaslev@gmail.com
Subject: Re: [PATCH] trace-cmd: Append metadata about trace-cmd's version
 when recording
Message-ID: <20190604082440.724d7d95@oasis.local.home>
In-Reply-To: <20190604121441.19305-1-kaslevs@vmware.com>
References: <20190604121441.19305-1-kaslevs@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  4 Jun 2019 15:14:41 +0300
Slavomir Kaslev <kaslevs@vmware.com> wrote:

> Add metadata when recording to the output trace about trace-cmd's version and
> git commit. When debugging this can be useful to know which version of trace-cmd
> recorded this trace.dat file.

Awesome! Some nits below...

> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=203547
> Signed-off-by: Slavomir Kaslev <kaslevs@vmware.com>
> ---
>  Makefile                      |  3 +++
>  include/trace-cmd/trace-cmd.h |  1 +
>  tracecmd/trace-record.c       | 17 ++++++++++++++++-
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index cde45f8..2062d97 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -238,6 +238,9 @@ endif
>  override CFLAGS += $(INCLUDES) $(PLUGIN_DIR_SQ) $(VAR_DIR)
>  override CFLAGS += $(udis86-flags) $(blk-flags)
>  
> +# Append version define
> +override CFLAGS += -DTRACECMD_VERSION=\"$(TRACECMD_VERSION)\"
> +override CFLAGS += -DTRACECMD_VERSION_GIT=\"$(shell git log -1 --pretty=format:"%H")\"
>  
>  CMD_TARGETS = trace-cmd $(BUILD_PYTHON)
>  
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index ceb03f4..ca9fc44 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -81,6 +81,7 @@ enum {
>  	TRACECMD_OPTION_HOOK,
>  	TRACECMD_OPTION_OFFSET,
>  	TRACECMD_OPTION_CPUCOUNT,
> +	TRACECMD_OPTION_VERSION,
>  };
>  
>  enum {
> diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
> index 4523128..4c4840b 100644
> --- a/tracecmd/trace-record.c
> +++ b/tracecmd/trace-record.c
> @@ -3145,6 +3145,21 @@ static void add_uname(struct tracecmd_output *handle)
>  	free(str);
>  }
>  
> +static void add_version(struct tracecmd_output *handle)
> +{
> +	char *str;
> +	int len;
> +
> +	len = strlen(TRACECMD_VERSION) + strlen(TRACECMD_VERSION_GIT) + 2;
> +	str = malloc(len);
> +	if (!str)
> +		return;
> +
> +	sprintf(str, "%s %s", TRACECMD_VERSION, TRACECMD_VERSION_GIT);

The above should use asprintf():

	ret = asprintf(&str, "%s %s", TRACECMD_VERSION, TRACE_cMD_VERSION_GIT);
	if (ret < 0)
		return;

But other than that, looks good!

-- Steve

> +	tracecmd_add_option(handle, TRACECMD_OPTION_VERSION, len, str);
> +	free(str);
> +}
> +
>  static void print_stat(struct buffer_instance *instance)
>  {
>  	int cpu;
> @@ -3182,7 +3197,7 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
>  	tracecmd_add_option(handle, TRACECMD_OPTION_TRACECLOCK, 0, NULL);
>  	add_option_hooks(handle);
>  	add_uname(handle);
> -
> +	add_version(handle);
>  }
>  
>  static void record_data(struct common_record_context *ctx)

