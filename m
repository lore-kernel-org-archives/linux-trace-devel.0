Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9009AC433F5
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 14:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbiAOO5M (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 09:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiAOO5K (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 09:57:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC51C061574
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 06:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 238A3B8092C
        for <linux-trace-devel@vger.kernel.org>; Sat, 15 Jan 2022 14:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FE4C36AE7;
        Sat, 15 Jan 2022 14:57:07 +0000 (UTC)
Date:   Sat, 15 Jan 2022 09:57:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v7 07/25] trace-cmd library: Add multiple options
 sections in trace file version 7
Message-ID: <20220115095705.05c80eb9@rorschach.local.home>
In-Reply-To: <20211210105448.97850-8-tz.stoyanov@gmail.com>
References: <20211210105448.97850-1-tz.stoyanov@gmail.com>
        <20211210105448.97850-8-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 10 Dec 2021 12:54:30 +0200
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

Nit, paragraphs should really be separated by spaces ;-)

> Introduced chain of options sections in trace file version 7. Extended
> the "DONE" option to hold the offset into the file to the next options
> section.

> Format of trace file version 7 is extended with a new mandatory field
> after the compression algorithm header:

>  <8 bytes>, unsigned long long integer - offset into the trace file
> where the first options section is located. This allows to place this
> section anywhere in the file. As all other sections have corresponding
> options, describing their offsets into the trace file, this change makes
> the structure of trace file version 7 flexible.

Makes it easier to read. Especially when you get older and your eyes
don't work as well.

