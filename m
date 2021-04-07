Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D864BC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF3E061284
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 16:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347947AbhDGRAF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Apr 2021 13:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343608AbhDGRAF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Apr 2021 13:00:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC6FC06175F
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Apr 2021 09:59:56 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id mj7-20020a17090b3687b029014d162a65b6so1632166pjb.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Apr 2021 09:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r0kZtuBxga3yivPMlRLd4TbiArnxTvmr+HUQt39zETM=;
        b=gWaoDMFZZY9VUcvC2uIZU2xRdqzoo5JpIR254C6wRXt1z7KItcO5iqHBcMBVYFepBE
         5i3Ulswtpzdj0iQzb4m9bfEFn/L7pt71+TgiTAQ+HKNlipK4Nh2YLivJqGfRlD745Sdz
         NOcXtz8kAta14Njbw0mFGv3W9qbfxL80Ova7lG6HtlNFOnXS509dlWLmNAhT/drZMF81
         5EVD0vJPIS1M7eSA82kkGrblv3tF/3fnu6BsxxaqMOfZPM0dhwlqAxB2eDZKfbNfyuNA
         i8O4EO9oXVCOQRUfQHr12JWLNHcbf8OTTtLYkJTQIFJ8ry22OsJFwzWT/CVHH7anqlo4
         ycfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r0kZtuBxga3yivPMlRLd4TbiArnxTvmr+HUQt39zETM=;
        b=OmN3HCpUDdZTv5doi+sy8/2N05KFYGrLClqNLFjAqv8YnwShhjpi45QUzMelPwVhkn
         DRCjlhvTQFGYILqVoIDH0XYWbWaL/TuZJwm2TH4nJY2uOsV+hr02WiXgKsc4cJw5skFS
         JCEHIbbLji0H8uPjpTy1LCHbGS/3Pliw+w94wJjF5gYH7suyu0V8JjLMyqx9dK6sutjF
         LMVXqJi7jreWKPnBg1Uhd9EfKkSoJsNSO1u5d3IICYI0f0ApYSccNF3sChrqTkhqgueD
         BZe8dw5jyrjwj+9VIdLAbLxgqbCrK3CxYjISRS4inUq6/mEL8OAKPfxssfWYeSkvUr8M
         Xw9w==
X-Gm-Message-State: AOAM533EbwQNhvqRo8G86Gw2DXVwQij8PxEZ3EwE6epDdyOMMWBZvIXV
        NdP3ehE8MkpoYmXfZd8JW5rqASqHCdbMjp8rZuDy/UVaqMoYUA==
X-Google-Smtp-Source: ABdhPJwGozyvYUzdiybl1Ub9lJXxKrsUWF2q3fRg6o3QZkPMCINIxu2QPbJKd+plzlcjjjGy2L8D1g8uOwD84KP05nE=
X-Received: by 2002:a17:90b:1643:: with SMTP id il3mr4269423pjb.2.1617814795744;
 Wed, 07 Apr 2021 09:59:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210407051154.2422172-1-tz.stoyanov@gmail.com>
 <20210407121928.464045ee@gandalf.local.home> <CAPpZLN4BUmTwx1QGYLZPoWc0iTRS0GPN3vo1GkXXd9GFerToVg@mail.gmail.com>
 <20210407125432.2de1382d@gandalf.local.home> <20210407125554.17b480e5@gandalf.local.home>
In-Reply-To: <20210407125554.17b480e5@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 7 Apr 2021 19:59:39 +0300
Message-ID: <CAPpZLN5YeKp0tFLLTwqz4wyH7UXFoptm_bViuyPK6oimiFTOkw@mail.gmail.com>
Subject: Re: [PATCH] libtracefs: Implement tracefs_warning()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 7, 2021 at 7:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 7 Apr 2021 12:54:32 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > > 3. A weak function specific to each library is a more straightforward
> > > way and the user has the flexibility to control warnings per library.
> > > The overhead to add library specific wrappers to those weak functions
> > > is not so big.
> >
> > It's an unnecessary burden. You may add libtracecmd, and want to capture
> > all the warnings and overwrite tracecmd_warning(), but then see that
> > there's other warnings coming from libtraceevent and libtracefs that you
> > never included (because libtracecmd pulled them in). And it's not obvious
> > how to deal with them.
>
> I'm fine if you want to make them all weak, but I really like to have a
> single function that can control all of them.

I'll submit the next version with weak functions for each library and
all of them using the __weak tep_vwarning() for the printing.

>
> -- Steve



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
