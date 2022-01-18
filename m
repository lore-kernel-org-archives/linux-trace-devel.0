Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9DFC433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 18 Jan 2022 01:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiARBQH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 20:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiARBQH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 20:16:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12716C061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 Jan 2022 17:16:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8019E61264
        for <linux-trace-devel@vger.kernel.org>; Tue, 18 Jan 2022 01:16:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91411C36AE7;
        Tue, 18 Jan 2022 01:16:05 +0000 (UTC)
Date:   Mon, 17 Jan 2022 20:16:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2] trace-cruncher: Add API to set tracing CPU affinity
Message-ID: <20220117201604.7b635a25@gandalf.local.home>
In-Reply-To: <20220117201231.414a4799@gandalf.local.home>
References: <20220117201231.414a4799@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 17 Jan 2022 20:12:31 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> +++ b/src/ftracepy.c
> @@ -372,11 +372,21 @@ static PyMethodDef ftracepy_methods[] = {
>  	 METH_VARARGS | METH_KEYWORDS,
>  	 "Define a kretprobe."
>  	},
> +	{"reset_affinity",
> +	 (PyCFunction) PyFtrace_reset_affinity,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Set an instance tracing affinity to all CPUs"
> +	},
>  	{"hist",
>  	 (PyCFunction) PyFtrace_hist,
>  	 METH_VARARGS | METH_KEYWORDS,
>  	 "Define a histogram."
>  	},
> +	{"set_affinity",
> +	 (PyCFunction) PyFtrace_set_affinity,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Return tracing affinity of an instance."

Bah, that should have been:

	"Set tracing affinity of an instance."

I wrote that while working on the "get_affinity" in libtracefs. :-p

v3 soon.

-- Steve


> +	},
>  	{"set_ftrace_loglevel",
>  	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
>  	 METH_VARARGS | METH_KEYWORDS,
