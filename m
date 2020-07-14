Return-Path: <SRS0=mFmS=AZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A91BEC433FB
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 12:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85062222B6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Jul 2020 12:12:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oA2H3QwM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgGNMM1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbgGNMMW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 08:12:22 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C76BC061755
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 05:12:22 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m9so7514585pfh.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Jul 2020 05:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z5SuEbu5DgWRAV25cWkC9Fvq7lHXyiKOGSywtszrPCo=;
        b=oA2H3QwMnVvcXJF3vhgE/hDi4lpsghLntSbPMkWTU/cc1msnMZvP4lasGT7bxGiIuk
         +bSi6T5RkiLSk+ti5UrkrHGgg0tQ8eUoPa8uI/SubCkTT9i2vJHmBkLZv9/zPMVOWiSW
         gx4JvBUZNhEteoNdtGe9CqLWHpcjroJahoMNU8BS0CeM6YUABXDvb9LisNXVCOJ6OCyk
         nq1aS28+ePjMjI7f8pn+a6XxmvYSJ6qrYaECg5AJzMuX5s+qQoE0zYcyPwdgn8gvrnjf
         Q6qSFB8uFtaYq61HF/zlfIHFhLJaWAMDAPOUNl8IPEA8SD+zJyakx5N0Jw4v8HW4t29X
         hy4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z5SuEbu5DgWRAV25cWkC9Fvq7lHXyiKOGSywtszrPCo=;
        b=LbbFxl9GdpTCe/dxOweXJe3Y0yuDqK9Bqz/0L6aIQkeIsy27pb7V9tzxKRcbiSq2zy
         ovLlh5odCIF14tHwgZeoqQQztEmZ3y6NBOrbJO+1/FEV2cRw2iRSi6Cbs910ymSna469
         7k7mumLPJIEhabPEvx+bAteqG8WWRmxP6wfcxlJMB6uzwGr6E0Q8CNBkQOKWTMdJUmi9
         IVgFZ9NSa7gKdcB+jRPZ08gSPyEmdYe43VPhCFtzYnF4P0QRvDM9WhHKZtauudqjtV4A
         a6UJRm2haPl0Enlj5Jg2NeEfzW0ACkQtuKua9sGVnajH2GLsvtxwIdZrT3N3/WJNS6Hi
         o+cg==
X-Gm-Message-State: AOAM530tWiuGaE0i2FqiwXgw6/0JG1DCQftv7n6Id9MetPXSDiCR9hvd
        U2MniY38cbcZ5sMZQ5qgUVZh+j0FawHsPMuArZ4=
X-Google-Smtp-Source: ABdhPJyxzJs64BcNlLnsQAm9+AJEVGbE0E/nf+UGKfpwACgJL0WYEsrkKfJ8puSMgMXJuh2diqR2HkWR7e2BarvzpKw=
X-Received: by 2002:a63:417:: with SMTP id 23mr3031321pge.44.1594728741793;
 Tue, 14 Jul 2020 05:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200714103027.2477584-1-tz.stoyanov@gmail.com> <CAM9d7cg-5sJ-iqCU25MqmdTOdoWPqcyFJFqdc67PdRwjwqqPsA@mail.gmail.com>
In-Reply-To: <CAM9d7cg-5sJ-iqCU25MqmdTOdoWPqcyFJFqdc67PdRwjwqqPsA@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Tue, 14 Jul 2020 15:12:10 +0300
Message-ID: <CAPpZLN6WVv3zUtcLgGAPoVJSOZtHDs+TOncXma-VS2TVRBL8BA@mail.gmail.com>
Subject: Re: [PATCH 0/8] Few libtraceeevnt fixes, suggested Namhyung Kim
To:     Namhyung Kim <namhyung@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Jul 14, 2020 at 3:07 PM Namhyung Kim <namhyung@kernel.org> wrote:
>
> Hello,
>
> On Tue, Jul 14, 2020 at 7:30 PM Tzvetomir Stoyanov (VMware)
> <tz.stoyanov@gmail.com> wrote:
> >
> > Fixes in libtraceeevnt, suggested by Namhyung Kim <namhyung@kernel.org>
> >
> > Tzvetomir Stoyanov (VMware) (8):
> >   trace-cmd: Document tep_load_plugins_hook()
> >   trace-cmd: Handle strdup() error in parse_option_name()
> >   trace-cmd: Fix typo in tep_plugin_add_option() description
> >   trace-cmd: Improve error handling of tep_plugin_add_option() API
> >   trace-cmd: Fixed broken indentation in parse_ip4_print_args()
> >   trace-cmd: Fixed type in PRINT_FMT_STING
> >   trace-cmd: Fixed description of tep_add_plugin_path() API
> >   trace-cmd: Handle possible strdup() error in tep_add_plugin_path() API
>
> Shouldn't the prefix be libtraceevent ?  Other than that,

I decided to address the comments in trace-cmd repo first, and after
that to backport the patches to the kernel's libtraceevent. That's why
the prefix is trace-cmd.
Thanks for making such a detailed review, Namhyung !

>
> Acked-by: Namhyung Kim <namhyung@kernel.org>
>
> Thanks
> Namhyung
>
> >
> >  lib/traceevent/event-parse-local.h |  2 +-
> >  lib/traceevent/event-parse.c       | 10 +++---
> >  lib/traceevent/event-plugin.c      | 50 ++++++++++++++++++++++--------
> >  3 files changed, 43 insertions(+), 19 deletions(-)
> >
> > --
> > 2.26.2
> >



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
