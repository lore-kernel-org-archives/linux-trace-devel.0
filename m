Return-Path: <SRS0=PQ4s=S4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB101C43218
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:49:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B960320878
	for <linux-trace-devel@archiver.kernel.org>; Fri, 26 Apr 2019 02:49:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbfDZCt7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 22:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728983AbfDZCt7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 22:49:59 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA3272084F;
        Fri, 26 Apr 2019 02:49:57 +0000 (UTC)
Date:   Thu, 25 Apr 2019 22:49:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 11/30] tools/lib/traceevent: Man pages for event
 handler APIs
Message-ID: <20190425224956.381d866e@oasis.local.home>
In-Reply-To: <20190412133811.15878-12-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-12-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:52 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for libtraceevent APIs:
>   tep_register_event_handler()
>   tep_unregister_event_handler()
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-reg_event_handler.txt       | 131 ++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
> new file mode 100644
> index 000000000000..8b1b75da7628
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_event_handler.txt
> @@ -0,0 +1,131 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_register_event_handler, tep_unregister_event_handler -  Register /
> +unregisters a callback function to parse an event information.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +enum *tep_reg_handler* {
> +	_TEP_REGISTER_SUCCESS_,
> +	_TEP_REGISTER_SUCCESS_OVERWRITE_,
> +};
> +
> +int *tep_register_event_handler*(struct tep_handle pass:[*]_tep_, int _id_, const char pass:[*]_sys_name_, const char pass:[*]_event_name_, tep_event_handler_func _func_, void pass:[*]_context_);
> +int *tep_unregister_event_handler*(struct tep_handle pass:[*]tep, int id, const char pass:[*]sys_name, const char pass:[*]event_name, tep_event_handler_func func, void pass:[*]_context_);
> +
> +typedef int (*pass:[*]tep_event_handler_func*)(struct trace_seq pass:[*]s, struct tep_record pass:[*]record, struct tep_event pass:[*]event, void pass:[*]context);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_register_event_handler()_ function registers a handler function,
> +which is going to be called to parse the information for a given event.
> +The _tep_ argument is the trace event parser context. The _id_ argument is
> +the id of the event. The _sys_name_ argument is the name of the system,
> +the event belongs to. The _event_name_ argument is the name of the event.
> +If _id_ is >= 0, it is used to find the event, otherwise _sys_name_ and
> +_event_name_ are used. The _func_ is a pointer to the function, which is going
> +to be called to parse the event information. The _context_ argument is a pointer
> +to the context data, which will be passed to the _func_. If a handler function
> +for the same event is already registered, it will be overridden with the new
> +one. This mechanism allows a developer to override the parsing of a given event.
> +If for some reason the default print format is not sufficient, the developer
> +can register a function for an event to be used to parse the data instead.
> +
> +The _tep_unregister_event_handler()_ function unregisters the handler function,
> +previously registered with _tep_register_event_handler()_. The _tep_ argument
> +is the trace event parser context. The _id_, _sys_name_, _event_name_, _func_,
> +and _context_ are the same arguments, as when the callback function _func_ was
> +registered.
> +
> +The _tep_event_handler_func_ is the type of the custom event handler
> +function. The _s_ argument is the trace sequence, it can be used to create a
> +custom string, describing the event. A _record_  to get the event from is passed
> +as input parameter and also the _event_ - the handle to the record's event. The
> +_context_ is custom context, set when the custom event handler is registered.
> +
> +RETURN VALUE
> +------------
> +The _tep_register_event_handler()_ function returns _TEP_REGISTER_SUCCESS_
> +if the new handler is registered successfully or
> +_TEP_REGISTER_SUCCESS_OVERWRITE_ if an existing handler is overwritten.
> +If there is not  enough memory to complete the registration,
> +TEP_ERRNO__MEM_ALLOC_FAILED is returned.
> +
> +The _tep_unregister_event_handler()_ function returns 0 if _func_ was removed
> +successful or, -1 if the event was not found.
> +
> +The _tep_event_handler_func_ should return -1 in case of an error,
> +or 0 otherwise.
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
> +int custom_event_handler(struct trace_seq *s, struct tep_record *record,
> +			 struct tep_event *event, void *context)
> +{
> +	trace_seq_printf(s, "kvm_exit event");

We should use a more concrete example. One that does something with the
event. Feel free to use one of the plugin calls.

-- Steve

> +	return 0;
> +}
> +...
> +	if (tep_register_event_handler(tep, -1, "kvm", "kvm_exit",
> +				   custom_event_handler, NULL)) {
> +	/* Failed to register the handler for event "kvm_exit",
> "kvm" system */
> +	}
> +...
> +	if (tep_unregister_event_handler(pevent, -1, "kvm",
> "kvm_exit",
> +				     custom_event_handler,
> NULL) != ) {
> +	/* Failed to unregister the handler for event "kvm_exit",
> "kvm" system */
> +	}
> +
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the
> library APIs. +*trace-seq.h*
> +	Header file to include in order to have access to trace
> sequences
> +	related APIs. Trace sequences are used to allow a function
> to call
> +	several other functions to create a string of data to use.
> +*-ltraceevent*
> +	Linker switch to add when building a program that uses the
> library. +--
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
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>, author of this man
> page. +--
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

