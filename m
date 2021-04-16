Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9E7C43619
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 19:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F6E861002
	for <linux-trace-devel@archiver.kernel.org>; Fri, 16 Apr 2021 19:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236021AbhDPTlH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 16 Apr 2021 15:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243989AbhDPTlG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 16 Apr 2021 15:41:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 883E661002;
        Fri, 16 Apr 2021 19:40:40 +0000 (UTC)
Date:   Fri, 16 Apr 2021 15:40:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Check if file version is supported
Message-ID: <20210416154038.5ae9a6ba@gandalf.local.home>
In-Reply-To: <20210416133110.47044-1-tz.stoyanov@gmail.com>
References: <20210416133110.47044-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 16 Apr 2021 16:31:10 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> When reading a trace file, version of the file is ignored. This could
> case problems when bumping the version number because of changes in
> in the structure of the file. The old code should detect unsupported
> file version and should not try to read it.
> A new trace-cmd library API is added to check if version is supported:
>  tracecmd_is_version_supported()
> Checks are added in the code to ensure not trying to read trace file
> with unsupported version.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
>  lib/trace-cmd/trace-input.c                       | 10 ++++++++++
>  lib/trace-cmd/trace-util.c                        |  8 ++++++++
>  tracecmd/trace-dump.c                             |  7 +++++++
>  4 files changed, 27 insertions(+)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index 56f82244..f7c1fa10 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -42,6 +42,8 @@ void tracecmd_record_ref(struct tep_record *record);
>  void tracecmd_set_debug(bool set_debug);
>  bool tracecmd_get_debug(void);
>  
> +bool tracecmd_is_version_supported(unsigned int version);
> +
>  struct tracecmd_output;
>  struct tracecmd_recorder;
>  struct hook_list;
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 991abd5f..9007c44e 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -117,6 +117,7 @@ struct tracecmd_input {
>  	bool			use_trace_clock;
>  	bool			read_page;
>  	bool			use_pipe;
> +	int			file_version;
>  	struct cpu_data 	*cpu_data;
>  	long long		ts_offset;
>  	struct tsc2nsec		tsc_calc;
> @@ -3175,6 +3176,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
>  	unsigned int page_size;
>  	char *version;
>  	char buf[BUFSIZ];
> +	long ver;

If we make this a unsigned long, we don't need all the checks.

>  
>  	handle = malloc(sizeof(*handle));
>  	if (!handle)
> @@ -3199,6 +3201,14 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd, int flags)
>  	if (!version)
>  		goto failed_read;
>  	pr_stat("version = %s\n", version);
> +	ver = strtol(version, NULL, 10);
> +	if (ver > INT_MAX || ver < INT_MIN || (!ver && errno))

if it is unsigned, then we don't need to worry about negative numbers, and
you could just have:

	if (!ver && errno)


> +		goto failed_read;
> +	if (!tracecmd_is_version_supported(ver)) {

And have this take an unsigned long as well.

> +		tracecmd_warning("Unsupported file version %d", ver);

If ver is unsigned long, it should be: %lu instead of %d.

> +		goto failed_read;
> +	}
> +	handle->file_version = ver;
>  	free(version);
>  
>  	if (do_read_check(handle, buf, 1))
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index 2d3bc741..bacc47d1 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -582,3 +582,11 @@ unsigned long long tracecmd_generate_traceid(void)
>  	free(str);
>  	return hash;
>  }
> +
> +bool tracecmd_is_version_supported(unsigned int version)

Have the above be unsigned long to match versions. Who knows, maybe some
day this will need to handle a file version greater than 4 billion :-)

And by then, there would be no more 32 bit machines.


> +{
> +	if (version < FILE_VERSION)

I think you want "<=" as with this patch I have:

trace-cmd report
  Unsupported file version 6
  error reading header for trace.dat

Better yet, just make it:

	return version <= FILE_VERSION;



> +		return true;
> +	return false;
> +}
> +

Extra whitespace at the end of the file. git complains about it.

> diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
> index 3f56f65a..8e74d8f5 100644
> --- a/tracecmd/trace-dump.c
> +++ b/tracecmd/trace-dump.c
> @@ -10,6 +10,7 @@
>  #include <getopt.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> +#include <errno.h>
>  
>  #include "trace-local.h"
>  
> @@ -145,6 +146,7 @@ static void dump_initial_format(int fd)
>  	char magic[] = TRACECMD_MAGIC;
>  	char buf[DUMP_SIZE];
>  	int val4;
> +	long ver;
>  
>  	do_print(SUMMARY, "\t[Initial format]\n");
>  
> @@ -166,6 +168,11 @@ static void dump_initial_format(int fd)
>  		die("no version string");
>  
>  	do_print(SUMMARY, "\t\t%s\t[Version]\n", buf);
> +	ver = strtol(buf, NULL, 10);
> +	if (ver > INT_MAX || ver < INT_MIN || (!ver && errno))

Again, make it unsigned long and you wont need all these INT_MAX INT_MIN
checks. If it's > INT_MAX, then the versioning would fail.

> +		die("Invalid file version string");
> +	if (!tracecmd_is_version_supported(ver))
> +		die("Unsupported file version %d", ver);
>  
>  	/* get file endianness*/
>  	if (read_file_bytes(fd, buf, 1))


-- Steve
