Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1081EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 15:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbiAOPMw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 10:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiAOPMw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 10:12:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED10C061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 07:12:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA0B60DBF
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 15:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4E8C36AE7;
        Sat, 15 Jan 2022 15:12:50 +0000 (UTC)
Date:   Sat, 15 Jan 2022 10:12:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 09/25] trace-cmd library: Move CPU flyrecord trace
 metadata into the buffer option, for trace file version 7
Message-ID: <20220115101248.09eca50f@rorschach.local.home>
In-Reply-To: <20211210105448.97850-10-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-10-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:32 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

I'm going to keep mentioning spacing ;-)

> Extended the BUFFER trace option in trace file version 7 with CPU
> flyrecord trace metadata. In the version 6 of the trace file, this metadata
> is located at several places in the file. Part of the metadata is only for
> the top trace instance, thus limiting per-instance configuration. Moving
> all CPU trace related metadata in the BUFFER option simplifies the parsing
> and makes per-instance configuration more flexible. In the new file
> structure, the top instance is treated as any other instances.

space

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
>  lib/trace-cmd/trace-output.c | 191 +++++++++++++++++++++++++----------
>  1 file changed, 137 insertions(+), 54 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index 59093be2..6e40c929 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -1675,7 +1675,7 @@ int tracecmd_append_options(struct tracecmd_output *handle)
>  }
>  
>  static struct tracecmd_option *
> -add_buffer_option(struct tracecmd_output *handle, const char *name, int cpus)
> +add_buffer_option_v6(struct tracecmd_output *handle, const char *name, int cpus)
>  {
>  	struct tracecmd_option *option;
>  	char *buf;
> @@ -1725,8 +1725,11 @@ int tracecmd_write_buffer_info(struct tracecmd_output *handle)
>  	struct tracecmd_option *option;
>  	struct tracecmd_buffer *buf;
>  
> +	if (HAS_SECTIONS(handle))
> +		return 0;
> +
>  	list_for_each_entry(buf, &handle->buffers, list) {
> -		option = add_buffer_option(handle, buf->name, buf->cpus);
> +		option = add_buffer_option_v6(handle, buf->name, buf->cpus);
>  		if (!option)
>  			return -1;
>  		buf->option = option;
> @@ -1777,6 +1780,98 @@ int tracecmd_write_cmdlines(struct tracecmd_output *handle)
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

Why allocate an instance, doesn't:

	tracefs_get_clock(NULL);

do the same? (at least the man page says it does).

Or are you worried that this has to do something with the tracing_dir?
But do we care?

> +	tracefs_instance_free(inst);
> +	return handle->trace_clock;
> +}
> +
> +__hidden struct tracecmd_option *
> +out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,

Again, I think it's safe to remove all the references to v7, and just
have that be the default.

> +			 unsigned short id, unsigned long long data_offset,
> +			 int cpus, struct data_file_write *cpu_data)
> +{
> +	struct tracecmd_option *option;
> +	int i, j = 0, k = 0;
> +	int *cpu_ids = NULL;
> +	struct iovec *vect;
> +	char *clock;
> +
> +	if (!HAS_SECTIONS(handle))
> +		return NULL;
> +
> +	clock = get_clock(handle);
> +
> +	/* Buffer flyrecord option, v7:

Including here (no need to say "v7")

> +	 *  - trace data offset in the file
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

and here.

> +	 *  - trace data offset in the file
> +	 *  - buffer name
> +	 *  - buffer clock
> +	 */
> +
> +	vect = calloc(5 + (cpus * 3), sizeof(struct iovec));

What's with the magical 5 and 3 numbers above?

As from the comments above, I only count 4 and 3.

 4 : offset, name, clock, count
 3 : cpu offset, name, clock

Could include the above in a comment too.

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
>  struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus)
>  {
>  	struct tracecmd_output *handle;
> @@ -1847,8 +1942,8 @@ out:
>  	return ret;
>  }
