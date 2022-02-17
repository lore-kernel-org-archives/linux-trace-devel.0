Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB355C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Feb 2022 18:55:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiBQSz2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Feb 2022 13:55:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244809AbiBQSzU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Feb 2022 13:55:20 -0500
X-Greylist: delayed 1335 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 10:54:58 PST
Received: from gateway30.websitewelcome.com (gateway30.websitewelcome.com [192.185.150.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD84B45ACC
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Feb 2022 10:54:58 -0800 (PST)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 2A38FC080
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Feb 2022 12:32:43 -0600 (CST)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id Kla7nmFil22u3Kla7n2RWY; Thu, 17 Feb 2022 12:32:43 -0600
X-Authority-Reason: nr=8
Received: from host-95-232-30-176.retail.telecomitalia.it ([95.232.30.176]:34156 helo=[10.0.0.45])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1nKla5-002U7P-7e; Thu, 17 Feb 2022 12:32:41 -0600
Message-ID: <7f227281-a5c8-ba55-ed75-6ce2c4d423e3@kernel.org>
Date:   Thu, 17 Feb 2022 19:32:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC V2 17/21] watchdog/dev: Add tracepoints
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>,
        Gabriele Paoloni <gpaoloni@redhat.com>,
        "Peter.Enderborg@sony.com" <Peter.Enderborg@sony.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <cover.1644830251.git.bristot@kernel.org>
 <e67874c8b676ea8dfe38679efa25363889bb1e76.1644830251.git.bristot@kernel.org>
 <96f418b4-0ba8-01fe-ead0-2028bfc42560@sony.com>
 <ba924008-c0ab-4800-aac4-d9d9ae930c32@kernel.org>
 <ef1b1d99-6172-2b4d-9612-7ecbe8fc6c8b@roeck-us.net>
 <6c6fc4fa-6464-2dbf-40da-e3c61f322d95@redhat.com>
 <b59155c2-81c1-b2d8-c8d9-a97e3166cee3@roeck-us.net>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <b59155c2-81c1-b2d8-c8d9-a97e3166cee3@roeck-us.net>
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
X-Exim-ID: 1nKla5-002U7P-7e
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-95-232-30-176.retail.telecomitalia.it ([10.0.0.45]) [95.232.30.176]:34156
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 2/17/22 19:17, Guenter Roeck wrote:
> On 2/17/22 09:49, Gabriele Paoloni wrote:
>>
>>
>> On 17/02/2022 18:27, Guenter Roeck wrote:
>>> On 2/17/22 08:27, Daniel Bristot de Oliveira wrote:
>>>> Hi Peter
>>>>
>>>> On 2/16/22 17:01, Peter.Enderborg@sony.com wrote:
>>>>> On 2/14/22 11:45, Daniel Bristot de Oliveira wrote:
>>>>>> Add a set of tracepoints, enabling the observability of the watchdog
>>>>>> device interactions with user-space.
>>>>>>
>>>>>> The events are:
>>>>>>      watchdog:watchdog_open
>>>>>>      watchdog:watchdog_close
>>>>>>      watchdog:watchdog_start
>>>>>>      watchdog:watchdog_stop
>>>>>>      watchdog:watchdog_set_timeout
>>>>>>      watchdog:watchdog_ping
>>>>>>      watchdog:watchdog_nowayout
>>>>>>      watchdog:watchdog_set_keep_alive
>>>>>>      watchdog:watchdog_keep_alive
>>>>>
>>>>> Some watchdogs have a bark functionality, I think it should be event
>>>>> for that too.
>>>>>
>>>>
>>>> I understand. The problems is that I do not see the bark abstraction
>>>> in the
>>>> watchdog_dev layer.
>>>>
>>>
>>> I don't even know what "bark functionality" means. A new term for
>>> pretimeout ?
>>> Something else ?
>>
>>> From my understanding the bark timeout is actually the pretimeout
>> whereas the bite timeout is the actual timeout.
>> I think in the Kernel ftwdt010_wdt and qcom-wdt are bark/bite WTDs
>>
> 
> If that is the case, I would prefer if we could stick to existing
> terminology to avoid issues like "I do not see the bark abstraction".

I agree! I am using the terminology from watchdog dev. Like, I hear the term
"pet" for the "ping", I used "ping."

-- Daniel
