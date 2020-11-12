Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE2DC55ABD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD3CE20B80
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Nov 2020 19:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKLTRb (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Nov 2020 14:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgKLTRb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Nov 2020 14:17:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010C120B80;
        Thu, 12 Nov 2020 19:17:29 +0000 (UTC)
Date:   Thu, 12 Nov 2020 14:17:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 5/6] libtracefs: Add new tracefs API
 tracefs_instances_walk()
Message-ID: <20201112141728.20e3607e@gandalf.local.home>
In-Reply-To: <20201112091109.1239169-6-tz.stoyanov@gmail.com>
References: <20201112091109.1239169-1-tz.stoyanov@gmail.com>
        <20201112091109.1239169-6-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 12 Nov 2020 11:11:08 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> The logic for finding all configured ftrace instances is encapuslated in
> a new tracefs_instances_walk() API. A user specified callback is
> called for each ftrace instance in the system, excpet for the top level
> one.
> The implementation of "trace-cmd stat" is modified to use the new API.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/tracefs/tracefs.h           |  1 +
>  lib/tracefs/include/tracefs-local.h |  1 +
>  lib/tracefs/tracefs-events.c        | 14 ++++----
>  lib/tracefs/tracefs-instance.c      | 55 +++++++++++++++++++++++++++++
>  tracecmd/trace-stat.c               | 52 +++++++--------------------
>  utest/tracefs-utest.c               | 52 +++++++++++++++++++++++++++
>  6 files changed, 129 insertions(+), 46 deletions(-)
> 
> diff --git a/include/tracefs/tracefs.h b/include/tracefs/tracefs.h
> index 388d8f94..bcf3dd64 100644
> --- a/include/tracefs/tracefs.h
> +++ b/include/tracefs/tracefs.h
> @@ -32,6 +32,7 @@ int tracefs_instance_file_write(struct tracefs_instance *instance,
>  				const char *file, const char *str);
>  char *tracefs_instance_file_read(struct tracefs_instance *instance,
>  				 char *file, int *psize);
> +int tracefs_instances_walk(int (*callback)(const char *, void *), void *context);
>  
>  bool tracefs_instance_exists(const char *name);
>  bool tracefs_file_exists(struct tracefs_instance *instance, char *name);
> diff --git a/lib/tracefs/include/tracefs-local.h b/lib/tracefs/include/tracefs-local.h
> index fe327a0f..08b67fa9 100644
> --- a/lib/tracefs/include/tracefs-local.h
> +++ b/lib/tracefs/include/tracefs-local.h
> @@ -9,5 +9,6 @@
>  /* Can be overridden */
>  void warning(const char *fmt, ...);
>  int str_read_file(const char *file, char **buffer);
> +char *trace_append_file(const char *dir, const char *name);
>  
>  #endif /* _TRACE_FS_LOCAL_H */
> diff --git a/lib/tracefs/tracefs-events.c b/lib/tracefs/tracefs-events.c
> index 6b796382..f2c6046c 100644
> --- a/lib/tracefs/tracefs-events.c
> +++ b/lib/tracefs/tracefs-events.c
> @@ -210,7 +210,7 @@ static char **add_list_string(char **list, const char *name, int len)
>  	return list;
>  }
>  
> -static char *append_file(const char *dir, const char *name)
> +char *trace_append_file(const char *dir, const char *name)

We should get into the habit of adding "__hidden" to anything that is not
static but also not visible outside the library.

-- Steve


>  {
>  	char *file;
>  	int ret;
> @@ -265,7 +265,7 @@ char **tracefs_event_systems(const char *tracing_dir)
>  	if (!tracing_dir)
>  		return NULL;
>  
> -	events_dir = append_file(tracing_dir, "events");
> +	events_dir = trace_append_file(tracing_dir, "events");
>  	if (!events_dir)
>  		return NULL;
>  
> @@ -290,14 +290,14 @@ char **tracefs_event_systems(const char *tracing_dir)
>  		    strcmp(name, "..") == 0)
>  			continue;
>  
> -		sys = append_file(events_dir, name);
> +		sys = trace_append_file(events_dir, name);
>  		ret = stat(sys, &st);
>  		if (ret < 0 || !S_ISDIR(st.st_mode)) {
>  			free(sys);
>  			continue;
>  		}
>  
> -		enable = append_file(sys, "enable");
> +		enable = trace_append_file(sys, "enable");
>  
>  		ret = stat(enable, &st);
>  		if (ret >= 0)
> @@ -359,7 +359,7 @@ char **tracefs_system_events(const char *tracing_dir, const char *system)
>  		    strcmp(name, "..") == 0)
>  			continue;
>  
> -		event = append_file(system_dir, name);
> +		event = trace_append_file(system_dir, name);
>  		ret = stat(event, &st);
>  		if (ret < 0 || !S_ISDIR(st.st_mode)) {
>  			free(event);
> @@ -401,7 +401,7 @@ char **tracefs_tracers(const char *tracing_dir)
>  	if (!tracing_dir)
>  		return NULL;
>  
> -	available_tracers = append_file(tracing_dir, "available_tracers");
> +	available_tracers = trace_append_file(tracing_dir, "available_tracers");
>  	if (!available_tracers)
>  		return NULL;
>  
> @@ -493,7 +493,7 @@ static int read_header(struct tep_handle *tep, const char *tracing_dir)
>  	int len;
>  	int ret = -1;
>  
> -	header = append_file(tracing_dir, "events/header_page");
> +	header = trace_append_file(tracing_dir, "events/header_page");
>  
>  	ret = stat(header, &st);
>  	if (ret < 0)
> 
