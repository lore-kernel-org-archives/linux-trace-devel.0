Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7632C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 17:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 645F964EB4
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 17:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhBIQ7x (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:50174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232561AbhBIQ7l (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 11:59:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33FBB60230;
        Tue,  9 Feb 2021 16:58:57 +0000 (UTC)
Date:   Tue, 9 Feb 2021 11:58:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH][WIP]libtracefs:New API to enable the filtering of
 functions
Message-ID: <20210209115855.37826f7f@gandalf.local.home>
In-Reply-To: <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com>
References: <CAK7tX=angRdxNdg2yNnss-NuBm+i-Y3unyT6BaeY0Quj-QB+UA@mail.gmail.com>
        <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 9 Feb 2021 07:52:20 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> Hi Sammer,
> 
> On Mon, Feb 8, 2021 at 3:17 AM Sameeruddin Shaik
> <sameeruddin.shaik8@gmail.com> wrote:
> >
> > Hi steve,
> > This is my progress so far on Adding API's to set the filtering of
> > functions https://bugzilla.kernel.org/show_bug.cgi?id=210643. I have
> > few doubts here , based on my assumptions, i have implemented the below
> > API. API function:
> >
> > int tracefs_function_filter(struct tracefs_instance *instance, const
> > char *filter);
> >
> > please give me some inputs on the below questions
> >
> > 1.Here filter is only one string or multiple strings followed by space?
> >  
> It is up to us to decide if the API will accept only one function at
> each call, or a list of functions.
> I think the logic should be simple, only one function per call.

I was thinking about this some more. If we have one function per call, it
would require opening up the set_ftrace_filter file each time, which I
think is unnecessary. This also brings up how we update the filter. If you
open the file with O_TRUNC set, it will clear the existing filter,
otherwise it appends to it.

Perhaps instead of passing a "const char *filter", we should pass an array,
"const char * const *filters", that is a n array of const char *
functions, and the last one being NULL.

We should also add a reset boolean value. Which if true, it opens the file
with O_TRUNC causing the file to be reset before we add the new values.

int tracefs_function_filter(struct tracefs_instance *instance,
		const char * const *filter, bool reset);

> >
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index 8b11d35..29aee66 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -47,6 +47,7 @@ int tracefs_trace_on(struct tracefs_instance
> > *instance); int tracefs_trace_off(struct tracefs_instance *instance);
> >  int tracefs_trace_on_fd(int fd);
> >  int tracefs_trace_off_fd(int fd);
> > +int tracefs_function_filter(struct tracefs_instance *instance, const
> > char *filter);
> >
> >  /**
> >   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in
> > given instance diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > index 101f389..cb0bc51 100644
> > --- a/src/tracefs-tools.c
> > +++ b/src/tracefs-tools.c
> > @@ -14,6 +14,7 @@
> >  #include "tracefs-local.h"
> >
> >  #define TRACE_CTRL "tracing_on"
> > +#define TRACE_FLTR      "set_ftrace_filter"

I'd rather have the above be "TRACE_FILTER", making things too cryptic adds
more unnecessary confusion. The TRACE_CTRL is cryptic enough ;-)

> >
> >  static int trace_on_off(int fd, bool on)
> >  {
> > @@ -107,3 +108,84 @@ int tracefs_trace_off_fd(int fd)
> >   return -1;
> >   return trace_on_off(fd, false);
> >  }
> > +
> > +int tracefs_function_filter(struct tracefs_instance *instance, const
> > char *filter) +{
> > + bool res = 0;;  
> One extra semicolon.
> 
> > + int ret= 0;
> > + char *available_filter_functions;
> > + char *buf, *saveptr, *str;
> > + char *final_filter;
> > + struct stat st;
> > + size_t len;
> > + char *function_name;
> > + char *saveptr1, *str1;
> > + char *each_filter;
> > + char *fun_sub_name;
> > + char *tmp = NULL;  
> Small hint on coding style. Please, arrange the variables by length -
> longest first, shortest last.
> We are trying to use this coding style rule, at least for the new code.

Yes, we call it upside down x-mas tree style. it looks like an upside down
x-mas tree and is much easier to read. Although, its best if you try to
keep the same types bunched together.

> 
> > +
> > + if (!filter)
> > + return -1;
> > + len = strlen(filter);
> > +
> > + final_filter = (char *)malloc(sizeof(char) * len);

Unnecessary typecast. Also, sizeof(char) is always one.

	final_filter = malloc(len);

is prefectly fine.

> > +
> > + if (!final_filter)
> > + goto gracefully_free;
> > + memset(final_filter, '\0', len);

If you are going to zero it out, its best to use calloc instead of malloc:

	final_filter = calloc(1, len);

Which will zero out the memory that you allocate for you.

> > +
> > + available_filter_functions = tracefs_instance_get_file(NULL,
> > "available_\ +filter_functions");  
> It is better to have it on a single line. This coding style rule could
> not be followed
> strictly in all cases, sometimes the code is more readable in one line.
> 
> > + ret = stat(available_filter_functions, &st);
> > + if (ret < 0)
> > + goto gracefully_free;
> > + /*Reading the available_filter_functions file*/
> > + len = str_read_file(available_filter_functions, &buf);
> > + if (len <= 0)
> > + goto gracefully_free;
> > + /* Match each function passed in filter against the
> > available_filter_fucntions*/  
> I think verifying the requested filter functions using
> available_filter_functions could be
> omitted. There is such validation in the kernel, so let's use it.
> Writing invalid strings into
> set_ftrace_filter should return an error, and we can pass that error
> to the API caller.
> Note that set_ftrace_filter supports wildcards also, you can filter
> "sched_*" for example.
> That makes the validation more complex.
> I would recommend to verify if a const char *filter is a valid string
> only and to rely on
> the kernel verification for valid function filter.
> 
> 
> > + for (str1 = filter; ; str1 = NULL) {
> > + each_filter = strtok_r(str1, " ", &saveptr1);
> > + if (!each_filter)
> > + break;
> > + tmp = (char *)malloc(sizeof(char) * len);
> > + if (!tmp)
> > + goto gracefully_free;
> > + if (memcpy(tmp, buf, len) == NULL)
> > + goto gracefully_free;

At the beginning of the loop, you should use regex to define the filters
(thus, people can use regex or the glob kernel parsing).

See: man 3 regex.

Create one regex_t for each filter passed in. Then you can go down and run
regexec() against the available filter names to find the matches.

Also since 5.1 (so we need to test this out to see if it errors or not),
you can pass in numbers to set_ftrace_filter that will set the
corresponding record in available_filter_functions (starting with 1).

That is:

 # cd /sys/kernel/tracing
 # head available_filter_functions
__traceiter_initcall_level
__traceiter_initcall_start
__traceiter_initcall_finish
trace_initcall_finish_cb
initcall_blacklisted
do_one_initcall
do_one_initcall
match_dev_by_label
match_dev_by_uuid
rootfs_init_fs_context

 # echo 5 > set_ftrace_filter
 # cat set_ftrace_filter
initcall_blacklisted

Where "initcall_blacklisted" is the fifth element in
available_filter_functions. It's much quicker to pass in numbers than it is
names, as it removes the searches.

Thus, if you can find all the names in available filter functions and
create an array of their index (remember it starts with 1 not zero), and
pass in those numbers, it will be much quicker!

But if a number fails (errors on write), then you have to default back to
the names (as kernels before 5.1 don't have this feature).

Who knew such a "simple" API would be so complex ;-)

Thanks!

-- Steve

