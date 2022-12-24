Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD79C4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 24 Dec 2022 21:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiLXVSM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 16:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbiLXVSL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 16:18:11 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04F2A46A
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 13:18:09 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 65so5291558pfx.9
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 13:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n0tEj2KHHLXlRs/DpFrhZLI9re/SQ5h+K4lQdCJqf/I=;
        b=Eu7JWJQgRap8U5kq6yICeqv5y9X6K6LbFwtdlCPwE2B3a4ZEyTXIqC7BTmr4Sj5879
         jgJrU9zMgnCDVRWV9+DnE8ejx4MwHkJbkJMAqRMz9u0QBfMkmEYrMRP6+C9O2HpiJ5gU
         uQxQp7AN1ymhz2AMNbHK8K+rYPMMTR+kGMthRUcMWlWHSyhzwwZGw7Tr5djGL3+zOfN4
         4qXOvJeAdHJts1GkZ7LOUttNb8ppSk5g6mAeDqyhDCIxNCG8fwVlLCKsbulL279cpPj8
         sWv1GolkamqSCBKAkWiCWtXmKs/0P44hxgTVogfWnPQfPaNAjLI/5gx9jgeOX9tD2Bxm
         ttNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n0tEj2KHHLXlRs/DpFrhZLI9re/SQ5h+K4lQdCJqf/I=;
        b=XLJdPWQNcC0qvhT5/j9gqVvuUSX0hKc4uSNUV/uLGJu5TUKVrvmD7XJdwxu5Z4eNF6
         lyx5/mkWBb1Ea/h2NgySYtQj6bEcPyPMpv+fl20pOKKPTyKvGD1aGHSKKTykkYa5F9f9
         bHIwt5HPRPmIMglwTYsNiS7d6gzEFLMF5fEntWRORWointa7b60v54M2PUo9S0zDAXhT
         Tbo8ixaliBtHPn6ES7Srr/eP7Wfkd3hoS13GTq2lnJzOuw3AebJTtjikxfWDnJqv87Lr
         junkgWPCt4Z+q8qpBQ+N/7cKEBiU9GFB7/78M/jrvl98bR8rLm7JspOfBmv0kbSdjUGr
         zbOA==
X-Gm-Message-State: AFqh2kqx7EOHlwziZhcDou00bCQPAKAO9rSgbcBVUYqA0KwthzbLdC0S
        8LvJJmxP+nMsCbke7Z8yUQ1Ybp1yUnHpZyblpcUhOQ==
X-Google-Smtp-Source: AMrXdXudlR3eJWqL676SrUiUQ2KL6TdVyqZp+yAys+Xtb3e9mJru5OHtHaaQ4dUt6Bl6SBfXkPhTpieAoEN9ExP/jnw=
X-Received: by 2002:a63:161d:0:b0:46f:6225:c2f9 with SMTP id
 w29-20020a63161d000000b0046f6225c2f9mr564361pgl.225.1671916689378; Sat, 24
 Dec 2022 13:18:09 -0800 (PST)
MIME-Version: 1.0
References: <d7bb31547e9bbf6684801a7bbd857810@umbiko.net>
In-Reply-To: <d7bb31547e9bbf6684801a7bbd857810@umbiko.net>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Sat, 24 Dec 2022 16:17:58 -0500
Message-ID: <CA+pv=HO1mvnN5XZHkWDjWr=NJHJZxjcstiY4qtJGJ6mfsqPfQw@mail.gmail.com>
Subject: Re: rtla osnoise hist: average duration is always zero
To:     Andreas Ziegler <br015@umbiko.net>
Cc:     Daniel Bristot de Oliveira <bristot@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Dec 24, 2022 at 7:48 AM Andreas Ziegler <br015@umbiko.net> wrote:
>
> -- Observed in, but not limited to, Linux 6.1.1

Wait, "but not limited to"? What does that mean? Are there more
versions affected?

-- Slade
