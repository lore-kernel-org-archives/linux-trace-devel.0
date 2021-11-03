Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D565DC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2BD261051
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Nov 2021 16:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbhKCQhm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Nov 2021 12:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbhKCQhm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 12:37:42 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABECFC061714
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Nov 2021 09:35:05 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u17so2831882plg.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Nov 2021 09:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7fQptE/WuRvY4bo8nnCOatcwIc9yYzyPFKiplcidoms=;
        b=mYd4dznOfbkta2lRNrj6p+GLSo/H4YmyDzeXdK3V8yaErNj7rfBa8DNM+7h5wdvAJV
         G40UlBXX6qK8p4q4VOtHmQx3G3BWobeB8FNXhsqky+BDROEXGqyqjRqcH/+leTrQfGbg
         cJxl0ljA+ruXOU61p3Tnyj30ZpIjQdh/P2dlLWrHHSL7nnMTOq4CpUz2dimKiCtXqvw+
         XdcBonYQ7TiOvGCGgQidYIeAAcGbbih7oaOA7QUPzl+2WoXhJS3mYoal1WXpxdkjIeKF
         lw2KyWbWK3nMnmhwGVnodgMg0iyMyMJNIujMCAh/OkxDualtuzbxtwAzS8CD0G+rFsUc
         m/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7fQptE/WuRvY4bo8nnCOatcwIc9yYzyPFKiplcidoms=;
        b=YgrWzURx7hpZSlX6qko+Az0KxW3JpO10Z0FvbFN6j277N1z2VwquwBqOIK5jAQOvKG
         VDd+cyiogHH0mlxCaxPJpwljgI/SniwZn7wuUz905RpQdWNybjTQq0GZWWcP3MirvgGg
         HRIMtE3nutv2JSGbL86ysGtpZFx4iaSNyptA3nSeHATiPJF7pvG73dKtClBf7r9Yhkft
         f3LZ7KBH9bgPpUNVDtjuioQhpgetqP1FK9SPc/ZDXo/6BdzZBGEme516tsijr9VQJU7K
         VbjpGQVSvzGrVf2TGVOxoMCYqL83J6dWWRorYM9nZAofRxD6AEIvQtPy7ntWJ/G7GxPE
         ffxA==
X-Gm-Message-State: AOAM532QDfZaJ9muSr4ApIzMb8RV0B0zCxryYXx7WgUdrhr3v08wLDMg
        lLr9mrVZwOPiHuaVox1fRPpCRd6OlUfhp3c1CSI=
X-Google-Smtp-Source: ABdhPJxmQTThA52uL7sBsUcF012OvU+Yl2C2xKt8g8y6diO+t/MhABs5pUyExOveBHD8r+6+ueG/y55YavAjzjFOl9I=
X-Received: by 2002:a17:902:748c:b0:141:c45e:c612 with SMTP id
 h12-20020a170902748c00b00141c45ec612mr27585636pll.73.1635957305203; Wed, 03
 Nov 2021 09:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20211103154417.246999-1-tz.stoyanov@gmail.com>
 <20211103154417.246999-2-tz.stoyanov@gmail.com> <20211103122406.7a21859c@gandalf.local.home>
In-Reply-To: <20211103122406.7a21859c@gandalf.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Wed, 3 Nov 2021 18:34:49 +0200
Message-ID: <CAPpZLN5ihwBHfKaaUtZGddRnJrrEvdsqc1poohUNxRmdiovo5g@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] libtracefs: Add new public macros for bits manipulations
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Nov 3, 2021 at 6:24 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed,  3 Nov 2021 17:44:07 +0200
> "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:
>
> > diff --git a/include/tracefs.h b/include/tracefs.h
> > index a2cda30..fa7f316 100644
> > --- a/include/tracefs.h
> > +++ b/include/tracefs.h
> > @@ -10,6 +10,10 @@
> >  #include <sched.h>
> >  #include <event-parse.h>
> >
> > +#define TRACEFS_BIT_SET(M, B)        do { (M) |= (1ULL << (B)); } while (0)
> > +#define TRACEFS_BIT_TEST(M, B)       ((M) & (1ULL<<(B)))
> > +#define TRACEFS_BIT_CLEAR(M, B)      do { (M) &= ~(1ULL << (B)); } while (0)
>
> Does this really need to be public?
>
> I was thinking that this would just be used internally, and thus in the
> tracefs-local.h.
>

The  only reason to export it is because of these APIs, which get
bitmask of enum tracefs_dynevent_type types:
     int tracefs_dynevent_destroy_all(unsigned long type_mask, bool force);
     struct tracefs_dynevent **tracefs_dynevent_get_all(unsigned long
type_mask, const char *system);
Currently that type is simple enum, and those macros are used to
construct the bitmask:
enum tracefs_dynevent_type {
    TRACEFS_DYNEVENT_KPROBE = 0,
    TRACEFS_DYNEVENT_KRETPROBE,
    TRACEFS_DYNEVENT_UPROBE,
    TRACEFS_DYNEVENT_URETPROBE,
    TRACEFS_DYNEVENT_EPROBE,
    TRACEFS_DYNEVENT_SYNTH,
    TRACEFS_DYNEVENT_MAX,
};

The other possible approach is to define the eum in that way, then no
macros will be needed:
enum tracefs_dynevent_type {
    TRACEFS_DYNEVENT_KPROBE = 1,
    TRACEFS_DYNEVENT_KRETPROBE = 1 << 1,
    TRACEFS_DYNEVENT_UPROBE = 1 << 2,
    TRACEFS_DYNEVENT_URETPROBE = 1 << 3,
    TRACEFS_DYNEVENT_EPROBE = 1 << 4,
    TRACEFS_DYNEVENT_SYNTH = 1 << 5,
    TRACEFS_DYNEVENT_MAX = 0,
};

> -- Steve
>
> > +
> >  char *tracefs_get_tracing_file(const char *name);



-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
