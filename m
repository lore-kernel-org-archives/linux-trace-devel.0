Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D32CFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Dec 2021 15:33:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238092AbhLAPgt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 10:36:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbhLAPgs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 10:36:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98BBBB81F4B
        for <linux-trace-devel@vger.kernel.org>; Wed,  1 Dec 2021 15:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECB2C53FCC;
        Wed,  1 Dec 2021 15:33:24 +0000 (UTC)
Date:   Wed, 1 Dec 2021 10:33:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Michael Sartain <mikesart@fastmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd library: Add API to get information from
 trace file
Message-ID: <20211201103322.24146cd5@gandalf.local.home>
In-Reply-To: <20211201022431.64763-1-mikesart@fastmail.com>
References: <20211201022431.64763-1-mikesart@fastmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 30 Nov 2021 19:24:31 -0700
Michael Sartain <mikesart@fastmail.com> wrote:

> New APIs added to get trace cpustats, uname, version strings, and
> cpu file sizes and offsets.

Hi Michael,

Thanks for contributing!

I have some comments below.

> 
>   const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
>   const char *tracecmd_get_uname(struct tracecmd_input *handle);
>   const char *tracecmd_get_version(struct tracecmd_input *handle);
>   unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu);
>   unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);
> 
> Signed-off-by: Michael Sartain <mikesart@fastmail.com>
> ---
>  .../include/private/trace-cmd-private.h       |  6 +++++
>  lib/trace-cmd/trace-input.c                   | 25 +++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 
> diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
> index c58b09e..cd78cc9 100644
> --- a/lib/trace-cmd/include/private/trace-cmd-private.h
> +++ b/lib/trace-cmd/include/private/trace-cmd-private.h
> @@ -90,6 +90,12 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle);
>  void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock);
>  const char *tracecmd_get_trace_clock(struct tracecmd_input *handle);
>  
> +const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
> +const char *tracecmd_get_uname(struct tracecmd_input *handle);
> +const char *tracecmd_get_version(struct tracecmd_input *handle);
> +unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu);
> +unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);

I wonder if we should follow normal standards here and return off64_t type
instead of unsigned long long? As that is what is returned by lseek64().


> +
>  static inline int tracecmd_host_bigendian(void)
>  {
>  	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index ac57bc4..99dbca2 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -4088,6 +4088,31 @@ const char *tracecmd_get_trace_clock(struct tracecmd_input *handle)
>  	return handle->trace_clock;
>  }
>  

For all APIs, we require a "kernel doc" style comment. That is:

/**
 * func_name - one line short description
 * @var1: short description of var1
 * @var2: short description of var2
 *
 * Long description of function, where referencing any variables used
 * still adds the '@', like @var1 is for X and @var2 is for y. Here
 * is where a longer description of the variables can be done too.
 *
 * Returns: Explain what it returns, and if applicable what function needs
 *   to be called to free the return value.
 */

For example, for the below function, you can have something like:

/**
 * tracecmd_get_cpustats - return cpustats of input descriptor
 * @handle: Input descriptor to get cpustats from.
 *
 * Provides a method to extract the cpustats saved in @handle.
 *
 * Returns: The cpustats string saved in the file @handle. The value
 *   returned must not be freed, as it is part of the descriptor, and will
 *   be freed by the destruction of the @handle.
 */
> +const char *tracecmd_get_cpustats(struct tracecmd_input *handle)
> +{
> +	return handle->cpustats;
> +}
> +

And the rest of the functions also need a kernel doc.

Not to mention, we would need to add a man page to describe these too. See
the Documentation/libtracecmd directory for examples.

> +const char *tracecmd_get_uname(struct tracecmd_input *handle)
> +{
> +	return handle->uname;
> +}
> +
> +const char *tracecmd_get_version(struct tracecmd_input *handle)
> +{
> +	return handle->version;
> +}
> +
> +unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu)

   Should be "unsigned int cpu"

> +{
> +	return (cpu < handle->cpus) ? handle->cpu_data[cpu].file_offset : 0;

Otherwise if we pass in -1 then the above would return handle->cpu_data[-1]

> +}
> +
> +unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu)
> +{
> +	return (cpu < handle->cpus) ? handle->cpu_data[cpu].file_size : 0;

Same here.


> +}
> +
>  /**
>   * tracecmd_get_show_data_func - return the show data func
>   * @handle: input handle for the trace.dat file

Anyway, welcome to our community Michael!

-- Steve
