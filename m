Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7FFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 16:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39A3E60EE3
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 16:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJSQIv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 12:08:51 -0400
Received: from gateway34.websitewelcome.com ([192.185.148.164]:32016 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhJSQIu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 12:08:50 -0400
X-Greylist: delayed 1316 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 12:08:50 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id 51B21AF86B
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Oct 2021 10:43:51 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id crHLmxHf6tL6ecrHLmDoMj; Tue, 19 Oct 2021 10:43:51 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:58586 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mcrHK-001tND-3B; Tue, 19 Oct 2021 10:43:50 -0500
Message-ID: <d92ac4a7-cd85-4004-03bd-784c83af9ac4@kernel.org>
Date:   Tue, 19 Oct 2021 17:43:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH V3 13/19] rtla: Add Documentation
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <zanussi@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1634574261.git.bristot@kernel.org>
 <7e205854656f41afe9a35e6390d3e3cbd724706f.1634574261.git.bristot@kernel.org>
 <877deaut3b.fsf@meer.lwn.net>
 <f0c50222-a9a8-d0e5-d705-d9d670467142@kernel.org>
 <20211019092124.6b403ca4@gandalf.local.home>
 <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
 <20211019104516.2df4669f@gandalf.local.home>
 <d5dc2a59-c73f-3ff0-aa4e-ed71e713c42b@kernel.org>
 <20211019112506.2901184a@gandalf.local.home>
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211019112506.2901184a@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4132.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.org
X-BWhitelist: no
X-Source-IP: 79.18.63.114
X-Source-L: No
X-Exim-ID: 1mcrHK-001tND-3B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:58586
X-Source-Auth: kernel@bristot.me
X-Email-Count: 31
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/19/21 17:25, Steven Rostedt wrote:
> On Tue, 19 Oct 2021 17:08:57 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>>> Is this really tracing, or is it another domain (analysis)?  
>>
>> Hummm... it uses tracing and capture trace... but to do analysis. rtsl (tool
>> inside the rtla in the future) will be even more in the analysis side....
> 
> Right. It's a user of tracing, but not a tracer itself. Which is why I'm
> thinking it deserves its own category.

For the docs only, or for the tool itself too... like, tools/rtla/ ?

-- Daniel
> 
> Jon, do you have thoughts about this?
> 
> -- Steve
> 

