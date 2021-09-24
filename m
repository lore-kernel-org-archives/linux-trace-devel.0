Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA603C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 15:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F29760EE9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 15:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347183AbhIXPxr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 11:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbhIXPxq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 11:53:46 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EECC061571
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 08:52:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x8so3934990plv.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 08:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xh2D/q/OoE9Cse0gCqhBf9ZH6n1ic4NOGmN65iJiJvY=;
        b=Zau/DGdaYLq/yA3QimxhH+Bl6u5xHxV+JAMEyfhjPuD7bI4CTMX/aeKAFIe2mlGfHL
         dQWNJahvnUvaG5THO3fPhJgDTHVdrKJrm5eFdMzLGCASthkpWPkR8na6qFIXJIrNCF6k
         VlsR5f+kVhADHor0+Lgn9KkdbEv4F/IyLUtm3mJClmRharIrS69eR6JITt7MmGObFIhf
         PRXxP7HX/1pzrPUgnJjFHUi5f5TFaWHnk2Pjc+2hVSAKcMMtivL2lYaW7FuvnQUg+S0n
         WwsTcKJxbBe4j9xeqib6+dQjZPvb/7nPcBxNjG0/tfeX8MtscV4j5abOu6/LvNqtbtza
         eR1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xh2D/q/OoE9Cse0gCqhBf9ZH6n1ic4NOGmN65iJiJvY=;
        b=6khQSpdmlBYUBv1ucEGkm0TWiMzk2k3twocdsz0ECiPFIics26cTIhgadZenYEC1WN
         JRy2qbYglcjMgI99x77P6y800f97y0JEQgh+kgddaS+Wec18zabFRrX10+ic2X2OGURx
         mehEJmI1I6HnwIBuViVnX8ijpvwbpqn3vM48yYBEdIK9SAtt5/VQ7v/LTHReYR8rtkIX
         5UD4T4CUH10auNUy+2dNpZ9YmLMHsOCVEQx7m0m9wMvuqzuX1FYsA/xi0dv8cdEenD0s
         yzRGSgqSGyqZhvO5iYdJYVQrSh+pLeLssCZStYqTfJJzSdQTVHRtG/5o4TcmzURKvorQ
         2wtg==
X-Gm-Message-State: AOAM531fmyWjzOTjQZMdbZfVMFzq6R/Sz01mNDcAvDvmxej9djJNMUvL
        pNklQVh5whk7a7/ROfC59/xgZaeRUDSosRr/ourt+TnhOiQ=
X-Google-Smtp-Source: ABdhPJwO2UOI6rZy3RTiZkw6UNpt+4AI8AzIPfDDPuEylnbR1RNuFuYMyq6Yo0Kc7UIf6Io2SH8817uEq8Z3FRNY5jg=
X-Received: by 2002:a17:90a:df0b:: with SMTP id gp11mr3022281pjb.96.1632498733105;
 Fri, 24 Sep 2021 08:52:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210924095702.151826-1-y.karadz@gmail.com> <20210924095702.151826-3-y.karadz@gmail.com>
In-Reply-To: <20210924095702.151826-3-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 24 Sep 2021 18:51:56 +0300
Message-ID: <CAPpZLN4yOiHBX2WRTWJHg+XUMULPUcx6KVE0_dNfP9hNaF-wgA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] libtracefs: Transform tracefs_hist_add_sort_key()
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Sep 24, 2021 at 12:59 PM Yordan Karadzhov (VMware)
<y.karadz@gmail.com> wrote:
>
> The current version of the API makes it hard to add multiple sort keys
> to a histogram. The only way to do this is to use the variadic arguments,
> however in order to do this the caller has to know the number of sort
> keys at compile time, because the method overwrite all previously added
> keys. The problem is addressed by creating a tracefs_hist_add_sort_key()
> into two methods - one that overwrite and one that does not.
> The current version of 'tracefs_hist_add_sort_key()' gets renamed to
> 'tracefs_hist_set_sort_key()' without introducing any functional changes.
> In the same time a new 'tracefs_hist_add_sort_key()' function is
> defined. The new function can add one new sort key to the list of
> previously added sort keys.
>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  include/tracefs.h  |  4 +++-
>  src/tracefs-hist.c | 33 ++++++++++++++++++++++++++++++---
>  2 files changed, 33 insertions(+), 4 deletions(-)
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 5c4141e..230bc41 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -333,7 +333,9 @@ int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
>                          enum tracefs_hist_key_type type);
>  int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
>  int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> -                             const char *sort_key, ...);
> +                             const char *sort_key);
> +int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
> +                               const char *sort_key, ...);

The new name of the function, mentioned in the patch description, is
    tracefs_hist_set_sort_key()
I like the name with "set" instead of "reset". The behaviour of the
function should be described in the function comments - to stress that
the old keys are overwritten.

>  int tracefs_hist_sort_key_direction(struct tracefs_hist *hist,
>                                     const char *sort_key,
>                                     enum tracefs_hist_sort_direction dir);
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index ea12204..a7c20de 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -437,16 +437,43 @@ add_sort_key(struct tracefs_hist *hist, const char *sort_key, char **list)
>  /**
>   * tracefs_hist_add_sort_key - add a key for sorting the histogram
>   * @hist: The histogram to add the sort key to
> + * @sort_key: The key to sort
> + *
> + * Call the function to add to the list of sort keys of the histohram in
> + * the order of priority that the keys would be sorted on output.
> + *
> + * Returns 0 on success, -1 on error.
> + */
> +int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> +                             const char *sort_key)
> +{
> +       char **list = hist->sort;
> +
> +       if (!hist || !sort_key)
> +               return -1;
> +
> +       list = add_sort_key(hist, sort_key, hist->sort);
> +       if (!list)
> +               return -1;
> +
> +       hist->sort = list;
> +
> +       return 0;
> +}
> +
> +/**
> + * tracefs_hist_reset_sort_key - set a key for sorting the histogram
> + * @hist: The histogram to set the sort key to
>   * @sort_key: The key to sort (and the strings after it)
>   *  Last one must be NULL.
>   *
> - * Add a list of sort keys in the order of priority that the
> + * Set a list of sort keys in the order of priority that the
>   * keys would be sorted on output. Keys must be added first.
>   *
>   * Returns 0 on success, -1 on error.
>   */
> -int tracefs_hist_add_sort_key(struct tracefs_hist *hist,
> -                             const char *sort_key, ...)
> +int tracefs_hist_reset_sort_key(struct tracefs_hist *hist,
> +                               const char *sort_key, ...)
>  {
>         char **list = NULL;
>         char **tmp;
> --
> 2.30.2
>


--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
