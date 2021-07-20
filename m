Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B2FC07E9B
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Jul 2021 18:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C9EA610A7
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Jul 2021 18:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGTRzo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Jul 2021 13:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhGTRzk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Jul 2021 13:55:40 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AACC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Jul 2021 11:36:14 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id u13so37215661lfs.11
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Jul 2021 11:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bHt0sZjd2SruSGor577rjcRuH+oWNXZGhZIo7JQTZNw=;
        b=LFYaqvDm18I3sArkdBmsCsGA6FMf6iWxWsAH9jsk7AYMQCS1Ofq4qOCFb6uIiRxRoE
         /i1acSLHCsi/poTX4nURILw4kIrBlePmcbuiSVWjkqC57FWKY1GTxQLzj1jetoXq9puM
         4VZtQ9eGeePYAjrMbHbfRBaFpRnDtAKuAhLtY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bHt0sZjd2SruSGor577rjcRuH+oWNXZGhZIo7JQTZNw=;
        b=IqTpMaCGFlRNgbP8JYuPYsxYLp5xTvw/14pVL4F+lkvyKqZ07cSOyLIGuQqlz+MlmG
         SPa2EL4sA3qkTe6ZrWCn8wdzHC5wapThXnt862gC7RYgPZiaHrjvI1A3Ggb7bvOwweAM
         m5/OcHkjbzOzemyse0QfbPD0aOVzctlAzSmSGlUpOdnnbN1Jpy2Vm4xxtsTP5fO6AhVx
         SLJ6WJNtregWUkGlSc5OTJIeUFbkc6zhT/kx0AcOvdwWoQ8D/7jEtmKBvPCei2eGC1KV
         QBnQEhAIo98CN0FMDfcs003EiCwb0kP/O7IC2jvxvNQvdKkjewdXdZUBJtoRduBAIbhi
         CMBg==
X-Gm-Message-State: AOAM530UZXF568/HoKmstdfiezjzzMyEhI5/r0P4BNaEW2cdpufErFo2
        N53cULHSOaZnpYEFmWTf+OnU/9mJYziq04oK
X-Google-Smtp-Source: ABdhPJzUXHm48jkGJA/tnUpjhxFVRfDcPYtjReJbYG/aUnV9iKcVRT7eJ/GLcHa5pt8wzzsTboWz4g==
X-Received: by 2002:ac2:5d2e:: with SMTP id i14mr22271679lfb.642.1626806172988;
        Tue, 20 Jul 2021 11:36:12 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id q20sm1573852lfu.168.2021.07.20.11.36.12
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 11:36:12 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id q16so37287940lfa.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Jul 2021 11:36:12 -0700 (PDT)
X-Received: by 2002:ac2:4475:: with SMTP id y21mr22508972lfl.487.1626806172300;
 Tue, 20 Jul 2021 11:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <YPaNxsIlb2yjSi5Y@aegistudio>
In-Reply-To: <YPaNxsIlb2yjSi5Y@aegistudio>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Tue, 20 Jul 2021 11:35:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
Message-ID: <CAHk-=wgFVAtZy9sc98nqujuEh-HqDW5WBvc+MAzobvphY8vZog@mail.gmail.com>
Subject: Re: [PATCH 1/1] tracing: fix bug in rb_per_cpu_empty() that might
 cause deadloop.
To:     Haoran Luo <www@aegistudio.net>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        linux-trace-devel@vger.kernel.org,
        Security Officers <security@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jul 20, 2021 at 2:04 AM Haoran Luo <www@aegistudio.net> wrote:
>
>         return reader->read == rb_page_commit(reader) &&
>                 (commit == reader ||
>                  (commit == head &&
> -                 head->read == rb_page_commit(commit)));
> +                 (rb_page_commit(commit) == 0 ||
> +                  head->read == rb_page_commit(commit))));
>  }

Can we please re-write that whole thing to be legible?

That conditional was complicated before. It's worse now.

For example, just splitting it up would help:

        if (reader->read != rb_page_commit(reader))
                return false;

        if (commit == reader)
                return true;

        if (commit != head)
                return false;

        return !rb_page_commit(commit) ||
                commit->read == rb_page_commit(commit);

but adding comments to each conditional case would also be good.

Note: I checked "head->read" to "commit->read" in that last
conditional, because we had _just_ verified that "commit" and "head"
are the same, and it seems to be more logical to check "commit->read"
with "rb_page_commit(commit)".

(And somebody should check that I split it right - I'm just doing this
in the MUA without knowing the code: I hate conditionals that are
cross multiple lines like this, and I hate them particularly when they
turn out to be buggy, so when you fix a complex conditional, that's a
BIG sign to me that the problem was that the conditional was too
complex to begin with).

Btw, that "rb_page_commit()" forces a new atomic read each time, so
the "rb_page_commit(commit)" value should probably be cached as a
variable before it's used twice.

Steven?

                  Linus
