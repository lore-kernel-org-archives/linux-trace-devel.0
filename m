Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F59C432BE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 13:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E3456109E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 13:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbhIBNVh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 09:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhIBNVh (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 09:21:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40289C061575
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Sep 2021 06:20:39 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id s29so1632489pfw.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Sep 2021 06:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=REGew4hKA4qbNPWVXn9xqk81UVUOBdUt9MfbTb2QrU0=;
        b=IQ/z59NjGdQsatynyQvz4UYql3XYxycjk9WQMzcvbwl7jF870yF6cJ8gIsy3j9X7w6
         InXis6DUw+YnRzFdGsBh1t1X+05hlvLfQdsOMaeck/6F6fKcng1bt5TeziJX82JSuLsq
         2VajgokeAgkKSJMLQHCIjXsHdF+0UV4MFEwf/3RQGFixNXwu64TPSFxOcCAUtQ2f7u81
         4ILnjzSHB6lr/pVDWWtI7dHbYLa9ecu5SrtJ48ZylMgRVA5vMZ9NML1/NrrzhwkYrTQd
         qAz/OUIxgdDFrtZwvVzs6Nuj25egILcpNrM91FSWChyA66UT9dYCY33TP0gSpiZRb8nt
         HgNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=REGew4hKA4qbNPWVXn9xqk81UVUOBdUt9MfbTb2QrU0=;
        b=ZKcyWs/GHOIV9JHQ5KgC02+D+ftdHleIiklmjY/QHy5JTe2AtMcVB3M0CEk2hfFkb2
         FxVHF5omHHjO2+/JRaZEL4q4GFQC1dcOHy4uGqoWYqC47D1hIpg50OuCyq26OdIGoJIa
         VayDq/tVLa18K6V3kkFvfKbfm2zo3jr8L88me77LoYX7RhoqO5OUSO0JXvhDfZkHpH9j
         axxDIqIOkVbVH10O2hSEC0g6SI6Rsz0gP3MEEGwBbgKx0hcLcDJIqG+eQ1giKOItzmrT
         D7hn3uUzErw8lCyLe9BoPTu+AdwlestoZh9Rw3/pVTDzIIur9+B6l5ErKZsCLmpS2S+e
         CT0A==
X-Gm-Message-State: AOAM530bDYKmbrDhgkfHwDjF5XCqlmFeaVSKhtcwwOPOOIpapB0n16nG
        BozYmVyM+GfowHYnccJagdeITQw1AjKJ23DzuWKAbm0euRC9vA==
X-Google-Smtp-Source: ABdhPJxgjLBUjmrYrzaApa0z96NcBT6D6gEgfx3r3/nCdfN0Ar+AmUlmlumlY6EZCsz44HYLVv6iu3kVqSxEpp2DLyo=
X-Received: by 2002:aa7:8151:0:b029:3e0:bba6:9754 with SMTP id
 d17-20020aa781510000b02903e0bba69754mr3494709pfn.19.1630588838756; Thu, 02
 Sep 2021 06:20:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210729050959.12263-1-tz.stoyanov@gmail.com> <20210729050959.12263-29-tz.stoyanov@gmail.com>
 <20210817114038.2a163dc2@oasis.local.home>
In-Reply-To: <20210817114038.2a163dc2@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 2 Sep 2021 16:20:22 +0300
Message-ID: <CAPpZLN7+ccxA9C9O841CwXN40yVN=0aL8ZRjBw1wZ=LaUZwSzA@mail.gmail.com>
Subject: Re: [PATCH v2 28/87] trace-cmd library: Move CPU flyrecord trace
 metadata into the buffer option, for trace file version 7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Aug 17, 2021 at 6:40 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
[...]
> > +
> > +__hidden struct tracecmd_option *
> > +out_add_buffer_option_v7(struct tracecmd_output *handle, const char *name,
> > +                      unsigned short id, unsigned long long data_offset,
> > +                      int cpus, struct data_file_write *cpu_data)
>
>
> Why is this hidden, and not static?
>
> I noticed that you are using "out_" as a normal prefix. Is that really
> needed?

I use "out_" and "in_" prefixes for internal library functions,
related to tracecmd_output and tracecmd_input handlers. For example,
there are:
  int out_uncompress_block(struct tracecmd_output *handle);
  int in_uncompress_block(struct tracecmd_input *handle);

>
>
[...]



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
