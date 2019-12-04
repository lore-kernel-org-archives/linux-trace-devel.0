Return-Path: <SRS0=XW/z=Z2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF45C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 20:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D912077B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 20:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfLDUKA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 15:10:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbfLDUKA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 15:10:00 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7B0205ED;
        Wed,  4 Dec 2019 20:09:59 +0000 (UTC)
Date:   Wed, 4 Dec 2019 15:09:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 05/18] trace-cmd: Add new library API for local CPU
 count
Message-ID: <20191204150957.07cef7d1@gandalf.local.home>
In-Reply-To: <20191203103522.482684-6-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:09 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> In order to reuse the code, the function detecting the
> number of local CPU is moved from trace-cmd application to
> libtracecmd. The following new library API is introduced:
> 	int tracecmd_count_cpus(void);
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h  |  3 +++
>  lib/trace-cmd/trace-util.c     | 40 +++++++++++++++++++++++++++++
>  tracecmd/include/trace-local.h |  2 --
>  tracecmd/trace-agent.c         |  2 +-
>  tracecmd/trace-profile.c       |  2 +-
>  tracecmd/trace-record.c        | 46 +++-------------------------------
>  tracecmd/trace-stat.c          |  4 +--
>  7 files changed, 50 insertions(+), 49 deletions(-)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 5287d23..5d4292e 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -427,6 +427,9 @@ void tracecmd_plog(const char *fmt, ...);
>  void tracecmd_plog_error(const char *fmt, ...);
>  int tracecmd_set_logfile(char *logfile);
>  
> +/* --- System --- */
> +int tracecmd_count_cpus(void);
> +
>  /* --- Hack! --- */
>  int tracecmd_blk_hack(struct tracecmd_input *handle);
>  
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 4c70d9a..e019dce 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -1112,6 +1112,46 @@ int tracecmd_stack_tracer_status(int *status)
>  	return 1; /* full success */
>  }
>  
> +int tracecmd_count_cpus(void)
> +{
> +	FILE *fp;
> +	char buf[1024];
> +	int cpus = 0;
> +	char *pbuf;
> +	size_t *pn;
> +	size_t n;
> +	int r;
> +
> +	cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	if (cpus > 0)
> +		return cpus;
> +
> +	warning("sysconf could not determine number of CPUS");

As this is now a library function, probably should have a static
variable here:

	static int once;

	if (!once) {
		once++;
		warning("...");
	}

No need to do more than one warning.


> +
> +	/* Do the hack to figure out # of CPUS */
> +	n = 1024;
> +	pn = &n;
> +	pbuf = buf;
> +
> +	fp = fopen("/proc/cpuinfo", "r");
> +	if (!fp)
> +		die("Can not read cpuinfo");

Need to get rid of the die(). Could be in a separate patch.

Will also need to have the call sites check to see if the returned
number is negative, and fail there.

-- Steve

> +
> +	while ((r = getline(&pbuf, pn, fp)) >= 0) {
> +		char *p;
> +
> +		if (strncmp(buf, "processor", 9) != 0)
> +			continue;
> +		for (p = buf+9; isspace(*p); p++)
> +			;
> +		if (*p == ':')
> +			cpus++;
> +	}
> +	fclose(fp);
> +
> +	return cpus;
> +}
> +
>  /*
>   * tracecmd_write_file - Write in trace file
>   * @file: Full name of the trace file.
> diff --git a/tracecmd/include/trace-local.h b/tracecmd/include/trace-local.h
