Return-Path: <SRS0=xYfD=TA=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C14BC43219
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C35B21743
	for <linux-trace-devel@archiver.kernel.org>; Tue, 30 Apr 2019 22:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfD3WCC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 18:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WCC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 18:02:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADD672087B;
        Tue, 30 Apr 2019 22:02:01 +0000 (UTC)
Date:   Tue, 30 Apr 2019 18:02:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v5 12/30] tools/lib/traceevent: Man pages for function
 related libtraceevent  APIs
Message-ID: <20190430180200.78d8f4c0@gandalf.local.home>
In-Reply-To: <20190412133811.15878-13-tstoyanov@vmware.com>
References: <20190412133811.15878-1-tstoyanov@vmware.com>
        <20190412133811.15878-13-tstoyanov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, 12 Apr 2019 16:37:53 +0300
Tzvetomir Stoyanov <tstoyanov@vmware.com> wrote:

> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <event-parse.h>
> +...
> +struct tep_handle *tep = tep_alloc();
> +...
> +char *my_resolve_kernel_addr(void *context,
> +			     unsigned long long *addrp, char **modp)
> +{

I would at least have something in there instead of just a stub
function. You can make up a resolver. But just a stub function is not
useful to know.

	struct db *function_database = context;
	struct symbol *sym = sql_lookup(function_database, *addrp);

	if (!sym)
		return NULL;

	*modp = sym->module_name;
	return sym->name;
}


> +	return NULL;
> +}
> +
> +void show_function( unsigned long long addr)
> +{
> +	unsigned long long fstart;
> +	const char *fname;
> +
> +	if (tep_set_function_resolver(tep, my_resolve_kernel_addr, NULL) != 0) {

	tep_set_function_resolver(tep, my_resolve_kernel_addr,
				function_database) != 0) {

This gives an idea on how to use it. Sure it's a fictional database,
but it is much more descriptive than passing in NULL that does nothing.

> +		/* failed to register my_resolve_kernel_addr */
> +	}
> +
> +	/* These APIs use my_resolve_kernel_addr() to resolve the addr */
> +	fname = tep_find_function(tep, addr);
> +	fstart = tep_find_function_address(tep, addr);
> +
> +	/*
> +	   addr is in function named fname, starting at fstart address,
> +	   at offset (addr - fstart)
> +	*/
> +
> +	tep_reset_function_resolver(tep);
> +
> +}
> +...
> +	if (tep_register_function(tep, "kernel_function_foo",
> +				(unsigned long long) 0x12345678, NULL) != 0) {

Prehaps add a module to register too.

Thanks!

-- Steve

> +		/* Failed to register kernel_function_foo address mapping */
> +	}
> +...
> +	if (tep_register_print_string(tep, "print string",
> +				(unsigned long long) 0x87654321, NULL) != 0) {
> +		/* Failed to register "print string" address mapping */
> +	}
> +...
> +--
> +
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
