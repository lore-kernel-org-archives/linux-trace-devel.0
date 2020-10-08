Return-Path: <SRS0=gEc1=DP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8760C43467
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 09:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 526142177B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Oct 2020 09:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oW1gMIWB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgJHJuZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Oct 2020 05:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729338AbgJHJuY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Oct 2020 05:50:24 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B31C061755
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Oct 2020 02:50:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f19so3530228pfj.11
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Oct 2020 02:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2lxU8QjUhtFhTUy3SCJVvDNYMXarUmnpBMq8RrLMyEY=;
        b=oW1gMIWBlFWTQgdzzC5/TY2l5ZsVHuFD1hOs8fsLS+S770+e5mAlkPz6jwJWcMQ0uY
         zmN+dEeH6Sb4PsAfiX8o6m+KVSjgjildasYAuTSyN6StwDUn77li5DPPgqFmLwtIPyZi
         bNKa73SkEqo48h7mpMH+ZJs3ucgqUKYmiPG/BDN2HnQDtNIVOWBTtb+0Q6hTHZ15pSHm
         QE2Q/s90u/c/zghDSgMsiYM4p4LO2OwG3ahnF1DzzBzpXf9fvjihLcEnBbpqyxzU18MS
         ZGvRkmXN4NL1zS2/SqTcjb5u5f0KYjt4GurZKHoYd2Dd+KMi+Uh+GXrigJS59xnD6NOP
         EvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2lxU8QjUhtFhTUy3SCJVvDNYMXarUmnpBMq8RrLMyEY=;
        b=EdHKrPiH9lydaNm4dFWdeRQX5rz9c09qRSPKybO6zfZfCdipROt1Sj/Bu+y25T3c6G
         smOdPES/NLGoIZs6GOrR19xHLtDEoDZdXMJTmHjjgEESYHU2J/MpP0yGlKVSvmPiAcUP
         YpuAaQiNfBVicmwUU3R0647sniVGj2yYqYDoAExIMsxyefxAjEWp4I2IJ1vuO1sJ8dSv
         ynvgG+IpAsq8d5LNkNwXAnkDa7mubNz3pbg9WSCr7UToNMYCUNA4paZiBqosiGJnS7Ho
         iJ6JmBeX1koukbtFvkll08sWIAhrYtyoGnk7BZh9ELnwL8Go6Hlfa+U2s4rxOyK558eU
         VEWg==
X-Gm-Message-State: AOAM532yn6tE5gLE2vgWdXxyvFMeQwkZTX3ZalSmZ028cjU6K7e7jjNQ
        PHcpD4bg13XMDUQTpZKQyEmrXtVXwIpeSg==
X-Google-Smtp-Source: ABdhPJzmxE4VfgWgOhpelwLbd4g4MgQNMOXqpXQcTTJRR5tnK14dLhDf4a7Mh9wIgjAnMFJoWAXGKg==
X-Received: by 2002:a63:485e:: with SMTP id x30mr6660702pgk.369.1602150623442;
        Thu, 08 Oct 2020 02:50:23 -0700 (PDT)
Received: from i7.zsun.org (h150-66-46-238.ablenetvps.ne.jp. [150.66.46.238])
        by smtp.gmail.com with ESMTPSA id e21sm6602873pgi.91.2020.10.08.02.50.22
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:50:22 -0700 (PDT)
To:     linux-trace-devel@vger.kernel.org
From:   Zamir SUN <sztsian@gmail.com>
Subject: libtraceevent: make doc-install tries different file names than
 generated
Message-ID: <7cdec98e-3184-4ddc-e78c-867a9650e636@gmail.com>
Date:   Thu, 8 Oct 2020 17:50:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

When I try to compiling the document of libtraceevent with the fix I 
mentioned in [1] applied, make doc-install fails with errors like

"/usr/bin/install: cannot stat 'libtraceevent-record_parse.3': No such 
file or directory"

Checking the compiled documents I see a lot of tep_*.3 generated, and 
some libtraceevent_*.html. However no libtraceevent_*.3.

$ ls Documentation/*3 | head
Documentation/libtraceevent.3
Documentation/tep_alloc.3
Documentation/tep_clear_flag.3
Documentation/tep_cmdline_pid.3
Documentation/tep_data_comm_from_pid.3
Documentation/tep_data_flags.3
Documentation/tep_data_pid.3
Documentation/tep_data_pid_from_comm.3
Documentation/tep_data_preempt_count.3
Documentation/tep_data_type.3
ls Documentation/*html | head
Documentation/libtraceevent-commands.html
Documentation/libtraceevent-cpus.html
Documentation/libtraceevent-endian_read.html
Documentation/libtraceevent-event_find.html
Documentation/libtraceevent-event_get.html
Documentation/libtraceevent-event_list.html
Documentation/libtraceevent-event_print.html
Documentation/libtraceevent-field_find.html
Documentation/libtraceevent-field_get_val.html
Documentation/libtraceevent-field_print.html

I also tried to port the Makefile from trace-cmd/Documentation to the 
document dir, and it still only generates tep_*.3 files, so I feel this 
is not the issue with the patch from [1].

As for my local environment, I have xmlto and asciidoc installed[2], but 
not asciidoctor. I expect asciidoc could generate the documentations 
like what it did in trace-cmd before.

Any idea if this is issue with my environment or it's something that 
need to be implemented in the Makefile?

Thanks in advance.


[1] 
https://lore.kernel.org/linux-trace-devel/7897620c-3039-5e4f-09d9-41606673fa63@gmail.com/T/#t
[2] $ rpm -q asciidoc xmlto
asciidoc-8.6.10-0.14.20180605git986f99d.fc32.noarch
xmlto-0.0.28-13.fc32.x86_64

-- 
Zamir SUN
Fedora user
GPG : 1D86 6D4A 49CE 4BBD 72CF FCF5 D856 6E11 F2A0 525E
