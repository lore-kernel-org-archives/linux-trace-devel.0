Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED83DC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 12:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 978BC619B8
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Mar 2021 12:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231162AbhCWMwz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Mar 2021 08:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhCWMwX (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Mar 2021 08:52:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A143F619B8;
        Tue, 23 Mar 2021 12:52:22 +0000 (UTC)
Date:   Tue, 23 Mar 2021 08:52:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
Subject: Re: [PATCH 0/7] libtracfes: Add tracefs_function_filter()
Message-ID: <20210323085220.6e20d125@gandalf.local.home>
In-Reply-To: <20210323012755.155237800@goodmis.org>
References: <20210323012755.155237800@goodmis.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 22 Mar 2021 21:27:55 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> This adds a new API tracefs_function_filter() as described in:
> 
>  https://bugzilla.kernel.org/show_bug.cgi?id=210643
> 
> It will use regular expressions against available_filter_functions (or even
> the kernel glob expression) to enable the function by the index method if it
> is supported. If it is not supported, it will go back to the writing of the
> filter strings directly into the set_ftrace_filter file.
> 
> 

Playing with the interface some more, I feel it's not quite adequate.

The returning the negative number of filters that failed, isn't very
useful. Having the errs array that points to those filters gives us that
information.

Also, because of the way that file works in the kernel, we need to be able
to call this function several times without closing the file. That's
because the actions take place when the file is closed, *not* when a write
is made. Having the interface return errors without closing the file would
allow the user to fix the failed filters and try again.

I plan on committing this patch series, so any new changes will be done on
top of them. But here's what I think needs to be done to make the interface
more usable.

 - Create a tracefs_function_filter_commit(instance) API that will close
   the file and commit the changes.

 - Have the tracefs_function_filter() open the set_ftrace_filter file if it
   is not already opened. This will allow for the function to be called
   multiple times. The file descriptor will be part of the instance
   descriptor or a global variable for the top level instance. The opening
   of the files will need to be protected by a pthread mutex.
   Note, the "reset" parameter is only applicable if the file is not
   already opened.

 - On success, return 0 and tracefs_function_filter_commit() must be called.

 - If the file descriptor is opened and an error happens, return 1, and the
   tracefs_function_filter_commit() still needs to be called, but the user
   can call tracefs_function_filter() again to try to fix the problem.

 - If an error is found before the file descriptor is opened, then
   tracefs_function_filter_commit() does not need to be called.

That is:

	ret = tracefs_function_filter(...);
	if (ret >= 0)
		tracefs_function_filter_commit();

 - Now for errs, it will be allocated if a problem happened on a filter,
   and may be set if the return value is non zero (1 or -1). The user can
   use it to know if the problem happened on a filter as well as find out
   which filter had the problem.

 - We can have a tracefs_read_function_filter() that returns an array of
   strings which ends with a NULL pointer (and needs to be freed with
   tracefs_list_free(), and have this:

   save_filters = tracefs_read_function_filter(instance);

   ret = tracefs_function_filter(instance, filters, NULL, true, &errs);
   if (ret > 0 && errs) {
	/* Modified but failed */
	int i, j;
	for (i = 0; filters[i]; i++)
		;
	for (j = 0; errs[i]; j++)
		;
	if (i == j)
		/* all filters failed! Put back the original */
		tracefs_function_filter(instance, save_filters, NULL, false, NULL);
   }
   if (ret >= 0)
	tracefs_function_filter_commit(instance);

Another reason to have it not close the file is because we only support
passing in one module at a time. If the user wants to enable functions in
two modules, they would need to call this twice, and we want them to be
able to do so and have both changes take affect at the same time.

Thoughts?

-- Steve
