Return-Path: <SRS0=4yZ8=US=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,URIBL_GREY
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C95BC31E49
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 14:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C3E4214AF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jun 2019 14:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfFSOrW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 10:47:22 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37725 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfFSOrW (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 10:47:22 -0400
Received: by mail-io1-f67.google.com with SMTP id e5so38830986iok.4;
        Wed, 19 Jun 2019 07:47:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QEYP9H4UymVw8xeOjLOrHSZwO8yB1IyVK9g6mOUClEU=;
        b=awhLPtgopr+4ipq4QGLSnzpBOsiO/E3KRM5BO2RDogh0gmE9vPpnGpnREaopIaFz9U
         92g7145c0vArK5Kz92ZmB9ObTSZT3sDP8P/ZP3+BUJc/Au5bbbB4jxd4w7YzBCbnw18q
         1o/5nZJrCP+cipOVETnPosiSBakU5nBBWwOHUTeNR/UekJXD83Vx0LuKgDTzx45mlgfo
         ZxZGRrXH83/pwO47lZB8VcyOlHOchDo4nlc4HFPqzUQXI2kqt7O7rkkecidlatdBy2rK
         D082u4D6OgRHsUHeBiC59T3WY71kqXuB455Q/hJt+ozmQ/boZdFWytaA3ntfZ5NaWnwL
         ODcw==
X-Gm-Message-State: APjAAAXaU3lezvrof7zo5M1E765owV1tz0S4m+6cFtJI/Pfz3rs0r/bq
        SGlp+qH5mnHkKHj+0CJzK/JKUNYW/lyUQ52UMlo=
X-Google-Smtp-Source: APXvYqxdMhOY/OZfjrMw6aAQiGZSCIplwo88vxdNupVG/0q9Pnjea0rgjppRWyCM2id1UYNso7aGg/xGyuV0xhH7q1w=
X-Received: by 2002:a5d:9a04:: with SMTP id s4mr33496209iol.19.1560955641157;
 Wed, 19 Jun 2019 07:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <CADcCL0irokZ8Xp7S3eBV728qpL5yipwW+=2QvwiZrixqSdtBog@mail.gmail.com>
In-Reply-To: <CADcCL0irokZ8Xp7S3eBV728qpL5yipwW+=2QvwiZrixqSdtBog@mail.gmail.com>
From:   Francis Deslauriers <francis.deslauriers@efficios.com>
Date:   Wed, 19 Jun 2019 10:47:05 -0400
Message-ID: <CADcCL0gpbfk28_E1otW0Ttz0Osot3CYymh=t5fVR77WrqoU6uQ@mail.gmail.com>
Subject: Re: Tracing Summit 2019: Announcement and Call for Proposals, August
 20th, 2019, San Diego, CA
To:     diamon-discuss@lists.linuxfoundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        linux-trace-users@vger.kernel.org, linuxtools-dev@eclipse.org,
        lttng-dev <lttng-dev@lists.lttng.org>, lwn@lwn.net,
        tracecompass-dev@eclipse.org
Cc:     info@tracingsummit.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi all,
This is a friendly reminder that the deadline for submitting talk
proposals for the Tracing Summit 2019 [1] is coming up soon (July
1st). Submit you talk today through this form:
https://forms.gle/L6mR2ZN3Nt7bUxY98.

The Tracing Summit 2019 will be held in San Diego, California on
August 20th, 2019, at the Hilton San Diego Bayfront, co-located with
the Open Source Summit & Embedded Linux Conference North America 2019

This year tickets are $100 and seating is limited to 100 people. To
register, you can add the Tracing Summit as an addon to your Open
Source Summit ticket or use this link to register solely for the
Tracing Summit:
https://www.cvent.com/events/tracing-summit-2019/registration-63351d06945a46d890b8e5a200dbc0fc.aspx.

We are actively looking for sponsors to support the Tracing Summit.
Contact us at info@tracingsummit.org.

More info: https://tracingsummit.org/wiki/TracingSummit2019

Thank you,

On behalf of the Diagnostic and Monitoring Workgroup,
Tracing Summit organizers

Le mar. 16 avr. 2019, à 11 h 54, Francis Deslauriers
<francis.deslauriers@efficios.com> a écrit :
>
> Hi all,
>
> This is a Call for Proposals for the Tracing Summit 2019 [0] which
> will be held in San Diego, California, USA at the Hilton San Diego
> Bayfront, co-located with the Open Source Summit & Embedded Linux
> Conference North America 2019 [1] on August 20th, 2019.
>
> You can subscribe to our mailing list ot get the latest info on the event: [2]
>
> The Tracing Summit is single-day, single-track conference on the topic
> of tracing. The event focuses on the field of software and hardware
> tracing, gathering developers and end-users of tracing and trace
> analysis tools. The main goal of the Tracing Summit is to provide
> space for discussion between people of the various areas that benefit
> from tracing, namely parallel, distributed and/or real-time systems,
> as well as kernel development.
>
> We are welcoming 30 minute presentations from both end users and
> developers, on topics covering, but not limited to:
> -Investigation workflow of Real-Time, latency, and throughput issues,
> -Trace collection and extraction,
> -Trace filtering,
> -Trace aggregation,
> -Trace formats,
> -Tracing multi-core systems,
> -Trace abstraction,
> -Trace modeling,
> -Automated trace analysis (e.g. dependency analysis),
> -Tracing large clusters and distributed systems,
> -Hardware-level tracing (e.g. DSP, GPU, bare-metal),
> -Trace visualisation,
> -Interaction between debugging and tracing,
> -Tracing remote control,
> -Analysis of large trace datasets,
> -Cloud trace collection and analysis,
> -Integration between trace tools,
> -Live tracing & monitoring,
> -Programmable tracing (e.g. eBPF).
>
> Those can cover recently available technologies, ongoing work, and yet
> non-existing technologies (which are compellingly interesting to
> end-users). Please understand that this open forum is not the proper
> place to present sales or marketing pitches, nor technologies which
> are prevented from being freely used in open source.
>
> * Submit you talk today using this form: https://forms.gle/L6mR2ZN3Nt7bUxY98 *
>
> The submission deadline is July 1st 2019 at 23:59 EST.
>
> This year tickets are $100 and seating is limited to 100 people. To
> register, you can add the Tracing Summit as an addon to your Open
> Source Summit ticket [3] or use this link [4] to register solely for
> the Tracing Summit.
>
> The Tracing Summit is sponsored by EfficiOS. We are actively looking
> for sponsors to support the Tracing Summit. Contact us at
> info@tracingsummit.org.
>
> Please send any query about this conference to info@tracingsummit.org.
>
> This event is organized by Francis Deslauriers and Mathieu Desnoyers
> on the behalf of the Linux Foundation Diagnostic and Monitoring
> Workgroup [5].
>
> [0] : https://tracingsummit.org
> [1]: https://events.linuxfoundation.org/events/open-source-summit-north-america-2019
> [2]: http://eepurl.com/goakfv
> [3]: https://www.cvent.com/events/open-source-summit-embedded-linux-conference-north-america-2019/registration-0ed1330c38bd4845be29b91c9d2444ce.aspx?fqp=true
> [4]: https://www.cvent.com/events/tracing-summit-2019/registration-63351d06945a46d890b8e5a200dbc0fc.aspx?fqp=true
> [5]: https://diamon.org
>
> --
> Francis Deslauriers
> Computer Engineer
> EfficiOS inc.



-- 
Francis Deslauriers
Computer Engineer
EfficiOS inc.
