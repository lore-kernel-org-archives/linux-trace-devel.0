Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66FBEC4320A
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 13:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53522610A0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Sep 2021 13:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344895AbhIBNIu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Sep 2021 09:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbhIBNIt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Sep 2021 09:08:49 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3FFC061575
        for <linux-trace-devel@vger.kernel.org>; Thu,  2 Sep 2021 06:07:50 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id k17so1157391pls.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 02 Sep 2021 06:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIq8VLtBSbrt6atEFDgol/WG4rATYjwR9g0IGaoiInk=;
        b=F2ADpUJhIjwXS8XLM+87yuMZezFkioL0S304H1olSUU6t8PUq85/lYXyew+pL/CKAL
         HIEm2rDPE2S+V1qeTzlF+KMNJA89ENvjxg8fL7Y8FRF5PULxm8fk9PxREXmuE/WUz5KU
         BbGCHfy6pieETsWSv9VhSVUsEL6n66BbGzKJnx+hopfMttMtnHRUmdVdcsbN0ehunwmg
         wycPNH2qDitzRknhn7NKzPQg4hcybSxWIDExE9k7DnvbZyqH2KMyMDM1l4Iv6Z2jJtj7
         8Cu5HjgechBRhtrkspL+cVIdB94A51ko7CvApi31kgDV8BXlK043iktPQTadgF7sg+Yk
         9Llg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FIq8VLtBSbrt6atEFDgol/WG4rATYjwR9g0IGaoiInk=;
        b=HuZqTUuAHeGV8R6T5A0vGrg6pK0dEORgY66cZdtEC9lAKfxtHa+EGARRcWUzkVzwPI
         UB6a3P0zwcBe6zkaw0PGZbNgw6S6EezxjOOj9RhvckeSV4gvVILbdBgwn8jg5dEw8hEh
         BbrYE7gDdfEYUKa7lgYPSlNDk+nHxrgpZjVq6LBRDU+hIb/IAFRUeJCuVr3fp22tL6Ys
         Zwgc4JqbqvPBu/zArjFeLtU6fvnF+vHKZYg5/dodhIM1d2iaD/immn2TsEGm+sU1pIHm
         zFtDl8LY5A8ilrtBLg5D5DQWEK4XZ2ig/rYPz5Ollj2B1SBAFRNvihGP2FtegPvvmzTt
         7SXg==
X-Gm-Message-State: AOAM531hnlGhWU+6AnqdEiasBWVE6E9cgMhnTA6g3I0+eMX9MEYcSSMq
        K9esAiirldAksyX4tCkM2m1AiCj0/ctHNxAAxlk3d0I/YCc=
X-Google-Smtp-Source: ABdhPJzo8KT8iqv0gJaL9QZ5S1jBrfTyLuM5duIkZOY2M2sqE6oebVwEGceV4MqsJug9H/U3ZTFdJNGKhSjyxulw2Vw=
X-Received: by 2002:a17:90b:3b81:: with SMTP id pc1mr3921069pjb.69.1630588070374;
 Thu, 02 Sep 2021 06:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210729050959.12263-1-tz.stoyanov@gmail.com> <20210729050959.12263-88-tz.stoyanov@gmail.com>
 <20210819153358.172ad728@oasis.local.home>
In-Reply-To: <20210819153358.172ad728@oasis.local.home>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 2 Sep 2021 16:07:34 +0300
Message-ID: <CAPpZLN43FmNb=wSVyT1zKmLEf_XshDhC61vW_f+j5+bxp2Vx0g@mail.gmail.com>
Subject: Re: [PATCH v2 87/87] trace-cmd: Document trace file version 7
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 19, 2021 at 10:34 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> OK, so I quickly went through the rest of the series, and this really
> should have been at least 4 different patch sets. This series was
> really hard to review, because it bounced around between clean ups,
> sections, compressions, and conversions.
>
> Thus, I'm going to set this entire series to "Changes Requested".
>
> Please break this into at least 4 patch sets (here's 6 I would recommend).
>
> Patch set 1: Clean ups.
>
> Any change that was to make v6 work better with v7, or fix to v6 or
> whatever. Should be first. It should be non-controversial, and we can
> get that in right away.
>
>
> Patch set 2: Sections:
>
> This adds the notion of v7, but also adds all the work that has to do
> with sections. Anything that has to do with compression, should be the
> "non-compressed" case. The focus of this series would be to simply
> break up the file for v7 where it is grouped by sections.
>
> Patch set 3: Compression
>
> This is where you can add all the changes that deal with compression.
>
>
> Patch set 4: Conversion
>
> This will add all the changes that are used to convert between v6 <-> v7.
>
> Patch set 5: Dump
>
> The changes here would be for dumping the output.
>
> Patch set 6: Documentation.
>
> And finally, add all the documentation at the end.
>
> This will make it much easier to understand, and manage. Let's not have
> a 87 patch series again. It's just too big to manage.
>
> -- Steve

Thanks for reviewing this huge patch set, Steven! I'll break it into 6
patch sets, as you proposed.


-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
