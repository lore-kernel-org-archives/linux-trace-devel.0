Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5FEC4320A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 15:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0BCC6102A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 15:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbhHQPmT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 11:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238459AbhHQPlS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 11:41:18 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F251760FD7;
        Tue, 17 Aug 2021 15:40:44 +0000 (UTC)
Date:   Tue, 17 Aug 2021 11:40:38 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 28/87] trace-cmd library: Move CPU flyrecord trace
 metadata into the buffer option, for trace file version 7
Message-ID: <20210817114038.2a163dc2@oasis.local.home>
In-Reply-To: <20210729050959.12263-29-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-29-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:00 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Extended the BUFFER trace option in trace file version 7 with CPU
> flyrecord trace metadata. In the version 6 of the trace file, this metadata
> is located at several places in the file. Part of the metadata is only for
> the top trace instance, thus limiting per-instance configuration. Moving
> all CPU trace related metadata in the BUFFER option simplifies the parsing
> and makes per-instance configuration more flexible. In the new file
> structure, the top instance is treated as any other instances.
> The format of the extended BUFFER option is:
>  - offset of the buffer in the trace file
>  - name of the buffer
>  - trace clock, used in this buffer for events timestamps
>  - count of CPUs with trace data
>  - array, describing each CPU with trace data:
>    - CPU id
>    - offset of CPU trace data in the trace file
>    - size of the recorded CPU trace data
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-output.c | 171 ++++++++++++++++++++++++++---------
>  1 file changed, 127 insertions(+), 44 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index d60bd456..21555d6d 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -1826,7 +1826,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
>  }
>  
>  static struct tracecmd_option *
> -add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
> +add_buffer_option_v6(struct tracecmd_output *handle, const char *name, int cpus)
>  {
>  	struct tracecmd_option *option;
>  	char *buf;
> @@ -1876,8 +1876,11 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
>  	struct tracecmd_option *option;
>  	struct tracecmd_buffer *buf;
>  
> +	if (handle->file_version >= 7)
> +		return 0;
> +
>  	list_for_each_entry(buf, &handle->buffers, list) {
> -		option = add_buffer_option(handle, buf->name, buf->cpus);
> +		option = add_buffer_option_v6(handle, buf->name, buf->cpus);
>  		if (!option)
>  			return -1;
>  		buf->option = option;
> @@ -1938,6 +1941,98 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
>  	return 0;
>  }
>  
> +static char *get_clock(struct tracecmd_output *handle)
> +{
> +	struct tracefs_instance *inst;
> +
> +	if (handle->trace_clock)
> +		return handle->trace_clock;
> +
> +	/*
> +	 * If no clock is set on this handle, get the trace clock of
> +	 * the top instance in the handle's tracing dir
> +	 */
> +	inst = tracefs_instance_alloc(handle->tracing_dir, NULL);
> +	if (!inst)
> +		return NULL;
> +	handle->trace_clock = tracefs_get_clock(inst);
> +	tracefs_instance_free(inst);
> +	return handle->trace_clock;
> +}
> +
> +__hidden struct tracecmd_option *
> +out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
> +			 unsigned short id, unsigned long long data_offset,
> +			 int cpus, struct data_file_write *cpu_data)


Why is this hidden, and not static?

I noticed that you are using "out_" as a normal prefix. Is that really
needed?


> +{
> +	struct tracecmd_option *option;
> +	int i, j = 0, k = 0;
> +	int *cpu_ids = NULL;
> +	struct iovec *vect;
> +	char *clock;
> +
> +	if (handle->file_version < 7)
> +		return NULL;
> +
> +	clock = get_clock(handle);
> +
> +	/* Buffer flyrecord option, v7:

Nit, for consistency, use:

	/*
	 * Buffer flyrecord option, v7:

> +	 *  - trace data offset in the file

Is the above the "meta data". If so, perhaps we should call it that.

> +	 *  - buffer name
> +	 *  - buffer clock
> +	 *  - CPU count
> +	 *  - for each CPU:
> +	 *    - CPU id
> +	 *    - CPU trace data offset in the file
> +	 *    - CPU trace data size
> +	 */
> +
> +	/* Buffer latency option, v7:
> +	 *  - trace data offset in the file

Is this the actual latency?

> +	 *  - buffer name
> +	 *  - buffer clock
> +	 */
> +
> +	vect = calloc(5 + (cpus * 3), sizeof(struct iovec));

Comment what these magic numbers are: 5 and 3.

-- Steve

> +	if (!vect)
> +		return NULL;
> +	if (cpus) {
> +		cpu_ids = calloc(cpus, sizeof(int));
> +		if (!cpu_ids) {
> +			free(vect);
> +			return NULL;
> +		}
> +	}
> +	vect[j].iov_base = (void *) &data_offset;
> +	vect[j++].iov_len = 8;
> +	vect[j].iov_base = (void *) name;
> +	vect[j++].iov_len = strlen(name) + 1;
> +	vect[j].iov_base = (void *) clock;
> +	vect[j++].iov_len = strlen(clock) + 1;
> +	if (id == TRACECMD_OPTION_BUFFER) {
> +		vect[j].iov_base = (void *) &k;
> +		vect[j++].iov_len = 4;
> +		for (i = 0; i < cpus; i++) {
> +			if (!cpu_data[i].file_size)
> +				continue;
> +			cpu_ids[i] = i;
> +			vect[j].iov_base = &cpu_ids[i];
> +			vect[j++].iov_len = 4;
> +			vect[j].iov_base = &cpu_data[i].data_offset;
> +			vect[j++].iov_len = 8;
> +			vect[j].iov_base = &cpu_data[i].write_size;
> +			vect[j++].iov_len = 8;
> +			k++;
> +		}
> +	}
> +
> +	option = tracecmd_add_option_v(handle, id, vect, j);
> +	free(vect);
> +	free(cpu_ids);
> +
> +	return option;
> +}
> +
