Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F60C33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9AF92072E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 12:10:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aqYYWuNQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgAFMKx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 07:10:53 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37651 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgAFMKx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 07:10:53 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so26823945pga.4
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jan 2020 04:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pldm63C03tQc2UP50zcAuypZd16DRiiw/6zzO9qJQtY=;
        b=aqYYWuNQkLyhJzea+aMzr5eBe1V3hkP9UUz5pRNUFkUlF3GmminoR338MpgoiivCDc
         HXLBIZtBk6W4xPY0wZ0RStAibqsvm+0pz8etY2O4izWe4VUQsIwQdTfctCNPfZcTilMq
         ZGeZL17sW9VB5VHObJohSbL3hQvoBp9tdeav3AjberztOfc6fMHoL0aDKPUzLuZlJ/Bd
         86HEkYQFzstoMrKI6mUPCnLtBYR7StK+NhFBTddZq2eKNPdGNv+rqZGCfTHTSQS4QE2/
         dSGey2MGias87RfmOMntyZu98Rp0lUz4z23w+YWW4CJZeL6I3eN1dS+VpUrvNtV13sY/
         lGIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pldm63C03tQc2UP50zcAuypZd16DRiiw/6zzO9qJQtY=;
        b=iZHIeTKyNdpRZUaGYZvOa4IFr/MPPJN72TJ/QVof9i4c7QC9rsg3koT0CVI60GEBiZ
         hlaapiHgIbznqjVkLTe9Rfs/PEjNsJXyGunrwWwjTyfdkIcY2GwN84LTe4sb6xaBqCqe
         Lp4IEvgJBQdX55kNIuFpZuCi4IM1eJhYIm5QYoQB3lfN9ZjfFcLnNHb3l9Tl31NeIlSN
         C+jdAQkWW9zB7kruDC+wMRHU/rcSnq9OgbZ1nd5G1Q6gQccLYonjT9EgScTuErcDyJje
         NNXMotsCF/vtsuvntliUlz6lMkd0ar1mjEZxfeBjN3TJvwz0eF3pTK8RYpirnD8vvudy
         vuLg==
X-Gm-Message-State: APjAAAXolg6VPFbvQetcFcWVmmt7PHB6l4a8nj8StEBXXEoZ8lBCG73i
        eCoI8iTSx9BCrGfXpncNo9/968v0nRM1ClCV1O5vJVTXxVw=
X-Google-Smtp-Source: APXvYqyDz7bJFNBbrH+sAerejYIf7w4I+hui3ytjjT0nosKDRIWzo2j/Q3lhORHe/lk3KG39+O9kGqbItd8w4v1l1G0=
X-Received: by 2002:a63:2cc8:: with SMTP id s191mr109742459pgs.206.1578312652654;
 Mon, 06 Jan 2020 04:10:52 -0800 (PST)
MIME-Version: 1.0
References: <20191219113502.28964-1-tz.stoyanov@gmail.com> <20191219113502.28964-4-tz.stoyanov@gmail.com>
 <20191219232131.0a6538a7@rorschach.local.home>
In-Reply-To: <20191219232131.0a6538a7@rorschach.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Mon, 6 Jan 2020 14:10:41 +0200
Message-ID: <CAPpZLN6gGQmsPTrp=cPcgde_fy5OXD2YrAP5rvg_AOGUhPVG_g@mail.gmail.com>
Subject: Re: [PATCH 3/6] trace-cmd: New libtracefs API tracefs_write_file()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Dec 20, 2019 at 6:21 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 19 Dec 2019 13:34:59 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > Moved write_file() static function from trace-record.c to
> > libtracefs API. The new API will be useful in future libtracefs
> > extension.
> > All die() calls in its implementation are replaced with warning().
> > A check is added to all current callers of tracefs_write_file(),
> > in case of a error die() is called, to keep the existing behavior.
>
> I'm curious to why this is being made as a library function, as its
> really just a helper function. Not sure it needs to be part of a
> library. It doesn't seem to be anything specific to tracefs. Or am I
> missing something?
>

My intention was to share the code between trace-cmd and the library,
but may be it is not a good idea to do it in such way. I'll remove
tracefs_write_file()
API and will add it as a local function.

> -- Steve
>
>
> >
> > Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
> > ---
> >  include/tracefs/tracefs.h   |  2 ++
> >  lib/tracefs/tracefs-utils.c | 41 ++++++++++++++++++++++++++++++++
> >  tracecmd/trace-record.c     | 47 ++++++++++++-------------------------
> >  3 files changed, 58 insertions(+), 32 deletions(-)
> >

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
