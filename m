Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E48C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 16:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 214F8613CB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 16:01:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346148AbhDFQBc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 12:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231787AbhDFQBb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 12:01:31 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D0D613C2;
        Tue,  6 Apr 2021 16:01:22 +0000 (UTC)
Date:   Tue, 6 Apr 2021 12:01:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] libtracefs: Iterate over raw events in sorted order
Message-ID: <20210406120120.24b40829@gandalf.local.home>
In-Reply-To: <20210406042001.912544-2-tz.stoyanov@gmail.com>
References: <20210406042001.912544-1-tz.stoyanov@gmail.com>
        <20210406042001.912544-2-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue,  6 Apr 2021 07:19:58 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> +static int read_kbuf_record(struct cpu_iterate *cpu)
>  {
>  	unsigned long long ts;
>  	void *ptr;
>  
> -	ptr = kbuffer_read_event(kbuf, &ts);
> -	if (!ptr || !record)
> +	if (!cpu || !cpu->kbuf)
> +		return -1;
> +	ptr = kbuffer_read_event(cpu->kbuf, &ts);
> +	if (!ptr)
>  		return -1;
>  
> -	memset(record, 0, sizeof(*record));
> -	record->ts = ts;
> -	record->size = kbuffer_event_size(kbuf);
> -	record->record_size = kbuffer_curr_size(kbuf);
> -	record->cpu = 0;
> -	record->data = ptr;
> -	record->ref_count = 1;
> +	memset(&(cpu->record), 0, sizeof(cpu->record));

No need for the parenthesis after the ampersand.

	memset(&cpu->record, 0, sizeof(cpu->record));

works the same.

> +	cpu->record.ts = ts;
> +	cpu->record.size = kbuffer_event_size(cpu->kbuf);
> +	cpu->record.record_size = kbuffer_curr_size(cpu->kbuf);
> +	cpu->record.cpu = cpu->cpu;
> +	cpu->record.data = ptr;
> +	cpu->record.ref_count = 1;
>  
> -	kbuffer_next_event(kbuf, NULL);
> +	kbuffer_next_event(cpu->kbuf, NULL);
>  
>  	return 0;
>  }
>  
> -static int
> -get_events_in_page(struct tep_handle *tep, void *page,
> -		   int size, int cpu,
> -		   int (*callback)(struct tep_event *,
> -				   struct tep_record *,
> -				   int, void *),
> -		   void *callback_context)
> +int read_next_page(struct tep_handle *tep, struct cpu_iterate *cpu)
>  {
> -	struct tep_record record;
> -	struct tep_event *event;
> -	struct kbuffer *kbuf;
> -	int id, cnt = 0;
> +	cpu->rsize = read(cpu->fd, cpu->page, cpu->psize);
> +	if (cpu->rsize <= 0)
> +		return -1;
> +
> +	cpu->kbuf = page_to_kbuf(tep, cpu->page, cpu->rsize);
> +	if (!cpu->kbuf)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +int read_next_record(struct tep_handle *tep, struct cpu_iterate *cpu)
> +{
> +	int id;
> +
> +	do {
> +		while (!read_kbuf_record(cpu)) {
> +			id = tep_data_type(tep, &(cpu->record));
> +			cpu->event = tep_find_event(tep, id);
> +			if (cpu->event)
> +				return 0;
> +		}
> +	} while (!read_next_page(tep, cpu));
> +
> +	return -1;
> +}
> +
> +static int read_cpu_pages(struct tep_handle *tep, struct cpu_iterate *cpus, int count,
> +			  int (*callback)(struct tep_event *,
> +					  struct tep_record *,
> +					  int, void *),
> +			  void *callback_context)
> +{
> +	bool has_data = false;
>  	int ret;
> +	int i, j;
>  
> -	if (size <= 0)
> -		return 0;
> +	for (i = 0; i < count; i++) {
> +		ret = read_next_record(tep, cpus + i);
> +		if (!ret)
> +			has_data = true;
> +	}
>  
> -	kbuf = page_to_kbuf(tep, page, size);
> -	if (!kbuf)
> -		return 0;
> -
> -	ret = read_kbuf_record(kbuf, &record);
> -	while (!ret) {
> -		id = tep_data_type(tep, &record);
> -		event = tep_find_event(tep, id);
> -		if (event) {
> -			cnt++;
> +	while (has_data) {
> +		j = count;
> +		for (i = 0; i < count; i++) {
> +			if (!cpus[i].event)
> +				continue;
> +			if (j == count || cpus[j].record.ts > cpus[i].record.ts)
> +				j = i;
> +		}
> +		if (j < count) {
>  			if (callback &&

This was already there, but there's no need to test if callback exists,
because that was already done by the calling function.

> -			    callback(event, &record, cpu, callback_context))
> +			    callback(cpus[j].event, &(cpus[j].record), cpus[j].cpu, callback_context))

Again, no need for the parenthesis around &cpus[j].record.

>  				break;
> +			cpus[j].event = NULL;
> +			read_next_record(tep, cpus + j);
> +		} else {
> +			has_data = false;
>  		}
> -		ret = read_kbuf_record(kbuf, &record);
>  	}
>  
> -	kbuffer_free(kbuf);
> -
> -	return cnt;
> +	return 0;
>  }
>  
> -/*
> - * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
> - *				per CPU trace buffers
> - * @tep: a handle to the trace event parser context
> - * @instance: ftrace instance, can be NULL for the top instance
> - * @cpus: Iterate only through the buffers of CPUs, set in the mask.
> - *	  If NULL, iterate through all CPUs.
> - * @cpu_size: size of @cpus set
> - * @callback: A user function, called for each record from the file
> - * @callback_context: A custom context, passed to the user callback function
> - *
> - * If the @callback returns non-zero, the iteration stops - in that case all
> - * records from the current page will be lost from future reads
> - *
> - * Returns -1 in case of an error, or 0 otherwise
> - */
> -int tracefs_iterate_raw_events(struct tep_handle *tep,
> -				struct tracefs_instance *instance,
> -				cpu_set_t *cpus, int cpu_size,
> -				int (*callback)(struct tep_event *,
> -						struct tep_record *,
> -						int, void *),
> -				void *callback_context)
> +static int open_cpu_fies(struct tracefs_instance *instance, cpu_set_t *cpus,

What's "fies"?

> +			 int cpu_size, struct cpu_iterate **all_cpus, int *count)
>  {
> +	struct cpu_iterate *tmp;
>  	unsigned int p_size;
>  	struct dirent *dent;
>  	char file[PATH_MAX];
> -	void *page = NULL;
>  	struct stat st;
> +	int ret = -1;
> +	int fd = -1;
>  	char *path;
>  	DIR *dir;
> -	int ret;
>  	int cpu;
> -	int fd;
> -	int r;
> +	int i = 0;
>  
> -	if (!tep || !callback)
> -		return -1;
> -
> -	p_size = getpagesize();
>  	path = tracefs_instance_get_file(instance, "per_cpu");
>  	if (!path)
>  		return -1;
>  	dir = opendir(path);
> -	if (!dir) {
> -		ret = -1;
> -		goto error;
> -	}
> -	page = malloc(p_size);
> -	if (!page) {
> -		ret = -1;
> -		goto error;
> -	}
> +	if (!dir)
> +		goto out;
> +	p_size = getpagesize();
>  	while ((dent = readdir(dir))) {
>  		const char *name = dent->d_name;
>  
> @@ -174,32 +184,88 @@ int tracefs_iterate_raw_events(struct tep_handle *tep,
>  		if (cpus && !CPU_ISSET_S(cpu, cpu_size, cpus))
>  			continue;
>  		sprintf(file, "%s/%s", path, name);
> -		ret = stat(file, &st);
> -		if (ret < 0 || !S_ISDIR(st.st_mode))
> +		if (stat(file, &st) < 0 || !S_ISDIR(st.st_mode))
>  			continue;
>  
>  		sprintf(file, "%s/%s/trace_pipe_raw", path, name);
>  		fd = open(file, O_RDONLY | O_NONBLOCK);
>  		if (fd < 0)
>  			continue;
> -		do {
> -			r = read(fd, page, p_size);
> -			if (r > 0)
> -				get_events_in_page(tep, page, r, cpu,
> -						   callback, callback_context);
> -		} while (r > 0);
> -		close(fd);
> +		tmp = realloc(*all_cpus, (i + 1) * sizeof(struct cpu_iterate));
> +		if (!tmp) {
> +			close(fd);
> +			goto out;
> +		}
> +		memset(tmp + i, 0, sizeof(struct cpu_iterate));
> +		tmp[i].fd = fd;
> +		tmp[i].cpu = cpu;
> +		tmp[i].page =  malloc(p_size);
> +		tmp[i].psize = p_size;
> +		*all_cpus = tmp;
> +		*count = i + 1;
> +		if (!tmp[i++].page)
> +			goto out;
>  	}
> +
>  	ret = 0;
>  
> -error:
> +out:
>  	if (dir)
>  		closedir(dir);
> -	free(page);
>  	tracefs_put_tracing_file(path);
>  	return ret;
>  }
>  
> +/*
> + * tracefs_iterate_raw_events - Iterate through events in trace_pipe_raw,
> + *				per CPU trace buffers
> + * @tep: a handle to the trace event parser context
> + * @instance: ftrace instance, can be NULL for the top instance
> + * @cpus: Iterate only through the buffers of CPUs, set in the mask.
> + *	  If NULL, iterate through all CPUs.
> + * @cpu_size: size of @cpus set
> + * @callback: A user function, called for each record from the file
> + * @callback_context: A custom context, passed to the user callback function
> + *
> + * If the @callback returns non-zero, the iteration stops - in that case all
> + * records from the current page will be lost from future reads
> + * The events are iterated in sorted order, oldest first.
> + *
> + * Returns -1 in case of an error, or 0 otherwise
> + */
> +int tracefs_iterate_raw_events(struct tep_handle *tep,
> +				struct tracefs_instance *instance,
> +				cpu_set_t *cpus, int cpu_size,
> +				int (*callback)(struct tep_event *,
> +						struct tep_record *,
> +						int, void *),
> +				void *callback_context)
> +{
> +	struct cpu_iterate *all_cpus = NULL;
> +	int count = 0;
> +	int ret;
> +	int i;
> +
> +	if (!tep || !callback)
> +		return -1;
> +
> +	ret = open_cpu_fies(instance, cpus, cpu_size, &all_cpus, &count);

Do you mean "files"?

-- Steve

> +	if (ret < 0)
> +		goto out;
> +	ret = read_cpu_pages(tep, all_cpus, count, callback, callback_context);
> +
> +out:
> +	if (all_cpus) {
> +		for (i = 0; i < count; i++) {
> +			close(all_cpus[i].fd);
> +			free(all_cpus[i].page);
> +		}
> +		free(all_cpus);
> +	}
> +
> +	return ret;
> +}
> +
>  static char **add_list_string(char **list, const char *name, int len)
>  {
>  	if (!list)

