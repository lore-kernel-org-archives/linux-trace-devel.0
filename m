Return-Path: <SRS0=1fLi=ZU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5626C43215
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E6D6217AB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Nov 2019 15:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWKFqwVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfK1P1y (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Nov 2019 10:27:54 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44701 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfK1P1x (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Nov 2019 10:27:53 -0500
Received: by mail-pj1-f66.google.com with SMTP id w8so12015954pjh.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Nov 2019 07:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfPHXZkSy0hGRvEhqIFOgRk/jobgxb4aoaPVbCd9HQw=;
        b=jWKFqwVM/sCERe2dZItsOdQe5rOwz14bVtbb8YmmXK+KlKL2VxrbQzx0xs8PVyRun1
         Xks0+3QJngO/KrvW2TBvN6RKuthgJtAgOzXGHL/fsJctmzQ7JqWxESieyn6CzKx+jU5g
         3YVjPl4g4HYX83CmPvLkAa+qu32VfGzfCwjJbn0B1d0e1zJX0UwLerJ2S8SvOhVPbCm/
         IkL6BCmmE2TqQkpM5q1tnrQb2Nz6WWLJ0N55oAxmiOy2lJFBTV6P57/IA8VymVWnb3Ad
         /eqg7r460hxH9TBUUbDaaW36OAXFNvaDfWqSWno/HL25QMPgWDrzGke54mJADRt0afQZ
         oiZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfPHXZkSy0hGRvEhqIFOgRk/jobgxb4aoaPVbCd9HQw=;
        b=AaJVxC4gMh0MMmvTI6m1168PQ3/qzcFhbnSPlitiOcvgJ70QsQ7UwHEe5NELLmUjYp
         GsVHjvxVgWGVH1vfTruSeWb7Zg2RqUmP1hVT4O/650X+pKnWCctlPpXkvAna1DkRIQSC
         yusenUarZ0NRWVOPFhA4CSkvzajYTbQ3RF4queekPjrCWMna2H8K8+ExdDe4hImyEbNl
         LQiL2uvfuMjIU/hPMG3wgm6KlFTH8mWsyRQb4fsWdA7cXX9KW/KA6HSeq9MjafNmMPr/
         WHoqGyzEGUkBvALTAQiDC15w5whFsaArey1YdxTMnR38kJ7iU/AtYgh97yzN4vEMEbvG
         coFQ==
X-Gm-Message-State: APjAAAVdWe7oGPxTXmxtI9DBYlIKYkaE1BIT3Lglte5LFtYpskgxRugA
        Kb4ru/yRS5l1m11XFJKnMKTfsmCAHLmHnzYv7Dg=
X-Google-Smtp-Source: APXvYqz2jY9nyrWMbpds1uc4wzuK/iN4t3peYLrlThSRzw2zmIXucGxhixJbMifkeDpp5gZo3ZLt0oa5/MyEK2xsrSY=
X-Received: by 2002:a17:90a:19dd:: with SMTP id 29mr13647280pjj.32.1574954871367;
 Thu, 28 Nov 2019 07:27:51 -0800 (PST)
MIME-Version: 1.0
References: <20191128085409.289684-1-tz.stoyanov@gmail.com>
 <20191128085409.289684-17-tz.stoyanov@gmail.com> <CAE0o1Nv33cEQGGX92XDCW7Y_E8CZ2uZ-ZKV=-_TkMeh3LB02DQ@mail.gmail.com>
In-Reply-To: <CAE0o1Nv33cEQGGX92XDCW7Y_E8CZ2uZ-ZKV=-_TkMeh3LB02DQ@mail.gmail.com>
From:   Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Date:   Thu, 28 Nov 2019 17:27:40 +0200
Message-ID: <CAPpZLN6LJOxxZkw8R4qP4i6BfUBz8+Le8SydsB9WwnWaaNqJag@mail.gmail.com>
Subject: Re: [PATCH v15 16/18] trace-cmd: Basic infrastructure for host -
 guest timestamp synchronization
To:     Slavomir Kaslev <slavomir.kaslev@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 28, 2019 at 5:08 PM Slavomir Kaslev
<slavomir.kaslev@gmail.com> wrote:
>
...
> > +       if (buf_size && payload && payload_size) {
> > +               if (*payload_size) {
> > +                       if (*payload_size != buf_size || *payload == NULL) {
> > +                               ret = -ENOMEM;
>
> Returning ENOMEM in this case is confusing. If this case is intended
> make it so that we don't allocate on each tracecmd_msg_recv_time_sync,
> maybe do realloc() here instead?
>
The main use case is to avoid the memory allocation at all, if the
payload is with known size. The user can pass a buffer with given
size, and the error should handle the case when the payload size is
not the one, expected by the user.

> --
> Slavomir Kaslev

Thanks !

-- 
Tzvetomir (Ceco) Stoyanov
VMware Open Source Technology Center
