Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24E0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Feb 2022 00:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiBYAWL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 19:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiBYAWK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 19:22:10 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B3E27145
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 16:21:38 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id j2so2833991ybu.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Feb 2022 16:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5uRNYe4m1JdGaN7GLKgVJiZgL5j/jAiCRDyuPUNk8pw=;
        b=CKz54nu1XwUI+y7u/h1MQrl+4zTrOXfjloTND97xqA5EomqpxJcpA4hWHf4+xNt4Lt
         LvZ+eLc0dJXQKdnC11PHcE1j/1lAQGViW73inhX7GNuw9q+uqagCiGrZHkVNYIbHCErw
         +pK7Fttx8H/69YWHepH5K+V0muLOYWmeaSsjzFW9Op8dpbwME8Y0I0RqIA2J0z1yFAYE
         7YcK7IqFM3wOJ1bYjV3QIKnh9QfH4VCohDYMFsO30TBIGxxXc8QzFBHYNcn2/NfveBAa
         Ns3nn34z3t2ll1ObVKtiwb7pfTGNqoAi614XqJutP60gLMPllSlEFmClglduqJy3K/oj
         5TCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5uRNYe4m1JdGaN7GLKgVJiZgL5j/jAiCRDyuPUNk8pw=;
        b=EER5j4g3N/hbb3euF4NS8jAiBzVnwXS1gpSe1HmRIT4Y63YMmptmyZTpcPr8/L1zo7
         EYyJR+Za10CxHztqQ2PDQjfF+tvShSX/XRe+nJV1EW7LeyFgBrxYPG5AfLbyiKqWH6GN
         WJfMIPwK6o2gTP0suaEkhzMe0vg48goQ83rM40NUUdH0dn+KqyG17Hm2oshpinA5eaQx
         QFQBCgqkmopZY3WgqggplBezcWpuV233z2a2PoSGOhVfsw3gnrDKbGR6qNQDVc3VV5HC
         xhmeZUi4F4KDEpc+WbDNzHKMDZxt2yH8cB4kSpV3iLpubeqWXw2fzTnk+AB2EF+kZhRA
         0xyg==
X-Gm-Message-State: AOAM531ShbtTpcKUYyracSGIZQqEXMSqInLKw4nU7MC9C5RY9iro4SYC
        MYgQxuq51LQ9df6DzPfhbh9tqEO452v+2CoEM/c1YA==
X-Google-Smtp-Source: ABdhPJzIOzoCjQTLZO4mtooFxC0YIhmVIA/HuzH5F9R9Z/8kv54Ee1wBawX+Ueds393lsCl7iun9LpTVg8hJm8SyhJ0=
X-Received: by 2002:a05:6902:562:b0:610:f96a:49e4 with SMTP id
 a2-20020a056902056200b00610f96a49e4mr4862901ybt.611.1645748482982; Thu, 24
 Feb 2022 16:21:22 -0800 (PST)
MIME-Version: 1.0
References: <20220224234823.1190425-1-irogers@google.com> <20220224234823.1190425-3-irogers@google.com>
 <20220224185556.2771ad18@gandalf.local.home> <CAP-5=fUmB4QgHTBBsnKkuhh7KHF2us-ZGkn_UB4ymxUkmO3ebA@mail.gmail.com>
 <20220224192006.1d6a09f9@gandalf.local.home>
In-Reply-To: <20220224192006.1d6a09f9@gandalf.local.home>
From:   Ian Rogers <irogers@google.com>
Date:   Thu, 24 Feb 2022 16:21:10 -0800
Message-ID: <CAP-5=fXpFSqCOLbE5+GN75py9+yFfLgPurCR3FLTqWsi0aLxVA@mail.gmail.com>
Subject: Re: [PATCH 3/3] libtracefs: Move initialization below a null test.
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Feb 24, 2022 at 4:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Thu, 24 Feb 2022 16:09:29 -0800
> Ian Rogers <irogers@google.com> wrote:
>
> > >  /**
> > >   * tracefs_dynevent_get_event - return tep event representing the given dynamic event
> > >   * @tep: a handle to the trace event parser context that holds the events
> > >
> >
> > LGTM. Thanks,
>
> Did you want to resend, or do you want me to just do this myself? I'm good
> either way.

Happy to let you do it. Thanks,

Ian

> -- Steve
