Return-Path: <SRS0=XW/z=Z2=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C32C43603
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 21:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC2102077B
	for <linux-trace-devel@archiver.kernel.org>; Wed,  4 Dec 2019 21:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfLDVKx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 16:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbfLDVKx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 16:10:53 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7BCD2073C;
        Wed,  4 Dec 2019 21:10:51 +0000 (UTC)
Date:   Wed, 4 Dec 2019 16:10:50 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v17 06/18] trace-cmd: Add new library API for reading
 ftrace buffers
Message-ID: <20191204161050.16ab1910@gandalf.local.home>
In-Reply-To: <20191203103522.482684-7-tz.stoyanov@gmail.com>
References: <20191203103522.482684-1-tz.stoyanov@gmail.com>
        <20191203103522.482684-7-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  3 Dec 2019 12:35:10 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new libtracecmd API is introduced:
> 
> 	int tracecmd_iterate_raw_events(struct tep_handle *tep,
> 					struct tracecmd_instance *instance,
> 					int (*callback)(struct tep_event *,
> 						   	struct tep_record *,
> 						   	int, void *context),
> 					void *callback_context);
> 
> It reads events from trace_pipe_raw, per cpu ftrace buffer, and calls a user
> callback for each of them. The API is instance aware.

Hmm, would be good to know what this would be used for.

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  include/trace-cmd/trace-cmd.h |   8 +++
>  lib/trace-cmd/trace-util.c    | 114 ++++++++++++++++++++++++++++++++++
>  2 files changed, 122 insertions(+)
> 
> diff --git a/include/trace-cmd/trace-cmd.h b/include/trace-cmd/trace-cmd.h
> index 5d4292e..831bb1a 100644
> --- a/include/trace-cmd/trace-cmd.h
> +++ b/include/trace-cmd/trace-cmd.h
> @@ -380,6 +380,14 @@ char *tracecmd_read_instance_file(struct tracecmd_instance *instance,
>  
>  void tracecmd_set_clock(struct tracecmd_instance *instance, char **old_clock);
>  
> +int tracecmd_iterate_raw_events(struct tep_handle *tep,
> +				struct tracecmd_instance *instance,
> +				   int (*callback)(struct tep_event *,
> +						   struct tep_record *,
> +						   int, void *context),
> +				void *callback_context);
> +
> +
>  
>  /* --- Plugin handling --- */
>  extern struct tep_plugin_option trace_ftrace_options[];
> diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
> index e019dce..a54a905 100644
> --- a/lib/trace-cmd/trace-util.c
> +++ b/lib/trace-cmd/trace-util.c
> @@ -1185,3 +1185,117 @@ int tracecmd_write_file(const char *file, const char *str, const char *type)
>  	}
>  	return ret;
>  }
> +
> +static int
> +get_events_in_page(struct tep_handle *tep, void *page,
> +		   int size, int cpu,
> +		   int (*callback)(struct tep_event *,
> +				   struct tep_record *,
> +				   int, void *),
> +		   void *callback_context)
> +{
> +	struct tep_record *last_record = NULL;
> +	struct tep_event *event = NULL;
> +	struct tep_record *record;
> +	int id, cnt = 0;
> +
> +	if (size <= 0)
> +		return 0;
> +
> +	while (true) {
> +		event = NULL;
> +		record = tracecmd_read_page_record(tep, page, size,
> +						   last_record);
> +		if (!record)
> +			break;
> +		free_record(last_record);
> +		id = tep_data_type(tep, record);
> +		event = tep_find_event(tep, id);
> +		if (event && callback) {
> +			if (callback(event, record, cpu, callback_context))

Hmm, need to be documented that breaking out of the loop will likely
call future reads to lose events. The records on the page after the
record that causes the break will be lost from future reads.

-- Steve



> +				break;
> +		}
> +		last_record = record;
> +	}
> +	free_record(last_record);
> +
> +	return cnt;
> +}
> +
> +/*
> + * tracecmd_iterate_raw_events - Iterate through events in trace_pipe_raw
> + *				 per CPU trace files
> + * @tep: a handle to the trace event parser context
> + * @instance: ftrace instance, can be NULL for the top instance
> + * @callback: A user function, called for each record from the file.
> + * @callback_context: A custom context, passed to the user callback function
> + *
> + * If the @callback returns non-zero, the iteration stops.
> + *
> + * Returns -1 in case of an error, or 0 otherwise.
> + */
> +int tracecmd_iterate_raw_events(struct tep_handle *tep,
> +				struct tracecmd_instance *instance,
> +				int (*callback)(struct tep_event *,
> +						struct tep_record *,
> +						int, void *),
> +				void *callback_context)
> +{
> +	unsigned int p_size;
> +	struct dirent *dent;
> +	char file[PATH_MAX];
> +	void *page = NULL;
> +	struct stat st;
> +	char *path;
> +	DIR *dir;
> +	int ret;
> +	int cpu;
> +	int fd;
> +	int r;
> +
> +	p_size = getpagesize();
> +	path = tracecmd_get_instance_file(instance, "per_cpu");
> +	if (!path)
> +		return -1;
> +	dir = opendir(path);
> +	if (!dir) {
> +		ret = -1;
> +		goto error;
> +	}
> +	page = malloc(p_size);
> +	if (!page) {
> +		ret = -1;
> +		goto error;
> +	}
> +	while ((dent = readdir(dir))) {
> +		const char *name = dent->d_name;
> +
> +		if (strlen(name) < 4 || strncmp(name, "cpu", 3) != 0)
> +			continue;
> +		cpu = atoi(name + 3);
> +		sprintf(file, "%s/%s", path, name);
> +		ret = stat(file, &st);
> +		if (ret < 0 || !S_ISDIR(st.st_mode))
> +			continue;
> +
> +		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
> +		fd = open(file, O_RDONLY | O_NONBLOCK);
> +		if (fd < 0)
> +			continue;
> +		do {
> +			r = read(fd, page, p_size);
> +			if (r > 0)
> +				get_events_in_page(tep, page, r, cpu,
> +						   callback, callback_context);
> +		} while (r > 0);
> +		close(fd);
> +	}
> +	ret = 0;
> +
> +error:
> +	if (dir)
> +		closedir(dir);
> +	free(page);
> +	tracecmd_put_tracing_file(path);
> +	return ret;
> +}

