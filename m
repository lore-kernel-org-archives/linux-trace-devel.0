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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FABBC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31B5464E70
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 05:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhBIFxS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 00:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhBIFxS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 00:53:18 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D510C061786
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Feb 2021 21:52:38 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id b145so11218733pfb.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Feb 2021 21:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XxUySktR75Ld5hHyMamz5gsvTZTenYp5d3Kg4vcpGOM=;
        b=VzsTL/TZATjt0Z/qb26u2wJwHhK/Bj9ewViL4vpYLGey7/6HlPi32Rd0Pva0Yl+XeW
         8gF6oAcRdgNJoicapBKQ8hstcGrDgQk+ZYpsQK4HTS0CoHERfNGaPnacb7UcubxxJ5Fl
         AFQS83J/N51jXw37hDkw95OiR5CtEivb3+JUqH0A67mBdNm1JCd5ijOP2L7nM++umqo7
         AV8bNgHvia1eEUacIRWJwT2BizT5SoBY1YRFL3DY2XAdNhV5QOGkU5p5TKCKzmhHzjJb
         tLgNKWfq4odpGqzvl9wl/uqkvkPW4+rsSo7bwSCEhq9llU1elW0gHWP+OVAYZOkTrMNu
         fsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XxUySktR75Ld5hHyMamz5gsvTZTenYp5d3Kg4vcpGOM=;
        b=DV8/WIggILZYedg1JYIziX3I8zd09fiuQIA46WX2FwZtmeP9QU5N3hgD6zq4UjUMcg
         x5pxtBi+ieDfMoVCUiD3qP6upsyUNLkgeM4HpgSD1lY+37VBfMMt7Ae6H7SiDvuX4gXG
         SfX929eO/qUgVtVnpb98VRMFgjhEPbcWgd+J29bXMxluT6eJfOnhS7TmrP/9HSeYPvJY
         noQ3DJm1pH+rD0RLodhEeThZYaH7REUhcvhFRdnoCJ0q4fdV/xoLpXF9FhU7O/qbUgdv
         IbeYMBpz5sGG2kNUllIuw7leLY0mX7MagYRmj4EUv+UiUz6DY38JccdDI+8SMgJQN4FX
         ZE8Q==
X-Gm-Message-State: AOAM530eHwyCOsaUnXvL4EgM1Adp6iKaGWQyZk+f8pxWMyevUBNyVhSH
        6UU/SU90F3Y7tzNpR7qrvKKQeQgmDA+U0GnrUO8kCzd1D43u/A==
X-Google-Smtp-Source: ABdhPJy9ufvfZmQrTAKy83RZYacy65IVScDhCMtiifcxW4HTEKEA2QCR2P3pYzlUyr2uF56grD5zGDR56s+alCI4GFw=
X-Received: by 2002:a63:1865:: with SMTP id 37mr20425999pgy.206.1612849957547;
 Mon, 08 Feb 2021 21:52:37 -0800 (PST)
MIME-Version: 1.0
References: <CAK7tX=angRdxNdg2yNnss-NuBm+i-Y3unyT6BaeY0Quj-QB+UA@mail.gmail.com>
In-Reply-To: <CAK7tX=angRdxNdg2yNnss-NuBm+i-Y3unyT6BaeY0Quj-QB+UA@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 9 Feb 2021 07:52:20 +0200
Message-ID: <CAPpZLN7ysUKXLXwCbkfq+-OMhzUOXtDam+937gquDX4uT_nTHQ@mail.gmail.com>
Subject: Re: [PATCH][WIP]libtracefs:New API to enable the filtering of functions
To:     Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Sammer,

On Mon, Feb 8, 2021 at 3:17 AM Sameeruddin Shaik
<sameeruddin.shaik8@gmail.com> wrote:
>
> Hi steve,
> This is my progress so far on Adding API's to set the filtering of functions https://bugzilla.kernel.org/show_bug.cgi?id=210643. I have few doubts here , based on my assumptions, i have implemented the below API.
> API function:
>
> int tracefs_function_filter(struct tracefs_instance *instance, const char *filter);
>
> please give me some inputs on the below questions
>
> 1.Here filter is only one string or multiple strings followed by space?
It is up to us to decide if the API will accept only one function at
each call, or a list of functions.
I think the logic should be simple, only one function per call.

>
> 2.I have used some internal API's to write to the set_ftrace_filter file, but with those API's
>
> we can be able to write only one string to the file, can i add my own write functionality in this
>
> function?
Yes, please do. You can modify internal functions in order to reuse
functionality. Please, be
sure that all external APIs that use those internal functions are not broken.

