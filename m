Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F49C433E0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 17:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89E9C64E77
	for <linux-trace-devel@archiver.kernel.org>; Tue, 23 Feb 2021 17:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhBWRCe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 23 Feb 2021 12:02:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233005AbhBWRCN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 23 Feb 2021 12:02:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 851E664E7A
        for <linux-trace-devel@vger.kernel.org>; Tue, 23 Feb 2021 17:01:31 +0000 (UTC)
Date:   Tue, 23 Feb 2021 12:01:30 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Fw: [Bug 210643] libtracefs: Add ways to set the filtering of
 function tracing
Message-ID: <20210223120130.280e7838@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Forwarding this to the mailing list, as well. Any discussions on this may
be easier to discuss here than on the bugzilla.

-- Steve


https://bugzilla.kernel.org/show_bug.cgi?id=210643

--- Comment #7 from Steven Rostedt (rostedt@goodmis.org) ---
After some discussions on the mailing lists, I found that it is important to
establish the requirements that I expect of this API. I'm doing it in the
bugzilla instead of the mailing list (but will also forward this to the
mailing list), as this is more about the feature request and not about the
development of it.

The prototype should be:

 int tracefs_function_filter(struct tracefs_instance *instance,
                             const char * const *filters,
                             const char *module,
                             boolean reset);

If @instance is NULL, the filter for the top level tracing directory is
used. Otherwise the filter is for the given instance.

The @filters is an array of strings that holds one or more filters, and the
array ends with a NULL pointer.

If @module is set, only apply the filter to functions for a given module.
This is ignored if NULL is passed in. I added this to the interface because
it is commonly used, and the set_ftrace_filter has a special way to handle
it (see more below).

If @reset is set, the function filter for the given instance (or toplevel if
@instance is NULL), is cleared before applying the new filter functions.
Otherwise, the function filters are appended.

Note on reset being set: This is an important implementation detail. The
reset must be done by opening the file with O_WRONLY|O_TRUNC set. And the
file is not closed until all the new filters are added. It must not clear
the file and close it before setting the new filters. The reason is, if it
does, then all functions will start to be traced!

If the function filter has some functions in set_ftrace_filter, and the
function tracer is active, then it is only tracing those functions in
set_ftrace_filter. If you want to change that set of functions to a new set,
you open the set_ftrace_filter file with O_WRONLY|O_TRUNC and add your new
functions. On closing the file, the change takes place. The old functions
being filtered will no longer be traced, and the new functions being filter
will start to be traced.

If the set_ftrace_filter is truncated and closed without setting the new
functions, then the function tracer will start tracing *all* functions!
That is not what this API should do. This is why it is important that you
write the new filters after opening with O_TRUNC and before closing the
file descriptor. This is another reason to use an array of filters instead
of having the application call this function multiple times with different
filters strings.

Now when writing the filters, the following should be done for each filter.
Write the filter to set_ftrace_filter file, and if it succeeds, then
continue to the next filter. If it does not succeed, then check if it is a
regex. If so, then add all the functions that match the regex that are in
available_filter_functions.

Note, if @module is not NULL, then before writing the filter strings for the
non regex write, append ":mod:@module" to each filter string. That is, if
@module is "bridge" and the filter is "br_*", then what should be written
into the set_ftrace_filter file is: "br_*:mod:bridge", and the kernel will
only apply the "br_*" to the module "bridge". Implementation detail, you
can simply write the filter unmodified, then write ":mod:" then write
"bridge", before writing any spaces to separate the filters. The kernel
will process that as one string "br_*:mod:bridge". This way the function
does not need to worry about allocating extra memory and copying the string
to append the ":mod:bridge" before writing.

If a regex is used, then the search of available_filter_functions should
only look for function names that have the module name behind it. That is,
if @module is "bridge" and the filter is ".*switchdev_\\(port\\|fdb\\).*",
and @module is set, then the search over available_filter_functions should
run the regex only on functions that have a matching module name "[bridge]".

-- 
You may reply to this email to add a comment.

You are receiving this mail because:
You reported the bug.
You are watching the assignee of the bug.
You are watching the reporter of the bug.
