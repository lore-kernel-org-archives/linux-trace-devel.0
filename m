Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47B20C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 15:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2926A60EE9
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 15:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347120AbhIXPxd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 11:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbhIXPxa (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 11:53:30 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6ADC061571
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 08:51:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v19so7274578pjh.2
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 08:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l9Z9xvDGDZYaGKzJDt2K2aPjrpt9Or025AVUn+EmvUg=;
        b=dDeZKNRemKOg+s4hXjZkdQn7KFwnRpfmN/Q/H6iefXmgvzyQYPIZs9/uMGLOUX8e+8
         QyXQZwA4Kl8XU1lvgw6Ym2+JKsK+mO/+opVgj+g0oe4sd5/EIq8wIznBwdkm79hu8z4P
         r+qhNEzI3bJ0vlRmk65fVYepPfrwxVaT3ip3Eteuescgcc49Vt/kfwK0BAoMUF5UU/Vz
         M6T8dlpsfSm5XbXNEo5Ak2TLgGFtCtc/+O77Bt+6IoNvucVNXlQv4wMNdhEL8hDlCUNi
         yx5AJHw/Wm9TD38XFhatlsSxB8hoWVGrEImZrk9waMwTyamzMXq6CMVM3YFbVkmBz9+h
         kkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l9Z9xvDGDZYaGKzJDt2K2aPjrpt9Or025AVUn+EmvUg=;
        b=8O+dgZfU7jPxPVgqGMKATusLUOt07H2ANr5PjJJnLIApQ/i7KvQjXaqSC4n85w6VfH
         7+MEeZo6nxVJ2TJclJbA9zepMjrdNhAx2Lv56/EdIlfITdAD/KSNeZSPr34G5DUGH6Wh
         w1SeAM2xg4giDAyI3avCaS+bK0vHCFW/IBN3ti6w2czztdsBzYlWE+KtvmH/q3kR91dD
         VezZ8pXelDVxlXmEnWTXAUgEwckba8KZHCTdazFjLclIGiZmUvhHL8G/OLptQQAjHPrh
         jdEkeZzFv2Yq+4v3V11Z7PFWS8DBC+GvnEnBKVQ86fiQILPGWh07tKkMfDiRjQcN4NCe
         VGUw==
X-Gm-Message-State: AOAM533x/9MxnHcS1GkVq4k53QQQ4BcQ1Y6p0W5fZTSsksXMoyRpV4IV
        1oBq62RkSsT6hITFfe1e9GhzyPLlDM6SSTXQg5LpVtNyN3k=
X-Google-Smtp-Source: ABdhPJxUgd0b8nElbEafyLx7o6/8ML8uI0xwdT7He/aLjRVVaGQS5kEhxnwA7g+vkmAoVgypC24Bw4a0PxRmgzsPUFo=
X-Received: by 2002:a17:90b:33c2:: with SMTP id lk2mr3085990pjb.111.1632498716519;
 Fri, 24 Sep 2021 08:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210924095702.151826-1-y.karadz@gmail.com> <20210924095702.151826-2-y.karadz@gmail.com>
In-Reply-To: <20210924095702.151826-2-y.karadz@gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Fri, 24 Sep 2021 18:51:38 +0300
Message-ID: <CAPpZLN7daWb2g_45CG3NzfKrEvK8NHNE+6k1NayYOL3u2b_EDw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] libtracefs: Add new constructors for histograms
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
> The current way to create an N-dimensional histogram is bit
> counterintuitive. We first have to call tracefs_hist_alloc()
> which is essentially a constructor of 1d histogram. Then we
> have to call tracefs_hist_add_key() N-1 times in order to
> increase the dimentions of the histogram. Here we transform
> tracefs_hist_alloc() into a constructor of N-dimensional
> histogram and we also add 2 helper constructors for 1d and
> 2d histograms.
>
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>  include/tracefs.h  | 19 +++++++++--
>  src/tracefs-hist.c | 84 ++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 87 insertions(+), 16 deletions(-)
>
> diff --git a/include/tracefs.h b/include/tracefs.h
> index 9d84777..5c4141e 100644
> --- a/include/tracefs.h
> +++ b/include/tracefs.h
> @@ -310,10 +310,25 @@ enum tracefs_compare {
>  };
>
>  void tracefs_hist_free(struct tracefs_hist *hist);
> +struct tracefs_hist *
> +tracefs_hist1d_alloc(struct tep_handle *tep,
> +                    const char *system, const char *event_name,
> +                    const char *key, enum tracefs_hist_key_type type);
> +struct tracefs_hist *
> +tracefs_hist2d_alloc(struct tep_handle *tep,
> +                    const char *system, const char *event_name,
> +                    const char *key1, enum tracefs_hist_key_type type1,
> +                    const char *key2, enum tracefs_hist_key_type type2);
> +
> +struct tracefs_hist_axis {
> +       const char *key;
> +       enum tracefs_hist_key_type type;
> +};
> +
>  struct tracefs_hist *
>  tracefs_hist_alloc(struct tep_handle *tep,

For consistency with the newly added "alloc" APIs, this should be
renamed. The dimensions of the histogram are part of the name, this
one is for N dimensions:
  tracefs_hist_alloc_1d()
  tracefs_hist_alloc_2d()
  tracefs_hist_alloc_nd()
or something like that.

> -                  const char *system, const char *event,
> -                  const char *key, enum tracefs_hist_key_type type);
> +                  const char *system, const char *event_name,
> +                  struct tracefs_hist_axis *axes);
>  int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
>                          enum tracefs_hist_key_type type);
>  int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
> diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
> index c112b68..ea12204 100644
> --- a/src/tracefs-hist.c
> +++ b/src/tracefs-hist.c
> @@ -189,7 +189,7 @@ void tracefs_hist_free(struct tracefs_hist *hist)
>  }

[...]

--
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
