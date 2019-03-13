Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A42C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0631C21019
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 17:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfCMRXr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 13:23:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfCMRXr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 13:23:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C061D21019;
        Wed, 13 Mar 2019 17:23:45 +0000 (UTC)
Date:   Wed, 13 Mar 2019 13:23:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 16/46] tools/lib/traceevent: Man pages for
 tep_register_print_function() and tep_unregister_print_function()
Message-ID: <20190313132344.5f58e940@gandalf.local.home>
In-Reply-To: <20190308133654.21264-17-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-17-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:24 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_register_print_function() and tep_unregister_print_function()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-reg_print_func.txt          | 128 ++++++++++++++++++
>  1 file changed, 128 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
> new file mode 100644
> index 000000000000..59cef18b71f1
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_print_func.txt
> @@ -0,0 +1,128 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_register_print_function,tep_unregister_print_function - Registers / Unregisters
> +a helper function.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +enum *tep_func_arg_type* {
> +	TEP_FUNC_ARG_VOID,
> +	TEP_FUNC_ARG_INT,
> +	TEP_FUNC_ARG_LONG,
> +	TEP_FUNC_ARG_STRING,
> +	TEP_FUNC_ARG_PTR,
> +	TEP_FUNC_ARG_MAX_TYPES
> +};
> +
> +typedef unsigned long long (*pass:[*]tep_func_handler*)(struct trace_seq pass:[*]s, unsigned long long pass:[*]args);
> +
> +int *tep_register_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, enum tep_func_arg_type _ret_type_, char pass:[*]_name_, _..._);
> +int *tep_unregister_print_function*(struct tep_handle pass:[*]_tep_, tep_func_handler _func_, char pass:[*]_name_);
> +--
> +
> +DESCRIPTION
> +-----------
> +Some events may have helper functions in the print format arguments. This allows
> +a plugin to dynamically create a way to process one of these functions.
> +
> +The _tep_register_print_function()_ registers such helper function. The _tep_
> +argument is the trace event parser context. The _func_ argument is the address
> +of the helper function. The _ret_type_ argument is  the return type of the

I would say "The _func_ argument is a pointer to the helper function".

> +helper function, value from the _tep_func_arg_type_ enum. The _name_ is the name
> +of the helper function, as seen in the print format arguments. The _..._ is a
> +variable list of _tep_func_arg_type_ enums, the _func_ function arguments.
> +This list must end with _TEP_FUNC_ARG_VOID_.

We should elaborate more what this is for. Some events have internal
functions called that appear in the print format output. For example,

tracefs/events/i915/g4x_wm/format has:

print fmt: "pipe %c, frame=%u, scanline=%u, wm %d/%d/%d, sr %s/%d/%d/%d, hpll %s/%d/%d/%d, fbc %s", ((REC->pipe) + 'A'), REC->frame, REC->scanline, REC->primary, REC->sprite, REC->cursor, yesno(REC->cxsr), REC->sr_plane, REC->sr_cursor, REC->sr_fbc, yesno(REC->hpll), REC->hpll_plane, REC->hpll_cursor, REC->hpll_fbc, yesno(REC->fbc)

Where inside the kernel they define a function:

static const char *yesno(int x)
{
	static const char *yes = "yes";
	static const char *no = "no";

	return x ? yes : no;
}

Now the event parser has no idea how to handle this "yesno()" function.
But if we have:


static const char *yesno(int x)
{
	return x ? "yes" : "no";
}

tep_register_print_function(tep, yesno, TEP_FUNC_ARG_STRING, "yesno",
				TEP_FUNC_ARG_INT, TEP_FUNC_ARG_VOID);

Then when the parser encounters this "yesno()" function, it will know
how to handle it.

This actually is a good example to use in the man page!

-- Steve

> +
> +The _tep_unregister_print_function()_ unregisters a helper function, previously
> +registered with _tep_register_print_function()_. The _tep_ argument is the
> +trace event parser context. The _func_ and _name_ arguments are the same, used
> +when the helper function was registered.
> +
> +The _tep_func_handler_ is the type of the helper function. The _s_ argument is
> +the trace sequence, it can be used to create a custom string.
> +The _args_  is a list of arguments, defined when the helper function was
> +registered.
> +
> +RETURN VALUE
> +------------
> +The _tep_register_print_function()_ function returns 0 in case of success.
> +In case of an error, TEP_ERRNO_... code is returned.
> +
> +The _tep_unregister_print_function()_ returns 0 in case of success, or -1 in
> +case of an error.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +#include <trace-seq.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +static long long
> +process_custom_helper(struct trace_seq *s, unsigned long long *args)
> +{
> +	unsigned long long param = args[0];
> +	trace_seq_printf(s, "the helper was called, with argument %lld", param);
> +	return 0;
> +}
> +...
> +	if ( tep_register_print_function(tep,
> +				    process_custom_helper,
> +				    TEP_FUNC_ARG_STRING,
> +				    "custom_helper",
> +				    TEP_FUNC_ARG_LONG,
> +				    TEP_FUNC_ARG_VOID) != 0) {
> +		/* Failed to register my process_custom_helper function */
> +	}
> +...
> +	if (tep_unregister_print_function(tep, process_custom_helper,
> +				      	  "custom_helper") != 0) {
> +		/* Failed to unregister my process_custom_helper function */
> +	}
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
> +*trace-seq.h*
> +	Header file to include in order to have access to trace sequences related APIs.
> +	Trace sequences are used to allow a function to call several other functions
> +	to create a string of data to use.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtraceevent(3)_, _trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>, author of *libtraceevent*.
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man page.
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtraceevent is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

