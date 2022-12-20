Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A9EC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 20 Dec 2022 21:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234006AbiLTVad (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 16:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbiLTVab (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 16:30:31 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3FD1EEFC
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 13:30:29 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id g14so13740409ljh.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 20 Dec 2022 13:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3PVEQThlMCQe37esCoDqjmSOXvrTlG1W6Q0egzVEBnE=;
        b=QXUfR7GsyzgHRV1JULxb9q7GziTqNgavRlZZ6qqFDmTLrkss8RmNGbZqsVBPWzTUmb
         EBLlRojkuDU1OlkwYD/eTeVwRxgEtg/9909/WcTPtFP7OurskcJHbfJpZvsrIpxRqN02
         DiXTOWEdkCIrXk5sM/QsoGwInYmuhqIDekrE94KRhamvyjvYB0STp13JaSAW319IRUfx
         pfbjsUhXJfiHRBmKeEeZ/1n8D4e1p37s4gn+qbkfsse6zSNtbt4Wrmhr3D6xBEQa9a3g
         8NliCFuJm37fW4iEaSrWJVkhbfLECBAPdtoY+7BtM26Xw6GrQ12TU9FVqX8DyzG78MEj
         wylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3PVEQThlMCQe37esCoDqjmSOXvrTlG1W6Q0egzVEBnE=;
        b=45m+kOo58Gjbx2295nUEDjqlZH8tCsgVDfFDdqiYFRYVfXUG3m/kW5DpxImqBR/ZRJ
         aq9ZSR77lcJK3Hu+1UoWaKx4cA3EsGnqOaujp8oYyuw9jld+6MjBaiyVfGKv3LBZzybO
         cDR350rtCbsMM4RMPUnJ8pbx5t8JZHsg98wqfEzI8uxZ1trlOVNj0sBC+3LjC49mvckQ
         I3DNHLIGyfGV5SguvTWfVNsiYAFjxAVY7n8+vR4vSo5k7cq+NF314yssX3bFRJWlNh1N
         yyJEv4huzJ1ZdujmqxC6TTUObZH22w+P3fm87lcjnnpkoUaXXnzlgtrgl0L0MPBVKXr7
         iVNQ==
X-Gm-Message-State: ANoB5plL9PWI25diXJddlEmX2L7y3kEHo7UVEEJ5MMMxdTSiG7z2Sx9H
        vTssvo+fVKXURG7Im86co/WCVAP8hlK9OTuj2YnI3FCF4O/SKQ==
X-Google-Smtp-Source: AA0mqf5C5WVllH1Sat0aCOVc3nz28WN30oUaH6Vajsc0bZ9UcE6vDcPa9WQsHRIk4VvcxH2C+EvYjdfnig0PqQnbJ9M=
X-Received: by 2002:a05:651c:246:b0:279:de15:608e with SMTP id
 x6-20020a05651c024600b00279de15608emr10531378ljn.211.1671571827830; Tue, 20
 Dec 2022 13:30:27 -0800 (PST)
MIME-Version: 1.0
References: <20221219173414.032e2124@gandalf.local.home> <CAAbOScnLETawvZYhZnhVMP_rs6tYEty1-LcWGD9JcQX5tbQW5A@mail.gmail.com>
 <20221220160002.1a34d937@gandalf.local.home>
In-Reply-To: <20221220160002.1a34d937@gandalf.local.home>
From:   Mike Frysinger <vapier@google.com>
Date:   Tue, 20 Dec 2022 16:29:49 -0500
Message-ID: <CAAbOScks--ApY2b+4voM73PSx5dL1rLU7R3=8Bs66HDKN-6LMA@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent: Have 32 bit compile with -D_FILE_OFFSET_BITS=64
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Ross Zwisler <zwisler@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Dec 20, 2022 at 4:00 PM Steven Rostedt wrote:
> BTW, the only issue that will happen if stat fails, is that a feature will
> be disabled.

i am certainly by no means an expert in this codebase.  from glancing
at it, the impact is that people won't be able to load any plugins
right ?  that's where stat() & readdir() appear to be used (the dirent
returned by readdir has both ino_t & off_t in it).
-mike
