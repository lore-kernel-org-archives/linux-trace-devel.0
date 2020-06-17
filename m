Return-Path: <SRS0=X5V/=76=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA4EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 22:56:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B172184D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jun 2020 22:56:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOribdCq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgFQW4O (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jun 2020 18:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgFQW4M (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jun 2020 18:56:12 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E5B4C06174E;
        Wed, 17 Jun 2020 15:56:11 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e16so2998500qtg.0;
        Wed, 17 Jun 2020 15:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:user-agent:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=rtJKBmYWA9oE3E+MeSR+9sAbuhCm/rkoIXEy403L6Hs=;
        b=VOribdCqu5UFifqtt0QPt1u7KxzW+CjZE0KSkrKvqAVFJYS24VhGa0kpCYZv/rjsLM
         YpCk1bsDZv5lGiIsxDLRS63BkF6FmR+EBNDOjaD6910nqBAGPRBfRAg96R19ZbPEaJDy
         zdaYsKPhcWn18RZ/yfg1y93eRLR+paQLnyFhfEbrdrrD0EgZeefi9nDXCv8FStXQ5iyA
         I31ZGLHVWhsWWO3cX1CqG/1/0e2E1hVZGIyY/p1dJqOb8iR17HkzgcXjnrJ26FcBqnzA
         c00F0IMRoVZv5vH/xlvuxKDHulMuKtUNfD7nWcIIG+mGEG3/QYkOQlTP4opSr/nmWKkY
         SDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:user-agent:in-reply-to:references
         :mime-version:content-transfer-encoding:subject:to:cc:from
         :message-id;
        bh=rtJKBmYWA9oE3E+MeSR+9sAbuhCm/rkoIXEy403L6Hs=;
        b=fIHKDJ4fW+17V1//legQHjvyQyuhceZOIHFZIWee0omnajXrH8fT1FZPZ4nwQ7hgMT
         FPyQ4Rd847d+EMLYkj0z9c+R6f3h0xQdgUy8JksZHPCrbRm37cT/4t4+OnRyFKw1N9ZW
         /h96c4Hzw0U9X4qSltvs6oqc+PUeq8nm65bNedHfcyx5UUvpWY7gTn4ljF3c0UHtYgRH
         c9D1quzR0W+r+VAFNThi1c0SfIHBbqdqttXUQjvDCLq7naltPEgo51gPITPh3ha4MyT3
         utBEcWsaUZdwJP7kAyazijJUqcdaVB/vYxUt+74D6om1KtG7L6JYBTl6qEAKBKcmTiaQ
         mb5A==
X-Gm-Message-State: AOAM530tBOJPz+gRhtVwMYt1AckvfOZsThUyArb3Nan9/hdXNhmbxJ9G
        U2BdFLWBKrPOpBdYnmn9hbTHIq5QerE=
X-Google-Smtp-Source: ABdhPJxN6XClQx5yZUbM1VPxhRnyDhyXxwIpI4m9IPk3lpD2KZl4vYKSHddBySFQS4m68PWwLjVy/Q==
X-Received: by 2002:ac8:5301:: with SMTP id t1mr1527331qtn.310.1592434570321;
        Wed, 17 Jun 2020 15:56:10 -0700 (PDT)
Received: from [192.168.86.185] ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id a5sm1240485qtw.22.2020.06.17.15.56.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2020 15:56:09 -0700 (PDT)
Date:   Wed, 17 Jun 2020 19:55:29 -0300
User-Agent: K-9 Mail for Android
In-Reply-To: <20200617172804.7eccb845@oasis.local.home>
References: <20200324200845.763565368@goodmis.org> <20200617172804.7eccb845@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 0/3] tool lib traceevent: Fix some parsing errors
To:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
CC:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Jaewon Kim <jaewon31.kim@samsung.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Kees Cook <keescook@chromium.org>
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Message-ID: <656DB3D9-6D76-4103-B05B-8E4FE142C3B9@gmail.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On June 17, 2020 6:28:04 PM GMT-03:00, Steven Rostedt <rostedt@goodmis=2Eo=
rg> wrote:
>Hi Arnaldo,
>
>I guess these patches were missed=2E

I'll pick those tomorrow,

Thanks for the reminder,


- Arnaldo

>
>-- Steve
>
>
>On Tue, 24 Mar 2020 16:08:45 -0400
>Steven Rostedt <rostedt@goodmis=2Eorg> wrote:
>
>> Arnaldo,
>>=20
>> Here's a few patches for lib traceevent=2E
>>=20
>> The first one adds an "append()" helper function for appending to
>strings,
>> which will also simplify the next patch=2E
>>=20
>> The second patch handles "__attribute__((user))" in the field of a
>> trace event=2E This is needed after the stack leak code added this
>> to parameters of system call events=2E
>>=20
>> The last patch adds handling of __builtin_expect(), as someone wanted
>> to move IS_ERR_VALUE() from the fast path into the print fmt section,
>> which breaks the parsing=2E This should also be useful for other macros
>> that may evaluate down to a __builtin_expect()=2E
>>=20
>> Steven Rostedt (VMware) (3):
>>       tools lib traceevent: Add append() function helper for
>appending strings
>>       tools lib traceevent: Handle __attribute__((user)) in field
>names
>>       tools lib traceevent: Add handler for __builtin_expect()
>>=20
>> ----
>>  tools/lib/traceevent/event-parse=2Ec | 168
>++++++++++++++++++++++++-------------
>>  1 file changed, 111 insertions(+), 57 deletions(-)

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