>
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 8b11d35..29aee66 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -47,6 +47,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
>  int tracefs_trace_off(struct tracefs_instance *instance);
>  int tracefs_trace_on_fd(int fd);
>  int tracefs_trace_off_fd(int fd);
> +int tracefs_function_filter(struct tracefs_instance *instance, const char *filter);
>
>  /**
>   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index 101f389..cb0bc51 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -14,6 +14,7 @@
>  #include "tracefs-local.h"
>
>  #define TRACE_CTRL "tracing_on"
> +#define TRACE_FLTR      "set_ftrace_filter"
>
>  static int trace_on_off(int fd, bool on)
>  {
> @@ -107,3 +108,84 @@ int tracefs_trace_off_fd(int fd)
>   return -1;
>   return trace_on_off(fd, false);
>  }
> +
> +int tracefs_function_filter(struct tracefs_instance *instance, const char *filter)
> +{
> + bool res = 0;;
One extra semicolon.

> + int ret= 0;
> + char *available_filter_functions;
> + char *buf, *saveptr, *str;
> + char *final_filter;
> + struct stat st;
> + size_t len;
> + char *function_name;
> + char *saveptr1, *str1;
> + char *each_filter;
> + char *fun_sub_name;
> + char *tmp = NULL;
Small hint on coding style. Please, arrange the variables by length -
longest first, shortest last.
We are trying to use this coding style rule, at least for the new code.

> +
> + if (!filter)
> + return -1;
> + len = strlen(filter);
> +
> + final_filter = (char *)malloc(sizeof(char) * len);
> +
> + if (!final_filter)
> + goto gracefully_free;
> + memset(final_filter, '\0', len);
> +
> + available_filter_functions = tracefs_instance_get_file(NULL, "available_\
> +filter_functions");
It is better to have it on a single line. This coding style rule could
not be followed
strictly in all cases, sometimes the code is more readable in one line.

> + ret = stat(available_filter_functions, &st);
> + if (ret < 0)
> + goto gracefully_free;
> + /*Reading the available_filter_functions file*/
> + len = str_read_file(available_filter_functions, &buf);
> + if (len <= 0)
> + goto gracefully_free;
> + /* Match each function passed in filter against the available_filter_fucntions*/
I think verifying the requested filter functions using
available_filter_functions could be
omitted. There is such validation in the kernel, so let's use it.
Writing invalid strings into
set_ftrace_filter should return an error, and we can pass that error
to the API caller.
Note that set_ftrace_filter supports wildcards also, you can filter
"sched_*" for example.
That makes the validation more complex.
I would recommend to verify if a const char *filter is a valid string
only and to rely on
the kernel verification for valid function filter.


> + for (str1 = filter; ; str1 = NULL) {
> + each_filter = strtok_r(str1, " ", &saveptr1);
> + if (!each_filter)
> + break;
> + tmp = (char *)malloc(sizeof(char) * len);
> + if (!tmp)
> + goto gracefully_free;
> + if (memcpy(tmp, buf, len) == NULL)
> + goto gracefully_free;
> + for (str = tmp; ; str = NULL) {
> + function_name = strtok_r(str, "\n", &saveptr);
> + if (!function_name)
> + break;
> + /*Matching the fucntion names like chunk_err [brtfs]*/
> + if (strchr(function_name, '[') != NULL) {
> + fun_sub_name = strtok(function_name, " [");
> + if (strcmp(fun_sub_name, each_filter) == 0){
> + strncat(final_filter, each_filter, strlen(each_filter));
> + strcat(final_filter, " ");
> + res = 1;
> + break;
> + }
> + }
> + if (strcmp(function_name, each_filter) == 0) {
> + strncat(final_filter, each_filter, strlen(each_filter));
> + strcat(final_filter, " ");
> + res = 1;
> + break;
> + }
> +
> + }
> + }
> + free(buf);
> + strcat(final_filter, "\n");
> + if (res)
> + ret = tracefs_instance_file_write(instance, TRACE_FLTR, final_filter);
Note that using this API will truncate the file, instead we should
append the new filter.

> + else
> + return -1;
> +
> + gracefully_free:
> + free(available_filter_functions);
> + free(tmp);
> + free(final_filter);
> + return ret;
> +}
>
> Thanks,
>
> sameer.

You can find documentation for ftrace function filtering in kernel tree,
in Documentation/trace/ftrace.rst. Please, look at it and - there are
some filter commands, that set_ftrace_filter supports. This new libtracefs
API should handle them.

Thanks for working on libtracefs :)

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
