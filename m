Return-Path: <SRS0=6X2q=SS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,URIBL_GREY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 971A7C282DA
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 15:54:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EF032087C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 16 Apr 2019 15:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729872AbfDPPyq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 16 Apr 2019 11:54:46 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:55427 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbfDPPyq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 16 Apr 2019 11:54:46 -0400
Received: by mail-it1-f195.google.com with SMTP id y134so33792049itc.5;
        Tue, 16 Apr 2019 08:54:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=c2mOD6byB4CWn0ecgDDCpY49m/bQo1yaNH6qFccDId8=;
        b=KrhFi+XthEXO8QBQf/ES+fzl2QjMRlpAszI1zWf1TgnTCszZ684/GxNzoSoHkzMutD
         5nIyxDMZTcAnob2xX8H8p0Bu70ncmgs/VofZzeqiUnq8+BCEx/G2RvjlEboDV/3GgJm/
         Wa7t3Fmyf1uZYIHxYlgR+vmubZa5WOq1sQTiByNBwBo5atydHL6KBTtbydb5Q1L/zDsW
         8m1VVWRSsPqQU/3m2Ht6Hd0R06ehDhp7XhM2zXomP1NrOTzkSx4F0MOrPUCT8X8vT/Y8
         Q7mR8jxcAIruZlKtGGh/bbIc8giOuFVMiSJvjTJmSPF7VGFp7GVbHYBRTEN8vbvxFe7X
         OQ9w==
X-Gm-Message-State: APjAAAVHPicWxnrqoQeq/sU8bNaihfUg3RIYeHLn+VYrRqQF40JdiHrg
        5KnTmRqfiVOzZhMkOixmhI9pk9NZN2aBBuKPpE4=
X-Google-Smtp-Source: APXvYqz2SB4xo8d+Vg52el11JGNW5UnUTM3cVCcceeaVa7Fv/abnC6j3J3eVTdluayNFGIt0MH7s6iIQoY9l37WjBVQ=
X-Received: by 2002:a24:3c51:: with SMTP id m78mr27986523ita.119.1555430085417;
 Tue, 16 Apr 2019 08:54:45 -0700 (PDT)
MIME-Version: 1.0
From:   Francis Deslauriers <francis.deslauriers@efficios.com>
Date:   Tue, 16 Apr 2019 11:54:34 -0400
Message-ID: <CADcCL0irokZ8Xp7S3eBV728qpL5yipwW+=2QvwiZrixqSdtBog@mail.gmail.com>
Subject: Tracing Summit 2019: Announcement and Call for Proposals, August
 20th, 2019, San Diego, CA
To:     diamon-discuss@lists.linuxfoundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        linux-trace-users@vger.kernel.org, linuxtools-dev@eclipse.org,
        lttng-dev <lttng-dev@lists.lttng.org>, lwn@lwn.net,
        tracecompass-dev@eclipse.org
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        info@tracingsummit.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,

This is a Call for Proposals for the Tracing Summit 2019 [0] which
will be held in San Diego, California, USA at the Hilton San Diego
Bayfront, co-located with the Open Source Summit & Embedded Linux
Conference North America 2019 [1] on August 20th, 2019.

You can subscribe to our mailing list ot get the latest info on the event: [2]

The Tracing Summit is single-day, single-track conference on the topic
of tracing. The event focuses on the field of software and hardware
tracing, gathering developers and end-users of tracing and trace
analysis tools. The main goal of the Tracing Summit is to provide
space for discussion between people of the various areas that benefit
from tracing, namely parallel, distributed and/or real-time systems,
as well as kernel development.

We are welcoming 30 minute presentations from both end users and
developers, on topics covering, but not limited to:
-Investigation workflow of Real-Time, latency, and throughput issues,
-Trace collection and extraction,
-Trace filtering,
-Trace aggregation,
-Trace formats,
-Tracing multi-core systems,
-Trace abstraction,
-Trace modeling,
-Automated trace analysis (e.g. dependency analysis),
-Tracing large clusters and distributed systems,
-Hardware-level tracing (e.g. DSP, GPU, bare-metal),
-Trace visualisation,
-Interaction between debugging and tracing,
-Tracing remote control,
-Analysis of large trace datasets,
-Cloud trace collection and analysis,
-Integration between trace tools,
-Live tracing & monitoring,
-Programmable tracing (e.g. eBPF).

Those can cover recently available technologies, ongoing work, and yet
non-existing technologies (which are compellingly interesting to
end-users). Please understand that this open forum is not the proper
place to present sales or marketing pitches, nor technologies which
are prevented from being freely used in open source.

* Submit you talk today using this form: https://forms.gle/L6mR2ZN3Nt7bUxY98 *

The submission deadline is July 1st 2019 at 23:59 EST.

This year tickets are $100 and seating is limited to 100 people. To
register, you can add the Tracing Summit as an addon to your Open
Source Summit ticket [3] or use this link [4] to register solely for
the Tracing Summit.

The Tracing Summit is sponsored by EfficiOS. We are actively looking
for sponsors to support the Tracing Summit. Contact us at
info@tracingsummit.org.

Please send any query about this conference to info@tracingsummit.org.

This event is organized by Francis Deslauriers and Mathieu Desnoyers
on the behalf of the Linux Foundation Diagnostic and Monitoring
Workgroup [5].

[0] : https://tracingsummit.org
[1]: https://events.linuxfoundation.org/events/open-source-summit-north-america-2019
[2]: http://eepurl.com/goakfv
[3]: https://www.cvent.com/events/open-source-summit-embedded-linux-conference-north-america-2019/registration-0ed1330c38bd4845be29b91c9d2444ce.aspx?fqp=true
[4]: https://www.cvent.com/events/tracing-summit-2019/registration-63351d06945a46d890b8e5a200dbc0fc.aspx?fqp=true
[5]: https://diamon.org

--
Francis Deslauriers
Computer Engineer
EfficiOS inc.
