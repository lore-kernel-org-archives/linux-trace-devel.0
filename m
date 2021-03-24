Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E239AC433DB
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8B8161A05
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 21:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhCXVkR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 17:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhCXVkK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 17:40:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58B4A61A02;
        Wed, 24 Mar 2021 21:40:09 +0000 (UTC)
Date:   Wed, 24 Mar 2021 17:40:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com
Subject: Re: [PATCH] libtracefs: Document function_filter API
Message-ID: <20210324174007.1de9b157@gandalf.local.home>
In-Reply-To: <1616689890-18853-1-git-send-email-sameeruddin.shaik8@gmail.com>
References: <1616689890-18853-1-git-send-email-sameeruddin.shaik8@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Sameer!

On Thu, 25 Mar 2021 22:01:30 +0530
Sameeruddin shaik <sameeruddin.shaik8@gmail.com> wrote:

> Added documentation for the below API:
> tracefs_function_filter()
> 
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> 
> diff --git a/Documentation/libtracefs-function-filter.txt b/Documentation/libtracefs-function-filter.txt
> new file mode 100644
> index 0000000..08eece7
> --- /dev/null
> +++ b/Documentation/libtracefs-function-filter.txt
> @@ -0,0 +1,116 @@
> +libtracefs(3)
> +=============
> +
> +NAME
> +----
> +tracefs_function_filter -  Function to write to set_ftrace_filter
> +file of specific instance or top tracing instance

Since we are abstracting out tracefs, I'd like to avoid the implementation
details, and keep it more about its functionality.

 - Function to limit kernel functions that are traced

> +
> +SYNOPSIS
> +--------
> +[verse]
> +--
> +*#include <tracefs.h>*
> +
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
> +--
> +
> +DESCRIPTION
> +-----------
> +This Function can be used to write to set_ftrace_file in the trace
> +filesystem, which will limit the trace to only those functions,
> +which were written in the file.

To avoid stating the implementation:

"This function can be used to limit the Linux kernel functions that is
traced by the function and function-graph tracers."


> +
> +It will take take _instance_argument, that can be NULL for the
> +top level tracing, _filters_, which is nothing but the array of the

No need to say "nothing"

"which is an array of strings that represent a list of filters that should
be applied to define what functions are to be traced. The array must end
with a NULL pointer."

> +strings to write into the set_ftrace_filter file ,_module_ , name of the
> +module to be traced, _reset_, to reset or append the filters to file

"_reset_ if set will clear the current set of filters and then apply the
filter list, otherwise the list of filters are added to the current set of
filters."

> + and _errs_ which is again an array of failed filters, which can be NULL

"and _errs_ is a pointer an array of strings, which will be allocated if
any of filters fail to any available function. If _errs_ is NULL, it will
be ignored."

> + if failed filters are not of concern, and  returns 0  on successful write,
> + 1 or -x (where x is an integer) on error.

I mentioned in a previous email that I think we need to change the return
value, but for now this is fine.

> +
> +RETURN VALUE
> +------------
> +tracefs_function_filter will return 0 on successful write to file, if there

Just need to say ".. return 0 on success."

> +is error, it will return 1 for general errors or negative number -x(x denotes
> +number of failed filters), if there are any failed filters.

Again, I think the error return may be changed, so we can leave this for
now.

> +
> +In case of negative return value, errs have to be checked and must be freed
> +using the free()
> +
> +EXAMPLE
> +-------
> +[source,c]
> +--
> +#include <tracefs.h>
> +
> +#define INST "dummy"
> +
> +const char *filters[] = { "run_init_process", "try_to_run_init_process", "dummy1", NULL };
> +
> +int main(int argc, char *argv[])
> +{
> +	struct tracefs_instance *inst = tracefs_instance_create(INST);
> +	const char **errs = NULL;
> +	bool reset = 1;
> +	int ret;
> +	int i = 0;
> +
> +	if (!inst) {
> +	   /* Error creating new trace instance*/
> +	   }
> +
> +	ret = tracefs_function_filter(inst, filters, NULL, reset, &errs);
> +
> +	if (ret < 0 && errs) {
> +	   	while (errs[i])
> +		      printf("%s\n", errs[i++]);
> +	      }
> +
> +	tracefs_instance_free(inst);
> +	tracefs_instance_destroy(inst);
> +	free(errs);
> +	return 0;

This looks fine.

Thanks!

-- Steve

> +}
> +--
> +
> +FILES
> +-----
> +[verse]
> +--
> +*tracefs.h*
> +	Header file to include in order to have access to the library APIs.
> +*-ltracefs*
> +	Linker switch to add when building a program that uses the library.
> +--
> +
> +SEE ALSO
> +--------
> +_libtracefs(3)_,
> +_libtraceevent(3)_,
> +_trace-cmd(1)_
> +
> +AUTHOR
> +------
> +[verse]
> +--
> +*Steven Rostedt* <rostedt@goodmis.org>
> +*Tzvetomir Stoyanov* <tz.stoyanov@gmail.com>
> +*sameeruddin shaik* <sameeruddin.shaik8@gmail.com>
> +--
> +REPORTING BUGS
> +--------------
> +Report bugs to  <linux-trace-devel@vger.kernel.org>
> +
> +LICENSE
> +-------
> +libtracefs is Free Software licensed under the GNU LGPL 2.1
> +
> +RESOURCES
> +---------
> +https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
> +
> +COPYING
> +-------
> +Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
> +the terms of the GNU Public License (GPL).

