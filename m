Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2327CC433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Mar 2021 16:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E341465237
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Mar 2021 16:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhCIQuq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 11:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhCIQuh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 11:50:37 -0500
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5482FC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Mar 2021 08:50:37 -0800 (PST)
Received: by mail-oo1-xc2e.google.com with SMTP id e17so3193777oow.4
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Mar 2021 08:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PHo4GHFjP+ejBzcopWyAyt8iBYKRs7Mk2lM/WqElN+0=;
        b=uibEYyXvgsS4LAujGe/8NmAtnlDb86gxkzuEb3tcPa0v4HBglifLyemyH2h4ZZP1ef
         wrY+b/JvWesrUigZjG4nnX5xMZPESH7qZHOUzECrJH5oJnEfjXuiLM1YnhAsTQsA7wps
         62C9pOlXG+D6VcmGVaoNWOq+kQ6P5wTICT4H/zdDJ0aVcqDqEnec2FCuq6Tos1LmCsEr
         Y9q2QYmIuAQH3J8UXNt2oPFq8Ne+u4hpJo5UwEFDWe9EKlgUjNlC8CUAJVhhS348Plq7
         0PuKdJ6Re6YQHTEA4M2sLSTsS1ETIHvF6MFfv3r1dZqrWCFqcRIThOaL8jFSolVXXkyR
         SFhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PHo4GHFjP+ejBzcopWyAyt8iBYKRs7Mk2lM/WqElN+0=;
        b=I2oSEyT/z5luFW5m40a0vIlKxPbm0uYbzm8rNDg6vhg1uqle5yr63KH6fTSVESk7st
         Vg2GDPCgrANpfnPe5xW93weTqrhd3kjsUTOtivxN3jjIeueQukiQn8cb0f2DbB0KI134
         56XmijJKIsjIA9Td3XkuFBd/AZwNynwlHEPOOzPDt7Wq5YSrKbJN4ampRM40Fz1GQjRw
         g+aRzuUtN8LIP7pDElq+fQ7OuTJOTQzHiLDZm9wscPjxp/B2AsL2NSnokN17WOlsVNbu
         qUV3cvN5kbiY9YDaqr4HR4ZpQV8gHZz53SXeHGapOB6mSXCZrzK0rSNB0wkcQWiR4opx
         PMFw==
X-Gm-Message-State: AOAM533aNM5LXfq+Raga2Jw3SXbDefAJyjqf8DV3ZdRmK/7tTeOIzH0X
        JKD3q+k8yj/z2A3DejIVnCBG/NiagRdr/4Xh+LfXCHnS8i1lSg==
X-Google-Smtp-Source: ABdhPJzmZbKTC6cPWOJWYqHdx6ug1b9RXHyY4aPpLJBXNQ9Jt8aT8bPWqD3Z6rS+q68Y0PGpA30SyUP9AYDzFj5LSZY=
X-Received: by 2002:a4a:e9a2:: with SMTP id t2mr22948696ood.15.1615308636339;
 Tue, 09 Mar 2021 08:50:36 -0800 (PST)
MIME-Version: 1.0
References: <1615393287-12344-1-git-send-email-sameeruddin.shaik8@gmail.com>
In-Reply-To: <1615393287-12344-1-git-send-email-sameeruddin.shaik8@gmail.com>
From:   Sameeruddin Shaik <sameeruddin.shaik8@gmail.com>
Date:   Wed, 10 Mar 2021 22:21:13 +0530
Message-ID: <CAK7tX=aU41LzhjmDZHWUL2qLQ0M8hRJKfg7QcY9FYDpTHfUq3g@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: An API to set the filtering of functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is my test code, I tried handling the triple pointers in the library,
but when it comes to user program, at first "errs" has NULL at the
end(checked it using the gdb), but when we try to dereference and
print, gradually position holding NULL in "errs" is getting assinged
to some other location, and i am getting the segmentation fault.

>Since a triple pointer is difficult to manage in the code, you could have:
>
>        const char **e = NULL;
>
>
>               if (errs) {
>                        e = realloc(sizeof(*e), j + 1);
>                        e[j++] = filters[i];
>                }
>
>Then at the end:
>
>        if (errs)
>                *errs = e;

i didn't got the clear picture of what, the above code snippet is doing.
particularly the below line

>e = realloc(sizeof(*e), j + 1);

From man page i got

void *realloc(void *ptr, size_t size);

could you please brief me with an example?

Subject: [PATCH] test: Test code
diff --git a/test.c b/test.c
index d38fc92..3e90711 100644
--- a/test.c
+++ b/test.c
@@ -1,7 +1,39 @@
 #include <tracefs.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+
+
+
+#define INST "dummy"
+
+const char *filters[] = {"kvm_pmu_reset", "kvm_pmu_init",
"dir_item_err", "tzvetomir", "sameer", "steve", NULL};

 int main()
 {
-    tracefs_tracing_dir();
+    struct tracefs_instance *instance = NULL;
+    const char ***errs;
+    int ret;
+    int fd;
+    int n;
+    int i = 0;
+
+    errs = malloc(sizeof(char *));
+    printf("%s\n",tracefs_tracing_dir());
+    instance = tracefs_instance_create(INST);
+    ret = tracefs_function_filter(instance, filters, "kvm", 1, errs);
+
+    if(ret < -1)
+        if (errs)
+            while (errs[i])
+                printf("%s\n", *errs[i++]);
+
+    getchar();
+    tracefs_instance_destroy(instance);
+    tracefs_instance_free(instance);
+    free(errs);
     return 0;
 }

