Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EE1C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 09:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiBPJXv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 04:23:51 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiBPJXs (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 04:23:48 -0500
X-Greylist: delayed 1467 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 01:23:25 PST
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com [192.185.50.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2954E0ACD
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 01:23:25 -0800 (PST)
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id E29FF400EC8C6
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 02:58:57 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id KG9JnqXBlRnrrKG9Jn5lBr; Wed, 16 Feb 2022 02:58:57 -0600
X-Authority-Reason: nr=8
Received: from host-95-232-30-176.retail.telecomitalia.it ([95.232.30.176]:46600 helo=[10.0.1.2])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nKG9I-001PYL-FP; Wed, 16 Feb 2022 02:58:56 -0600
Message-ID: <05a593c4-0134-1449-7f30-305a0ffe1b49@kernel.org>
Date:   Wed, 16 Feb 2022 09:58:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC V2 12/21] rv/reactor: Add the printk reactor
Content-Language: en-US
To:     John Ogness <john.ogness@linutronix.de>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
References: <cover.1644830251.git.bristot@kernel.org>
 <fad2d358d57dfffc084d482684ecc1d13b62b262.1644830251.git.bristot@kernel.org>
 <10cf6003-6d2b-056b-11bb-3ae9c342a369@linuxfoundation.org>
 <c1657d1c-0d2b-4aa3-c1ed-2ae6fdfcda86@kernel.org>
 <87v8xg30qc.fsf@jogness.linutronix.de>
 <45179cdb-2391-207a-2f7b-2dea828d1606@kernel.org>
 <87r1842r1m.fsf@jogness.linutronix.de>
 <65172f14-bad6-37b1-d243-e91ca472d22e@kernel.org>
 <874k50hqmj.fsf@jogness.linutronix.de>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <874k50hqmj.fsf@jogness.linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 95.232.30.176
X-Source-L: No
X-Exim-ID: 1nKG9I-001PYL-FP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-232-30-176.retail.telecomitalia.it ([10.0.1.2]) [95.232.30.176]:46600
X-Source-Auth: kernel@bristot.me
X-Email-Count: 1
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2/15/22 20:33, John Ogness wrote:
>> I saw deadlocks in the past, and while testing the WIP monitor some
>> time ago, it seems it depends on the console type. If such restriction
>> does not exist anymore, I can remove that comment, it would be even
>> better!
> If you say it depended on the console type, then it was probably the
> framebuffer console that was at fault. The fbcon is a landmine for
> deadlocks, which is why PREEMPT_RT avoids fbcon printing from
> non-preemptible context. For mainline, the series is currently in
> review.
> 
> Perhaps avoiding fbcon would be good enough for you to avoid deadlocks
> with this reactor using printk().

So, I will keep printk(), add a depends on *!* fbcon, and remove the comment.
What do you think?

-- Daniel