> 
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> ---
>  lib/trace-cmd/trace-output.c | 103 ++++++++++++++++++++++++++++++++---
>  1 file changed, 96 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
> index aa55aad7..6e07fece 100644
> --- a/lib/trace-cmd/trace-output.c
> +++ b/lib/trace-cmd/trace-output.c
> @@ -64,7 +64,7 @@ struct tracecmd_output {
>  	unsigned long		file_version;
>  	unsigned long		strings_p;
>  	unsigned long		strings_offs;
> -	size_t			options_start;
> +	tsize_t			options_start;

I have to ask. Why use tsize_t? (I see it used elsewhere as well, but
just really noticed it now)

The only reference to tsize_t I see in the wild is for libtiff.

>  	bool			big_endian;
>  
>  	struct list_head	options;
> @@ -89,6 +89,7 @@ struct list_event_system {
>  
>  #define HAS_SECTIONS(H) ((H)->file_version >= FILE_VERSION_SECTIONS)
>  
> +static int write_options_v7(struct tracecmd_output *handle);

I'm thinking that since v7 will be the main method, we could just
remove all the references to "v7", as we don't know if v8 will use this
as well. That is, the old versions should be labeled as such ("v6"),
but the new versions shouldn't have to be.

>  static int save_string_section(struct tracecmd_output *handle);
>  
>  static stsize_t
> @@ -218,6 +219,9 @@ void tracecmd_output_close(struct tracecmd_output *handle)
>  		return;
>  
>  	if (handle->file_version >= FILE_VERSION_SECTIONS) {
> +		/* write any unsaved options at the end of trace files with sections */
> +		write_options_v7(handle);
> +
>  		/* write strings section */
>  		save_string_section(handle);
>  	}
> @@ -1295,6 +1299,7 @@ int tracecmd_output_set_version(struct tracecmd_output *handle, int file_version
>   */
>  static int output_write_init(struct tracecmd_output *handle)
>  {
> +	unsigned long long offset;
>  	char buf[BUFSIZ];
>  	int endian4;
>  
> @@ -1328,6 +1333,14 @@ static int output_write_init(struct tracecmd_output *handle)
>  	endian4 = convert_endian_4(handle, handle->page_size);
>  	if (do_write_check(handle, &endian4, 4))
>  		return -1;
> +	if (HAS_SECTIONS(handle)) {
> +		/* Write 0 as options offset and save its location */
> +		offset = 0;
> +		handle->options_start = do_lseek(handle, 0, SEEK_CUR);
> +		if (do_write_check(handle, &offset, 8))
> +			return -1;
> +	}
> +
>  	handle->file_state = TRACECMD_FILE_INIT;
>  	return 0;
>  }
> @@ -1396,7 +1409,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
>  	 * We can only add options before tracing data were written.
>  	 * This may change in the future.
>  	 */
> -	if (handle->file_state > TRACECMD_FILE_OPTIONS)
> +	if (!HAS_SECTIONS(handle) && handle->file_state > TRACECMD_FILE_OPTIONS)
>  		return NULL;
>  
>  	for (i = 0; i < count; i++)
> @@ -1409,8 +1422,7 @@ tracecmd_add_option_v(struct tracecmd_output *handle,
>  			return NULL;
>  		}
>  	}
> -
> -	option = malloc(sizeof(*option));
> +	option = calloc(1, sizeof(*option));
>  	if (!option) {
>  		tracecmd_warning("Could not allocate space for option");
>  		free(data);
> @@ -1473,7 +1485,7 @@ int tracecmd_write_cpus(struct tracecmd_output *handle, int cpus)
>  	return 0;
>  }
>  
> -int tracecmd_write_options(struct tracecmd_output *handle)
> +static int write_options_v6(struct tracecmd_output *handle)
>  {
>  	struct tracecmd_option *options;
>  	unsigned short option;
> @@ -1491,7 +1503,7 @@ int tracecmd_write_options(struct tracecmd_output *handle)
>  
>  	if (do_write_check(handle, "options  ", 10))
>  		return -1;
> -
> +	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
>  	list_for_each_entry(options, &handle->options, list) {
>  		endian2 = convert_endian_2(handle, options->id);
>  		if (do_write_check(handle, &endian2, 2))
> @@ -1515,6 +1527,70 @@ int tracecmd_write_options(struct tracecmd_output *handle)
>  		return -1;
>  
>  	handle->file_state = TRACECMD_FILE_OPTIONS;
> +	return 0;
> +}
> +
> +static int write_options_v7(struct tracecmd_output *handle)
> +{
> +	struct tracecmd_option *options;
> +	unsigned long long endian8;
> +	unsigned short endian2;
> +	unsigned int endian4;
> +	bool new = false;
> +	tsize_t offset;
> +
> +	/* Check if there are unsaved options */
> +	list_for_each_entry(options, &handle->options, list) {
> +		if (!options->offset) {
> +			new = true;
> +			break;
> +		}
> +	}
> +
> +	if (!new)
> +		return 0;
> +	offset = do_lseek(handle, 0, SEEK_CUR);

The spacing is backwards above. You can remove the space before the
 "if (!new)" and add one after the if condition.

The if check is the result of the previous loop, and should be
associated with it, just like one would do in any language.

Code spacing is important. It should be used to show how lines of code
are associated with each other, just like paragraphs in text.

> +	/* Append to the previous options section, if any */
> +	if (handle->options_start) {
> +		if (do_lseek(handle, handle->options_start, SEEK_SET) == (off64_t)-1)
> +			return -1;
> +		endian8 = convert_endian_8(handle, offset);
> +		if (do_write_check(handle, &endian8, 8))
> +			return -1;
> +		if (do_lseek(handle, offset, SEEK_SET) == (off_t)-1)
> +			return -1;
> +	}

space

> +	offset = out_write_section_header(handle, TRACECMD_OPTION_DONE, "options", 0, false);
> +	if (offset == (off_t)-1)
> +		return -1;

space.

> +	list_for_each_entry(options, &handle->options, list) {
> +		/* Option is already saved, skip it */
> +		if (options->offset)
> +			continue;
> +		endian2 = convert_endian_2(handle, options->id);
> +		if (do_write_check(handle, &endian2, 2))
> +			return -1;
> +		endian4 = convert_endian_4(handle, options->size);
> +		if (do_write_check(handle, &endian4, 4))
> +			return -1;
> +		/* Save the data location */
> +		options->offset = do_lseek(handle, 0, SEEK_CUR);
> +		if (do_write_check(handle, options->data, options->size))
> +			return -1;
> +	}
> +
> +	endian2 = convert_endian_2(handle, TRACECMD_OPTION_DONE);
> +	if (do_write_check(handle, &endian2, 2))
> +		return -1;
> +	endian4 = convert_endian_4(handle, 8);
> +	if (do_write_check(handle, &endian4, 4))
> +		return -1;
> +	endian8 = 0;
> +	handle->options_start = do_lseek(handle, 0, SEEK_CUR);
> +	if (do_write_check(handle, &endian8, 8))
> +		return -1;
> +	if (out_update_section_header(handle, offset))
> +		return -1;
>  
>  	return 0;
>  }

-- Steve
