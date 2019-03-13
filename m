Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417C7C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 16:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14D4B2147C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 16:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfCMQ5z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 12:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfCMQ5z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 12:57:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9B22077B;
        Wed, 13 Mar 2019 16:57:54 +0000 (UTC)
Date:   Wed, 13 Mar 2019 12:57:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 15/46] tools/lib/traceevent: Man pages for
 tep_register_function() and tep_register_print_string()
Message-ID: <20190313125753.41fa3f05@gandalf.local.home>
In-Reply-To: <20190308133654.21264-16-tstoyanov@vmware.com>
References: <20190308133654.21264-1-tstoyanov@vmware.com>
        <20190308133654.21264-16-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri,  8 Mar 2019 15:36:23 +0200
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> Create man pages for tep_register_function() and tep_register_print_string()
> as part of the libtraceevent APIs.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  .../libtraceevent-reg_funcstr.txt             | 89 +++++++++++++++++++
>  1 file changed, 89 insertions(+)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt b/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
> new file mode 100644
> index 000000000000..fdb9e0352586
> --- /dev/null
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-reg_funcstr.txt
> @@ -0,0 +1,89 @@
> +libtraceevent(3)
> +================
> +
> +NAME
> +----
> +tep_register_function, tep_register_print_string - Registers a function / string
> +with a given address.
> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <event-parse.h>*
> +
> +int *tep_register_function*(struct tep_handle pass:[*]_tep_, char pass:[*]_name_, unsigned long long _addr_, char pass:[*]_mod_);
> +int *tep_register_print_string*(struct tep_handle pass:[*]_tep_, const char pass:[*]_fmt_, unsigned long long _addr_);
> +--
> +
> +DESCRIPTION
> +-----------
> +The _tep_register_function()_ function registers a function name with an
> +address and module. The _tep_ argument is the trace event parser context. The
> +_name_ is the name of the function, the string is copied internally. The _addr_
> +is the start address of the function. The _mod_ is the kernel module
> +the function may be in (NULL for none).

I would elaborate here more about what this means. What is registered
is kernel function name that is mapped to an address that will be used
in function look ups. For the function tracer or events that have a
"%pF" or "%pS" in the format string. It is common to pass in the
kallsyms function names with their corresponding addresses with this
function.


> +
> +The _tep_register_print_string()_ function  registers a string by the address
> +it was stored in the kernel. The _tep_ argument is the trace event parser
> +context. The _fmt_ is the string to register, it is copied internally. The _addr_
> +is the address the string was located at.

Some strings internal to the kernel with static address are passed to
certain events. The "%s" in the format field which has an address will
need to know what string would be at that address. The
tep_register_print_string() supplies the parsing with the mapping
between kernel addresses and those strings.

-- Steve


> +
> +RETURN VALUE
> +------------
> +The _tep_register_function()_ function returns 0 in case of success. In case of
> +an error -1 is returned, and errno is set to the appropriate error number.
> +
> +The _tep_register_print_string()_ function returns 0 in case of success. In case
> +of an error -1 is returned, and errno is set to the appropriate error number.
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +	if (tep_register_function(tep, "my_custom_func",
> +			  	 (unsigned long long) 0x12345678, NULL) != 0) {
> +		/* Failed to register my_custom_func address mapping */
> +	}
> +...
> +	if (tep_register_print_string(tep, "print string",
> +			  	 (unsigned long long) 0x87654321, NULL) != 0) {
> +		/* Failed to register "print string" address mapping */
> +	}
> +--
> +FILES
> +-----
> +[verse]
> +--
> +*event-parse.h*
> +	Header file to include in order to have access to the library APIs.
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