On Tue, Mar 9, 2021 at 9:51 PM Sameeruddin shaik
<sameeruddin.shaik8@gmail.com> wrote:
>
> This new API will write the function filters into the
> set_ftrace_filter file.
>
> tracefs_function_filter()
>
> https://bugzilla.kernel.org/show_bug.cgi?id=210643
>
> Signed-off-by: Sameeruddin shaik <sameeruddin.shaik8@gmail.com>
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index f3eec62..a2249d0 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -50,6 +50,7 @@ int tracefs_trace_on(struct tracefs_instance *instance);
>  int tracefs_trace_off(struct tracefs_instance *instance);
>  int tracefs_trace_on_fd(int fd);
>  int tracefs_trace_off_fd(int fd);
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs);
>
>  /**
>   * tracefs_trace_on_get_fd - Get a file descriptor of "tracing_on" in given instance
> diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
> index e2dfc7b..4e168df 100644
> --- a/src/tracefs-tools.c
> +++ b/src/tracefs-tools.c
> @@ -18,6 +18,7 @@
>  #include "tracefs-local.h"
>
>  #define TRACE_CTRL     "tracing_on"
> +#define TRACE_FILTER      "set_ftrace_filter"
>
>  static const char * const options_map[] = {
>         "unknown",
> @@ -387,3 +388,96 @@ void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_opt
>         if (options && id > TRACEFS_OPTION_INVALID)
>                 options->mask &= ~(1ULL << (id - 1));
>  }
> +
> +static int controlled_write(const char *filter_path, const char **filters, const char *module, bool reset, const char ***errs)
> +{
> +       int flags = reset ? O_TRUNC : O_APPEND;
> +       int write_size;
> +       char *each_str;
> +       int ret = 0;
> +       int j = 0;
> +       int size;
> +       int slen;
> +       int fd;
> +       int i;
> +
> +       fd = open(filter_path, O_WRONLY | flags);
> +       if (fd < 0)
> +               return 1;
> +
> +       for (i = 0; filters[i]; i++) {
> +               slen = strlen(filters[i]);
> +               if (!slen)
> +                       continue;
> +
> +               if (module)
> +                       /* Adding 5 extra bytes for ":mod:"*/
> +                       slen += strlen(module) + 5;
> +
> +               /* Adding 2 extra byte for the space and '\0' at the end*/
> +               slen += 2;
> +               each_str = calloc(1, slen);
> +               if (!each_str)
> +                       return 1;
> +               if (module)
> +                       write_size = snprintf(each_str, slen, "%s:mod:%s ", filters[i], module);
> +               else
> +                       write_size = snprintf(each_str, slen, "%s ", filters[i]);
> +
> +               size = write(fd, each_str, write_size);
> +               /* compare written bytes*/
> +               if (size < write_size) {
> +                       if (errs) {
> +                               errs[j++] = &filters[i];
> +                               ret -= 1;
> +                       }
> +               }
> +               free(each_str);
> +       }
> +       errs[j] = NULL;
> +       close(fd);
> +       return ret;
> +}
> +
> +/**
> + * tracefs_function_filter - write to set_ftrace_filter file to trace particular functions
> + * @instance: ftrace instance, can be NULL for top tracing instance
> + * @filters: An array of function names ending with a NULL pointer
> + * @module: Module to be traced
> + * @reset: set to true to reset the file before applying the filter
> + * @errs: A pointer to array of constant strings that will be allocated
> + * on negative return of this function, pointing to the filters that failed.
> + * May be NULL, in which case this field will be ignored.
> + *
> + * The @filters is an array of strings, where each string will be used to set
> + * a function or functions to be traced.
> + *
> + * If @reset is true, then all functions in the filter are cleared before
> + * adding functions from @filters. Otherwise, the functions set by @filters
> + * will be appended to the filter file
> + *
> + * returns -x on filter errors (where x is number of failed filter srtings)
> + * and if @errs is not NULL will be an allocated string array pointing to the
> + * strings in @filters that failed and must be freed with free().
> + *
> + * returns 1 on general errors not realted to setting the filter.
> + * @errs is not set even if supplied.
> + *
> + * return 0 on success and @errs is not set.
> + */
> +int tracefs_function_filter(struct tracefs_instance *instance, const char **filters, const char *module, bool reset, const char ***errs)
> +{
> +       char *ftrace_filter_path;
> +       int ret = 0;
> +
> +       if (!filters)
> +               return 1;
> +
> +       ftrace_filter_path = tracefs_instance_get_file(instance, TRACE_FILTER);
> +       if (!ftrace_filter_path)
> +               return 1;
> +
> +       ret = controlled_write(ftrace_filter_path, filters, module, reset, errs);
> +       tracefs_put_tracing_file(ftrace_filter_path);
> +       return ret;
> +}
> --
> 2.7.4
>
