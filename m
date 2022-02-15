Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35BC5C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Feb 2022 18:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243026AbiBOSXt (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Feb 2022 13:23:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243028AbiBOSXo (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Feb 2022 13:23:44 -0500
X-Greylist: delayed 1920 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 15 Feb 2022 10:23:33 PST
Received: from gateway31.websitewelcome.com (gateway31.websitewelcome.com [192.185.143.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CDE119F5F
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 10:23:33 -0800 (PST)
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 007D96ED01
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Feb 2022 11:23:14 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id K1VpnPNvJHnotK1VpnNV8P; Tue, 15 Feb 2022 11:21:13 -0600
X-Authority-Reason: nr=8
Received: from host-95-232-30-176.retail.telecomitalia.it ([95.232.30.176]:59436 helo=[10.0.0.45])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nK1Vo-002nDW-7t; Tue, 15 Feb 2022 11:21:12 -0600
Message-ID: <65172f14-bad6-37b1-d243-e91ca472d22e@kernel.org>
Date:   Tue, 15 Feb 2022 18:21:05 +0100
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
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <87r1842r1m.fsf@jogness.linutronix.de>
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
X-Exim-ID: 1nK1Vo-002nDW-7t
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-232-30-176.retail.telecomitalia.it ([10.0.0.45]) [95.232.30.176]:59436
X-Source-Auth: kernel@bristot.me
X-Email-Count: 1
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2/15/22 14:33, John Ogness wrote:
> On 2022-02-15, Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
>>> I suggest using printk_deferred() for this reactor for now. With
>>> printk_deferred() the message and timestamp are immediately and
>>> locklessly stored in the buffer, and the printing is performed in a
>>> separate context. printk_deferred() is safe for all contexts.
>> Question: Does it always postpone or only postpone when in a
>> particular contexts, like, with irqs disabled?
> printk_deferred() always postpones printing.

That is why printk() seems to be the better option, though I can use the
deferred option too.

Noting that, I am aware of printk_deferred(), and every once and while I am
Cc'ed on patches suggesting changing printk() to printk_deferred(), but they are
not, let's say, welcome [1]... that is why I am not using it.

>> Note: do not use this reactor with rq_lock taken, it will lock the
>> system until printk can handle that.
> Perhaps you could explain thi comment in your commit message?  printk()
> should never lock the system.

I saw deadlocks in the past, and while testing the WIP monitor some time ago, it
seems it depends on the console type. If such restriction does not exist
anymore, I can remove that comment, it would be even better!

[1]
https://lore.kernel.org/lkml/e68888438cec9a1da53aaa1647720ade638d6ad4.1600705105.git.bristot@redhat.com/

-- Daniel
