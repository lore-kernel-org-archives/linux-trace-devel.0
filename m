Return-Path: <SRS0=VTjS=25=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6FEC00523
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 06:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A00C82073A
	for <linux-trace-devel@archiver.kernel.org>; Wed,  8 Jan 2020 06:36:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C2/rzC7V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgAHGgU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 01:36:20 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:51228 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgAHGgT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 01:36:19 -0500
Received: by mail-pj1-f68.google.com with SMTP id j11so626969pjs.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 22:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8RhMKbx7IOz/kJQWsLQ/3AV9S1f26zU9ELe7xp/VpYM=;
        b=C2/rzC7VNdffZPMHWgzIWsp/F5/Bd9/aMLEwpUmqxIOYV4ReF3rgQZNtR738ecKXH8
         EVZXhVZzVOLg1Rz0zczCDVCb1r7OPfCJ/NN+7NDPM0emjBw4wY5b7xsE9P8+853ka/LD
         za/GZkCC0QXZmUwQ/dy0QPj9ms5HQrhHQMMxRBzCIuoyv8jM2LOnKaVJ4kao1YBYi0Ga
         ERR85TZyKi0bjQH8cUO2xkBnFYgou2k7TuGID5DKjzuAA9AD2iHtDroH0OtrXUn/jV5l
         tXGwHHG89KiUklsM0joTVChiHtMTxuRxGkWpa/frRZpgYIDQTJh8IvX9JXovNtI3LDSI
         Qh+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8RhMKbx7IOz/kJQWsLQ/3AV9S1f26zU9ELe7xp/VpYM=;
        b=Bu9aFD6VMOHgomJR1Oxq09q0rP7CuozG6X9iLJla+avrJIh9X0EaT6PxCpxak4jLPA
         UefO7MGhjCKTxZ2PSNEGyh+j7SpOzOIRLRC80kLg87kg7sO8FiBrSPbFhivLNtjOmKSF
         ISf4IE7vMxDSrRkYmpXSHpaGTsyae8qdXF7EnsS8FUU0ZxXInUz3MemoekTe7CC/q8tb
         dtp7cMBd5fDnm9609E1vE0yHwi9R352KfdBysGgzsNa6+dfP78hIqr4GDNwKUrwW12MT
         9diOHASemf2raHC7B8+kesY53uExCHVLgMDQWt9Vj3j0h5WET1uruenrhgbdBxifShqP
         K3jQ==
X-Gm-Message-State: APjAAAUbWSMpxnmvifk/c1LPNY/vmVSHopGHtVtM9aBN53B4kzlSQkuN
        iS50ruway7eRsPzjMt8309rifg==
X-Google-Smtp-Source: APXvYqzrFxy1mGS5tIP8Jdv5v+7KCKy9pVPNHbd8JnrHQeJd/Ti5qQZOvoWhAaNBAFill0ctaZDirQ==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr2610945pjw.3.1578465379251;
        Tue, 07 Jan 2020 22:36:19 -0800 (PST)
Received: from localhost ([122.172.26.121])
        by smtp.gmail.com with ESMTPSA id 64sm1853565pfd.48.2020.01.07.22.36.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Jan 2020 22:36:18 -0800 (PST)
Date:   Wed, 8 Jan 2020 12:06:15 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] sched/fair: Load balance aggressively for SCHED_IDLE CPUs
Message-ID: <20200108063615.x3qxzu3v6zbkdtca@vireshk-i7>
References: <885b1be9af68d124f44a863f54e337f8eb6c4917.1577090998.git.viresh.kumar@linaro.org>
 <20200102122901.6acbf857@gandalf.local.home>
 <20200107112518.fqqzldnflqxonptf@vireshk-i7>
 <20200107123144.2d6dc5a2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107123144.2d6dc5a2@gandalf.local.home>
User-Agent: NeoMutt/20180716-391-311a52
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 07-01-20, 12:31, Steven Rostedt wrote:
> Thanks. I think I was able to reproduce it.

Great.

> Speaking of, I'd
> recommend that you download and install the latest KernelShark
> (https://www.kernelshark.org), as it looks like you're still using the
> pre-1.0 version (which is now deprecated).

I have trace-cmd of the latest version since a long time, not sure how
kernelshark was left out (I must have done install_gui as well). Thanks for
noticing though.

> One nice feature of the
> latest is that it has json session files that you can pass to others.

Nice.

-- 
viresh
