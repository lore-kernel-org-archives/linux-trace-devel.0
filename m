Return-Path: <SRS0=0lml=RS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E142C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:21:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD313218A5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 15 Mar 2019 10:21:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IbpnzW+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfCOKVr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 06:21:47 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41861 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfCOKVr (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 06:21:47 -0400
Received: by mail-io1-f68.google.com with SMTP id v10so7762058iom.8
        for <linux-trace-devel@vger.kernel.org>; Fri, 15 Mar 2019 03:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qlv+ocpWlVFRWqpta1bdfPlRWJSauxuURNgXky+hzf0=;
        b=IbpnzW+cLuWo3p2oHj9VqYPKBowhEyrAJamWOpoIcGPw+BBbl77JAm6nlRt/VKMju+
         mPeF7qTywPWGrb9EGrSD6G/H8PL8rRnWTC4FYA9195dD+0/lmgAT32Y1T3P2PajFxK6A
         Ed1L62Z1CNJG875ooRL5TpXaRDB0nip0LTkfXpD3sVGokHKZLW+jNg71I32Oh7B1W5Le
         h8VwTjKz3/99J9Y4wqLWbTwuO7CNOfWqw2zq+yFZPO8y8768s+Ziu2q6sK3/scSQNANx
         XstUOlOKg7FA/lr+TmwHIkU7NGHJgaQQ7XARBPpHUYWldfp+Ov97IimF/qAQu7/qOyeC
         nISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qlv+ocpWlVFRWqpta1bdfPlRWJSauxuURNgXky+hzf0=;
        b=M6z/85iUngnFOty/PR5TOb2V7dru1O6FLE2AoUFhZuDbnFmkp8V+mOpS7ph6wmkhMl
         075WRanL2hMp+MtkTeobsKP1D5oAdo+9MlKNQ3c5jp12rO849L44daGN0FU79AM4TpbK
         s/okAyPja5abgyMJv8dkSGFk19St26OCXyN/GJI/cbtmABN4iZkbGLNZhbOsBOTFi+tG
         X0HJdNTHTgSm6iJhWd+bfyNf+ArKCz/0sH7eSCRbclwvNKPQXIWrBWrnaY9Gxl7YqhY9
         tXBk58PiZKDDZVH6Jx6fMR2Ww0cUVmDyHiZGGES5GTA6+oUPQpGouCcXMiju2Drs05E/
         H+3w==
X-Gm-Message-State: APjAAAUEzfJmmB8M4iKEcwR9g1ESOOJENXx6i1eakD7yFLZJx0/+l4M6
        8/TPsAQC66Ha1dvvbIu6yL0vYi76VOMFhDpfSg==
X-Google-Smtp-Source: APXvYqwZt2gZS8cmxA449O7nTMbSMg6lC1SsKPXS+tG2m/cyze1hkG549555jhk3EEdFZ8BeK4xAf6WJVZH1UyQZl8E=
X-Received: by 2002:a5d:9947:: with SMTP id v7mr1747930ios.81.1552645306475;
 Fri, 15 Mar 2019 03:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190314151012.905-1-ykaradzhov@vmware.com> <20190314151012.905-12-ykaradzhov@vmware.com>
In-Reply-To: <20190314151012.905-12-ykaradzhov@vmware.com>
From:   Slavomir Kaslev <slavomir.kaslev@gmail.com>
Date:   Fri, 15 Mar 2019 12:21:35 +0200
Message-ID: <CAE0o1NtREV88Xz9EAntMcubKUJLDM+Q_w1Yn5xfoWEFntBTmLg@mail.gmail.com>
Subject: Re: [PATCH 11/12] kernel-shark: In model, handle the case when all
 bins are empty
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Mar 14, 2019 at 5:11 PM Yordan Karadzhov <ykaradzhov@vmware.com> wrote:
>
> ksmodel_set_bin_counts() should not crash in the case when all
> bins of the model, except the Upper Overflow bin, are empty.
>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/libkshark-model.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/kernel-shark/src/libkshark-model.c b/kernel-shark/src/libkshark-model.c
> index af3440b..29676c7 100644
> --- a/kernel-shark/src/libkshark-model.c
> +++ b/kernel-shark/src/libkshark-model.c
> @@ -290,7 +290,7 @@ static void ksmodel_set_next_bin_edge(struct kshark_trace_histo *histo,
>  static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
>  {
>         int i = 0, prev_not_empty;
> -       ssize_t count_tmp;
> +       ssize_t count_tmp = 0;
>
>         histo->tot_count = 0;
>         memset(&histo->bin_count[0], 0,
> @@ -303,7 +303,7 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
>                 prev_not_empty = LOB(histo);
>         } else {
>                 /* Loop till the first non-empty bin. */
> -               while (histo->map[i] < 0) {
> +               while (histo->map[i] < 0 && i < histo->n_bins) {

I would suggest switching the order of those checks

    while (i < histo->n_bins && histo->map[i] < 0) {

It's safe as is since hist->map has histo->n_bins+2 entries but
checking bounds before dereferencing is more idiomatic.

-- Slavi

>                         ++i;
>                 }
>
> @@ -316,7 +316,8 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
>          */
>         for (; i < histo->n_bins; ++i) {
>                 if (histo->map[i] != KS_EMPTY_BIN) {
> -                       /* The current bin is not empty, take its data row and
> +                       /*
> +                        * The current bin is not empty, take its data row and
>                          * subtract it from the data row of the previous not
>                          * empty bin, which will give us the number of data
>                          * rows in the "prev_not_empty" bin.
> @@ -358,7 +359,7 @@ static void ksmodel_set_bin_counts(struct kshark_trace_histo *histo)
>          * We will do a sanity check. The number of data rows in the last not
>          * empty bin must be greater than zero.
>          */
> -       assert(count_tmp > 0);
> +       assert(count_tmp >= 0);
>         histo->tot_count += histo->bin_count[prev_not_empty] = count_tmp;
>  }
>
> --
> 2.19.1
>


-- 
Slavomir Kaslev
