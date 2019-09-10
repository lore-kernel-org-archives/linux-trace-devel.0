Return-Path: <SRS0=H2rx=XF=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25A01C3A5A2
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 11:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0BD2208E4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 10 Sep 2019 11:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404010AbfIJLSn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 07:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:53482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403952AbfIJLSn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 07:18:43 -0400
Received: from oasis.local.home (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9723520872;
        Tue, 10 Sep 2019 11:18:38 +0000 (UTC)
Date:   Tue, 10 Sep 2019 07:18:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Petr Mladek <pmladek@suse.com>, linux-kernel@vger.kernel.org,
        rafael@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Joe Perches <joe@perches.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        linux-trace-devel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v6 01/12] tools lib traceevent: Convert remaining %p[fF]
 users to %p[sS]
Message-ID: <20190910071837.2e9110f8@oasis.local.home>
In-Reply-To: <20190910084707.18380-2-sakari.ailus@linux.intel.com>
References: <20190910084707.18380-1-sakari.ailus@linux.intel.com>
        <20190910084707.18380-2-sakari.ailus@linux.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 10 Sep 2019 11:46:56 +0300
Sakari Ailus <sakari.ailus@linux.intel.com> wrote:

> There are no in-kernel %p[fF] users left. Convert the traceevent tool,
> too, to align with the kernel.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> Cc: linux-trace-devel@vger.kernel.org
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
>  .../Documentation/libtraceevent-func_apis.txt          | 10 +++++-----
>  tools/lib/traceevent/event-parse.c                     |  7 +++----
>  2 files changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt b/tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
> index 38bfea30a5f64..f6aca0df2151a 100644
> --- a/tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
> +++ b/tools/lib/traceevent/Documentation/libtraceevent-func_apis.txt
> @@ -59,12 +59,12 @@ parser context.
>  
>  The _tep_register_function()_ function registers a function name mapped to an
>  address and (optional) module. This mapping is used in case the function tracer
> -or events have "%pF" or "%pS" parameter in its format string. It is common to
> -pass in the kallsyms function names with their corresponding addresses with this
> +or events have "%pS" parameter in its format string. It is common to pass in
> +the kallsyms function names with their corresponding addresses with this
>  function. The _tep_ argument is the trace event parser context. The _name_ is
> -the name of the function, the string is copied internally. The _addr_ is
> -the start address of the function. The _mod_ is the kernel module
> -the function may be in (NULL for none).
> +the name of the function, the string is copied internally. The _addr_ is the
> +start address of the function. The _mod_ is the kernel module the function may
> +be in (NULL for none).
>  
>  The _tep_register_print_string()_ function  registers a string by the address
>  it was stored in the kernel. Some strings internal to the kernel with static
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index b36b536a9fcba..1d7927ff32660 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -4335,8 +4335,6 @@ static struct tep_print_arg *make_bprint_args(char *fmt, void *data, int size, s
>  					switch (*ptr) {
>  					case 's':
>  					case 'S':
> -					case 'f':
> -					case 'F':

This file is used to parse output from older kernels, so remove this hunk.

It's not just for the lastest kernel. We must maintain backward
compatibility here too. If there use to be a usage of this, then we
must keep it until the kernels are no longer used (perhaps 7 years?)


>  					case 'x':
>  						break;
>  					default:
> @@ -4455,12 +4453,13 @@ get_bprint_format(void *data, int size
> __maybe_unused, 
>  	printk = find_printk(tep, addr);
>  	if (!printk) {
> -		if (asprintf(&format, "%%pf: (NO FORMAT FOUND at
> %llx)\n", addr) < 0)
> +		if (asprintf(&format, "%%ps: (NO FORMAT FOUND at
> %llx)\n",
> +			     addr) < 0)

Remove the line break. I hate the 80 character limit especially when it
makes the code look worse. Like it does here.

-- Steve

>  			return NULL;
>  		return format;
>  	}
>  
> -	if (asprintf(&format, "%s: %s", "%pf", printk->printk) < 0)
> +	if (asprintf(&format, "%s: %s", "%ps", printk->printk) < 0)
>  		return NULL;
>  
>  	return format;

