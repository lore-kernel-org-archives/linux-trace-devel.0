Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC87C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 14:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA3661175
	for <linux-trace-devel@archiver.kernel.org>; Tue, 19 Oct 2021 14:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbhJSOek (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 19 Oct 2021 10:34:40 -0400
Received: from gateway30.websitewelcome.com ([192.185.149.4]:27742 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhJSOek (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 10:34:40 -0400
X-Greylist: delayed 1290 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 10:34:40 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 36B451D3CF
        for <linux-trace-devel@vger.kernel.org>; Tue, 19 Oct 2021 09:07:47 -0500 (CDT)
Received: from gator4132.hostgator.com ([192.185.4.144])
        by cmsmtp with SMTP
        id cpmMmtGcLtL6ecpmMmAFHy; Tue, 19 Oct 2021 09:07:47 -0500
X-Authority-Reason: nr=8
Received: from host-79-18-63-114.retail.telecomitalia.it ([79.18.63.114]:58578 helo=[10.0.0.35])
        by gator4132.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <bristot@kernel.org>)
        id 1mcpmL-0042su-LX; Tue, 19 Oct 2021 09:07:45 -0500
Message-ID: <ecf3bfee-8a7a-e3bf-4fba-af9bc479526e@kernel.org>
Date:   Tue, 19 Oct 2021 16:07:40 +0200
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
From:   Daniel Bristot de Oliveira <bristot@kernel.org>
In-Reply-To: <20211019092124.6b403ca4@gandalf.local.home>
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
X-Exim-ID: 1mcpmL-0042su-LX
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: host-79-18-63-114.retail.telecomitalia.it ([10.0.0.35]) [79.18.63.114]:58578
X-Source-Auth: kernel@bristot.me
X-Email-Count: 2
X-Source-Cap: YnJpc3RvdG1lO2JyaXN0b3RtZTtnYXRvcjQxMzIuaG9zdGdhdG9yLmNvbQ==
X-Local-Domain: no
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10/19/21 15:21, Steven Rostedt wrote:
> On Tue, 19 Oct 2021 14:56:15 +0200
> Daniel Bristot de Oliveira <bristot@kernel.org> wrote:
> 
>> I am not a document format specialist, neither have a strong opinion on this, so
>> suggestions are welcome. I used this format as a suggestion from steven, it is
>> also similar to what we have on perf...
> 
> My suggestion came from not knowing that the man pages were going to live
> in the kernel Documentation tree ;-)

That is true!

Question, should we mode these files to Documentation/trace/ ?

>>
>> The idea here is to create a set of man pages. I saw that it is possible to
>> create man pages using Sphinx, but there are so many options that it is hard to
>> get started...
>>
>> I also noticed that bpftools uses .rst files, but uses rst2man to convert the files.
>>
>> Converting the current files to .rst is easy.
>>
>> So, could give me some directions on what you think would be the best way to
>> create this set of man pages?
>>
>> A link to a project that creates a set of man pages using Sphinx using a
>> Makefile would be a plus :-).
> 
> 
> If everyone is OK with converting to .rst and using rst2man I'm fine with
> that.

+1

-- Daniel

> -- Steve
> 

