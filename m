Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B846EC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C01D64EB6
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 06:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhBIGk0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 01:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhBIGjy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 01:39:54 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE46C06178C
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Feb 2021 22:38:58 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id r75so4756406oie.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Feb 2021 22:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eSOb14mHXluAJY+VCm+6mCfkh0Ys+aUEShHRzrugCzY=;
        b=mCFixBHTM0PXqOyOlvQlLbZymTPl6Ct5E7373ZJIk6OF7wijaUriIjmXDv154fO+Pj
         Z3oG5fuof1HJKpaMOxOg/vesYVCsWpoBrvycSOIdR/hCmD367Z6YlEz5ZdThjCcca3Nt
         TovxMnANfLAMLbGnZsV577ByyS9DWvpNvCzOgPe1aa9zzhFNwLKGgf2xFoVFeRD/zYlj
         melSsj330XP1Fk3a9l/q1Uv2HzMmxIsZvaRff/2tiFWD1Jjkxz1djEQjl6JHAPZUTloL
         ihQw3V3Gz0vzEP5oTEJLkdriDjlPEcUo+fc2Tibsr6sVS2kRC4cejVpUhRDVcYkAFdHq
         7vBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eSOb14mHXluAJY+VCm+6mCfkh0Ys+aUEShHRzrugCzY=;
        b=jewds7zoH17yOvqEPGHrbVeg+t/yREgnTqtC3v9avZUwralOWDfWXFcIJ7k5ZzNp0L
         HGy80C1SlaxblDWDpmsC3P2nf63VMuJG3VFU78TGBIrtzuebRfDw8jkSSlCasXhMOxEv
         PmzZAkUVrskde8rCZLsII3vG1myHc2epkLnLUYYzkC9TvfpK1cda/pczN3kzGZWauBbu
         a8s4dTDDTFnR6OHYg84bzIqnaIXKH5S3iYxvb/h3cky3KNX7gSwFJlMFkPW1bc0Uiriz
         ajpIWlr8TMjtfCe4nq5LJHZ4DZqKxj+xD2pdFJ0A0cnwDlcXfUukdfVDdUK3CdQMhn8i
         Fe7A==
X-Gm-Message-State: AOAM530LpgLxAz1lMvfVid/dRC77rIekdcsT96b3oOl/ahxlDVKDLZMq
        F6f1/ajUnDKCuiL6aT5PSDFL3I9n7NGY8T863Gh6/06dV1hMXQ==
X-Google-Smtp-Source: ABdhPJxNb7UcQWDLyjBmpP3Iyl54Eq55AH/+zPcPjRkl3aY7b7Znvx9U72DRLjT4IctleE2frDhm62k/Imis39K3eXs=
X-Received: by 2002:aca:3354:: with SMTP id z81mr1500583oiz.2.1612852738105;
 Mon, 08 Feb 2021 22:38:58 -0800 (PST)
MIME-Version: 1.0
References: <CAK7tX=angRdxNdg2yNnss-NuBm+i-Y3unyT6BaeY0Quj-QB+UA@mail.gmail.com>
 <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com>
In-Reply-To: <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Tue, 9 Feb 2021 12:08:46 +0530
Message-ID: <CAK7tX=YPkgJWwKvqKwnz4eVasdogi_zoteeUken-G4-VQc_cAA@mail.gmail.com>
Subject: Re: [PATCH][WIP]libtracefs:New API to enable the filtering of functions
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Tzvetomir,
Thanks for Your review, will try to modify the code as you suggested
and will give a new patch.
Thanks,
sameer shaik.


