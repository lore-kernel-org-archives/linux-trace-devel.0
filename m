Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7935C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Feb 2022 18:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357444AbiBNS30 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Feb 2022 13:29:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348672AbiBNS3Z (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Feb 2022 13:29:25 -0500
X-Greylist: delayed 1378 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Feb 2022 10:29:17 PST
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com [192.185.168.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D65855480
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Feb 2022 10:29:17 -0800 (PST)
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 4F5343967F
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Feb 2022 12:06:19 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id JfjunvKiuXvvJJfjuntGAc; Mon, 14 Feb 2022 12:06:19 -0600
X-Authority-Reason: nr=8
Received: from host-95-232-30-176.retail.telecomitalia.it ([95.232.30.176]:59428 helo=[10.0.0.45])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nJfjs-001Rrw-HC; Mon, 14 Feb 2022 12:06:16 -0600
Message-ID: <c1657d1c-0d2b-4aa3-c1ed-2ae6fdfcda86@kernel.org>
Date:   Mon, 14 Feb 2022 19:06:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC V2 12/21] rv/reactor: Add the printk reactor
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, john.ogness@linutronix.de
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
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <10cf6003-6d2b-056b-11bb-3ae9c342a369@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 95.232.30.176
X-Source-L: No
X-Exim-ID: 1nJfjs-001Rrw-HC
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-232-30-176.retail.telecomitalia.it ([10.0.0.45]) [95.232.30.176]:59428
X-Source-Auth: kernel@bristot.me
X-Email-Count: 1
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2/14/22 18:25, Shuah Khan wrote:
> On 2/14/22 3:45 AM, Daniel Bristot de Oliveira wrote:
>> Sample reactor that printks the reaction message.
>>
> 
> Who is supposed to take action on this message and how do they
> get notified?

The same people that use printk to debug systems (who never?), on conditions
where other debugging methods might not available.

> 
>> Note: do not use this reactor with rq_lock taken, it will lock the
>> system until printk can handle that.
> 
> Please give more details on "lock the system" and how locking
> would impact users and system operation

It is a deadlock on the rq_lock. Hopefully the new printk implementation handles
that better.

/me looks at John Ogness

-- Daniel
