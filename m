Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C590C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 30 Mar 2022 19:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350659AbiC3TaW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 15:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350723AbiC3TaV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 15:30:21 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AC72E9E1
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Mar 2022 12:28:34 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h7so37610546lfl.2
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Mar 2022 12:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jVig4TMXo4XXW+YYHFnVZTCO1uSpbm2NwpusO0nWM20=;
        b=eoAarFYSq60lhcO0YE7U6h8l1TAYLsyl0mwxA7kyk0Yf1FEPtAz0UDJNugw0CuGySz
         QC8AA8LwEOz7YnhM5H8EYLCMgvcySHe66L0/u6GiqQheodoMrPENraETAYN9xc6fW/5d
         ftWAS0w3hXHYM0Ao8IqqpFHIl/DI2GyDW9+nk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jVig4TMXo4XXW+YYHFnVZTCO1uSpbm2NwpusO0nWM20=;
        b=7eTpx+MmANdZ8pFd9h9qoog6PrxgW+GhL9bxxxNpbRJnPe8/6+5oceXWnE1/MZBHfy
         J75rUT4EII/6BPEn70V87aUm2ezBwFFhVPZ0LJlyaH0oVxuVOCi5JUI8ktrurGIbOdUp
         iYq/Pr+Sakq+gsjLQLbyx0AHtHo5n7lHuWRUFzeGZboHcgwE8RnCGKi8+aIbTI7bFu3p
         ntNs9iQXzwUfXZyt0/JHri+eJvHkv74cVtSIshJliVejBuxoj2rg+W32X3U8Ane4GMPM
         3JcvpXLopsksdzqKs7bPxArYq7v3C3zxqbNILRszBGUv7huyHDHZLb/EDFW2a1vC8tfs
         l3wA==
X-Gm-Message-State: AOAM531LgLeniOLtsf3VN1yQT7Qd3YcfURLagE1BpUPtEZnH09i6c5K9
        4IDwgDL58h3OwSC8O6M/758LBT5+PwZ9hCUT
X-Google-Smtp-Source: ABdhPJzHh3CkAKp5NHR5eU/ChqbtRq9YIbVZ/AEZQG9fYzs4XLTarsF4go6aaqREvc6gGXp6VWMLAQ==
X-Received: by 2002:a05:6512:1051:b0:44a:5dcb:3a74 with SMTP id c17-20020a056512105100b0044a5dcb3a74mr7981722lfb.51.1648668509884;
        Wed, 30 Mar 2022 12:28:29 -0700 (PDT)
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com. [209.85.167.43])
        by smtp.gmail.com with ESMTPSA id x23-20020a056512131700b004486c863c8esm2424229lfu.257.2022.03.30.12.28.27
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 12:28:28 -0700 (PDT)
Received: by mail-lf1-f43.google.com with SMTP id p15so37586783lfk.8
        for <linux-trace-devel@vger.kernel.org>; Wed, 30 Mar 2022 12:28:27 -0700 (PDT)
X-Received: by 2002:a05:6512:3055:b0:44a:3914:6603 with SMTP id
 b21-20020a056512305500b0044a39146603mr8015065lfb.435.1648668507455; Wed, 30
 Mar 2022 12:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220329222514.51af6c07@gandalf.local.home> <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
In-Reply-To: <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Mar 2022 12:28:11 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgZ0RccFsUhgKpdh130ydsY57bqaCGRQS7w3-ckgHP=OA@mail.gmail.com>
Message-ID: <CAHk-=wgZ0RccFsUhgKpdh130ydsY57bqaCGRQS7w3-ckgHP=OA@mail.gmail.com>
Subject: Re: [PATCH] tracing: Set user_events to BROKEN
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     rostedt <rostedt@goodmis.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Mar 30, 2022 at 9:54 AM Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> If we are not ready to commit to an ABI, perhaps it would be safer to ensure
> that include/uapi/linux/user_events.h is not installed with the uapi headers
> until it's ready.

I don't th8ink the uapi matters if the code then cannot be used.
There's no regression in that.

That said, if we leave the code in the kernel source tree, I feel like
we should probably at least compile-test it.

So maybe it should be marked as

        depends on BROKEN || COMPILE_TEST

instead?

             Linus
