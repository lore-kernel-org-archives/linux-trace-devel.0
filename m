Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2C81C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 21:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A81AD60C41
	for <linux-trace-devel@archiver.kernel.org>; Thu, 22 Jul 2021 21:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhGVUfZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 22 Jul 2021 16:35:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230455AbhGVUfX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 22 Jul 2021 16:35:23 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F032B60C41;
        Thu, 22 Jul 2021 21:15:57 +0000 (UTC)
Date:   Thu, 22 Jul 2021 17:15:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] trace-cruncher: Add set_ftrace_loglevel()
Message-ID: <20210722171551.6a640651@oasis.local.home>
In-Reply-To: <20210712123242.223500-1-y.karadz@gmail.com>
References: <20210712123242.223500-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 12 Jul 2021 15:32:39 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

-ENOCOMMITMESSAGE

Please describe what you are doing and why. The subject is not enough.

Even on simple changes, there should be some commentary.

The rest looks fine.

-- Steve


> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  src/ftracepy-utils.c | 23 +++++++++++++++++++++++
>  src/ftracepy-utils.h |  3 +++
>  src/ftracepy.c       |  5 +++++
>  3 files changed, 31 insertions(+)
> 
> diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
> index dfb0669..8f4b50c 100644
> --- a/src/ftracepy-utils.c
> +++ b/src/ftracepy-utils.c
> @@ -1801,6 +1801,29 @@ PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
>  	return event_is_enabled(instance, TC_SYS, event);
>  }
>  
> +PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
> +						       PyObject *kwargs)
> +{
> +	static char *kwlist[] = {"level", NULL};
> +	int level;
> +
> +	if (!PyArg_ParseTupleAndKeywords(args,
> +					 kwargs,
> +					 "i",
> +					 kwlist,
> +					 &level)) {
> +		return NULL;
> +	}
> +
> +	if (level < 0)
> +		level = 0;
> +
> +	tracefs_set_loglevel(level);
> +	tep_set_loglevel(level);
> +
> +	Py_RETURN_NONE;
> +}
> +
>  static bool set_fork_options(struct tracefs_instance *instance, bool enable)
>  {
>  	if (enable) {
> diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
> index d826427..5d7c19c 100644
> --- a/src/ftracepy-utils.h
> +++ b/src/ftracepy-utils.h
> @@ -155,6 +155,9 @@ PyObject *PyFtrace_disable_kprobe(PyObject *self, PyObject *args,
>  PyObject *PyFtrace_kprobe_is_enabled(PyObject *self, PyObject *args,
>  						     PyObject *kwargs);
>  
> +PyObject *PyFtrace_set_ftrace_loglevel(PyObject *self, PyObject *args,
> +						       PyObject *kwargs);
> +
>  PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
>  						 PyObject *kwargs);
>  
> diff --git a/src/ftracepy.c b/src/ftracepy.c
> index e5fcd54..e3fec7b 100644
> --- a/src/ftracepy.c
> +++ b/src/ftracepy.c
> @@ -269,6 +269,11 @@ static PyMethodDef ftracepy_methods[] = {
>  	 METH_VARARGS | METH_KEYWORDS,
>  	 "Check if kprobe event is enabled."
>  	},
> +	{"set_ftrace_loglevel",
> +	 (PyCFunction) PyFtrace_set_ftrace_loglevel,
> +	 METH_VARARGS | METH_KEYWORDS,
> +	 "Set the verbose level of the ftrace libraries."
> +	},
>  	{"trace_process",
>  	 (PyCFunction) PyFtrace_trace_process,
>  	 METH_VARARGS | METH_KEYWORDS,

