Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,TRACKER_ID,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3400C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 21:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3163610CE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 15 Apr 2021 21:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhDOVTN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 15 Apr 2021 17:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235866AbhDOVTL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 15 Apr 2021 17:19:11 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5339760E0C;
        Thu, 15 Apr 2021 21:18:47 +0000 (UTC)
Date:   Thu, 15 Apr 2021 17:18:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] trace-cmd: Get the timestamp of the first recorded
 event as TSC offset
Message-ID: <20210415171845.3e6ee0d8@gandalf.local.home>
In-Reply-To: <20210415081527.3483835-5-tz.stoyanov@gmail.com>
References: <20210415081527.3483835-1-tz.stoyanov@gmail.com>
        <20210415081527.3483835-5-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 15 Apr 2021 11:15:27 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:


> @@ -4183,7 +4156,100 @@ static void add_options(struct tracecmd_output *handle, struct common_record_con
>  	free(clocks);
>  }
>  
> -static void write_guest_file(struct buffer_instance *instance)
> +int get_first_ts(char *file, unsigned long long *ts)

		 const char *file,

> +{
> +	enum kbuffer_long_size long_size;
> +	enum kbuffer_endian endian;
> +	struct kbuffer *kbuf = NULL;
> +	int psize, rsize;
> +	char *page = NULL;
> +	int ret = -1;
> +	char *data;
> +	int fd;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		return -1;
> +
> +	psize = getpagesize();
> +	page = calloc(1, psize);
> +	if (!page)
> +		goto error;
> +
> +	rsize = read(fd, page, psize);
> +	if (rsize <= 0)
> +		goto error;
> +

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

> +	if (tracecmd_host_bigendian())
> +		endian = KBUFFER_ENDIAN_BIG;
> +	else
> +		endian = KBUFFER_ENDIAN_LITTLE;
> +	if (sizeof(long) == 8)
> +		long_size = KBUFFER_LSIZE_8;
> +	else
> +		long_size = KBUFFER_LSIZE_4;
> +
> +	kbuf = kbuffer_alloc(long_size, endian);
> +	if (!kbuf)
> +		goto error;

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The above should be moved into the calling function. The
kbuffer_load_subbuffer() will reset the kbuf. No need to constantly
allocate it and set it up each time.


> +
> +	kbuffer_load_subbuffer(kbuf, page);
> +	if (kbuffer_subbuffer_size(kbuf) > rsize)
> +		goto error;
> +
> +	data = kbuffer_read_event(kbuf, ts);
> +	if (!data)
> +		goto error;
> +
> +	ret = 0;
> +error:
> +	if (kbuf)
> +		kbuffer_free(kbuf);
> +	free(page);
> +	close(fd);
> +	return ret;
> +}
> +
> +void get_first_ts_instance(struct buffer_instance *instance)
> +{
> +	struct tracecmd_ts_corrections corrections;
> +	unsigned long long first_ts = 0;

I wouldn't use first_ts as the check to start. What happens if the first_ts
is actually zero?

use bool first = true; or something.

> +	unsigned long long ts;
> +	unsigned int flags;
> +	int first_ts_cpu;
> +	char *file;
> +	int ret;
> +	int i;
> +

	if (tracecmd_host_bigendian())
		endian = KBUFFER_ENDIAN_BIG;
	else
		endian = KBUFFER_ENDIAN_LITTLE;
	if (sizeof(long) == 8)
		long_size = KBUFFER_LSIZE_8;
	else
		long_size = KBUFFER_LSIZE_4;

	kbuf = kbuffer_alloc(long_size, endian);
	if (!kbuf)
		goto return;

And shouldn't this be returning these errors? Do we really want to continue
if this doesn't work?

> +	for (i = 0; i < instance->cpu_count; i++) {
> +		file = get_temp_file(instance, i);
> +		if (!file)
> +			continue;
> +		if (!get_first_ts(file, &ts)) {

		if (!get_first_ts(kbuf, file, &ts)) {

> +			if (!first_ts || ts < first_ts) {

			if (first || ts < first_ts) {
				first = false;

> +				first_ts = ts;
> +				first_ts_cpu = i;
> +			}
> +		}
> +		put_temp_file(file);
> +	}

No need to check if kbuf is not NULL, kbuffer_free() handles that.

	kbuffer_free(kbuf);


> +	if (first_ts) {

	if (!first) {

> +		if (is_guest(instance)) {
> +			ret = tracecmd_tsync_get_proto_flags(instance->tsync, &flags);
> +			if (ret)
> +				return;
> +			ret =  tracecmd_tsync_get_offsets(instance->tsync, first_ts_cpu, &corrections);
> +			if (ret)
> +				return;
> +			instance->first_ts = tracecmd_guest_ts_calc(first_ts, &corrections, flags);
> +			free(corrections.ts_samples);
> +		} else  {
> +			instance->first_ts = first_ts;
> +		}
> +	}
> +}
> +
> +static void write_guest_file(struct common_record_context *ctx, struct buffer_instance *instance)
>  {
>  	struct tracecmd_output *handle;
>  	int cpu_count = instance->cpu_count;
> @@ -4201,6 +4267,12 @@ static void write_guest_file(struct buffer_instance *instance)
>  		die("error writing to %s", file);
>  	if (instance->flags & BUFFER_FL_TSC2NSEC)
>  		tracecmd_set_out_clock(handle, TSCNSEC_CLOCK);
> +
> +	if (ctx->tsc2nsec.mult)
> +		add_tsc2nsec(handle, &ctx->tsc2nsec);
> +	tracecmd_write_guest_time_shift(handle, instance->tsync);
> +	tracecmd_append_options(handle);
> +
>  	temp_files = malloc(sizeof(*temp_files) * cpu_count);
>  	if (!temp_files)
>  		die("failed to allocate temp_files for %d cpus",
> @@ -4219,6 +4291,9 @@ static void write_guest_file(struct buffer_instance *instance)
>  	for (i = 0; i < cpu_count; i++)
>  		put_temp_file(temp_files[i]);
>  	free(temp_files);
> +
> +	tracecmd_tsync_free(instance->tsync);
> +	instance->tsync = NULL;
>  }
>  
>  static void record_data(struct common_record_context *ctx)
> @@ -4231,9 +4306,18 @@ static void record_data(struct common_record_context *ctx)
>  	char **temp_files;
>  	int i;
>  
> +	if (ctx->tsc2nsec.mult) {
> +		for_all_instances(instance) {
> +			get_first_ts_instance(instance);

Should check the return code, and at least warn if it fails. As it is done
after the recording, we don't want to die. But at least let the user know
something went wrong.

-- Steve

> +			if (instance->first_ts &&
> +			    (!ctx->tsc2nsec.offset || ctx->tsc2nsec.offset > instance->first_ts))
> +				ctx->tsc2nsec.offset = instance->first_ts;
> +		}
> +	}
> +
>  	for_all_instances(instance) {
>  		if (is_guest(instance))
> -			write_guest_file(instance);
> +			write_guest_file(ctx, instance);
>  		else if (host && instance->msg_handle)
>  			finish_network(instance->msg_handle);
>  		else

