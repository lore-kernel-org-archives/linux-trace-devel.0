Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2016C4338F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 17:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD7A2610A3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 19 Aug 2021 17:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbhHSRyB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 13:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232481AbhHSRxy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 13:53:54 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E54C46109F;
        Thu, 19 Aug 2021 17:53:17 +0000 (UTC)
Date:   Thu, 19 Aug 2021 13:53:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 34/87] trace-cmd library: Introduce sections in trace
 file reading logic
Message-ID: <20210819135311.1cc2601b@oasis.local.home>
In-Reply-To: <20210729050959.12263-35-tz.stoyanov@gmail.com>
References: <20210729050959.12263-1-tz.stoyanov@gmail.com>
        <20210729050959.12263-35-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 29 Jul 2021 08:09:06 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> Trace file version 7 is based on sections. Added an internal sections
> database and new helper functions to add, read, open and close file
> sections.
> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-input.c | 71 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index 6872f6ef..e8eefb5c 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -114,6 +114,14 @@ struct tsc2nsec {
>  	unsigned long long offset;
>  };
>  
> +struct file_section {
> +	int				id;
> +	unsigned long long		section_offset;
> +	unsigned long long		data_offset;

Should we have a size too?

> +	enum tracecmd_section_flags	flags;
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
> @@ -411,6 +420,61 @@ __hidden int in_uncompress_block(struct tracecmd_input *handle)
>  	return ret;
>  }
>  
> +static struct file_section *get_section(struct tracecmd_input *handle, int id)
> +{
> +	struct file_section *sec = handle->sections;
> +
> +	while (sec) {
> +		if (sec->id == id)
> +			return sec;
> +		sec = sec->next;
> +	}

The above could be a simple for loop.

	for (sec = handle->sections; sec; sec = sec->next) {
		if (sec->id == id);
			return sec;
	}


> +	return NULL;
> +}
> +
> +static struct file_section *open_section(struct tracecmd_input *handle, int id)

I wonder if we should change the names to "section_open()", "section_close()" ...

This way the prefix "section_" is know to be a command for handling sections.

> +{
> +	struct file_section *sec = get_section(handle, id);
> +
> +	if (!sec)
> +		return NULL;
> +
> +	if (lseek64(handle->fd, sec->data_offset, SEEK_SET) == (off64_t)-1)
> +		return NULL;
> +	if ((sec->flags & TRACECMD_SEC_FL_COMPRESS) && in_uncompress_block(handle))
> +		return NULL;
> +	return sec;
> +}
> +
> +static void close_section(struct tracecmd_input *handle, struct file_section *sec)
> +{
> +	if (sec->flags & TRACECMD_SEC_FL_COMPRESS)
> +		in_uncompress_reset(handle);
> +}
> +
> +static int add_section(struct tracecmd_input *handle, int id, int flags,
> +		       unsigned long long soffset, unsigned long long doffset)

I'm still not sure what "soffest' is compared to "doffset".

> +{
> +	struct file_section *sec = get_section(handle, id);
> +
> +	if (!sec) {
> +		sec = calloc(1, sizeof(struct file_section));
> +		if (!sec)
> +			return -1;
> +		sec->next = handle->sections;
> +		handle->sections = sec;
> +	}

Hmm, we should probably have an "add" and "update" because blindly
changing an existing section may not be what was expected. That is,
going with the "section_" prefix.

section_add(...) 

Would error if it already exists.

section_update(..)

Would expect it to already exist.

Could have an:

section_add_or_update(...)

Which would be the above, and lets the caller know that it will ether
add the section, or update it.

-- Steve


> +	sec->id = id;
> +	if (soffset)
> +		sec->section_offset = soffset;
> +	if (doffset)
> +		sec->data_offset = doffset;
> +	if (flags > 0)
> +		sec->flags = flags;
> +	return 0;
> +}
> +
> +
>  static int read_header_files(struct tracecmd_input *handle)
>  {
>  	struct tep_handle *pevent = handle->pevent;
> @@ -3522,6 +3586,7 @@ void tracecmd_ref(struct tracecmd_input *handle)
>   */
>  void tracecmd_close(struct tracecmd_input *handle)
>  {
> +	struct file_section *del_sec;
>  	int i;
>  
>  	if (!handle)
> @@ -3560,6 +3625,11 @@ void tracecmd_close(struct tracecmd_input *handle)
>  	free(handle->version);
>  	close(handle->fd);
>  
> +	while (handle->sections) {
> +		del_sec = handle->sections;
> +		handle->sections = handle->sections->next;
> +		free(del_sec);
> +	}
>  	for (i = 0; i < handle->nr_buffers; i++)
>  		free(handle->buffers[i].name);
>  
> @@ -4006,6 +4076,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
>  	new_handle->nr_buffers = 0;
>  	new_handle->buffers = NULL;
>  	new_handle->version = NULL;
> +	new_handle->sections = NULL;
>  	new_handle->guest = NULL;
>  	new_handle->ref = 1;
>  	if (handle->trace_clock) {