On Tue, Feb 9, 2021 at 11:22 AM Tzvetomir Stoyanov
<tz.stoyanov@gmail.com> wrote:
>
> Hi Sammer,
>
> On Mon, Feb 8, 2021 at 3:17 AM Sameeruddin Shaik
> <sameeruddin.shaik8@gmail.com> wrote:
> >
> > Hi steve,
> > This is my progress so far on Adding API's to set the filtering of functions https://bugzilla.kernel.org/show_bug.cgi?id=210643. I have few doubts here , based on my assumptions, i have implemented the below API.
> > API function:
> >
> > int tracefs_function_filter(struct tracefs_instance *instance, const char *filter);
> >
> > please give me some inputs on the below questions
> >
> > 1.Here filter is only one string or multiple strings followed by space?
> It is up to us to decide if the API will accept only one function at
> each call, or a list of functions.
> I think the logic should be simple, only one function per call.
>
> >
> > 2.I have used some internal API's to write to the set_ftrace_filter file, but with those API's
> >
> > we can be able to write only one string to the file, can i add my own write functionality in this
> >
> > function?
> Yes, please do. You can modify internal functions in order to reuse
> functionality. Please, be
> sure that all external APIs that use those internal functions are not broken.
>
> >
> > Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
> >
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index 8b11d35..29aee66 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -47,6 +47,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
> >  int tracefs_trace_off(struct tracefs_instance *instance);
> >  int tracefs_trace_on_fd(int fd);
> >  int tracefs_trace_off_fd(int fd);
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char *filter);
> >
> >  /**
> >   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> > diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> > index 101f389..cb0bc51 100644
> > --- a/src/tracefs-tools.c
> > +++ b/src/tracefs-tools.c
> > @@ -14,6 +14,7 @@
> >  #include "tracefs-local.h"
> >
> >  #define TRACE_CTRL "tracing_on"
> > +#define TRACE_FLTR      "set_ftrace_filter"
> >
> >  static int trace_on_off(int fd, bool on)
> >  {
> > @@ -107,3 +108,84 @@ int tracefs_trace_off_fd(int fd)
> >   return -1;
> >   return trace_on_off(fd, false);
> >  }
> > +
> > +int tracefs_function_filter(struct tracefs_instance *instance, const char *filter)
> > +{
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
>
> > +
> > + if (!filter)
> > + return -1;
> > + len = strlen(filter);
> > +
> > + final_filter = (char *)malloc(sizeof(char) * len);
> > +
> > + if (!final_filter)
> > + goto gracefully_free;
> > + memset(final_filter, '\0', len);
> > +
> > + available_filter_functions = tracefs_instance_get_file(NULL, "available_\
> > +filter_functions");
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
> > + /* Match each function passed in filter against the available_filter_fucntions*/
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
> > + for (str = tmp; ; str = NULL) {
> > + function_name = strtok_r(str, "\n", &saveptr);
> > + if (!function_name)
> > + break;
> > + /*Matching the fucntion names like chunk_err [brtfs]*/
> > + if (strchr(function_name, '[') != NULL) {
> > + fun_sub_name = strtok(function_name, " [");
> > + if (strcmp(fun_sub_name, each_filter) == 0){
> > + strncat(final_filter, each_filter, strlen(each_filter));
> > + strcat(final_filter, " ");
> > + res = 1;
> > + break;
> > + }
> > + }
> > + if (strcmp(function_name, each_filter) == 0) {
> > + strncat(final_filter, each_filter, strlen(each_filter));
> > + strcat(final_filter, " ");
> > + res = 1;
> > + break;
> > + }
> > +
> > + }
> > + }
> > + free(buf);
> > + strcat(final_filter, "\n");
> > + if (res)
> > + ret = tracefs_instance_file_write(instance, TRACE_FLTR, final_filter);
> Note that using this API will truncate the file, instead we should
> append the new filter.
>
> > + else
> > + return -1;
> > +
> > + gracefully_free:
> > + free(available_filter_functions);
> > + free(tmp);
> > + free(final_filter);
> > + return ret;
> > +}
> >
> > Thanks,
> >
> > sameer.
>
> You can find documentation for ftrace function filtering in kernel tree,
> in Documentation/trace/ftrace.rst. Please, look at it and - there are
> some filter commands, that set_ftrace_filter supports. This new libtracefs
> API should handle them.
>
> Thanks for working on libtracefs :)
>
> --
> Tzvetomir (Ceco) Stoyanov
> VMware Open Source Technology Center
