Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85A1C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 03:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B95A64E50
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Feb 2021 03:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbhBJDDm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 22:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbhBJDDl (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 22:03:41 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56800C061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Feb 2021 19:03:01 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id c16so554856otp.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Feb 2021 19:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SHQRUHx1jcfxBK8auOyvgpA7ZdVIxtWAv5WtZ6BRJE0=;
        b=FM1Q5E5ICgHSvAqdfCJepPIteSHjrdvis8yaoZedyzmvmTLEEWMa/fdFfQRJ5LhL9s
         7bW+hdBtoyub75G35MG9X0Y8/qpSxT1iseWZ45XcR0o4GjrvyJWLi+gENzxFpjvkRe6S
         RzZgOdTxoXyy+lTADn4zWIvPOx/T7Um37h1UXEILX/fpnKsd3lbEKUueXQTL/HQPzlAO
         gx/EZSIdUr6PiXZKNnra1jok3EwzLwURWIglDrbOP5aNiPbW1XV55r/bXYtDzRQdgN7q
         183NckH7wq2r5emMPE576vw1QwGQH8QX3pBqo8lejNVEqUlrpG0t5Q1sVnwW+9UIPFaJ
         mPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SHQRUHx1jcfxBK8auOyvgpA7ZdVIxtWAv5WtZ6BRJE0=;
        b=MlhHdONxLe8hk75VHO+DSafr26qwVOcEKR06hBCoqKhmFLUSgcu9it0S8GWJyTNfbt
         pTY+d4DUsJBtOGbEL2uF07ZAEFhwu4nyKM78M1mWR+aIvJCbQyAiG2bpRk9i/avLMEOh
         qsz/HzPdj2LWlsuvqR9WgvsSeNGkFC1vRu3V6pOC1RgHVDxr4xxMLORNdBlpbYsXzhhE
         /9f1OkJi1Wx432hhMl/G68yW90atylJ83/iQkAalgufo7+fFHqKIUR8pyQnwqfgERPoV
         SVkq72gwXijzBseuRv/Ab/s3XnA3Z/ejBgjtwPJkb214lxso4L3+3ZfEDTQu18ee/G0E
         pc7Q==
X-Gm-Message-State: AOAM5305kp1thfGfEY11Cj+CdAIha1aTugYEK7fOageuH1wmlG6mnqjE
        6e0id/YffwS6+wileG6ILtIu7/CHk1co1JwBt6ECce6JwS3LmA==
X-Google-Smtp-Source: ABdhPJz+nAhbZBxFZT4fE2KkJSVnh2cxDQFa+On90QWoTp/yDvzHMW5ul/OJBk6d/t9gkNgGYmMfaITRPJEXr5HMPf4=
X-Received: by 2002:a9d:3de5:: with SMTP id l92mr599976otc.227.1612926180622;
 Tue, 09 Feb 2021 19:03:00 -0800 (PST)
MIME-Version: 1.0
References: <CAK7tX=angRdxNdg2yNnss-NuBm+i-Y3unyT6BaeY0Quj-QB+UA@mail.gmail.com>
 <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com> <20210209115855.37826f7f@gandalf.local.home>
In-Reply-To: <20210209115855.37826f7f@gandalf.local.home>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Thu, 11 Feb 2021 08:33:50 +0530
Message-ID: <CAK7tX=YfQ4SGdUu3ac7bwRw0jGKBzgrNGtVib6VfrBUYEdJj2g@mail.gmail.com>
Subject: Re: [PATCH][WIP]libtracefs:New API to enable the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

tzvetomir,
sure will do as you said.
since its a WIP patch, i sent it without any validations.

steve,
-_________________________________________________
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
corresponding record in available_filter_functions (starting with 1)
_________________________________________________________

By this you mean to say like, we have to do the filter functions
validation in the API?
or
shall we continue with tzvetomir idea (I mean depending on the kernel
validation)?

Thanks,
sameer.


On Tue, Feb 9, 2021 at 10:28 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 9 Feb 2021 07:52:20 +0200
> Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:
>
> > Hi Sammer,
> >
> > On Mon, Feb 8, 2021 at 3:17 AM Sameeruddin Shaik
> > <sameeruddin.shaik8@gmail.com> wrote:
> > >
> > > Hi steve,
> > > This is my progress so far on Adding API's to set the filtering of
> > > functions https://bugzilla.kernel.org/show_bug.cgi?id=210643. I have
> > > few doubts here , based on my assumptions, i have implemented the below
> > > API. API function:
> > >
> > > int tracefs_function_filter(struct tracefs_instance *instance, const
> > > char *filter);
> > >
> > > please give me some inputs on the below questions
> > >
> > > 1.Here filter is only one string or multiple strings followed by space?
> > >
> > It is up to us to decide if the API will accept only one function at
> > each call, or a list of functions.
> > I think the logic should be simple, only one function per call.
>
> I was thinking about this some more. If we have one function per call, it
> would require opening up the set_ftrace_filter file each time, which I
> think is unnecessary. This also brings up how we update the filter. If you
> open the file with O_TRUNC set, it will clear the existing filter,
> otherwise it appends to it.
>
> Perhaps instead of passing a "const char *filter", we should pass an array,
> "const char * const *filters", that is a n array of const char *
> functions, and the last one being NULL.
>
> We should also add a reset boolean value. Which if true, it opens the file
> with O_TRUNC causing the file to be reset before we add the new values.
>
> int tracefs_function_filter(struct tracefs_instance *instance,
>                 const char * const *filter, bool reset);
>
> > >
> > > diff --git a/include/tracefs.h b/include/tracefs.h
> > > index 8b11d35..29aee66 100644
> > > --- a/include/tracefs.h
> > > +++ b/include/tracefs.h
> > > @@ -47,6 +47,7 @@ int tracefs_trace_on(struct tracefs_instance
> > > *instance); int tracefs_trace_off(struct tracefs_instance *instance);
> > >  int tracefs_trace_on_fd(int fd);
> > >  int tracefs_trace_off_fd(int fd);
> > > +int tracefs_function_filter(struct tracefs_instance *instance, const
> > > char *filter);
> > >
> > >  /**
> > >   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in
> > > given instance diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > > index 101f389..cb0bc51 100644
> > > --- a/src/tracefs-tools.c
> > > +++ b/src/tracefs-tools.c
> > > @@ -14,6 +14,7 @@
> > >  #include "tracefs-local.h"
> > >
> > >  #define TRACE_CTRL "tracing_on"
> > > +#define TRACE_FLTR      "set_ftrace_filter"
>
> I'd rather have the above be "TRACE_FILTER", making things too cryptic adds
> more unnecessary confusion. The TRACE_CTRL is cryptic enough ;-)
>
> > >
> > >  static int trace_on_off(int fd, bool on)
> > >  {
> > > @@ -107,3 +108,84 @@ int tracefs_trace_off_fd(int fd)
> > >   return -1;
> > >   return trace_on_off(fd, false);
> > >  }
> > > +
> > > +int tracefs_function_filter(struct tracefs_instance *instance, const
> > > char *filter) +{
> > > + bool res = 0;;
> > One extra semicolon.
> >
> > > + int ret= 0;
> > > + char *available_filter_functions;
> > > + char *buf, *saveptr, *str;
> > > + char *final_filter;
> > > + struct stat st;
> > > + size_t len;
> > > + char *function_name;
> > > + char *saveptr1, *str1;
> > > + char *each_filter;
> > > + char *fun_sub_name;
> > > + char *tmp = NULL;
> > Small hint on coding style. Please, arrange the variables by length -
> > longest first, shortest last.
> > We are trying to use this coding style rule, at least for the new code.
>
> Yes, we call it upside down x-mas tree style. it looks like an upside down
> x-mas tree and is much easier to read. Although, its best if you try to
> keep the same types bunched together.
>
> >
> > > +
> > > + if (!filter)
> > > + return -1;
> > > + len = strlen(filter);
> > > +
> > > + final_filter = (char *)malloc(sizeof(char) * len);
>
> Unnecessary typecast. Also, sizeof(char) is always one.
>
>         final_filter = malloc(len);
>
> is prefectly fine.
>
> > > +
> > > + if (!final_filter)
> > > + goto gracefully_free;
> > > + memset(final_filter, '\0', len);
>
> If you are going to zero it out, its best to use calloc instead of malloc:
>
>         final_filter = calloc(1, len);
>
> Which will zero out the memory that you allocate for you.
>
> > > +
> > > + available_filter_functions = tracefs_instance_get_file(NULL,
> > > "available_\ +filter_functions");
> > It is better to have it on a single line. This coding style rule could
> > not be followed
> > strictly in all cases, sometimes the code is more readable in one line.
> >
> > > + ret = stat(available_filter_functions, &st);
> > > + if (ret < 0)
> > > + goto gracefully_free;
> > > + /*Reading the available_filter_functions file*/
> > > + len = str_read_file(available_filter_functions, &buf);
> > > + if (len <= 0)
> > > + goto gracefully_free;
> > > + /* Match each function passed in filter against the
> > > available_filter_fucntions*/
> > I think verifying the requested filter functions using
> > available_filter_functions could be
> > omitted. There is such validation in the kernel, so let's use it.
> > Writing invalid strings into
> > set_ftrace_filter should return an error, and we can pass that error
> > to the API caller.
> > Note that set_ftrace_filter supports wildcards also, you can filter
> > "sched_*" for example.
> > That makes the validation more complex.
> > I would recommend to verify if a const char *filter is a valid string
> > only and to rely on
> > the kernel verification for valid function filter.
> >
> >
> > > + for (str1 = filter; ; str1 = NULL) {
> > > + each_filter = strtok_r(str1, " ", &saveptr1);
> > > + if (!each_filter)
> > > + break;
> > > + tmp = (char *)malloc(sizeof(char) * len);
> > > + if (!tmp)
> > > + goto gracefully_free;
> > > + if (memcpy(tmp, buf, len) == NULL)
> > > + goto gracefully_free;
>
> At the beginning of the loop, you should use regex to define the filters
> (thus, people can use regex or the glob kernel parsing).
>
> See: man 3 regex.
>
> Create one regex_t for each filter passed in. Then you can go down and run
> regexec() against the available filter names to find the matches.
>
> Also since 5.1 (so we need to test this out to see if it errors or not),
> you can pass in numbers to set_ftrace_filter that will set the
> corresponding record in available_filter_functions (starting with 1).
>
> That is:
>
>  # cd /sys/kernel/tracing
>  # head available_filter_functions
> __traceiter_initcall_level
> __traceiter_initcall_start
> __traceiter_initcall_finish
> trace_initcall_finish_cb
> initcall_blacklisted
> do_one_initcall
> do_one_initcall
> match_dev_by_label
> match_dev_by_uuid
> rootfs_init_fs_context
>
>  # echo 5 > set_ftrace_filter
>  # cat set_ftrace_filter
> initcall_blacklisted
>
> Where "initcall_blacklisted" is the fifth element in
> available_filter_functions. It's much quicker to pass in numbers than it is
> names, as it removes the searches.
>
> Thus, if you can find all the names in available filter functions and
> create an array of their index (remember it starts with 1 not zero), and
> pass in those numbers, it will be much quicker!
>
> But if a number fails (errors on write), then you have to default back to
> the names (as kernels before 5.1 don't have this feature).
>
> Who knew such a "simple" API would be so complex ;-)
>
> Thanks!
>
> -- Steve
>
