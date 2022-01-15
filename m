Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F07FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 15:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbiAOP17 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 10:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiAOP17 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 10:27:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FD9C061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 07:27:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9ABFB80928
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 15:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F239C36AE7;
        Sat, 15 Jan 2022 15:27:56 +0000 (UTC)
Date:   Sat, 15 Jan 2022 10:27:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 13/25] trace-cmd library: Introduce sections in trace
 file reading logic
Message-ID: <20220115102754.581486d9@rorschach.local.home>
In-Reply-To: <20211210105448.97850-14-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-14-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:36 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Trace file version 7 is based on sections. Added an internal sections
> database and new helper functions to add, read, open and close file
> sections.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 69 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 0375afba..78f9effd 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -115,6 +115,14 @@ struct tsc2nsec {
>  	unsigned long long offset;
>  };
>  
> +struct file_section {
> +	unsigned long long		section_offset;
> +	unsigned long long		data_offset;
> +	int				id;
> +	int				flags;
> +	struct file_section		*next;
> +};
> +
>  struct tracecmd_input {
>  	struct tep_handle	*pevent;
>  	unsigned long		file_state;
> @@ -154,6 +162,7 @@ struct tracecmd_input {
>  	struct hook_list	*hooks;
>  	struct pid_addr_maps	*pid_maps;
>  	/* file information */
> +	struct file_section	*sections;
>  	size_t			header_files_start;
>  	size_t			ftrace_files_start;
>  	size_t			event_files_start;
> @@ -377,6 +386,58 @@ static int read8(struct tracecmd_input *handle, unsigned long long *size)
>  	return 0;
>  }
>  
> +static struct file_section *section_get(struct tracecmd_input *handle, int id)
> +{
> +	struct file_section *sec;
> +
> +	for (sec = handle->sections; sec; sec = sec->next) {
> +		if (sec->id == id)
> +			return sec;
> +	}
> +
> +	return NULL;
> +}
> +
> +static struct file_section *section_open(struct tracecmd_input *handle, int id)
> +{
> +	struct file_section *sec = section_get(handle, id);
> +
> +	if (!sec)
> +		return NULL;
> +
> +	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
> +		return NULL;
> +	return sec;
> +}
> +
> +static void section_close(struct tracecmd_input *handle, struct file_section *sec)
> +{
> +	/* To Do */
> +}
> +
> +static int section_add_or_update(struct tracecmd_input *handle, int id, int flags,
> +				 unsigned long long section_offset,
> +				 unsigned long long data_offset)
> +{
> +	struct file_section *sec = section_get(handle, id);
> +
> +	if (!sec) {
> +		sec = calloc(1, sizeof(struct file_section));
> +		if (!sec)
> +			return -1;
> +		sec->next = handle->sections;
> +		handle->sections = sec;
> +	}
> +	sec->id = id;

Could move the above into the previous if block. As it's only to be
updated if it wasn't already found (with the id).

> +	if (section_offset)
> +		sec->section_offset = section_offset;
> +	if (data_offset)
> +		sec->data_offset = data_offset;
> +	if (flags > 0)

Why the greater than zero check?

Is there a way to clear flags?

> +		sec->flags = flags;
> +	return 0;
> +}

-- Steve

> +
>  static int read_header_files(struct tracecmd_input *handle)
>  {
>  	struct tep_handle *pevent = handle->pevent;
> @@ -3493,6 +3554,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
>   */
>  void tracecmd_close(struct tracecmd_input *handle)
>  {
> +	struct file_section *del_sec;
>  	int cpu;
>  	int i;
>  
> @@ -3532,6 +3594,12 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	free(handle->version);
>  	close(handle->fd);
>  
> +	while (handle->sections) {
> +		del_sec = handle->sections;
> +		handle->sections = handle->sections->next;
> +		free(del_sec);
> +	}
> +
>  	for (i = 0; i < handle->nr_buffers; i++)
>  		free(handle->buffers[i].name);
>  	free(handle->buffers);
> @@ -3976,6 +4044,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
>  	new_handle->nr_buffers = 0;
>  	new_handle->buffers = NULL;
>  	new_handle->version = NULL;
> +	new_handle->sections = NULL;
>  	new_handle->guest = NULL;
>  	new_handle->ref = 1;
>  	if (handle->trace_clock) {

